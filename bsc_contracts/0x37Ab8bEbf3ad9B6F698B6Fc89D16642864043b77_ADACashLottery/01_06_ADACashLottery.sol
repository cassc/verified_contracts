//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

error Lottery__notEnoughEthForEntrance();
error Lottery__TransferFailed();
error Lottery__notOpen();
error Lottery__upkeepNotNeeded(
    uint256 lotteryBalance,
    uint256 numPlayers,
    uint256 lotteryState
);

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: node_modules\openzeppelin-solidity\contracts\utils\Context.sol

pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

// File: openzeppelin-solidity\contracts\access\Ownable.sol

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _setOwner(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 internal _totalSupply;

    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    function name() public view virtual override returns (string memory) {
        return _name;
    }

    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
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
        virtual
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
        virtual
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
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(
            amount,
            "ERC20: burn amount exceeds balance"
        );
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
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
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/** 
    @title Lottery contract
    @dev It's using Chainlink VRF V2 and ChainLink keepers
 */

contract ADACashLottery is
    VRFConsumerBaseV2,
    KeeperCompatibleInterface,
    Ownable
{
    /* Type declarations */
    enum LotteryState {
        OPEN,
        CALCULATING
    }

    /* Storage variables */
    address payable[] s_players;
    address private s_recentFirst;
    address private s_recentSecond;
    address private s_recentThird;
    uint256 private immutable i_entranceFee;
    uint256 private s_lastTimestamp;
    uint256 private immutable i_interval;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 3;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    LotteryState private s_lotteryState;
    uint256 public lotteryFundCollected = 0;
    mapping(address => uint256) public ticketCounter;

    address public deadwallet = 0x000000000000000000000000000000000000dEaD;

    IUniswapV2Router02 public immutable uniswapV2Router =
        IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

    address public teamWallet = 0x0b3b498070D00207c2E096Ebfc6e004DAA3d6836;

    uint8 public jackpotOutgoing = 70; // 70% of Pot will be used for Winners
    uint8 public contractPercent = 20; // 20% will roll over to the next lotteryevent
    uint8 public marketingPercent = 5; // 5% goes to marketing
    uint8 public burnPercent = 5; // 5% of tokens will go to the dead address.

    uint8 public firstplacePercent = 60; // 60 % of Jackpot will go to first Place
    uint8 public secondplacePercent = 25; // 25 % of Jackpot will go to second Place
    uint8 public thirdplacePercent = 15; // 15 % of Jackpot will go to third Place

    IERC20 public paytoken = IERC20(0x651a89fed302227d41425235F8E934502FB94C48);

    IERC20 public immutable wintoken =
        IERC20(0x651a89fed302227d41425235F8E934502FB94C48);

    /* Events */
    event EnterLottery(address indexed playerAddress);
    event requestedLotteryWinner(uint256 indexed requestId);
    event WinnerPicked(
        address firstplace,
        address secondplace,
        address thirdplace
    );
    event ChangeTeamWallet(address account);
    event ChangePayToken(address account);

    /* Functions */
    constructor(
        address vrfCoordinatorV2,
        uint64 subscriptioId,
        bytes32 gasLane,
        uint256 interval,
        uint256 entranceFee,
        uint32 callbackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_entranceFee = entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptioId;
        i_callbackGasLimit = callbackGasLimit;
        s_lotteryState = LotteryState.OPEN;
        s_lastTimestamp = block.timestamp;
        i_interval = interval;
    }

    function changeRewardPercent(
        uint8 _jackpotOutgoing,
        uint8 _contractPercent,
        uint8 _marketingPercent,
        uint8 _burnPercent
    ) public onlyOwner {
        require(
            _jackpotOutgoing +
                _contractPercent +
                _marketingPercent +
                _burnPercent ==
                uint8(100),
            "Sum should be 100 of total reward percent"
        );
        jackpotOutgoing = _jackpotOutgoing;
        contractPercent = _contractPercent;
        burnPercent = _burnPercent;
        marketingPercent = marketingPercent;
    }

    function resetTicketCounter() internal {
        for (uint256 i = 0; i < s_players.length; i++) {
            ticketCounter[s_players[i]] = 0;
        }
    }

    function changeWinnersPercent(
        uint8 _firstplacePercent,
        uint8 _secondplacePercent,
        uint8 _thirdplacePercent
    ) public onlyOwner {
        require(
            _firstplacePercent + _secondplacePercent + _thirdplacePercent ==
                uint8(100),
            "Sum should be 100 of total reward percent"
        );
        firstplacePercent = _firstplacePercent;
        secondplacePercent = _secondplacePercent;
        thirdplacePercent = _thirdplacePercent;
    }

    function updateTeamWallet(address account) public onlyOwner {
        teamWallet = account;
        emit ChangeTeamWallet(account);
    }

    function updatePayToken(address account) public onlyOwner {
        paytoken = IERC20(account);
        emit ChangePayToken(account);
    }

    function getPlayer(uint256 id) public view returns (address) {
        return s_players[id];
    }

    function getRecentFirstWinner() public view returns (address) {
        return s_recentFirst;
    }

    function getRecentSecondWinner() public view returns (address) {
        return s_recentSecond;
    }

    function getRecentThirdWinner() public view returns (address) {
        return s_recentThird;
    }

    function getLotteryState() public view returns (LotteryState) {
        return s_lotteryState;
    }

    function getNumWords() public pure returns (uint32) {
        return NUM_WORDS;
    }

    function getNumOfPlayers() public view returns (uint256) {
        return s_players.length;
    }

    function getLatestTimeStamp() public view returns (uint256) {
        return s_lastTimestamp;
    }

    function getRequestConfiramtions() public pure returns (uint256) {
        return REQUEST_CONFIRMATIONS;
    }

    function getLotteryFundsCollected() public view returns (uint256) {
        return wintoken.balanceOf(address(this));
    }

    function getInterval() public view returns (uint256) {
        return i_interval;
    }

    function getBNBPriceForBUSD(uint256 tokenAmount)
        internal
        view
        returns (uint256)
    {
        address[] memory path = new address[](2);
        path[0] = address(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
        path[1] = uniswapV2Router.WETH();
        uint256[] memory bnbprice = uniswapV2Router.getAmountsOut(
            tokenAmount,
            path
        );
        uint256 convertedTicketPrice = bnbprice[1];
        return convertedTicketPrice;
    }

    function getTokenPriceForBNB(uint256 tokenAmount)
        internal
        view
        returns (uint256)
    {
        address[] memory path = new address[](2);
        path[0] = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
        path[1] = address(paytoken);
        uint256[] memory payprice = uniswapV2Router.getAmountsOut(
            tokenAmount,
            path
        );
        uint256 entryprice = payprice[1];
        return entryprice;
    }

    function getEntranceFee() public view returns (uint256) {
        uint256 precision = i_entranceFee * 10**18;
        uint256 bnbprice = getBNBPriceForBUSD(precision);
        uint256 costToEnter = getTokenPriceForBNB(bnbprice);

        return costToEnter;
    }

    /* Write functions */
    function enterLottery(uint256 _numberOfEntries) public payable {
        uint256 entrance = getEntranceFee();

        if (s_lotteryState != LotteryState.OPEN) {
            revert Lottery__notOpen();
        }

        require(
            ticketCounter[msg.sender] <= 10,
            "Per wallet only 10 Tickets allowed"
        );

        require(
            paytoken.transferFrom(
                msg.sender,
                address(this),
                entrance * _numberOfEntries
            ) == true,
            "Could not transfer tokens from your address to this contract"
        );

        for (uint256 counter = 0; counter < _numberOfEntries; counter++) {
            s_players.push(payable(msg.sender));
            ticketCounter[msg.sender]++;
        }

        swapFortuneCashForEth(entrance * _numberOfEntries);
        uint256 amountBNB = address(this).balance;
        payable(teamWallet).transfer((amountBNB * 90) / 100);
        emit EnterLottery(msg.sender);
    }

    function swapADACashForEth(uint256 tokenAmount) internal {
        address[] memory path = new address[](2);
        path[0] = address(wintoken);
        path[1] = uniswapV2Router.WETH();
        wintoken.approve(address(this), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function swapFortuneCashForEth(uint256 tokenAmount) internal {
        address[] memory path = new address[](2);
        path[0] = address(paytoken);
        path[1] = uniswapV2Router.WETH();
        paytoken.approve(address(this), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        uint256 amountBNB = address(this).balance;
        payable(msg.sender).transfer((amountBNB * amountPercentage) / 100);
    }

    function pickWinner() public {
        bool isOpen = s_lotteryState == LotteryState.OPEN;
        bool timePassed = (block.timestamp - s_lastTimestamp) > i_interval;
        bool hasPlayers = s_players.length > 0;
        bool hasBalance = wintoken.balanceOf(address(this)) > 0;

        require(
            isOpen == true &&
                timePassed == true &&
                hasPlayers == true &&
                hasBalance == true,
            "Lottery not ready to be drawn"
        );

        s_lotteryState = LotteryState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId, // contract that will fund subscription requests
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit requestedLotteryWinner(requestId);
    }

    /* Chainlink VRF V2 functions implementations */
    function fulfillRandomWords(
        uint256, /*request_id */
        uint256[] memory randomWords
    ) internal override {
        uint256 firstWinner = randomWords[0] % s_players.length;
        uint256 secondWinner = randomWords[1] % s_players.length;
        uint256 thirdWinner = randomWords[2] % s_players.length;

        address payable firstplace = s_players[firstWinner];
        address payable secondplace = s_players[secondWinner];
        address payable thirdplace = s_players[thirdWinner];

        s_recentFirst = firstplace;
        s_recentSecond = secondplace;
        s_recentThird = thirdplace;
        s_lotteryState = LotteryState.OPEN;
        s_players = new address payable[](0);
        s_lastTimestamp = block.timestamp;
        lotteryFundCollected = wintoken.balanceOf(address(this));

        uint256 marketing = (lotteryFundCollected * marketingPercent) / 100;
        uint256 burning = (lotteryFundCollected * burnPercent) / 100;

        swapADACashForEth(marketing);
        uint256 amountBNB = address(this).balance;
        payable(teamWallet).transfer((amountBNB * 90) / 100);

        wintoken.transfer(deadwallet, burning);

        uint256 potSize = (lotteryFundCollected * jackpotOutgoing) / 100;
        wintoken.transfer(firstplace, (potSize * firstplacePercent) / 100);
        wintoken.transfer(secondplace, (potSize * secondplacePercent) / 100);
        wintoken.transfer(thirdplace, (potSize * thirdplacePercent) / 100);

        resetTicketCounter();

        emit WinnerPicked(firstplace, secondplace, thirdplace);
    }

    // Chainlink keeper functions

    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        bool isOpen = s_lotteryState == LotteryState.OPEN;
        bool timePassed = (block.timestamp - s_lastTimestamp) > i_interval;
        bool hasPlayers = s_players.length > 0;
        bool hasBalance = wintoken.balanceOf(address(this)) > 0;
        upkeepNeeded = isOpen && timePassed && hasPlayers && hasBalance;
    }

    // This one triggers after checkUpkeep returns true
    function performUpkeep(
        bytes calldata /*performData*/
    ) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Lottery__upkeepNotNeeded(
                wintoken.balanceOf(address(this)),
                s_players.length,
                uint256(s_lotteryState)
            );
        }
        s_lotteryState = LotteryState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId, // contract that will fund subscription requests
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit requestedLotteryWinner(requestId);
    }
}