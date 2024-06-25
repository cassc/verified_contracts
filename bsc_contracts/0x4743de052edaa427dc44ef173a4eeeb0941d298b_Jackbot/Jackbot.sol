/**
 *Submitted for verification at BscScan.com on 2022-09-18
*/

/*
JACKBOT - The Greatest Crypto Lottery Ever Made on the Binance Smart Chain
https://jackbot.club/
https://t.me/FeelingLuckyToday
https://twitter.com/JackBotBSC
*/

// File: contracts/random.sol

//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;
library Random {
    /*
     * @dev startingValue is inclusive, endingValue is inclusive
     * naive implementation! Do not use in production
     * ie if 1, 10, rand int can include 1-10
     */
    function naiveRandInt(uint256 _startingValue, uint256 _endingValue)
        internal
        view
        returns (uint256)
    {
        // hash of the given block when blocknumber is one of the 256 most recent blocks; otherwise returns zero
        // create random value from block number; use previous block number just to make sure we aren't on 0
        uint randomInt = uint(blockhash(block.number - 1));
        // convert this into a number within range
        uint range = _endingValue - _startingValue + 1; // add 1 to ensure it is inclusive within endingValue

        randomInt = randomInt % range; // modulus ensures value is within range
        randomInt += _startingValue; // now shift by startingValue to ensure it is >= startingValue

        return randomInt;
    }
}
// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol

pragma solidity >=0.6.2;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

// File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol

pragma solidity >=0.6.2;


interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol

pragma solidity >=0.5.0;

interface IUniswapV2Pair {
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

// File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol

pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)

pragma solidity ^0.8.1;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
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
        return a + b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
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
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: contracts/Jackbot.sol


pragma solidity ^0.8.10;

contract Jackbot is Context, IERC20 {
  using SafeMath for uint256;
  using Address for address;

  address private _owner;

  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );

  function owner() public view virtual returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(owner() == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public virtual onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }

  mapping(address => uint256) private _tOwned;

  uint256 private _round = 0;
  mapping(uint256 => mapping(address => uint256)) private _jackpotAllocation;

  mapping(address => mapping(address => uint256)) private _allowances;
  mapping(address => bool) public _isExcludedFromFee;

  address payable public Wallet_Marketing =
    payable(0xF3BeAaD8F3CFDCE8b0f2a0f0F677a58058CCd877);
  address payable public constant Wallet_Burn =
    payable(0x000000000000000000000000000000000000dEaD);
  address payable public constant Team_Vesting_wallet =
    payable(0x9Ecdb7B19D9493A23950eafd79165c4B0C1F6371);
  address payable public constant Private_Vesting_Wallet =
    payable(0x2877d66346D10f3e2041546e3b5c2E711ed44f92);
  address payable public constant PS_Lock = payable(0x407993575c91ce7643a4d4cCACc9A98c36eE1BBE);
    address payable public constant MD_Lock = payable(0xD55d70E9F7243A11e650E7d1569649B2E9BB6b68);
    address payable public Development = payable(0xeaEd594B5926A7D5FBBC61985390BaAf936a6b8d);



  address public WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;

  uint256 private constant MAX = ~uint256(0);
  uint8 private constant _decimals = 18;
  uint256 private _tTotal = 777777777 * 10**_decimals;
  string private constant _name = "Jackbot";
  string private constant _symbol = "JB";

  uint8 private txCount = 0;
  uint8 private swapTrigger = 3;

  // This is the max fee that the contract will accept, it is hard-coded to protect buyers
  uint256 public maxPossibleSellFee = 20;
  uint256 public maxPossibleBuyFee = 20;

  uint256 public _Tax_On_Buy = 10;
  uint256 public _Tax_On_Sell = 10;

  uint256 public Percent_Marketing = 20;
  uint256 public Percent_Hourly_Jackpot = 50;
  uint256 public Percent_Daily_Jackpot = 10;
  uint256 public Percent_Burn = 0;
  uint256 public Percent_AutoLP = 20;

  uint256 public _maxWalletToken = _tTotal.mul(15).div(1000);
  uint256 private _previousMaxWalletToken = _maxWalletToken;

  uint256 public _maxTxAmount = _tTotal.mul(15).div(1000);
  uint256 private _previousMaxTxAmount = _maxTxAmount;

  IUniswapV2Router02 public uniswapV2Router;
  address public uniswapV2Pair;
  bool public inSwapAndLiquify;
  bool public swapAndLiquifyEnabled = true;

  event SwapAndLiquifyEnabledUpdated(bool true_or_false);
  event SwapAndLiquify(
    uint256 tokensSwapped,
    uint256 ethReceived,
    uint256 tokensIntoLiqudity
  );

  event isbuy(bool isit);
  event buyfee(uint256 buyFEE);
  event txcount(uint256 ttxcount);
  event ttransferAmount(uint256 tTransferAmount);
  event howmuchfee(uint256 fee);
  event isswap(bool truefalse);
  event inswapAndLiquify(bool trufals);
  event frm(address frmo);
  event tto(address ttto);
  event swapandLiquifyEnabled(bool trufls);

  modifier lockTheSwap() {
    inSwapAndLiquify = true;
    _;
    inSwapAndLiquify = false;
  }

  constructor() {
    address deployer = msg.sender;

    _owner = deployer;
    emit OwnershipTransferred(address(0), _owner);

    _tOwned[owner()] = _tTotal;

    IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
      0x10ED43C718714eb63d5aA57B78B54704E256024E
    );

    uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
      address(this),
      _uniswapV2Router.WETH()
    );
    uniswapV2Router = _uniswapV2Router;

    _isExcludedFromFee[owner()] = true;
    _isExcludedFromFee[address(this)] = true;
    _isExcludedFromFee[Wallet_Marketing] = true;
    _isExcludedFromFee[Wallet_Burn] = true;
    _isExcludedFromFee[Team_Vesting_wallet] = true;
    _isExcludedFromFee[Private_Vesting_Wallet] = true;
    _isExcludedFromFee[PS_Lock] = true;
    _isExcludedFromFee[MD_Lock] = true;
    _isExcludedFromFee[Development] = true;


    emit Transfer(address(0), owner(), _tTotal);
  }

  function changeBS(uint256 bamount, uint256 samount) public onlyOwner {
    require((samount) <= maxPossibleSellFee, "Sell fee is too high!");
    require((bamount) <= maxPossibleBuyFee, "Buy fee is too high!");

    _Tax_On_Buy = bamount;
    _Tax_On_Sell = samount;
  }

  function changeTaxDist(
    uint256 marketing,
    uint256 jackpothr,
    uint256 jackpotday,
    uint256 burn,
    uint256 lp
  ) public onlyOwner {
    uint256 total = marketing + jackpothr + jackpotday + burn + lp;
    require((total) == 100, "Not 100%");
    Percent_Marketing = marketing;
    Percent_Hourly_Jackpot = jackpothr;
    Percent_Daily_Jackpot = jackpotday;
    Percent_Burn = burn;
    Percent_AutoLP = lp;
  }

  function changeMTX(uint256 amount) public onlyOwner {
    _maxTxAmount = amount;
  }

  function changeMW(uint256 amount) public onlyOwner {
    _maxWalletToken = amount;
  }

  function changeTS(uint256 amount) public onlyOwner {
    _ticketSet = amount;
    ticketPrice = (_ticketSet * (10**16));
  }

  function changeMWPerc(uint256 amount) public onlyOwner {
    _maxWalletToken = (_tTotal * amount) / 1000;
  }

  function changeDevelopmentWallet(address payable wallet) public onlyOwner{
    Development = payable(wallet);
  }

  function name() public pure returns (string memory) {
    return _name;
  }

  function symbol() public pure returns (string memory) {
    return _symbol;
  }

  function decimals() public pure returns (uint8) {
    return _decimals;
  }

  function totalSupply() public view override returns (uint256) {
    return _tTotal;
  }

  function balanceOf(address account) public view override returns (uint256) {
    return _tOwned[account];
  }

  function transfer(address recipient, uint256 amount)
    public
    override
    returns (bool)
  {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function allowance(address theOwner, address theSpender)
    public
    view
    override
    returns (uint256)
  {
    return _allowances[theOwner][theSpender];
  }

  function approve(address spender, uint256 amount)
    public
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
  ) public override returns (bool) {
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

  receive() external payable {}

  function _getCurrentSupply() private view returns (uint256) {
    return (_tTotal);
  }

  function balanceOfBNB() public view returns (uint256) {
    return address(this).balance;
  }

  function _approve(
    address theOwner,
    address theSpender,
    uint256 amount
  ) private {
    require(
      theOwner != address(0) && theSpender != address(0),
      "ERR: zero address"
    );
    _allowances[theOwner][theSpender] = amount;
    emit Approval(theOwner, theSpender, amount);
  }

  function _transfer(
    address from,
    address to,
    uint256 amount
  ) private {
    if (
      to != owner() &&
      to != Wallet_Burn &&
      to != Wallet_Marketing &&
      to != address(this) &&
      to != uniswapV2Pair &&
      to != Team_Vesting_wallet &&
      to != Private_Vesting_Wallet &&
      to != PS_Lock &&
      to != MD_Lock &&
      to != Development &&
      from != Development &&
      from != owner()
    ) {
      uint256 heldTokens = balanceOf(to);
      require((heldTokens + amount) <= _maxWalletToken, "Over wallet limit.");
    }

    if (
      from != Wallet_Marketing &&
      from != Team_Vesting_wallet &&
      from != Private_Vesting_Wallet &&
      from != PS_Lock &&
      from != MD_Lock &&
      from != Development &&
      from != owner()
    )
{      require(amount <= _maxTxAmount, "Over transaction limit.");
}
    require(from != address(0) && to != address(0), "ERR: Using 0 address!");
    require(amount > 0, "Token value must be higher than zero.");

    if (
      txCount >= swapTrigger &&
      !inSwapAndLiquify &&
      from != uniswapV2Pair &&
      swapAndLiquifyEnabled &&
      from != Wallet_Marketing &&
      to != Wallet_Marketing
    ) {
      //  emit isswap (true);

      uint256 contractTokenBalance = balanceOf(address(this));
      if (contractTokenBalance > _maxTxAmount) {
        contractTokenBalance = _maxTxAmount;
      }
      txCount = 0;
      swapAndLiquify(contractTokenBalance);
    }

    bool takeFee = true;
    bool isBuy;
    if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
      takeFee = false;
    } else {
      if (from == uniswapV2Pair) {
        isBuy = true;
      }

      txCount++;
      //    emit txcount (txCount);
    }

    _tokenTransfer(from, to, amount, takeFee, isBuy);
  }

  function sendToWallet(address payable wallet, uint256 amount) private {
    wallet.transfer(amount);
  }

  /*----------------------------------------------------------------
in case of emergenices
*/
  function withdrawBNB(address payable wallet, uint256 amount)
    public
    onlyOwner
  {
    wallet.transfer(amount);
  }

  function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
    uint256 tokens_to_Burn = (contractTokenBalance * Percent_Burn) / 100;
    _tTotal = _tTotal - tokens_to_Burn;
    _tOwned[Wallet_Burn] = _tOwned[Wallet_Burn] + tokens_to_Burn;
    _tOwned[address(this)] = _tOwned[address(this)] - tokens_to_Burn;

    uint256 tokens_to_M = (contractTokenBalance * Percent_Marketing) / 100;
    uint256 tokens_to_D = (contractTokenBalance * Percent_Hourly_Jackpot) / 100;
    uint256 tokens_to_J = (contractTokenBalance * Percent_Daily_Jackpot) / 100;
    uint256 tokens_to_LP_Half = (contractTokenBalance * Percent_AutoLP) / 200;

    uint256 balanceBeforeSwap = address(this).balance;
    swapTokensForBNB(
      tokens_to_LP_Half + tokens_to_M + tokens_to_D + tokens_to_J
    );
    uint256 BNB_Total = address(this).balance - balanceBeforeSwap;

    uint256 split_M = (Percent_Marketing * 100) /
      (Percent_AutoLP +
        Percent_Marketing +
        Percent_Hourly_Jackpot +
        Percent_Daily_Jackpot);
    uint256 BNB_M = (BNB_Total * split_M) / 100;

    //hourly jackpot pot
    uint256 split_D = (Percent_Hourly_Jackpot * 100) /
      (Percent_AutoLP +
        Percent_Marketing +
        Percent_Hourly_Jackpot +
        Percent_Daily_Jackpot);
    uint256 BNB_D = (BNB_Total * split_D) / 100;
    hourlyPool = hourlyPool + BNB_D;

    //daily jackpot pot
    uint256 split_J = (Percent_Daily_Jackpot * 100) /
      (Percent_AutoLP +
        Percent_Marketing +
        Percent_Hourly_Jackpot +
        Percent_Daily_Jackpot);
    uint256 BNB_J = (BNB_Total * split_J) / 100;
    dailyPool = dailyPool + BNB_J;

    addLiquidity(tokens_to_LP_Half, (BNB_Total - BNB_M - BNB_D - BNB_J));
    emit SwapAndLiquify(
      tokens_to_LP_Half,
      (BNB_Total - BNB_M - BNB_D - BNB_J),
      tokens_to_LP_Half
    );

    sendToWallet(Wallet_Marketing, BNB_M);

    BNB_Total = address(this).balance;
  }

  function swapTokensForBNB(uint256 tokenAmount) private {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapV2Router.WETH();
    _approve(address(this), address(uniswapV2Router), tokenAmount);
    uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
      tokenAmount,
      0,
      path,
      address(this),
      block.timestamp
    );
  }

  function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {
    _approve(address(this), address(uniswapV2Router), tokenAmount);
    uint256 dline = block.timestamp + 30;
    uniswapV2Router.addLiquidityETH{ value: BNBAmount }(
      address(this),
      tokenAmount,
      0,
      0,
      owner(),
      dline
    );
  }

  function remove_Random_Tokens(
    address random_Token_Address,
    uint256 percent_of_Tokens
  ) public returns (bool _sent) {
    require(
      random_Token_Address != address(this),
      "Can not remove native token"
    );
    uint256 totalRandom = IERC20(random_Token_Address).balanceOf(address(this));
    uint256 removeRandom = (totalRandom * percent_of_Tokens) / 100;
    _sent = IERC20(random_Token_Address).transfer(
      Wallet_Marketing,
      removeRandom
    );
  }

  function _tokenTransfer(
    address sender,
    address recipient,
    uint256 tAmount,
    bool takeFee,
    bool isBuy
  ) private {
    if (!takeFee) {
      _tOwned[sender] = _tOwned[sender] - tAmount;
      _tOwned[recipient] = _tOwned[recipient] + tAmount;
      emit Transfer(sender, recipient, tAmount);

      if (recipient == Wallet_Burn) _tTotal = _tTotal - tAmount;
    } else if (isBuy) {
      uint256 tokenBNBprice = getAmountOutMin(address(this), WBNB, tAmount);
      bnbAmount[recipient] = bnbAmount[recipient] + tokenBNBprice;
      uint256 ticketAmount = bnbAmount[recipient] / ticketPrice;

      //  if(tickets[recipient] )
      if (ticketAmount > 0) {
        if (hodlBonus[recipient] == 0) {
          hodlBonus[recipient] = block.timestamp;
          if (hodlBonusDaily[recipient] == 0) {
            hodlBonusDaily[recipient] = block.timestamp;
          }
        }
        if (lotteriesDaily[currentLotteryIdDaily].isActive == true) {
          if (ticketsDaily[recipient] == 0) {
            buyLotteryTicketsDaily(1, recipient);
          }
        }
        if (lotteries[currentLotteryId].isActive == true) {
          buyLotteryTickets(ticketAmount, recipient);

          bnbAmount[recipient] =
            bnbAmount[recipient] -
            (ticketAmount * ticketPrice);
        }
      }

      //     emit howmuchfee(tAmount);
      uint256 buyFEE = (tAmount * _Tax_On_Buy) / 100;
      //     emit buyfee(buyFEE);

      uint256 tTransferAmount = tAmount - buyFEE;
      //       emit ttransferAmount(tTransferAmount);

      _tOwned[sender] = _tOwned[sender] - tAmount;
      _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
      _tOwned[address(this)] = _tOwned[address(this)] + buyFEE;

      emit Transfer(sender, recipient, tTransferAmount);

      if (recipient == Wallet_Burn) _tTotal = _tTotal - tTransferAmount;
    } else {
      uint256 tokenBNBprice = getAmountOutMin(address(this), WBNB, tAmount);
      bnbAmountSell[sender] = bnbAmountSell[sender] + tokenBNBprice;

      uint256 ticketAmount = bnbAmountSell[sender] / ticketPrice;

      if (ticketAmount > 0) {
        if (lotteriesDaily[currentLotteryIdDaily].isActive == true) {
          if (ticketsDaily[sender] == 1) {
            sellLotteryTicketsDaily(1, sender);
          }
        }
        if (lotteries[currentLotteryId].isActive == true) {
          if (tickets[sender] > 0) {
            if (ticketAmount > tickets[sender]) {
              sellLotteryTickets(tickets[sender], sender);
            } else {
              sellLotteryTickets(ticketAmount, sender);
            }
          }
          if (bnbAmountSell[sender] < (ticketAmount * ticketPrice)) {
            bnbAmountSell[sender] = 0;
          } else {
            bnbAmountSell[sender] =
              bnbAmountSell[sender] -
              (ticketAmount * ticketPrice);
          }
        }
      }
      hodlBonus[sender] = 0;
      hodlBonusDaily[sender] = 0;

      uint256 sellFEE = (tAmount * _Tax_On_Sell) / 100;
      uint256 tTransferAmount = tAmount - sellFEE;

      _tOwned[sender] = _tOwned[sender] - tAmount;
      _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
      _tOwned[address(this)] = _tOwned[address(this)] + sellFEE;
      emit Transfer(sender, recipient, tTransferAmount);

      if (recipient == Wallet_Burn) _tTotal = _tTotal - tTransferAmount;
    }
  }

  /*
Calculate 1 token price via router getAmountsOut method
*/
  function getAmountOutMin(
    address _tokenIn,
    address _tokenOut,
    uint256 _amount
  ) public view returns (uint256) {
    address[] memory path;
    path = new address[](2);
    path[0] = _tokenIn;
    path[1] = _tokenOut;
    uint256[] memory amountOutMins = uniswapV2Router.getAmountsOut(
      _amount,
      path
    );
    return amountOutMins[path.length - 1];
  }

  struct LotteryStruct {
    uint256 lotteryId;
    uint256 startTime;
    uint256 endTime;
    bool isActive;
    bool isCompleted; // winner was found; winnings were deposited.
    bool isCreated; // is created
  }
  struct TicketDistributionStruct {
    address playerAddress;
    uint256 startIndex; // inclusive
    uint256 endIndex; // inclusive
  }
  struct WinningTicketStruct {
    uint256 currentLotteryId;
    uint256 winningTicketIndex;
    address addr; // TASK: rename to "winningAddress"?
  }

  uint256 public constant NUMBER_OF_HOURS_HOURLY = 1; // 1 day by default; configurable
  uint256 public constant NUMBER_OF_HOURS_DAILY = 24; // 1 day by default; configurable

  bool public inLotteryDraw; //used so people can't buy while drawing lottery

  // max # loops allowed for binary search; to prevent some bugs causing infinite loops in binary search
  uint256 public maxLoops = 10;
  uint256 private loopCount = 0; // for binary search

  uint256 public _ticketSet = 1;
  uint256 public ticketPrice = (_ticketSet * (10**16));

  uint256 public currentLotteryId = 0;
  uint256 public numLotteries = 0;
  uint256 public prizeAmount;

  WinningTicketStruct public winningTicket;

  TicketDistributionStruct[] public ticketDistribution;

  address[] public listOfPlayers; // Don't rely on this for current participants list

  uint256 public numActivePlayers;
  uint256 public numTotalTickets;

  uint256 public hourlyPool;
  uint256 public dailyPool;

  mapping(uint256 => WinningTicketStruct) public winningTickets; // key is lotteryId
  mapping(address => bool) public players; // key is player address
  mapping(address => uint256) public tickets; // key is player address
  mapping(uint256 => LotteryStruct) public lotteries; // key is lotteryId
  mapping(uint256 => address payable) public winnerAddress;

  mapping(address => uint256) public hodlBonus;

  mapping(address => uint256) public bnbAmount;
  mapping(address => uint256) public bnbAmountSell;

  // Events
  event LogNewLottery(address creator, uint256 startTime, uint256 endTime); // emit when lottery created

  // emit when lottery drawing happens; winner found
  event LogWinnerFound(
    uint256 lotteryId,
    uint256 winningTicketIndex,
    address winningAddress,
    uint256 prize
  );

  // Errors
  error Lottery__ActiveLotteryExists();
  error Lottery__NotCompleted();
  error Lottery__InadequateFunds();
  error Lottery__InvalidWinningIndex();
  error Lottery__InvalidWithdrawalAmount();
  error Lottery__WithdrawalFailed();

  /* check that new lottery is a valid implementation
    previous lottery must be inactive for new lottery to be saved
    for when new lottery will be saved
    */
  modifier isNewLotteryValid() {
    // active lottery
    LotteryStruct memory lottery = lotteries[currentLotteryId];
    if (lottery.isActive == true) {
      revert Lottery__ActiveLotteryExists();
    }
    _;
  }

  /* check that period is completed, and lottery drawing can begin
    either:
    1.  period manually ended, ie lottery is inactive. Then drawing can begin immediately.
    2. lottery period has ended organically, and lottery is still active at that point
    */
  modifier isLotteryCompleted() {
    if (
      !((lotteries[currentLotteryId].isActive == true &&
        lotteries[currentLotteryId].endTime < block.timestamp) ||
        lotteries[currentLotteryId].isActive == false)
    ) {
      revert Lottery__NotCompleted();
    }
    _;
  }

  /*
    A function for owner to force update lottery status isActive to false
    public because it needs to be called internally when a Lottery is cancelled
    */
  function setLotteryInactive() public onlyOwner {
    lotteries[currentLotteryId].isActive = false;
  }

  /*
    A function for owner to force update lottery to be cancelled
    funds should be returned to players too
    */
  function cancelLottery() external onlyOwner {
    setLotteryInactive();
    _resetLottery();
  }

  /*
    A function to initialize a lottery
    probably should also be onlyOwner
    uint256 startTime_: start of period, unixtime
    uint256 numHours: in hours, how long period will last
    */
  function initLottery(uint256 startTime_, uint256 numHours_)
    public
    onlyOwner
    isNewLotteryValid
  {
    // basically default value
    // if set to 0, default to explicit default number of days
    if (numHours_ == 0) {
      numHours_ = NUMBER_OF_HOURS_HOURLY;
    }
    delete listOfPlayers;
    numTotalTickets = 0;
    numActivePlayers = 0;

    uint256 endTime = startTime_ + (numHours_ * 1 hours);
    currentLotteryId = currentLotteryId + 1;
    lotteries[currentLotteryId] = LotteryStruct({
      lotteryId: currentLotteryId,
      startTime: startTime_,
      endTime: endTime,
      isActive: true,
      isCompleted: false,
      isCreated: true
    });
    numLotteries = numLotteries + 1;
    emit LogNewLottery(msg.sender, startTime_, endTime);
  }

  /*
    a function for players to lottery tix
    */
  function buyLotteryTickets(uint256 numberOfTickets, address player) private {
    uint256 _numTickets = numberOfTickets;
    require(_numTickets >= 1);
    // if player is "new" for current lottery, update the player lists

    uint256 _numActivePlayers = numActivePlayers;

    if (players[player] == false) {
      if (listOfPlayers.length > _numActivePlayers) {
        listOfPlayers[_numActivePlayers] = player;
      } else {
        listOfPlayers.push(player); // otherwise append to array
      }
      players[player] = true;
      numActivePlayers = _numActivePlayers + 1;
    }
    tickets[player] = tickets[player] + _numTickets; // account for if user has already tix previously for this current lottery
    numTotalTickets = numTotalTickets + _numTickets; // update the total # of tickets
  }

  /*
    a function for players to lottery tix
    */
  function sellLotteryTickets(uint256 numberOfTickets, address player) private {
    uint256 _numTickets = numberOfTickets;
    require(_numTickets >= 1);
    require(tickets[player] >= _numTickets); // double check that user has enough tix to sell
    // if player is "new" for current lottery, update the player lists

    //  uint _numActivePlayers = numActivePlayers;

    tickets[player] = tickets[player] - _numTickets; // account for if user has already tix previously for this current lottery
    numTotalTickets = numTotalTickets - _numTickets; // update the total # of tickets sell
  }

  /*
    a function for owner to trigger lottery drawing
    */

  function triggerLotteryDrawing() public onlyOwner isLotteryCompleted {
    // console.log("triggerLotteryDrawing");

    _playerTicketDistribution(); // create the distribution to get ticket indexes for each user
    // can't be done a prior bc of potential multiple tix per user
    uint256 winningTicketIndex = _performRandomizedDrawing();

    // initialize what we can first
    winningTicket.currentLotteryId = currentLotteryId;
    winningTicket.winningTicketIndex = winningTicketIndex;

    findWinningAddress(winningTicketIndex); // via binary search

    winnerAddress[currentLotteryId] = payable(winningTicket.addr); // keep track of winning address for each of the previous lotteries

    sendToWallet(winnerAddress[currentLotteryId], hourlyPool);

    emit LogWinnerFound(
      currentLotteryId,
      winningTicket.winningTicketIndex,
      winningTicket.addr,
      hourlyPool
    );
    hourlyPool = 0;

    hodlBonus[winningTicket.addr] = 0;
    lotteries[currentLotteryId].isCompleted = true;
  }

  /*
    getter function for ticketDistribution bc its a struct
    */
  function getTicketDistribution(uint256 playerIndex_)
    public
    view
    returns (
      address playerAddress,
      uint256 startIndex, // inclusive
      uint256 endIndex // inclusive
    )
  {
    return (
      ticketDistribution[playerIndex_].playerAddress,
      ticketDistribution[playerIndex_].startIndex,
      ticketDistribution[playerIndex_].endIndex
    );
  }

  /*
    function to handle creating the ticket distribution
    if 1) player1 buys 10 tix, then 2) player2 buys 5 tix, and then 3) player1 buys 5 more
    player1's ticket indices will be 0-14; player2's from 15-19
    this is why ticketDistribution cannot be determined until period is closed
    */
  function _playerTicketDistribution() private {
    uint256 _ticketDistributionLength = ticketDistribution.length; // so state var doesn't need to be invoked each iteration of loop

    uint256 _ticketIndex = 0; // counter within loop
    for (uint256 i = _ticketIndex; i < numActivePlayers; i++) {
      address _playerAddress = listOfPlayers[i];
      uint256 _numTickets = tickets[_playerAddress] +
        _calculateHodlBonus(_playerAddress);

      TicketDistributionStruct memory newDistribution = TicketDistributionStruct({
        playerAddress: _playerAddress,
        startIndex: _ticketIndex,
        endIndex: _ticketIndex + _numTickets - 1 // sub 1 to account for array indices starting from 0
      });
      if (_ticketDistributionLength > i) {
        ticketDistribution[i] = newDistribution;
      } else {
        ticketDistribution.push(newDistribution);
      }

      tickets[_playerAddress] = 0; // reset player's tickets to 0 after they've been counted
      _ticketIndex = _ticketIndex + _numTickets;
    }
  }

  /*
    function to generate random winning ticket index. Still need to find corresponding user afterwards.
    */

  function _performRandomizedDrawing() private view returns (uint256) {
    // console.log("_performRandomizedDrawing");
    /* TASK: implement random drawing from 0 to numTotalTickets-1
    use chainlink https://docs.chain.link/docs/get-a-random-number/ to get random values
    */
    return Random.naiveRandInt(0, numTotalTickets - 1);
  }

  /*
    function to find winning player address corresponding to winning ticket index
    calls binary search
    uint256 winningTicketIndex_: ticket index selected as winner.
    Search for this within the ticket distribution to find corresponding Player
    */
  function findWinningAddress(uint256 winningTicketIndex1_) private {
    // console.log("findWinningAddress");
    uint256 _numActivePlayers = numActivePlayers;
    if (_numActivePlayers == 1) {
      winningTicket.addr = ticketDistribution[0].playerAddress;
    } else {
      // do binary search on ticketDistribution array to find winner
      uint256 _winningPlayerIndex = _bSearch(
        0,
        _numActivePlayers - 1,
        winningTicketIndex1_
      );
      if (_winningPlayerIndex >= _numActivePlayers) {
        revert Lottery__InvalidWinningIndex();
      }
      winningTicket.addr = ticketDistribution[_winningPlayerIndex]
        .playerAddress;
    }
  }

  /*
    function implementing binary search on ticket distribution var
    uint256 leftIndex_ initially 0
    uint256 rightIndex_ initially max ind, ie array.length - 1
    uint256 ticketIndexToFind_ to search for
    */

  function _bSearch(
    uint256 leftIndex_,
    uint256 rightIndex_,
    uint256 ticketIndexToFind_
  ) private returns (uint256) {
    uint256 _searchIndex = (rightIndex_ - leftIndex_) / (2) + (leftIndex_);
    uint256 _loopCount = loopCount;
    // counter
    loopCount = _loopCount + 1;
    if (_loopCount + 1 > maxLoops) {
      // emergency stop in case infinite loop due to unforeseen bug
      return numActivePlayers;
    }

    if (
      ticketDistribution[_searchIndex].startIndex <= ticketIndexToFind_ &&
      ticketDistribution[_searchIndex].endIndex >= ticketIndexToFind_
    ) {
      return _searchIndex;
    } else if (
      ticketDistribution[_searchIndex].startIndex > ticketIndexToFind_
    ) {
      // go to left subarray
      rightIndex_ = _searchIndex - (leftIndex_);

      return _bSearch(leftIndex_, rightIndex_, ticketIndexToFind_);
    } else if (ticketDistribution[_searchIndex].endIndex < ticketIndexToFind_) {
      // go to right subarray
      leftIndex_ = _searchIndex + (leftIndex_) + 1;
      return _bSearch(leftIndex_, rightIndex_, ticketIndexToFind_);
    }

    // if nothing found (bug), return an impossible player index
    // this index is outside expected bound, bc indexes run from 0 to numActivePlayers-1
    return numActivePlayers;
  }

  /*
    function to reset lottery by setting state vars to defaults
    */

  function _resetLottery() private {
    // console.log("_resetLottery");

    numTotalTickets = 0;
    numActivePlayers = 0;
    lotteries[currentLotteryId].isActive = false;
    lotteries[currentLotteryId].isCompleted = true;
    delete listOfPlayers;
    winningTicket = WinningTicketStruct({
      currentLotteryId: 0,
      winningTicketIndex: 0,
      addr: address(0)
    });

    // increment id counter
    currentLotteryId = currentLotteryId + (1);
  }

  /*
    function calculate hodl bonus tickets (one per hour)
    */

  function _calculateHodlBonus(address player) public view returns (uint256) {
    uint256 _hodlBonus = 0;
    // uint256 bonusStart =  hodlBonus[player]
    if (hodlBonus[player] > 0) {
      _hodlBonus = (block.timestamp - hodlBonus[player]) / 3600;
    }

    return _hodlBonus;
  }

  struct LotteryStructDaily {
    uint256 lotteryId;
    uint256 startTime;
    uint256 endTime;
    bool isActive;
    bool isCompleted; // winner was found; winnings were deposited.
    bool isCreated; // is created
  }
  struct TicketDistributionStructDaily {
    address playerAddress;
    uint256 startIndex; // inclusive
    uint256 endIndex; // inclusive
  }
  struct WinningTicketStructDaily {
    uint256 currentLotteryId;
    uint256 winningTicketIndex;
    address addr; // TASK: rename to "winningAddress"?
  }

  bool public inLotteryDrawDaily; //used so people can't buy while drawing lottery

  // max # loops allowed for binary search; to prevent some bugs causing infinite loops in binary search
  uint256 public maxLoopsDaily = 10;
  uint256 private loopCountDaily = 0; // for binary search

  uint256 public currentLotteryIdDaily = 0;
  uint256 public numLotteriesDaily = 0;
  uint256 public prizeAmountDaily;

  WinningTicketStructDaily public winningTicketDaily;

  TicketDistributionStructDaily[] public ticketDistributionDaily;

  address[] public listOfPlayersDaily; // Don't rely on this for current participants list

  uint256 public numActivePlayersDaily;
  uint256 public numTotalTicketsDaily;

  // Daily

  mapping(uint256 => WinningTicketStructDaily) public winningTicketsDaily; // key is lotteryId
  mapping(address => bool) public playersDaily; // key is player address
  mapping(address => uint256) public ticketsDaily; // key is player address
  mapping(uint256 => LotteryStructDaily) public lotteriesDaily; // key is lotteryId

  mapping(uint256 => address payable) public winnerAddressDaily;

  mapping(address => uint256) public hodlBonusDaily;

  // Events
  event LogNewLotteryDaily(address creator, uint256 startTime, uint256 endTime); // emit when lottery created

  // emit when lottery drawing happens; winner found
  event LogWinnerFoundDaily(
    uint256 lotteryId,
    uint256 winningTicketIndex,
    address winningAddress,
    uint256 prize
  );

  // Errors
  error Lottery__ActiveLotteryExistsDaily();
  error Lottery__NotCompletedDaily();
  error Lottery__InadequateFundsDaily();
  error Lottery__InvalidWinningIndexDaily();
  error Lottery__InvalidWithdrawalAmountDaily();
  error Lottery__WithdrawalFailedDaily();

  /* check that new lottery is a valid implementation
    previous lottery must be inactive for new lottery to be saved
    for when new lottery will be saved
    */
  modifier isNewLotteryValidDaily() {
    // active lottery
    LotteryStructDaily memory lotteryDaily = lotteriesDaily[
      currentLotteryIdDaily
    ];
    if (lotteryDaily.isActive == true) {
      revert Lottery__ActiveLotteryExistsDaily();
    }
    _;
  }

  /* check that round period is completed, and lottery drawing can begin
    either:
    1.  period manually ended, ie lottery is inactive. Then drawing can begin immediately.
    2. lottery  period has ended organically, and lottery is still active at that point
    */
  modifier isLotteryCompletedDaily() {
    if (
      !((lotteriesDaily[currentLotteryIdDaily].isActive == true &&
        lotteriesDaily[currentLotteryIdDaily].endTime < block.timestamp) ||
        lotteriesDaily[currentLotteryIdDaily].isActive == false)
    ) {
      revert Lottery__NotCompletedDaily();
    }
    _;
  }

  /*
    A function for owner to force update lottery status isActive to false
    public because it needs to be called internally when a Lottery is cancelled
    */
  function setLotteryInactiveDaily() public onlyOwner {
    lotteriesDaily[currentLotteryIdDaily].isActive = false;
  }

  /*
    A function for owner to force update lottery to be cancelled
    funds should be returned to players too
    */
  function cancelLotteryDaily() external onlyOwner {
    setLotteryInactiveDaily();
    _resetLotteryDaily();
  }

  /*
    A function to initialize a lottery
    probably should also be onlyOwner
    uint256 startTime_: start of period, unixtime
    uint256 numHours: in hours, how long period will last
    */
  function initLotteryDaily(uint256 startTime_, uint256 numHours_)
    public
    onlyOwner
    isNewLotteryValidDaily
  {
    // basically default value
    // if set to 0, default to explicit default number of days
    if (numHours_ == 0) {
      numHours_ = NUMBER_OF_HOURS_DAILY;
    }
    delete listOfPlayersDaily;
    numTotalTicketsDaily = 0;
    numActivePlayersDaily = 0;

    currentLotteryIdDaily = currentLotteryIdDaily + (1);
    uint256 endTime = startTime_ + (numHours_ * 1 hours);
    lotteriesDaily[currentLotteryIdDaily] = LotteryStructDaily({
      lotteryId: currentLotteryIdDaily,
      startTime: startTime_,
      endTime: endTime,
      isActive: true,
      isCompleted: false,
      isCreated: true
    });
    numLotteriesDaily = numLotteriesDaily + 1;
    emit LogNewLotteryDaily(msg.sender, startTime_, endTime);
  }

  /*
    a function for players to lottery tix
    */
  function buyLotteryTicketsDaily(uint256 numberOfTickets, address player)
    private
  {
    uint256 _numTickets = numberOfTickets;
    require(_numTickets >= 1);
    // if player is "new" for current lottery, update the player lists

    uint256 _numActivePlayers = numActivePlayersDaily;

    if (playersDaily[player] == false) {
      if (listOfPlayersDaily.length > _numActivePlayers) {
        listOfPlayersDaily[_numActivePlayers] = player;
      } else {
        listOfPlayersDaily.push(player); // otherwise append to array
      }
      playersDaily[player] = true;
      numActivePlayersDaily = _numActivePlayers + 1;
    }
    ticketsDaily[player] = ticketsDaily[player] + _numTickets; // account for if user has already tix previously for this current lottery
    numTotalTicketsDaily = numTotalTicketsDaily + _numTickets; // update the total # of tickets
  }

  /*
    a function for players to sell lottery tix
    */
  function sellLotteryTicketsDaily(uint256 numberOfTickets, address player)
    private
  {
    uint256 _numTickets = numberOfTickets;
    require(_numTickets >= 1);
    require(ticketsDaily[player] >= _numTickets); // double check that user has enough tix
    // if player is "new" for current lottery, update the player lists

    //  uint _numActivePlayers = numActivePlayers;

    ticketsDaily[player] = ticketsDaily[player] - _numTickets; // account for if user has already tix previously for this current lottery
    numTotalTicketsDaily = numTotalTicketsDaily - _numTickets; // update the total # of tickets
  }

  /*
    a function for owner to trigger lottery drawing
    */

  function triggerLotteryDrawingDaily()
    public
    onlyOwner
    isLotteryCompletedDaily
  {
    // console.log("triggerLotteryDrawing");

    _playerTicketDistributionDaily(); // create the distribution to get ticket indexes for each user
    // can't be done a prior bc of potential multiple tix per user
    uint256 winningTicketIndexDaily = _performRandomizedDrawingDaily();

    // initialize what we can first
    winningTicketDaily.currentLotteryId = currentLotteryIdDaily;
    winningTicketDaily.winningTicketIndex = winningTicketIndexDaily;

    findWinningAddressDaily(winningTicketIndexDaily); // via binary search

    winnerAddressDaily[currentLotteryIdDaily] = payable(
      winningTicketDaily.addr
    ); // keep track of winning address for each of the previous lotteries

    sendToWallet(winnerAddressDaily[currentLotteryIdDaily], dailyPool);
    emit LogWinnerFoundDaily(
      currentLotteryIdDaily,
      winningTicketDaily.winningTicketIndex,
      winningTicketDaily.addr,
      dailyPool
    );
    dailyPool = 0;

    hodlBonusDaily[winningTicketDaily.addr] = 0;
    lotteriesDaily[currentLotteryIdDaily].isCompleted = true;
  }

  /*
    getter function for ticketDistribution bc its a struct
    */
  function getTicketDistributionDaily(uint256 playerIndex_)
    public
    view
    returns (
      address playerAddress,
      uint256 startIndex, // inclusive
      uint256 endIndex // inclusive
    )
  {
    return (
      ticketDistributionDaily[playerIndex_].playerAddress,
      ticketDistributionDaily[playerIndex_].startIndex,
      ticketDistributionDaily[playerIndex_].endIndex
    );
  }

  /*
    function to handle creating the ticket distribution
    if 1) player1 buys 10 tix, then 2) player2 buys 5 tix, and then 3) player1 buys 5 more
    player1's ticket indices will be 0-14; player2's from 15-19
    this is why ticketDistribution cannot be determined until period is closed
    */
  function _playerTicketDistributionDaily() private {
    uint256 _ticketDistributionLength = ticketDistributionDaily.length; // so state var doesn't need to be invoked each iteration of loop

    uint256 _ticketIndex = 0; // counter within loop
    for (uint256 i = _ticketIndex; i < numActivePlayersDaily; i++) {
      address _playerAddress = listOfPlayersDaily[i];
      uint256 _numTickets = ticketsDaily[_playerAddress] +
        _calculateHodlBonusDaily(_playerAddress);

      TicketDistributionStructDaily memory newDistributionDaily = TicketDistributionStructDaily({
        playerAddress: _playerAddress,
        startIndex: _ticketIndex,
        endIndex: _ticketIndex + _numTickets - 1 // sub 1 to account for array indices starting from 0
      });
      if (_ticketDistributionLength > i) {
        ticketDistributionDaily[i] = newDistributionDaily;
      } else {
        ticketDistributionDaily.push(newDistributionDaily);
      }

      ticketsDaily[_playerAddress] = 0; // reset player's tickets to 0 after they've been counted
      _ticketIndex = _ticketIndex + _numTickets;
    }
  }

  /*
    function to generate random winning ticket index. Still need to find corresponding user afterwards.
    */

  function _performRandomizedDrawingDaily() private view returns (uint256) {
    // console.log("_performRandomizedDrawing");
    /* TASK: implement random drawing from 0 to numTotalTickets-1
    use chainlink https://docs.chain.link/docs/get-a-random-number/ to get random values
    */
    return Random.naiveRandInt(0, numTotalTicketsDaily - 1);
  }

  /*
    function to find winning player address corresponding to winning ticket index
    calls binary search
    uint256 winningTicketIndex_: ticket index selected as winner.
    Search for this within the ticket distribution to find corresponding Player
    */
  function findWinningAddressDaily(uint256 winningTicketIndex1_) private {
    // console.log("findWinningAddress");
    uint256 _numActivePlayers = numActivePlayersDaily;
    if (_numActivePlayers == 1) {
      winningTicketDaily.addr = ticketDistributionDaily[0].playerAddress;
    } else {
      // do binary search on ticketDistribution array to find winner
      uint256 _winningPlayerIndex = _bSearchDaily(
        0,
        _numActivePlayers - 1,
        winningTicketIndex1_
      );
      if (_winningPlayerIndex >= _numActivePlayers) {
        revert Lottery__InvalidWinningIndexDaily();
      }
      winningTicketDaily.addr = ticketDistributionDaily[_winningPlayerIndex]
        .playerAddress;
    }
  }

  /*
    function implementing binary search on ticket distribution var
    uint256 leftIndex_ initially 0
    uint256 rightIndex_ initially max ind, ie array.length - 1
    uint256 ticketIndexToFind_ to search for
    */

  function _bSearchDaily(
    uint256 leftIndex_,
    uint256 rightIndex_,
    uint256 ticketIndexToFind_
  ) private returns (uint256) {
    uint256 _searchIndex = (rightIndex_ - leftIndex_) / (2) + (leftIndex_);
    uint256 _loopCount = loopCountDaily;
    // counter
    loopCountDaily = _loopCount + 1;
    if (_loopCount + 1 > maxLoopsDaily) {
      // emergency stop in case infinite loop due to unforeseen bug
      return numActivePlayersDaily;
    }

    if (
      ticketDistributionDaily[_searchIndex].startIndex <= ticketIndexToFind_ &&
      ticketDistributionDaily[_searchIndex].endIndex >= ticketIndexToFind_
    ) {
      return _searchIndex;
    } else if (
      ticketDistributionDaily[_searchIndex].startIndex > ticketIndexToFind_
    ) {
      // go to left subarray
      rightIndex_ = _searchIndex - (leftIndex_);

      return _bSearchDaily(leftIndex_, rightIndex_, ticketIndexToFind_);
    } else if (
      ticketDistributionDaily[_searchIndex].endIndex < ticketIndexToFind_
    ) {
      // go to right subarray
      leftIndex_ = _searchIndex + (leftIndex_) + 1;
      return _bSearchDaily(leftIndex_, rightIndex_, ticketIndexToFind_);
    }

    // if nothing found (bug), return an impossible player index
    // this index is outside expected bound, bc indexes run from 0 to numActivePlayers-1
    return numActivePlayersDaily;
  }

  /*
    function to reset lottery by setting state vars to defaults
    */

  function _resetLotteryDaily() public onlyOwner {
    // console.log("_resetLottery");

    numTotalTicketsDaily = 0;
    numActivePlayersDaily = 0;
    delete listOfPlayers;
    lotteriesDaily[currentLotteryIdDaily].isActive = false;
    lotteriesDaily[currentLotteryIdDaily].isCompleted = true;
    winningTicketDaily = WinningTicketStructDaily({
      currentLotteryId: 0,
      winningTicketIndex: 0,
      addr: address(0)
    });

    // increment id counter
    currentLotteryIdDaily = currentLotteryIdDaily + (1);
  }

  /*
    function calculate hodl bonus tickets (one per hour)
    */

  function _calculateHodlBonusDaily(address player)
    public
    view
    returns (uint256)
  {
    uint256 _hodlBonus = 0;
    // uint256 bonusStart =  hodlBonus[player]
    if (hodlBonusDaily[player] > 0) {
      _hodlBonus = (block.timestamp - hodlBonusDaily[player]) / 86400;
    }

    return _hodlBonus;
  }
}