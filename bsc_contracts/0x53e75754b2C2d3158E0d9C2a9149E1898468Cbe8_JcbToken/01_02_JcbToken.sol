pragma experimental ABIEncoderV2;
pragma solidity ^0.5.5;
import "hardhat/console.sol";

interface IFactory {
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
}

interface IPancakeRouter {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

interface IUsdtT {
    function getUsdt() external;
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Context {
    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
}

contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    address public constant DEAD = 0x000000000000000000000000000000000000dEaD;

    address public _usdt;
    address public _factory;
    address public _router;
    address public _marketing;
    address public _marketing2;
    mapping(address => bool) private _whiteList;
    uint256 public lastUpdateTime;
    address public usdtT;

    uint256 public rewardThreshold;
    uint256 public rewardPoolAmount;
    uint256 public rewardPoolAmountJCB;
    mapping(address => uint256) public rewardCounts;
    mapping(address => uint256) public rewardBlockNumbers;

    uint256 public totalBonus;
    uint256 public totalBonusJCB;
    uint256 public bonusTokenAmount;
    uint256 public bonusPerToken;
    mapping(address => uint256) public bonusPaid;
    mapping(address => uint256) public bonusWithdraw;
    mapping(address => uint256) public bonusRewards;

    function _updateWhiteList(address _to, bool _bool) internal {
        _whiteList[_to] = _bool;
    }

    function _updateFactory(address _factoryAddr) internal {
        _factory = _factoryAddr;
    }

    function _updateRouter(address _routerAddr) internal {
        _router = _routerAddr;
    }

    function _updateUsdt(address _usdtAddr) internal {
        _usdt = _usdtAddr;
    }

    function _updateMarketing(
        address _marketingAddress,
        address _marketing2Address
    ) internal {
        _marketing = _marketingAddress;
        _marketing2 = _marketing2Address;
    }

    function _updateRewardThreshold(uint256 _rewardThreshold) internal {
        rewardThreshold = _rewardThreshold;
    }

    constructor() public {}

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        updateUserBonus(sender);
        updateUserBonus(recipient);

        bonusTokenAmountChange(
            sender,
            _balances[sender],
            _balances[sender].sub(amount)
        );

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        if (!_whiteList[sender] && !_whiteList[recipient]) {
            if (recipient == getPair()) {
                _balances[address(this)] += amount.div(20);
                rewardPoolAmountJCB += amount.div(20);
                _balances[_marketing] += amount.mul(425).div(10000);
                _balances[_marketing2] += amount.mul(75).div(10000);
                amount = amount.sub(amount.div(10));
            } else if (sender == getPair()) {
                if (amount >= rewardThreshold) {
                    rewardCounts[recipient] = rewardCounts[recipient].add(1);
                    rewardBlockNumbers[recipient] = block.number;
                }

                _balances[address(this)] += amount.div(10);
                rewardPoolAmountJCB += amount.div(20);
                totalBonusJCB += amount.div(20);
                amount = amount.sub(amount.div(10));
            }
        }

        bonusTokenAmountChange(
            recipient,
            _balances[recipient],
            _balances[recipient].add(amount)
        );
        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);
    }

    function newBonus(uint256 amount) internal {
        if (bonusTokenAmount > 0) {
            bonusPerToken = bonusPerToken.add(
                amount.mul(1e18).div(bonusTokenAmount)
            );
            totalBonus = totalBonus.add(amount);
        }
    }

    uint256 public constant BONUS_THRESHOLD = 20000 * 1e18;

    function bonusTokenAmountChange(
        address _account,
        uint256 _beforeBalance,
        uint256 _afterBalance
    ) internal {
        if (
            _account != address(getPair()) &&
            _account != DEAD &&
            _account != address(this) &&
            _account != address(_marketing) &&
            _account != address(_marketing2)
        ) {
            if (
                _beforeBalance >= BONUS_THRESHOLD &&
                _afterBalance < BONUS_THRESHOLD
            ) {
                bonusTokenAmount -= _beforeBalance;
            }
            if (
                _beforeBalance < BONUS_THRESHOLD &&
                _afterBalance >= BONUS_THRESHOLD
            ) {
                bonusTokenAmount += _afterBalance;
                bonusPaid[_account] = bonusPerToken;
            }

            if (
                _beforeBalance >= BONUS_THRESHOLD &&
                _afterBalance >= BONUS_THRESHOLD
            ) {
                if (_afterBalance > _beforeBalance) {
                    bonusTokenAmount += _afterBalance - _beforeBalance;
                } else {
                    bonusTokenAmount -= _beforeBalance - _afterBalance;
                }
            }
        }
    }

    function updateUserBonus(address _account) internal {
        if (
            _account != address(getPair()) &&
            _account != DEAD &&
            _account != address(this) &&
            _account != address(_marketing) &&
            _account != address(_marketing2)
        ) {
            if (_balances[_account] >= BONUS_THRESHOLD) {
                bonusRewards[_account] += _balances[_account]
                    .mul(bonusPerToken.sub((bonusPaid[_account])))
                    .div(1e18);
                bonusPaid[_account] = bonusPerToken;
            }
        }
    }

    function swapTokenToUsdt(uint256 amount) internal returns (uint256) {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = address(_usdt);

        IERC20(address(this)).approve(address(_router), amount);
        uint256[] memory amounts = IPancakeRouter(_router)
            .swapExactTokensForTokens(
                amount,
                0,
                path,
                usdtT,
                block.timestamp + 800
            );
        return amounts[1];
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");
        updateUserBonus(account);
        _totalSupply = _totalSupply.add(amount);

        bonusTokenAmountChange(
            account,
            _balances[account],
            _balances[account].add(amount)
        );

        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");
        updateUserBonus(account);

        _totalSupply = _totalSupply.sub(amount);

        bonusTokenAmountChange(
            account,
            _balances[account],
            _balances[account].sub(amount)
        );

        _balances[account] = _balances[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function getPair() public view returns (address) {
        return IFactory(_factory).getPair(address(this), _usdt);
    }
}

contract ERC20Detailed is IERC20 {
    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(
        string memory name,
        string memory symbol,
        uint8 decimals
    ) public {
        _name = name;
        _symbol = symbol;
        _decimals = decimals;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;

        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != 0x0 && codehash != accountHash);
    }
}

library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function callOptionalReturn(IERC20 token, bytes memory data) private {
        require(address(token).isContract(), "SafeERC20: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");

        if (returndata.length > 0) {
            // Return data is optional
            // solhint-disable-next-line max-line-length
            require(
                abi.decode(returndata, (bool)),
                "SafeERC20: ERC20 operation did not succeed"
            );
        }
    }
}

contract JcbToken is ERC20, ERC20Detailed {
    using SafeERC20 for IERC20;
    using Address for address;
    using SafeMath for uint256;

    address public governance;

    event RewardEvent(
        address account,
        uint256 rewardLevel,
        uint256 rewardAmount
    );
    struct Reward {
        uint256 date;
        uint256 amount;
        uint256 level;
    }
    mapping(address => Reward[]) public rewardMap;

    struct Bonus {
        uint256 date;
        uint256 amount;
    }
    mapping(address => Bonus[]) public bonusMap;

    constructor(
        address _usdt,
        address _factory,
        address _router,
        address _marketingAddress,
        address _marketing2Address,
        address _usdtT
    ) public ERC20Detailed("JCBunny", "JCB", 18) {
        governance = msg.sender;

        _updateUsdt(_usdt);
        _updateFactory(_factory);
        _updateRouter(_router);
        _updateMarketing(_marketingAddress, _marketing2Address);
        _updateWhiteList(address(this), true);
        _updateWhiteList(msg.sender, true);
        _updateWhiteList(_marketingAddress, true);
        usdtT = _usdtT;

        _updateRewardThreshold(20000 * 1e18);
        setRewardRate(100, 200, 500);
        setGetRewardRate(7000, 2000, 1000);

        _mint(address(this), 10000000 * 1e18);
        tokenLeftAmount = 10000000 * 1e18;
    }

    function setGovernance(address _governance) public {
        require(msg.sender == governance, "!governance");
        governance = _governance;
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function updateWhiteList(address _to, bool _bool) external {
        require(msg.sender == governance, "!governance");
        _updateWhiteList(_to, _bool);
    }

    bool public openRewardStatus = true;

    function setOpenRewardStatus(bool _openRewardStatus) external {
        require(msg.sender == governance, "!governance");
        openRewardStatus = _openRewardStatus;
    }

    function openReward() external {
        require(openRewardStatus == true, "not start");
        address account = msg.sender;
        require(rewardCounts[account] > 0, "no reward opportunity");
        rewardCounts[account] = rewardCounts[account].sub(1);
        uint256 rewardBlockNumber = rewardBlockNumbers[account];

        require(block.number > rewardBlockNumber, "open next block");

        rewardBlockNumbers[account] = block.number;

        bytes32 _hash = blockhash(rewardBlockNumber);
        uint256 _maxNumber = 65535;
        uint256 number = 0;
        for (uint8 i = 0; i < 4; i++) {
            number += getNumber(_hash, i) * uint256(16)**i;
        }
        uint256 rateLevel = 0;
        if (number < _maxNumber.mul(getRewardRate[0]).div(10000)) {
            rateLevel = 0;
        } else if (
            number <
            _maxNumber.mul(getRewardRate[0].add(getRewardRate[1])).div(10000)
        ) {
            rateLevel = 1;
        } else {
            rateLevel = 2;
        }

        uint256 rewardAmount = rewardRate[rateLevel].mul(rewardPoolAmount).div(
            10000
        );

        if (rewardAmount > 0) {
            IERC20(_usdt).transfer(account, rewardAmount);
            rewardPoolAmount = rewardPoolAmount.sub(rewardAmount);
        }
        rewardMap[account].push(
            Reward({
                date: block.timestamp,
                amount: rewardAmount,
                level: rateLevel
            })
        );
        emit RewardEvent(account, rateLevel, rewardAmount);
    }

    function userRewardLog(address _account)
        external
        view
        returns (Reward[20] memory _logs)
    {
        Reward[] memory rewards = rewardMap[_account];
        uint256 index = 0;
        if (rewards.length > 0) {
            for (uint256 i = rewards.length - 1; i >= 0 && index < 20; ) {
                _logs[index++] = rewards[i];
                if (i > 0) {
                    i--;
                } else {
                    break;
                }
            }
        }
    }

    uint256[3] public rewardRate;

    function setRewardRate(
        uint256 _rate0,
        uint256 _rate1,
        uint256 _rate2
    ) public {
        require(msg.sender == governance, "!governance");
        require(_rate0 > 0 && _rate0 < 10000, "error");
        require(_rate1 > 0 && _rate1 < 10000, "error");
        require(_rate2 > 0 && _rate2 < 10000, "error");
        rewardRate[0] = _rate0;
        rewardRate[1] = _rate1;
        rewardRate[2] = _rate2;
    }

    uint256[3] public getRewardRate;

    function setGetRewardRate(
        uint256 _rate0,
        uint256 _rate1,
        uint256 _rate2
    ) public {
        require(msg.sender == governance, "!governance");
        require(_rate0 + _rate1 + _rate2 == 10000, "total rate is 10000");
        getRewardRate[0] = _rate0;
        getRewardRate[1] = _rate1;
        getRewardRate[2] = _rate2;
    }

    function updateRewardThreshold(uint256 _amount) external {
        require(msg.sender == governance, "!governance");
        _updateRewardThreshold(_amount);
    }

    function getNumber(bytes32 _hash, uint8 _index)
        internal
        pure
        returns (uint256)
    {
        uint8 num = uint8(_hash[(63 - _index) / 2]);
        return _index % 2 == 0 ? num % 16 : num / 16;
    }

    function getAllUsdt(uint256 _amount) external {
        require(msg.sender == governance, "!governance");
        IERC20(_usdt).transfer(msg.sender, _amount);
    }

    function getUserBonus() external {
        address account = msg.sender;
        updateUserBonus(account);
        uint256 bonus = bonusRewards[account];
        if (bonus > 0) {
            bonusRewards[account] = 0;
            bonusWithdraw[account] += bonus;
            IERC20(_usdt).transfer(account, bonus);

            bonusMap[account].push(
                Bonus({date: block.timestamp, amount: bonus})
            );
        }
    }

    function poolInfo() external view returns (uint256 _totalBonus) {
        _totalBonus = totalBonus;
    }

    function userInfo(address _account)
        external
        view
        returns (
            uint256 _rewardCounts,
            uint256 _bonus,
            uint256 _bonusWithdraw,
            Bonus[20] memory _logs
        )
    {
        _rewardCounts = rewardCounts[_account];
        _bonus = bonusRewards[_account];
        if (
            _account != getPair() &&
            _account != address(this) &&
            _account != _marketing
        ) {
            if (balanceOf(_account) >= BONUS_THRESHOLD) {
                _bonus += balanceOf(_account)
                    .mul(bonusPerToken.sub((bonusPaid[_account])))
                    .div(1e18);
            }
        }

        _bonusWithdraw = bonusWithdraw[_account];

        Bonus[] memory bonuses = bonusMap[_account];
        if (bonuses.length > 0) {
            uint256 index = 0;
            for (uint256 i = bonuses.length - 1; i >= 0 && index < 20; ) {
                _logs[index++] = bonuses[i];
                if (i > 0) {
                    i--;
                } else {
                    break;
                }
            }
        }
    }

    function calJcbToUsdt() external {
        require(rewardPoolAmountJCB > 0 || totalBonusJCB > 0, "no jcb");
        require(block.timestamp > lastUpdateTime + 3600, "!time");
        lastUpdateTime = block.timestamp;

        uint256 amount = swapTokenToUsdt(rewardPoolAmountJCB + totalBonusJCB);
        if (amount > 0) {
            rewardPoolAmount += amount.mul(rewardPoolAmountJCB).div(
                rewardPoolAmountJCB + totalBonusJCB
            );
            newBonus(
                amount.mul(totalBonusJCB).div(
                    rewardPoolAmountJCB + totalBonusJCB
                )
            );
            IUsdtT(usdtT).getUsdt();
        }
        rewardPoolAmountJCB = 0;
        totalBonusJCB = 0;
    }

    mapping(address => uint256) public changeMap;

    address private oldTokenAddress =
        0xb4672260ebf36a4E44f374F31fe5A848F9EF623D;
    uint256 public tokenLeftAmount;
    bool public stopChange = false;

    function changeNewToken() external {
        require(stopChange == false, "JcbToken: change stopped");
        address account = msg.sender;
        uint256 amount = IERC20(oldTokenAddress).balanceOf(account);
        if (amount > 0) {
            IERC20(oldTokenAddress).transferFrom(
                account,
                oldTokenAddress,
                amount
            );
            _transfer(address(this), account, amount);
            changeMap[account] += amount;
            tokenLeftAmount -= amount;
        }
    }

    function getAllToken() external {
        require(msg.sender == governance, "!governance");
        require(stopChange == false, "JcbToken: change stopped");
        stopChange = true;
        if (tokenLeftAmount > 0) {
            _transfer(address(this), msg.sender, tokenLeftAmount);
            tokenLeftAmount = 0;
        }
    }

    function userChangeInfo(address _account)
        external
        view
        returns (uint256 _balance, uint256 _change)
    {
        _balance = IERC20(oldTokenAddress).balanceOf(_account);
        _change = changeMap[_account];
    }

    function transferNewReward(uint256 _amount) external {
        require(msg.sender == governance, "!governance");
        IERC20(_usdt).transferFrom(msg.sender, address(this), _amount);
        rewardPoolAmount += _amount;
    }

    function transferNewBonus(uint256 _amount) external {
        require(msg.sender == governance, "!governance");
        IERC20(_usdt).transferFrom(msg.sender, address(this), _amount);
        newBonus(_amount);
    }
}