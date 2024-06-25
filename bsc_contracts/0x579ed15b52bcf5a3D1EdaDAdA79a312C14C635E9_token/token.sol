/**
 *Submitted for verification at BscScan.com on 2022-10-13
*/

/**
 *Submitted for verification at BscScan.com on 2022-06-19
*/

/**
 *Submitted for verification at hecoinfo.com on 2021-05-05
*/

/**
 *
 *Submitted for verification at hecoinfo.com on 2021-05-02
*/

pragma solidity ^0.6.12;
// SPDX-License-Identifier: Unlicensed
library SafeMath {
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
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
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
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
        require(b != 0, errorMessage);
        return a % b;
    }
}
interface IERC20 {

    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient` sign xgll.
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
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}


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
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
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

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
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
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
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
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
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
contract Ownable is Context {
    address private _owner;

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
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
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
}

// pragma solidity >=0.5.0;

interface IPancakeRouter01 {
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

// File: contracts\interfaces\IPancakeRouter02.sol


interface IPancakeRouter02 is IPancakeRouter01 {
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

// File: contracts\interfaces\IPancakeFactory.sol

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

// File: contracts\libraries\PancakeLibrary.sol

pragma solidity >=0.5.0;



library PancakeLibrary {
    using SafeMath for uint;

    // returns sorted token addresses, used to handle return values from pairs sorted in this order
    function sortTokens(address tokenA, address tokenB) internal pure returns (address token0, address token1) {
        require(tokenA != tokenB, 'PancakeLibrary: IDENTICAL_ADDRESSES');
        (token0, token1) = tokenA < tokenB ? (tokenA, tokenB) : (tokenB, tokenA);
        require(token0 != address(0), 'PancakeLibrary: ZERO_ADDRESS');
    }

    // calculates the CREATE2 address for a pair without making any external calls
    function pairFor(address factory, address tokenA, address tokenB) internal pure returns (address pair) {
        (address token0, address token1) = sortTokens(tokenA, tokenB);
        pair = address(uint(keccak256(abi.encodePacked(
                hex'ff',
                factory,
                keccak256(abi.encodePacked(token0, token1)),
                hex'00fb7f630766e6a796048ea87d01acd3068e8ff67d078148a3fa3f4a84f69bd5' // init code hash
            ))));
    }

    // fetches and sorts the reserves for a pair
    function getReserves(address factory, address tokenA, address tokenB) internal view returns (uint reserveA, uint reserveB) {
        (address token0,) = sortTokens(tokenA, tokenB);
        pairFor(factory, tokenA, tokenB);
        (uint reserve0, uint reserve1,) = IPancakePair(pairFor(factory, tokenA, tokenB)).getReserves();
        (reserveA, reserveB) = tokenA == token0 ? (reserve0, reserve1) : (reserve1, reserve0);
    }

    // given some amount of an asset and pair reserves, returns an equivalent amount of the other asset
    function quote(uint amountA, uint reserveA, uint reserveB) internal pure returns (uint amountB) {
        require(amountA > 0, 'PancakeLibrary: INSUFFICIENT_AMOUNT');
        require(reserveA > 0 && reserveB > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        amountB = amountA.mul(reserveB) / reserveA;
    }

    // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) internal pure returns (uint amountOut) {
        require(amountIn > 0, 'PancakeLibrary: INSUFFICIENT_INPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        uint amountInWithFee = amountIn.mul(9975);
        uint numerator = amountInWithFee.mul(reserveOut);
        uint denominator = reserveIn.mul(10000).add(amountInWithFee);
        amountOut = numerator / denominator;
    }

    // given an output amount of an asset and pair reserves, returns a required input amount of the other asset
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) internal pure returns (uint amountIn) {
        require(amountOut > 0, 'PancakeLibrary: INSUFFICIENT_OUTPUT_AMOUNT');
        require(reserveIn > 0 && reserveOut > 0, 'PancakeLibrary: INSUFFICIENT_LIQUIDITY');
        uint numerator = reserveIn.mul(amountOut).mul(10000);
        uint denominator = reserveOut.sub(amountOut).mul(9975);
        amountIn = (numerator / denominator).add(1);
    }

    // performs chained getAmountOut calculations on any number of pairs
    function getAmountsOut(address factory, uint amountIn, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'PancakeLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[0] = amountIn;
        for (uint i; i < path.length - 1; i++) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i], path[i + 1]);
            amounts[i + 1] = getAmountOut(amounts[i], reserveIn, reserveOut);
        }
    }

    // performs chained getAmountIn calculations on any number of pairs
    function getAmountsIn(address factory, uint amountOut, address[] memory path) internal view returns (uint[] memory amounts) {
        require(path.length >= 2, 'PancakeLibrary: INVALID_PATH');
        amounts = new uint[](path.length);
        amounts[amounts.length - 1] = amountOut;
        for (uint i = path.length - 1; i > 0; i--) {
            (uint reserveIn, uint reserveOut) = getReserves(factory, path[i - 1], path[i]);
            amounts[i - 1] = getAmountIn(amounts[i], reserveIn, reserveOut);
        }
    }
}

interface ISwapMining {
    function swap(address account, address input, address output, uint256 amount) external returns (bool);
}

interface ExternalToken {
    function jdBhMapping(address account) external returns(address);
}

interface IWrap {
    function withdraw() external;
}

contract token is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    IWrap public wrap;
    
    mapping (address => uint256) private _rOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) public _isContractList;
    mapping (address => uint256) public _rewardMapping;

    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 7381000 * 10**18;
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 public _pairValue;

    string private _name = "PEOPLE";
    string private _symbol = "PEOPLE";
    uint8 private _decimals = 18;
    
    uint256 public _devSellFee = 15;
    uint256 public _burnSellFee = 10;
    uint256 public _poolSellFee = 25;
    uint256 public _lpSeellFee = 15;
    uint256 public _famSeelFee = 15;
    uint256 public _jxSellFee = 10;
    
    uint256 public _invitBuyFee = 70;
    uint256 public _devBuyFee = 10;
    
    uint256 public _transferFee = 80;
    
    address public burnAddress = address(0x000000000000000000000000000000000000dEaD);
    address public ownerAddres = address(0x291BAF185E77AA4A29c58Aea332Ff4c81f8f00B0);
    address public devAddress = address(0x3C96A7aa852A8a621C2BB9754fC6dE8f2cf5900D);
    address public poolAddress = address(0x000000000000000000000000000000000000dEaD);
    address public famAddress = address(0x000000000000000000000000000000000000dEaD);
    address public jxAddress = address(0x3C96A7aa852A8a621C2BB9754fC6dE8f2cf5900D);
    
    address public husdtToken = 0x55d398326f99059fF775485246999027B3197955;

    IPancakeRouter02 public immutable uniswapV2Router;
    address public uniswapV2Pair;
    ExternalToken public externalToken = ExternalToken(address(0x4CFd1d3BF008995E1cFCBf72284f46d8d1dA3783));

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = true;
    
    uint256 public upRewardTime = block.timestamp;
    uint256 public rewardJg = 4 * 60;
    uint256 public rewardApr = 438;
    uint256 public rewardOneApr = 438;
    uint256 public rewardTwoApr = 352;
    uint256 public rewardThreeApr = 249;
    
    uint256 public rewardStarTime;
    uint256 public rewardOneDay = 270 days;
    uint256 public rewardTwoDay = 540 days;
    uint256 public rewardThreeDay = 720 days;
    
    uint256 public cbNumber = 500 * 10 **18;
    uint256 private numTokensSellToAddToLiquidity = 1000 * 10 **18;
    bool public rewardFlag = false;
    
    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    constructor () public {
        _rOwned[ownerAddres] = _rTotal;

        IPancakeRouter02 _uniswapV2Router = IPancakeRouter02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
        .createPair(address(this), husdtToken);

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;

        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[ownerAddres] = true;
        _isExcludedFromFee[burnAddress] = true;
        _isExcludedFromFee[devAddress] = true;
        _isExcludedFromFee[poolAddress] = true;
        _isExcludedFromFee[famAddress] = true;
        _isExcludedFromFee[poolAddress] = true;
        _isExcludedFromFee[jxAddress] = true;
        _isExcludedFromFee[address(this)] = true;
        
        _isContractList[uniswapV2Pair] = true;
        _isContractList[address(this)] = true;
        
        emit Transfer(address(0),ownerAddres, _tTotal);
    }
    
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(!isContract(to) || _isContractList[to],"To address is contract");
        if(from != ownerAddres && to != ownerAddres && _pairValue == 0) {
            require(to != uniswapV2Pair,"no start");
        }
        // also, don't swap & liquify if sender is uniswap pair.
        uint256 contractTokenBalance = balanceOf(address(this));

        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            to == uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            //add liquidity
            swapAndLiquify(contractTokenBalance);
        }
        //transfer amount, it will take tax, burn, liquidity fee
        _tokenTransfer(from,to,amount);
    }
    
    //this method is responsible for taking all fee, if takeFee is true
    function _tokenTransfer(address sender, address recipient, uint256 amount) private {
        
        if (rewardFlag) {
            rewardSuper();
        }
        uint256 currentRate =  _getRate();
        bool _feeFlag = false;
        if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
            _feeFlag = true;
        } 
        if (sender == uniswapV2Pair) {  // 购买
            _pairValue = _pairValue.sub(amount);
            if (_feeFlag) {
                _rOwned[recipient] = _rOwned[recipient].add(amount.mul(currentRate));
                emit Transfer(sender,recipient, amount);
            } else {
                uint256 invitBuyAmount = amount.mul(_invitBuyFee).div(1000);
                uint256 devBuyAmount = amount.mul(_devBuyFee).div(1000);
                uint256 newAmount = amount.sub(invitBuyAmount).sub(devBuyAmount);
                _rOwned[recipient] = _rOwned[recipient].add(newAmount.mul(currentRate));
                _rOwned[devAddress] = _rOwned[devAddress].add(devBuyAmount.mul(currentRate));
                buyFeeDist(sender,recipient,invitBuyAmount);
                emit Transfer(sender,recipient, newAmount);
            }
        } else if (recipient == uniswapV2Pair) { // 出售
            _rOwned[sender] = _rOwned[sender].sub(amount.mul(currentRate));
            if(_feeFlag) {
                _pairValue = _pairValue.add(amount);
                emit Transfer(sender,recipient, amount);
            } else {
                uint256 devSellAmount = amount.mul(_devSellFee).div(1000);
                uint256 burnSellAmount = amount.mul(_burnSellFee).div(1000);
                uint256 poolSellAmount = amount.mul(_poolSellFee).div(1000);
                uint256 famSellAmount = amount.mul(_famSeelFee).div(1000);
                uint256 jxSellAmount = amount.mul(_jxSellFee).div(1000);
                uint256 lpSellAmount = amount.mul(_lpSeellFee).div(1000);
                
                uint256 newAmount = amount.sub(devSellAmount).sub(burnSellAmount).sub(poolSellAmount);
                newAmount = newAmount.sub(famSellAmount).sub(jxSellAmount).sub(lpSellAmount);
                _pairValue = _pairValue.add(newAmount);
                sellFeeDist(devSellAmount,burnSellAmount,poolSellAmount,lpSellAmount,famSellAmount,jxSellAmount);
                emit Transfer(sender,recipient, newAmount);
            }
        } else {
            _rOwned[sender] = _rOwned[sender].sub(amount.mul(currentRate));
            if(_feeFlag) {
                _rOwned[recipient] = _rOwned[recipient].add(amount.mul(currentRate));
               emit Transfer(sender,recipient, amount);
            } else {
                uint256 tranferAmount = amount.mul(_transferFee).div(1000);
                uint256 newAmount = amount.sub(tranferAmount);
                _rOwned[recipient] = _rOwned[recipient].add(newAmount.mul(currentRate));
                _rOwned[devAddress] = _rOwned[devAddress].add(tranferAmount.mul(currentRate));
                emit Transfer(sender,recipient, newAmount);
            }
            
        }
        
    }
    
    //  购买手续费分配
    function buyFeeDist(address sender,address recipient,uint256 invitBuyAmount) private {
        uint256 currentRate =  _getRate();
        uint256 oneAmount = invitBuyAmount.div(14);
        address sjAddress = externalToken.jdBhMapping(recipient);
        uint256 syAmount = invitBuyAmount;
        for (uint256 i=0; i < 10; i++) {
            if (sjAddress != address(0)) {
                uint256 newAmount = oneAmount;
                if (syAmount <= oneAmount) {
                    newAmount = syAmount;
                }
                if (i == 0) {
                    newAmount = oneAmount.mul(4);
                } else if(i == 1) {
                    newAmount = oneAmount.mul(2);
                }
                if (balanceOf(sjAddress) >= cbNumber) {
                    _rOwned[sjAddress] = _rOwned[sjAddress].add(newAmount.mul(currentRate));
                    _rewardMapping[sjAddress] = _rewardMapping[sjAddress].add(newAmount.mul(currentRate));
                    emit Transfer(sender,sjAddress, newAmount);
                    syAmount = syAmount.sub(newAmount);
                }
                sjAddress = externalToken.jdBhMapping(sjAddress);
            } else {
                _rOwned[devAddress] = _rOwned[devAddress].add(syAmount.mul(currentRate));
                break;
            }
        }
        
    }
    
    //  出售手续费分配
    function sellFeeDist(uint256 devSellAmount,uint256 burnSellAmount,uint256 poolSellAmount,uint256 lpSellAmount,uint256 famSellAmount,uint256 jxSellAmount) private {
        uint256 currentRate =  _getRate();
        if (devSellAmount >= 0) {
            _rOwned[devAddress] = _rOwned[devAddress].add(devSellAmount.mul(currentRate));
        }
        
        if (burnSellAmount >= 0) {
            _rOwned[burnAddress] = _rOwned[burnAddress].add(burnSellAmount.mul(currentRate));
        }
        
        if (poolSellAmount >= 0) {
            _rOwned[poolAddress] = _rOwned[poolAddress].add(poolSellAmount.mul(currentRate));
        }
        
        if (poolSellAmount >= 0) {
            _rOwned[famAddress] = _rOwned[famAddress].add(famSellAmount.mul(currentRate));
        }
        
        if (poolSellAmount >= 0) {
            _rOwned[jxAddress] = _rOwned[jxAddress].add(jxSellAmount.mul(currentRate));
        }
        
        if (lpSellAmount >= 0) {
            _rOwned[address(this)] = _rOwned[address(this)].add(lpSellAmount.mul(currentRate));
        }
    }
    
    //  静态分红
    function rewardSuper() private {
        if (block.timestamp >= upRewardTime.add(rewardJg)) {
            if (block.timestamp >= rewardStarTime.add(rewardThreeDay)) {
                rewardFlag = false;
                return;
            } else if (block.timestamp >= rewardStarTime.add(rewardTwoDay)) {
                rewardApr = rewardThreeApr;
            } else if (block.timestamp >= rewardStarTime.add(rewardOneDay)) {
                rewardApr = rewardTwoApr;
            } else {
                rewardApr = rewardOneApr;
            }
            uint256 rewardValue = _tTotal.sub(_pairValue).mul(rewardApr).div(10000000);
            uint256 updateTime = block.timestamp.sub(upRewardTime);
            uint256 csNumber = updateTime.div(rewardJg);
            uint256 csValue = rewardValue.mul(csNumber);
            _tTotal = _tTotal.add(csValue);
            upRewardTime = upRewardTime.add(rewardJg.mul(csNumber));
        }
    }
    
    function setSellFee(uint256 dFee,uint256 bFee,uint256 pFee,uint256 lFee,uint256 fFee,uint256 jFee) public onlyOwner {
        _devSellFee = dFee;
        _burnSellFee = bFee;
        _poolSellFee = pFee;
        _lpSeellFee = lFee;
        _famSeelFee = fFee;
        _jxSellFee = jFee;
    }
    
    function setRewardDay(uint256 _oneDay,uint256 _twoDay,uint256 _threeDay) public onlyOwner {
        rewardOneDay = _oneDay;
        rewardTwoDay = _twoDay;
        rewardThreeDay = _threeDay;
    }
    
    function setRewardApr(uint256 _oneApr,uint256 _twoApr,uint256 _threeApr) public onlyOwner {
        rewardOneApr = _oneApr;
        rewardTwoApr = _twoApr;
        rewardThreeApr = _threeApr;
    }
    
    function setBuyFee(uint256 iFee,uint256 dFee) public onlyOwner {
        _invitBuyFee = iFee;
        _devBuyFee = dFee;
    }
    
    function setDevAddress(address dAddress) public onlyOwner {
        devAddress = dAddress;
    }
    
    function setPoolAddress(address pAddress) public onlyOwner {
        poolAddress = pAddress;
    }
    
    function setFamAddress(address fAddress) public onlyOwner {
        famAddress = fAddress;
    }
    
    function setJxAdderss(address jAddress) public onlyOwner {
        jxAddress = jAddress;
    }
    
    function setNumTokensSellToAddToLiquidity(uint256 amount) public onlyOwner {
        numTokensSellToAddToLiquidity = amount;
    }
    
    function setContractList(address account,bool _bool) public onlyOwner {
        _isContractList[account] = _bool;
    }
    
    function setCbNumber(uint256 _number) public onlyOwner {
        cbNumber = _number;
    }
    
    function setWrap(IWrap _wrap) public onlyOwner {
        wrap = _wrap;
        _isExcludedFromFee[address(_wrap)] = true;
    }
    
    function setRewardFlag(bool _bool) public onlyOwner {
        rewardFlag = _bool;
        rewardStarTime = block.timestamp;
        upRewardTime = block.timestamp;
    }
    
    function setRewardApr(uint256 _rA) public onlyOwner {
        rewardApr = _rA;
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

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (account == uniswapV2Pair) {
            return _pairValue;
        } else {
            return tokenFromReflection(_rOwned[account]);
        }
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
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
    
    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount.div(currentRate);
    }
    
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }

    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
    
    //to recieve ETH from uniswapV2Router when swaping
    receive() external payable {}
    
    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
        uint256 initialBalance = IERC20(husdtToken).balanceOf(address(this));
        swapTokensForDividendToken(half);
        uint256 newBalance =IERC20(husdtToken).balanceOf(address(this)).sub(initialBalance);
        addLiquidity(otherHalf, newBalance);
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }
    
    function addLiquidity(uint256 tokenAmount, uint256 tokenBmount) public {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount * 100);
        IERC20(husdtToken).approve(address(uniswapV2Router), tokenBmount * 100);
        // add the liquidity
        uniswapV2Router.addLiquidity (
            address(this),
            address(husdtToken),
            tokenAmount,
            tokenBmount,
            0,
            0,
            devAddress,
            block.timestamp.add(30)
        );
    }
    
    function swapTokensForDividendToken(uint256 tokenAmount) private {
        if (tokenAmount > 0) {
            address[] memory path = new address[](2);
            path[0] = address(this);
            path[1] = husdtToken;
            
            _approve(address(this), address(uniswapV2Router), _tTotal);
    
            // make the swap
            uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
                tokenAmount,
                0, // accept any amount of dividend token
                path,
                address(wrap),
                block.timestamp.add(30)
            );
            wrap.withdraw(); 
        }  
    }
    
    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(addr) }
        return size > 0;
    }
}