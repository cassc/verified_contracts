/**
 *Submitted for verification at BscScan.com on 2022-11-11
*/

// File: openzeppelin-solidity-2.3.0/contracts/ownership/Ownable.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be aplied to your functions to restrict their use to
 * the owner.
 */
contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * > Note: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

// File: openzeppelin-solidity-2.3.0/contracts/math/SafeMath.sol

pragma solidity ^0.5.0;

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
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
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
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

// File: openzeppelin-solidity-2.3.0/contracts/utils/ReentrancyGuard.sol

pragma solidity ^0.5.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
 * available, which can be aplied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 */
contract ReentrancyGuard {
    /// @dev counter to allow mutex lock with only one SSTORE operation
    uint256 private _guardCounter;

    constructor () internal {
        // The counter starts at one to prevent changing it from zero to a non-zero
        // value, which is a more expensive operation.
        _guardCounter = 1;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _guardCounter += 1;
        uint256 localCounter = _guardCounter;
        _;
        require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
    }
}

// File: @uniswap/v2-core/contracts/libraries/Math.sol

pragma solidity =0.5.16;

// a library for performing various math operations

library Math {
    function min(uint x, uint y) internal pure returns (uint z) {
        z = x < y ? x : y;
    }

    // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
    function sqrt(uint y) internal pure returns (uint z) {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

// File: contracts/SafeToken.sol

pragma solidity 0.5.16;

interface ERC20Interface {
    function balanceOf(address user) external view returns (uint256);
}

library SafeToken {
    function myBalance(address token) internal view returns (uint256) {
        return ERC20Interface(token).balanceOf(address(this));
    }

    function balanceOf(address token, address user) internal view returns (uint256) {
        return ERC20Interface(token).balanceOf(user);
    }

    function safeApprove(address token, address to, uint256 value) internal {
        // bytes4(keccak256(bytes('approve(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeApprove");
    }

    function safeTransfer(address token, address to, uint256 value) internal {
        // bytes4(keccak256(bytes('transfer(address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransfer");
    }

    function safeTransferFrom(address token, address from, address to, uint256 value) internal {
        // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
        require(success && (data.length == 0 || abi.decode(data, (bool))), "!safeTransferFrom");
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call.value(value)(new bytes(0));
        require(success, "!safeTransferETH");
    }
}

// File: contracts/Strategy.sol

pragma solidity 0.5.16;

interface Strategy {
    /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.
    /// @param user The original user that is interacting with the operator.
    /// @param debt The user's total debt, for better decision making context.
    /// @param data Extra calldata information passed along to this strategy.
    function execute(address user, uint256 debt, bytes calldata data) external payable;
}

// File: contracts/wombat/IWombatPool.sol

pragma solidity 0.5.16;

interface IWombatPool {
    function quotePotentialWithdraw(address token, uint256 liquidity)
    external
    view
    returns (uint256 amount, uint256 fee);

  function quotePotentialSwap(
    address fromToken,
    address toToken,
    int256 fromAmount
  ) external
    view
    returns (uint256 potentialOutcome, uint256 haircut);

  function deposit(
    address token,
    uint256 amount,
    uint256 minimumLiquidity,
    address to,
    uint256 deadline,
    bool shouldStake
  ) external returns (uint256 liquidity);

  function withdraw(
    address token,
    uint256 liquidity,
    uint256 minimumAmount,
    address to,
    uint256 deadline
  ) external returns (uint256 amount);
}

// File: contracts/wombat/IWombatRouterV2.sol

pragma solidity 0.5.16;

interface IWombatRouterV2 {
  function wNative() external returns (address);

  function swapExactTokensForTokens(
    address[] calldata tokenPath,
    address[] calldata poolPath,
    uint256 amountIn,
    uint256 minimumamountOut,
    address to,
    uint256 deadline
  ) external returns (uint256 amountOut);

  function swapExactNativeForTokens(
    address[] calldata tokenPath,
    address[] calldata poolPath,
    uint256 minimumamountOut,
    address to,
    uint256 deadline
  ) external payable returns (uint256 amountOut);

  function swapExactTokensForNative(
    address[] calldata tokenPath,
    address[] calldata poolPath,
    uint256 amountIn,
    uint256 minimumamountOut,
    address to,
    uint256 deadline
  ) external returns (uint256 amountOut);
}

// File: contracts/ISwapV2.sol

pragma solidity 0.5.16;

interface ISwapV2 {
  function etherERC20() external pure returns (address);
  function swapQuery(uint256 amount, address src, address dest) external payable;
}

// File: contracts/StrategyAddTwoSidesOptimalWombatV2BR.sol

pragma solidity 0.5.16;










interface IGoblin {
  function wombatPool() view external returns (address);
  function wombatLpToken() view external returns (address);
  function wombatFarming() view external returns (address);
  function router() view external returns (address);
  function farmingPid() view external returns (uint256);
}

contract StrategyAddTwoSidesOptimalWombatV2BR is Ownable, ReentrancyGuard, Strategy {
    using SafeToken for address;
    using SafeMath for uint256;

    address public weth;
    address public goblin;
    IWombatRouterV2 public router;
    IWombatPool public wombatPool;
    ISwapV2 public swap;
    address public swapWETH;

    /// @dev Create a new add two-side optimal strategy instance.
    /// @param _router The Uniswap router smart contract.
    constructor(IWombatRouterV2 _router, address _goblin, IWombatPool _wombatPool, ISwapV2 _swap) public {
        router = _router;
        swap = _swap;
        swapWETH = _swap.etherERC20();
        weth = _router.wNative();
        goblin = address(_goblin);
        wombatPool = _wombatPool;
    }
    
    /// @dev Throws if called by any account other than the goblin.
    modifier onlyGoblin() {
        require(isGoblin(), "caller is not the goblin");
        _;
    }

    /// @dev Returns true if the caller is the current goblin.
    function isGoblin() public view returns (bool) {
        return msg.sender == goblin;
    }

    /// @dev Execute worker strategy. Take LP tokens + ETH. Return LP tokens + ETH.
    /// @param user User address
    /// @param data Extra calldata information passed along to this strategy.
    function execute(address user, uint256, /* debt */ bytes calldata data) 
        external         
        payable  
        onlyGoblin       
        nonReentrant 
    {
        // 1. Find out what farming token we are dealing with.
        (address fToken, uint256 fAmount, uint256 minLPAmount, address lpToken) = abi.decode(data, (address, uint256, uint256, address));
        // 2. Compute the optimal amount of ETH and fToken to be converted.  
        if (fAmount > 0) {  
            fToken.safeTransferFrom(user, address(this), fAmount);            
        }
        uint256 ethBalance = address(this).balance;
        // 3. Convert between ETH and farming tokens
        if (ethBalance > 0) {
            swap.swapQuery.value(ethBalance)(ethBalance, swapWETH, fToken); // ETH to farming tokens
        }
        // 4. Mint more LP tokens and return all LP tokens to the sender.
        fToken.safeApprove(address(wombatPool), 0);
        fToken.safeApprove(address(wombatPool), uint(-1));
        (uint256 moreLPAmount) = wombatPool.deposit(
            fToken, fToken.myBalance(), 0, address(this), now, false
        );
        require(moreLPAmount >= minLPAmount, "insufficient LP tokens received");
        lpToken.safeTransfer(msg.sender, lpToken.balanceOf(address(this)));
    }

    /// @dev Recover ERC20 tokens that were accidentally sent to this smart contract.
    /// @param token The token contract. Can be anything. This contract should not hold ERC20 tokens.
    /// @param to The address to send the tokens to.
    /// @param value The number of tokens to transfer to `to`.
    function recover(address token, address to, uint256 value) external onlyOwner nonReentrant {
        token.safeTransfer(to, value);
    }

    function() external payable {}
}