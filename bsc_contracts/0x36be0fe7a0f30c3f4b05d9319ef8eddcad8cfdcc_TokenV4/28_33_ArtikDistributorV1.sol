// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./interfaces/DexRouter.sol";

import "./libraries/ABDKMathQuad.sol";

contract ArtikDistributorV1 is Initializable {
    using SafeMath for uint256;

    // Pancakeswap 0x10ED43C718714eb63d5aA57B78B54704E256024E (testnet: 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3)
    address constant ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    // WBNB 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c (testnet: 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd)
    address constant WETH = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    // BUSD 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56 (testnet: 0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7)
    address constant STABLE_COIN = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    uint256 private constant BUY_BACK_FEE = 25; //(2% of total fee)
    uint256 private accumulatedEthForAirdrop;

    DexRouter private dexRouter;

    address private artikToken;
    address payable private admin;

    address[] public shareholders;
    uint256 private shareholderCount;
    mapping(address => uint256) private shareholderIndexes;

    uint256 public roundNumber;
    mapping(address => mapping(uint256 => uint256)) private voters;
    mapping(address => bool) private isVoter;

    mapping(address => mapping(uint256 => bool)) private userClaimedProject;
    uint256 public totalAmountAirdropped;
    mapping(address => uint256) public amountClaimed;

    Project public bestProject;

    uint256 public airdropBalance;
    uint256 public totalHoldersBalance;
    uint256 public airdropDate;

    uint256 public projectCount;
    uint256 public votesCount;
    mapping(uint256 => Project) public projects;

    mapping(address => mapping(uint256 => mapping(uint256 => bool)))
        private userHasClaimedProject;

    mapping(uint256 => uint256) private airdropSnapshot;

    struct Project {
        uint256 id;
        string img;
        string name;
        string description;
        string category;
        string url;
        string twitter;
        uint256 votes;
        address tokenAddress;
        string tokenSymbol;
        uint256 tokenDecimals;
        bool active;
    }

    function initialize(address _tokenAddress) public initializer {
        dexRouter = DexRouter(ROUTER);
        artikToken = _tokenAddress;
        admin = payable(msg.sender);
        shareholderCount = 0;
        roundNumber = 1;
        totalAmountAirdropped = 0;
        projectCount = 0;
        votesCount = 0;
        accumulatedEthForAirdrop = 0;
        totalHoldersBalance = 0;
        airdropBalance = 0;
    }

    modifier onlyToken() {
        require(msg.sender == artikToken, "sender is not the token");
        _;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin);
        _;
    }

    function uploadProject(
        string memory _img,
        string memory _name,
        string memory _description,
        string memory _category,
        string memory _url,
        string memory _twitter,
        bytes20 _tokenAddress,
        string memory _tokenSymbol,
        uint256 _tokenDecimals
    ) external onlyAdmin {
        require(msg.sender != address(0));
        require(bytes(_img).length > 0);
        require(bytes(_name).length > 0);
        require(bytes(_description).length > 0);
        require(bytes(_category).length > 0);
        require(bytes(_url).length > 0);
        require(address(_tokenAddress) != address(0x0));
        require(bytes(_tokenSymbol).length > 0);
        require(_tokenDecimals > 0);

        projectCount = projectCount.add(1);
        projects[projectCount] = Project(
            projectCount,
            _img,
            _name,
            _description,
            _category,
            _url,
            _twitter,
            0,
            address(_tokenAddress),
            _tokenSymbol,
            _tokenDecimals,
            true
        );
    }

    function changeProjectState(
        uint256 _projectId,
        bool _active
    ) external onlyAdmin {
        projects[_projectId].active = _active;
    }

    function voteProject(uint256 _projectId) external {
        require(
            voters[msg.sender][_projectId] != roundNumber,
            "voters can vote the same project only 1 time"
        );
        require(
            shareholderIndexes[msg.sender] > 0,
            "voters must be token holders"
        );
        require(_projectId != 0, "projectId canno be 0");

        projects[_projectId].votes = projects[_projectId].votes.add(1);
        voters[msg.sender][_projectId] = roundNumber;
        isVoter[msg.sender] = true;
        votesCount = votesCount.add(1);
    }

    function resetProjectVotes(uint256 _projectId) external onlyAdmin {
        projects[_projectId].votes = 0;
    }

    function setBestProject(uint256 _projectId) external onlyAdmin {
        bestProject = projects[_projectId];
    }

    function setAirdropDate(uint256 _days) public onlyAdmin {
        airdropDate = block.timestamp + (1 days * _days);
    }

    function takeSnapshot() external onlyAdmin {
        airdropSnapshot[roundNumber] = calculateTVL(true);
    }

    function initializeAirdrop(uint256 _days) external onlyAdmin {
        require(block.timestamp >= airdropDate);

        uint256 STABLE_COINBalance = IERC20(STABLE_COIN).balanceOf(
            address(this)
        );

        require(STABLE_COINBalance > 0);
        require(bestProject.id != 0);

        nextRound();
        airdropSnapshot[roundNumber] = 0;

        IERC20(STABLE_COIN).approve(ROUTER, STABLE_COINBalance);
        (uint256 amountWethMin, ) = getAmountOutMin(
            STABLE_COINBalance,
            STABLE_COIN,
            WETH
        );
        IERC20(WETH).approve(ROUTER, amountWethMin);

        uint256 buyBackFee = mulDiv(STABLE_COINBalance, BUY_BACK_FEE, 100);
        uint256 amountToSwap = STABLE_COINBalance.sub(buyBackFee);

        // Buy back mechanism
        buyBack(buyBackFee);

        // Swap BUSD -> BNB -> Airdrop Token
        buyAirdropTokens(amountToSwap, bestProject.tokenAddress);
        setAirdropDate(_days);

        airdropBalance = IERC20(bestProject.tokenAddress).balanceOf(
            address(this)
        );
    }

    function buyAirdropTokens(uint256 _amount, address _project) private {
        swapTokensForETH(_amount, STABLE_COIN);
        swapETHForTokens(address(this).balance, _project);
    }

    function buyBack(uint256 _fee) private {
        swapTokensForETH(_fee, STABLE_COIN);
        swapETHForTokens(address(this).balance, artikToken);
        IERC20(artikToken).transfer(
            address(0x0),
            IERC20(artikToken).balanceOf(address(this))
        );
    }

    function claimAirdrop() public {
        uint256 airdrop = calculateAirdropAmount(msg.sender);
        IERC20(bestProject.tokenAddress).transfer(msg.sender, airdrop);

        isVoter[msg.sender] = false;
        userHasClaimedProject[msg.sender][roundNumber][bestProject.id] = true;

        (uint256 amountWethMin, ) = getAmountOutMin(
            airdrop,
            bestProject.tokenAddress,
            WETH
        );
        (uint256 amountStableMin, ) = getAmountOutMin(
            amountWethMin,
            WETH,
            STABLE_COIN
        );

        amountClaimed[msg.sender] = amountClaimed[msg.sender].add(
            amountStableMin
        );
        totalAmountAirdropped = totalAmountAirdropped.add(amountStableMin);
    }

    function calculateTVL(bool _onlyVoters) public view returns (uint256) {
        uint256 currentBalance = 0;
        for (uint256 i = 0; i < shareholders.length; i++) {
            if ((_onlyVoters && isVoter[shareholders[i]]) || !_onlyVoters) {
                currentBalance = currentBalance.add(
                    IERC20(artikToken).balanceOf(shareholders[i])
                );
            }
        }
        return currentBalance;
    }

    function calculateAirdropAmount(
        address _shareholder
    ) public view returns (uint256) {
        require(shareholderIndexes[_shareholder] > 0, "not a shareholder");
        require(isVoter[_shareholder] == true, "not a voter");
        require(
            _shareholder != address(0x0),
            "shareholder cannot be address of 0"
        );
        require(
            airdropSnapshot[roundNumber - 1] > 0,
            "total holders balance less than 0"
        );

        require(
            userHasClaimedProject[_shareholder][roundNumber][bestProject.id] !=
                true,
            "shareholder has already claimed this airdrop"
        );

        uint256 holderPercentage = calculateHolderPercentage(
            _shareholder,
            airdropSnapshot[roundNumber - 1]
        );

        uint256 airdrop = mulDiv(airdropBalance, holderPercentage, 1000000);

        return airdrop;
    }

    function calculateHolderPercentage(
        address _shareholder,
        uint256 _totalHoldersBalance
    ) private view returns (uint256) {
        // 100 : x = totalHoldersBalance : holderBalance
        uint256 holderBalance = IERC20(artikToken).balanceOf(_shareholder);
        uint256 holderPercentage = mulDiv(
            holderBalance,
            100,
            _totalHoldersBalance.mul(10000)
        );
        return holderPercentage;
    }

    function calculateExpectedAirdrop(
        address _shareholder
    ) external view returns (uint256) {
        require(
            _shareholder != address(0x0),
            "shareholder address cannot be 0"
        );
        require(shareholderIndexes[_shareholder] > 0, "not a shareholder");

        uint256 holderBalance = IERC20(artikToken).balanceOf(_shareholder);
        require(
            holderBalance > 0,
            "shareholder balance must be greater than 0"
        );

        uint256 holders_balance = 0;
        if (airdropSnapshot[roundNumber] > 0) {
            holders_balance = airdropSnapshot[roundNumber];
        } else {
            holders_balance = calculateTVL(true);
        }

        uint256 holderPercentage = calculateHolderPercentage(
            _shareholder,
            holders_balance
        );

        uint256 treasuryForAirdrop = mulDiv(
            IERC20(STABLE_COIN).balanceOf(address(this)),
            75,
            100
        );

        return mulDiv(treasuryForAirdrop, holderPercentage, 1000000);
    }

    function addShareHolder(address _shareholder) external onlyToken {
        require(_shareholder != address(0x0));

        if (shareholderIndexes[_shareholder] <= 0) {
            shareholders.push(_shareholder);
            shareholderCount = shareholderCount.add(1);
            shareholderIndexes[_shareholder] = shareholderCount;
        }
    }

    function removeShareHolder(address _shareholder) external onlyToken {
        require(_shareholder != address(0x0));

        if (shareholderIndexes[_shareholder] > 0) {
            shareholders[shareholderIndexes[_shareholder] - 1] = shareholders[
                shareholders.length - 1
            ];
            shareholders.pop();
            shareholderCount = shareholderCount.sub(1);
            shareholderIndexes[_shareholder] = 0;
        }
    }

    function swapETHForTokens(uint256 _amount, address _token) private {
        require(_amount > 0);
        require(_token != address(0x0));
        require(address(this).balance >= _amount, "balance less than _amount");

        address[] memory path = new address[](2);
        path[0] = WETH;
        path[1] = _token;

        dexRouter.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: _amount
        }(0, path, address(this), block.timestamp);
    }

    function swapTokensForETH(uint256 _amount, address _token) private {
        require(_amount > 0);
        require(_token != address(0x0));
        require(
            IERC20(_token).balanceOf(address(this)) >= _amount,
            "balance less than _amount"
        );

        address[] memory path = new address[](2);
        path[0] = _token;
        path[1] = WETH;

        dexRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            _amount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function getAmountOutMin(
        uint256 _amount,
        address _tokenIn,
        address _tokenOut
    ) private view returns (uint256, address[] memory) {
        address[] memory path = new address[](2);
        path[0] = _tokenIn;
        path[1] = _tokenOut;

        uint256[] memory amountOutMins = dexRouter.getAmountsOut(_amount, path);
        return (amountOutMins[1], path);
    }

    function swapTokens() external onlyToken {
        IERC20(WETH).approve(ROUTER, address(this).balance);
        swapETHForTokens(address(this).balance, STABLE_COIN);
    }

    function nextRound() public onlyAdmin {
        roundNumber = roundNumber.add(1);
    }

    function withdrawRemainingAirdrop(address _token) external onlyAdmin {
        require(_token != address(0x0));
        uint256 remainingBalance = IERC20(_token).balanceOf(address(this));
        require(remainingBalance > 0);
        IERC20(_token).transfer(admin, remainingBalance);
    }

    function hasVotedProject(uint256 _projectId) external view returns (bool) {
        if (voters[msg.sender][_projectId] == roundNumber) {
            return true;
        } else {
            return false;
        }
    }

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 z
    ) public pure returns (uint256) {
        return
            ABDKMathQuad.toUInt(
                ABDKMathQuad.div(
                    ABDKMathQuad.mul(
                        ABDKMathQuad.fromUInt(x),
                        ABDKMathQuad.fromUInt(y.mul(100))
                    ),
                    ABDKMathQuad.fromUInt(z)
                )
            );
    }

    receive() external payable {}
}