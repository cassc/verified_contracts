/**
 *Submitted for verification at BscScan.com on 2023-03-01
*/

// File: bkc/token/ERC20/IERC20.sol

pragma solidity >=0.6.0 <0.8.0;

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
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: openzeppelin/utils/Context.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: openzeppelin/access/Ownable.sol

pragma solidity >=0.6.0 <0.8.0;

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
  
    bool private _pause = false;
    bool private _enableWhiteList = false;
    mapping(address => bool) private _whiteListAccount;
    mapping(address => bool) private _blackListAccount;
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
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
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    modifier onlyNotPause() {
        require(!_pause, "Ownable: transfer pause");
        _;
    }

    modifier onlyWhiteList() {
        require(!_blackListAccount[_msgSender()], "Ownable: _msgSender is in black list!");

        if (_enableWhiteList) {
            if (!_whiteListAccount[_msgSender()]){
                require(false, "Ownable: transfer is enable white list");
            }
        }
        _;
    }

    modifier onlyWhiteListAccount() {
        if (!_whiteListAccount[_msgSender()]){
            require(false, "Ownable: _msgSender is not in white list!");
        }
        _;
    }

    function setTransferState(bool isPause) public virtual onlyOwner {
        _pause = isPause;
    }
    
    function getEnableWhiteList() public view returns(bool){
        return _enableWhiteList;
    }
    
    function setEnableWhiteList(bool isEnableWhiteList) public onlyOwner {
        _enableWhiteList = isEnableWhiteList;
    }

    function addAccountToWhiteLsit(address account) public onlyOwner {
        _whiteListAccount[account] = true;
    }
    
    function removeAccountFromWhiteLst(address account) public onlyOwner {
        _whiteListAccount[account] = false;
    }
    
    function addAccountToBlackList(address account) public onlyOwner {
        _blackListAccount[account] = true;
    }
    
    function removeAccountFromBlackList(address account) public onlyOwner {
        _blackListAccount[account] = false;
    }
}

// File: openzeppelin/math/SafeMath.sol

// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b > a) return (false, 0);
        return (true, a - b);
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }

    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        return a - b;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) return 0;
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: division by zero");
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath: modulo by zero");
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        return a - b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryDiv}.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        return a % b;
    }
}

// File: openzeppelin/interface/IPancakeFactory.sol

pragma solidity >=0.6.0 <0.8.0;

interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
}

// File: openzeppelin/interface/IPancakeRouter.sol

pragma solidity >=0.6.0 <0.8.0;

interface IPancakeRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
    function addLiquidity(
        address tokenA,address tokenB,uint amountADesired,uint amountBDesired,
        uint amountAMin,uint amountBMin,address to,uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
}

// File: openzeppelin/interface/IPancakePair.sol

pragma solidity >=0.6.0 <0.8.0;

interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

// File: bkc/token/ERC20/MtcERC20.sol

pragma solidity >=0.6.0 <0.8.0;






interface MtcStake {
    function getLength() external view returns (uint256);
    function getHolder(uint256 index) external view returns (address);
    function balanceOf(address owner) external view returns (uint256);
    function getIsValid(address owner) external view returns (bool);
}

contract MtcERC20 is Context, Ownable, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    uint8 private _decimals;
    
    address private usdtOwner;
    address private lpAddress;
    address private dropAddress;
    address private marketAddress;
    address private upgradeAddress;
    address private mineAddress;

    address private mtcBonus;
    address private mtcBurn;
    address private destroyAddress = address(0x000000000000000000000000000000000000dEaD);
    address private usdt = address(0x55d398326f99059fF775485246999027B3197955);
    address private router = address(0x10ED43C718714eb63d5aA57B78B54704E256024E);
    
    address public pair;
    IPancakeRouter public pancakeRouter;

    bool    private swapping;
    uint256 public minsell;  //MTC
    uint256 public minBurn;  //USDT
    uint256 public minBonus; //USDT

    uint256 public index;
    uint256 public perMaxBonus;

    uint256 public startTime;

    MtcStake public stakeBonus;

    constructor (address mtcBonus_, address mtcBurn_, address dropAddress_, address lpAddress_, address marketAddress_, 
                address upgradeAddress_, address mineAddress_, address mtcStakeAddress_, uint256 startTime_) public {
        _name = "Mate coin";
        _symbol = "MTC";
        _decimals = 18;

        startTime = startTime_;

        perMaxBonus = 100 * 10**18;
        minBonus = 500 * 10**18;

        minsell = 10 * 10**16;
        minBurn = 1000 * 10**18;
        
        usdtOwner = msg.sender;
        mtcBonus = mtcBonus_;
        mtcBurn = mtcBurn_;
        lpAddress = lpAddress_;
        dropAddress = dropAddress_;
        marketAddress = marketAddress_;
        upgradeAddress = upgradeAddress_;
        mineAddress = mineAddress_;

        stakeBonus = MtcStake(mtcStakeAddress_);
        
        _mint(upgradeAddress_, 4000 * 10**18);
        _mint(mineAddress_, 6000 * 10**18);

        pancakeRouter = IPancakeRouter(router);
        pair = IPancakeFactory(pancakeRouter.factory()).createPair(address(this), usdt);
    }
    
    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }
 
    function _transfer(address from, address to, uint256 amount) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "ERC20: transfer amount must be greater than zero");

        _balances[from] = _balances[from].sub(amount, "ERC20: transfer amount exceeds balance");
        if (from == lpAddress || to == lpAddress || from == dropAddress || to == dropAddress || from == mineAddress || to == mineAddress
             || from == upgradeAddress || to == upgradeAddress || from == address(stakeBonus) || to == address(stakeBonus)) {
            _balances[to] = _balances[to].add(amount);
            emit Transfer(from, to, amount);
            return;
        } 

        if ((isContract(from) || isContract(to)) && block.timestamp < startTime) {
            require(false, "cannot start");
        } 

        uint256 burnAmount = IERC20(usdt).balanceOf(mtcBurn);
        if (burnAmount >= minBurn && !swapping && from != pair) {
            swapping = true;
            _doMtcBurn(burnAmount);
            swapping = false;
        }

        uint256 bonusBanlance = IERC20(usdt).balanceOf(mtcBonus);
        if (bonusBanlance >= minBonus && !swapping && from != pair) {
            _doBonus();
        }

        uint256 sellAmount = balanceOf(address(this));
        if (sellAmount >= minsell && !swapping && from != pair) {
            swapping = true;
            _doSwap(sellAmount);
            swapping = false;
        }
        
        if (to == pair) { //sell, add
            (uint112 r0, uint112 r1, ) = IPancakePair(pair).getReserves();
            uint112 reserveUsdt;
            uint256 amountUsdt;
            if (r0 > 0 && r1 > 0) {
                if (IPancakePair(pair).token0() == address(this)) {
                    reserveUsdt = r1;
                    amountUsdt = pancakeRouter.quote(amount, r0, r1);
                } else {
                    reserveUsdt = r0;
                    amountUsdt = pancakeRouter.quote(amount, r1, r0);
                }
            }
            
            if (IERC20(usdt).balanceOf(pair) < reserveUsdt + amountUsdt) {
                uint256 mineFeeAmount = amount.div(100).mul(5);
                uint256 otherFeeAmount = amount.div(100).mul(7);

                _takeFee(from, lpAddress, mineFeeAmount);
                _takeFee(from, address(this), otherFeeAmount);

                amount = amount - mineFeeAmount - otherFeeAmount;
            } 
        }
        
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
    }
    
    function _doBonus() private {
        uint256 size = stakeBonus.getLength();
        uint256 i = index;
        uint256 done = 0;
        uint256 max  = 0;
        address user;

        while(i < size && done < 5 && max < 50) {
            user = stakeBonus.getHolder(i);

            uint256 bonusAmount = stakeBonus.balanceOf(user);
            if (bonusAmount > perMaxBonus) {
                bonusAmount = perMaxBonus;
            } 
            
            if (bonusAmount > 0 && !isContract(user) && stakeBonus.getIsValid(user)) {
                IERC20(usdt).transferFrom(mtcBonus, user, bonusAmount);
                done ++;
            }

            max++;
            i++;
        }
        if (i == size) { i = 0; }
        index = i;
    }

    function _doMtcBurn(uint256 usdtAmount) private {
        IERC20(usdt).transferFrom(mtcBurn, address(this), usdtAmount);
        _swapUsdtForToken(address(this), usdtAmount, destroyAddress);
    }
    
    function _doSwap(uint256 tokenAmount) private {
        _swapTokenForUsdt(tokenAmount, usdtOwner);
        
        uint256 sumAmount = IERC20(usdt).balanceOf(usdtOwner);
        if (sumAmount > 0) {
            uint256 burnAmount = sumAmount.div(70).mul(30);
            uint256 marketAmount = sumAmount - 2*burnAmount;

            IERC20(usdt).transferFrom(usdtOwner, mtcBurn, burnAmount);
            IERC20(usdt).transferFrom(usdtOwner, mtcBonus, burnAmount);
            IERC20(usdt).transferFrom(usdtOwner, marketAddress, marketAmount);
        } 
    }
    
    function _swapUsdtForToken(address tokenB, uint256 usdtAmount, address receiver) private {
        address[] memory path = new address[](2);
        path[0] = usdt;
        path[1] = tokenB;
        IERC20(usdt).approve(address(pancakeRouter), usdtAmount);
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            usdtAmount, 0, path, receiver, block.timestamp);
    }

    function _swapTokenForUsdt(uint256 tokenAmount, address receiver) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;
        _approve(address(this), address(pancakeRouter), tokenAmount);
        pancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(
            tokenAmount, 0, path, receiver, block.timestamp);
    }

    function _takeFee(address from, address to, uint256 amount) private {
        _balances[to] = _balances[to].add(amount);
        emit Transfer(from, to, amount);
    }
    
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function setUpgradeAddress(address upgradeAddress_) public onlyOwner {
        upgradeAddress = upgradeAddress_;
    }

    function setMineAddress(address mineAddress_) public onlyOwner {
        mineAddress = mineAddress_;
    }

    function setMtcStakeAddress(address mtcStakeAddress_) public onlyOwner {
        stakeBonus = MtcStake(mtcStakeAddress_);
    }

    function setStartTime(uint256 startTime_) public onlyOwner {
        startTime = startTime_;
    }

    function setMinsell(uint256 val) public onlyOwner {
        minsell = val * 10**16;
    }

    function setMinBurn(uint256 val) public onlyOwner {
        minBurn = val * 10**18;
    }

    function setMinBonus(uint256 val) public onlyOwner {
        minBonus = val * 10**18;
    }

}