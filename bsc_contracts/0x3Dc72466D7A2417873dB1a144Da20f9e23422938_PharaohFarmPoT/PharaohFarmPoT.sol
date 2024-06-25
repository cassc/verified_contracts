/**
 *Submitted for verification at BscScan.com on 2023-02-15
*/

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol

// SPDX-License-Identifier: MIT

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

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

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

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}

// File: @openzeppelin/contracts/utils/Address.sol


// OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)

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
        return functionCallWithValue(target, data, 0, "Address: low-level call failed");
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
        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
     * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
     *
     * _Available since v4.8._
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        if (success) {
            if (returndata.length == 0) {
                // only check isContract if the call was successful and the return data is empty
                // otherwise we already know that it was a contract
                require(isContract(target), "Address: call to non-contract");
            }
            return returndata;
        } else {
            _revert(returndata, errorMessage);
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason or using the provided one.
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
            _revert(returndata, errorMessage);
        }
    }

    function _revert(bytes memory returndata, string memory errorMessage) private pure {
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

// File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
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

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: contracts/PharoaohPot.sol


pragma solidity ^0.8.0;





contract PharaohFarmPoT is Ownable, ReentrancyGuard{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    uint256 internal constant maxPayout = 365;
    uint256 internal constant DEPOSITE_TAX_RATE = 15;
    //Change this to set new minimum deposit/
    uint256 public constant MIN_DEPOSIT_AMOUNT = 100 * 1e18;
    uint256 public startTime;

    address public firstAddress;
    uint256[] public refRewardLevels = [100, 25, 5, 5, 5, 5, 5];
    IERC20 CAFToken = IERC20(0x5662ac531A2737C3dB8901E982B43327a2fDe2ae);
    struct User {
        address userAddress;
        uint256 initialDeposit;
        uint256 depositBefTax;
        uint256 maxPayout;
        uint256 claimed;
        uint256 referralRewards;
        uint256 totalReferrals;
        uint256 previousDoubleUp;
        address referred_by;
        uint256 lastUpdated;
        uint256 createdAt;
    }
    struct level1Address {
        address[] referred;
        
    }
    struct level2Address {
        address[] referred;

    }
    struct level3Address {
        address[] referred;

    }
    struct level4Address {
        address[] referred;

    }
    struct level5Address {
        address[] referred;

    }
    struct level6Address {
        address[] referred;

    }
    struct level7Address {
        address[] referred;

    }
    struct dailyRecords {
        uint256 claims;
        uint256 amount;
        address userAddress;
    }

    mapping(address => level1Address) internal level1;
    mapping(address => level2Address) internal level2;
    mapping(address => level3Address) internal level3;
    mapping(address => level4Address) internal level4;
    mapping(address => level5Address) internal level5;
    mapping(address => level6Address) internal level6;
    mapping(address => level7Address) internal level7;

    mapping(address => User) public user_data;
    mapping(uint256 => dailyRecords) public dailyPayoutRecords;
    // event Upline(address indexed addr, address indexed upline);
    event Reffered(address indexed _referrer, address indexed referred, uint256 value);
    event DepositMade(address indexed addr, uint256 amount);
    event Withdraw(address indexed addr, uint256 amount);
  
    event ClaimedAdjusted(address indexed from, address indexed to, uint256 value);
    event WithdrawAdjusted(address indexed from, address indexed to, uint256 value);

   
    event ReferralRewarded(address indexed from,address  to, uint256 amount);

    constructor() {
      startTime = block.timestamp;
        firstAddress = msg.sender;
        user_data[msg.sender] = User(
            msg.sender,
            0,
            0,
            0,
            0,
            0,
            0,
            0,
            address(0),
            block.timestamp,
            block.timestamp
        );
    }

    // function changeSetDays(uint256 newSetDays) public {
    //     setDays = setDays + (newSetDays * 1 days);
    // }

  
        
        function deposit(uint256 amount, address referAddress) public nonReentrant {
        require(
            user_data[msg.sender].userAddress == address(0),
            "Can not deposit again"
        );

        require(
            user_data[referAddress].userAddress != address(0),
            "Invalid Referral Address"
        );
        require(referAddress != address(0), "Invalid Refer address");
        require(
            amount >= MIN_DEPOSIT_AMOUNT,
            "Amount should be greater or equal to minimum amount"
        );

        uint256 allowance = CAFToken.allowance(msg.sender, address(this));
        require(
            allowance >= amount,
            "Allowance should be greater or equal to amount"
        );
        CAFToken.safeTransferFrom(msg.sender, address(this), amount);
        uint256 finalAmount = depositAfterTax(amount);

        uint256 _maxPayout = (finalAmount * 365) / 100;
        user_data[msg.sender] = User(
            msg.sender,
            finalAmount,
            amount,
            _maxPayout,
            0,
            0,
            0,
            0,
            referAddress,
            block.timestamp,
            block.timestamp
        );
        setLvl1Setter(referAddress);
        user_data[referAddress].totalReferrals += 1;
        //NOTE: cache to INT in order to avoid revert in line 1091
        int max = int(user_data[referAddress].maxPayout);
        int claimed = int(user_data[referAddress].claimed);
        int available = int(availableRewards(referAddress));
        int refRew =   int((amount * refRewardLevels[0]) /
        1000);
emit Reffered(msg.sender,referAddress,uint(refRew));
        if (available + claimed+ refRew <= max && referAddress != firstAddress) {
        emit ReferralRewarded(msg.sender,referAddress, uint(refRew));
            user_data[referAddress].referralRewards += uint(refRew);
              
        }else if( max - (claimed + available )>0 && referAddress != firstAddress){
                        int gib = max   - (claimed+ available) ; //NOTE: this can't be zero/negative due to the else if check
                        if(gib > refRew){
                            gib= refRew;
                        }
                        user_data[referAddress].referralRewards += uint(gib);
                        emit ReferralRewarded(msg.sender,referAddress, uint(refRew));

                    }

        refer(referAddress, amount);
    }

    function refer(address referAddress, uint256 amount) internal {
        uint256 currentDistributionLevel = 1;
        address uplineUserAddress = getUplineAddress(referAddress);
        for (uint256 i = 0; i < 6; i++) {
            if (uplineUserAddress != address(0) && uplineUserAddress != firstAddress) {
                if (currentDistributionLevel < 7 ) {
                    int rew = int(((amount *
                        refRewardLevels[currentDistributionLevel]) / 1000));
                    user_data[uplineUserAddress].totalReferrals += 1;
                    int max = int(user_data[uplineUserAddress].maxPayout);
                    int claimed = int(user_data[uplineUserAddress].claimed);
                    int available = int(availableRewards(uplineUserAddress));
                    if (available + claimed +rew  <= max ){
                        emit ReferralRewarded(msg.sender,uplineUserAddress, uint(rew));
                        user_data[uplineUserAddress].referralRewards += uint(rew);
                    }else if( max - (claimed + available) >0){
                        int gib = max   - (claimed+ available) ;
                        if(gib > rew){
                            gib= rew;
                        }
                        user_data[uplineUserAddress].referralRewards += uint(gib);
                        emit ReferralRewarded(msg.sender,uplineUserAddress, uint(rew));

                    }
                    if (currentDistributionLevel == 1) {
                        setLvl2Setter(uplineUserAddress);
                    //NOTE: wrapped rew to uint in order to be able to emit event properly
emit Reffered(msg.sender,uplineUserAddress,uint(rew));
                    } else if (currentDistributionLevel == 2) {
                        setLvl3Setter(uplineUserAddress);
emit Reffered(msg.sender,uplineUserAddress,uint(rew));

                    } else if (currentDistributionLevel == 3) {
                        setLvl4Setter(uplineUserAddress);
emit Reffered(msg.sender,uplineUserAddress,uint(rew));

                    } else if (currentDistributionLevel == 4) {
                        setLvl5Setter(uplineUserAddress);
emit Reffered(msg.sender,uplineUserAddress,uint(rew));

                    } else if (currentDistributionLevel == 5) {
                        setLvl6Setter(uplineUserAddress);
emit Reffered(msg.sender,uplineUserAddress,uint(rew));

                    } else if (currentDistributionLevel == 6) {
                        setLvl7Setter(uplineUserAddress);
emit Reffered(msg.sender,uplineUserAddress,uint(rew));

                    }
                    currentDistributionLevel++;
                    uplineUserAddress = getUplineAddress(uplineUserAddress);
                } else {
                    break;
                }
            } else {
                break;
            }
        }
    }

    function reinvestRefer(address referAddress, uint256 amount) internal {
        uint256 currentDistributionLevel = 1;
        address uplineUserAddress = getUplineAddress(referAddress);
        for (uint256 i = 0; i < 6; i++) {
            if (uplineUserAddress != address(0) && uplineUserAddress != firstAddress) {
                if (currentDistributionLevel < 7) {
                    int rew = int(((amount *
                        refRewardLevels[currentDistributionLevel]) / 1000));
                    int max = int(user_data[uplineUserAddress].maxPayout);
                    int claimed = int(user_data[uplineUserAddress].claimed);
                    int available = int(availableRewards(uplineUserAddress));
                    if (available + claimed+ rew <= max ) {
                        emit ReferralRewarded(msg.sender, uplineUserAddress,uint(rew));
                        user_data[uplineUserAddress].referralRewards += uint(rew);
                    }else if( max -( claimed + available )>0){
                        int gib = max   - (claimed+ available) ; //NOTE: this can't be zero/negative due to the else if check
                        if(gib > rew){
                            gib= rew;
                        }
                        user_data[uplineUserAddress].referralRewards += uint(gib);
                        emit ReferralRewarded(msg.sender,uplineUserAddress, uint(rew));

                    }
                    currentDistributionLevel++;
                    uplineUserAddress = getUplineAddress(uplineUserAddress);
                } else {
                    break;
                }
            } else {
                break;
            }
        }
    }

    function getUplineAddress(address userAddress)
        public
        view
        returns (address)
    {
        address UA = user_data[userAddress].referred_by;
        return UA;
    }

    function depositAfterTax(uint256 amount) public view returns (uint256) {
        uint256 afTax = (amount * DEPOSITE_TAX_RATE) / 100;
        return amount - afTax;
    }

    function getMaxPayout(address userAddress) external view returns (uint256) {
        uint256 payout = user_data[userAddress].maxPayout;
        return payout;
    }

    function availableRewards(address userAddress)
        public
        view
        returns (uint256)
    {
        // uint256 deposit_time = user_data[userAddress].lastUpdated;
        // uint256 initial = user_data[userAddress].initialDeposit;
        uint256 prev = user_data[userAddress].previousDoubleUp;
     
        uint256 refRew = user_data[userAddress].referralRewards;

        uint256 payout= calculatePayout(userAddress);
        uint256 avail = payout + refRew + prev;
        uint256 claimedRewards = user_data[userAddress].claimed;
        uint256 _maxpayout = user_data[userAddress].maxPayout;
       
        if ( claimedRewards >= _maxpayout){
            return 0;
        }else  if(claimedRewards+avail >= _maxpayout){
            return avail;
        }else{
            return avail;
        }
    }

    // function claimRewardsFirstAddress() external {
    //     require(msg.sender == firstAddress);
    //     uint256 refRew = user_data[msg.sender].referralRewards;
    //     CAFToken.safeTransfer(msg.sender, refRew);
    //     user_data[msg.sender].referralRewards = 0;
    // }

    function getWithdrawalTax(address userAddress)
        public
        view
        returns (uint256)
    {
        uint256 initial = user_data[userAddress].initialDeposit;
        uint256 _totalSupply = CAFToken.balanceOf(address(this));
        uint256 balancePercentage = initial.mul(100).div(_totalSupply);
        uint256 withdrawTax;
        if (balancePercentage >= 10) {
            withdrawTax = 60;
        } else if (balancePercentage >= 9) {
            withdrawTax = 55;
        } else if (balancePercentage >= 8) {
            withdrawTax = 50;
        } else if (balancePercentage >= 7) {
            withdrawTax = 45;
        } else if (balancePercentage >= 6) {
            withdrawTax = 40;
        } else if (balancePercentage >= 5) {
            withdrawTax = 35;
        } else if (balancePercentage >= 4) {
            withdrawTax = 30;
        } else if (balancePercentage >= 3) {
            withdrawTax = 25;
        } else if (balancePercentage >= 2) {
            withdrawTax = 20;
        } else if (balancePercentage >= 1) {
            withdrawTax = 15;
        } else {
            withdrawTax = 10;
        }
        return withdrawTax;
    }

    function getDay() external view returns (uint256) {
        uint256 day = (block.timestamp - startTime) / 1 days;
        return day;
    }

    function claimRewards() external nonReentrant {
        uint256 interest = availableRewards(msg.sender);
        uint256 withdrawTax = getWithdrawalTax(msg.sender);
        uint256 tax = interest.mul(withdrawTax).div(100);
        uint256 maximumInterest = user_data[msg.sender].maxPayout;
        uint256 claimed = user_data[msg.sender].claimed;
        uint256 lastClaim = user_data[msg.sender].lastUpdated;
    uint256 toClaim;
        uint256 day = (block.timestamp - startTime) / 1 days;
        // address today = dailyPayoutRecords[day].userAddress;

        require(interest > 0, "Can't claim if nothing is available");
        //Changed for Testing
        require(
           ( block.timestamp - lastClaim )/ 1 days >= 1 days,
            "Can't claim twice in 24hrs"
        );

        require(claimed < maximumInterest, "Require DoubleUp To Claim");
 if (interest + claimed > maximumInterest) {
        uint256 maxTax = (maximumInterest-claimed).mul(withdrawTax).div(100);
            toClaim = (maximumInterest - claimed) - maxTax;
            user_data[msg.sender].claimed += (maximumInterest - claimed);
            user_data[msg.sender].previousDoubleUp =    ( interest - (maximumInterest - claimed));  
            emit ClaimedAdjusted(address(this), msg.sender, toClaim);
        } else {
             toClaim = (interest.sub(tax));
            user_data[msg.sender].claimed += interest;
            user_data[msg.sender].previousDoubleUp = 0;
            emit WithdrawAdjusted(address(this), msg.sender, toClaim);

        }
        CAFToken.safeTransfer(msg.sender, toClaim);

        dailyPayoutRecords[day].amount += toClaim;
        dailyPayoutRecords[day].claims++;
        user_data[msg.sender].lastUpdated = block.timestamp;
        user_data[msg.sender].referralRewards = 0;
    }

    function doubleUp() external nonReentrant {
        uint256 claimed = user_data[msg.sender].claimed;
        uint256 max = user_data[msg.sender].maxPayout;
        uint256 _availableRewards =availableRewards(msg.sender);
        require (claimed + _availableRewards >= max, "Double Up requires 365% interest accumalation") ;
        uint256 initial = user_data[msg.sender].depositBefTax;
        uint256 finalAmount = initial * 2;
        uint256 allowance = CAFToken.allowance(msg.sender, address(this));
        uint256 doubleUpAmount = depositAfterTax(finalAmount);
        require(
            allowance >= doubleUpAmount,
            "Allowance should be double the initial amount."
        );
        uint256 referCount = user_data[msg.sender].totalReferrals; 
                address oldRef = user_data[msg.sender].referred_by;
        uint256 _maxPayout = (doubleUpAmount * maxPayout) / 100;

        if (_availableRewards < finalAmount) {
            CAFToken.safeTransferFrom(
                msg.sender,
                address(this),
                finalAmount - _availableRewards
            );

            user_data[msg.sender] = User(
                msg.sender,
                doubleUpAmount,
                finalAmount,
                _maxPayout,
                0,
                0,
                referCount,
                0,
                oldRef,
                block.timestamp,
                block.timestamp
            );
        } else {
            user_data[msg.sender] = User(
                msg.sender,
                doubleUpAmount,
                finalAmount,
                _maxPayout,
                0,
                0,
                referCount,
                _availableRewards - finalAmount,
                oldRef,
                block.timestamp,
                block.timestamp
            );
        }
        int _max = int(user_data[oldRef].maxPayout);
        int _claimed = int(user_data[oldRef].claimed);
        int available = int(availableRewards(oldRef));
            int _refRew = int((finalAmount * refRewardLevels[0]) /
            1000);
        if (available + _claimed + _refRew <= _max && oldRef != firstAddress) {
            user_data[oldRef].referralRewards +=uint(_refRew);
            emit ReferralRewarded(msg.sender, oldRef,uint(_refRew)); 
        }else if( _max - (_claimed + available )>0 && oldRef != firstAddress){
                        int gib = _max   - (_claimed+ available) ;
                        if(gib > _refRew){
                            gib= _refRew;
                        }
                        user_data[oldRef].referralRewards += uint(gib);
                        emit ReferralRewarded(msg.sender,oldRef, uint(_refRew));

                    }
        reinvestRefer(oldRef, finalAmount);

        // refer(oldRef, finalAmount);
    }

    function setLvl1Setter(address userAddresss) internal {
        address[] storage array = level1[userAddresss].referred;
        array.push(msg.sender);
    }

    function setLvl2Setter(address userAddresss) internal {
        address[] storage array = level2[userAddresss].referred;
        array.push(msg.sender);
    }

    function setLvl3Setter(address userAddresss) internal {
        address[] storage array = level3[userAddresss].referred;
        array.push(msg.sender);
    }

    function setLvl4Setter(address userAddresss) internal {
        address[] storage array = level4[userAddresss].referred;
        array.push(msg.sender);
    }

    function setLvl5Setter(address userAddresss) internal {
        address[] storage array = level5[userAddresss].referred;
        array.push(msg.sender);
    }

    function setLvl6Setter(address userAddresss) internal {
        address[] storage array = level6[userAddresss].referred;
        array.push(msg.sender);
    }

    function setLvl7Setter(address userAddresss) internal  {
        address[] storage array = level7[userAddresss].referred;
        array.push(msg.sender);
    }

    function getLevel1Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level1[userAddresss].referred;
        return array;
    }

    function getLevel2Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level2[userAddresss].referred;
        return array;
    }

    function getLevel3Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level3[userAddresss].referred;
        return array;
    }

    function getLevel4Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level4[userAddresss].referred;
        return array;
    }

    function getLevel5Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level5[userAddresss].referred;
        return array;
    }

    function getLevel6Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level6[userAddresss].referred;
        return array;
    }

    function getLevel7Reffers(address userAddresss)
        external
        view
        returns (address[] memory)
    {
        address[] storage array = level7[userAddresss].referred;
        return array;
    }

        function calculatePayout(address caller) public view returns (uint256) {
            uint256 deposit_time = user_data[caller].lastUpdated;
            uint256 durationInHours = (block.timestamp - deposit_time) / 1 hours;
            uint256 _deposit = user_data[caller].initialDeposit;
            uint256 contractBalance = CAFToken.balanceOf(address(this));
            uint256 finalValue;
            
            if (contractBalance >= 10000000 * 1e18) {
                finalValue = (_deposit.mul(416666666666667).mul(durationInHours).div(1e18));
                return finalValue;
            } else if (contractBalance >= 5000000 * 1e18) {
                finalValue = (_deposit.mul(312500000000000).mul(durationInHours).div(1e18));
                return finalValue;
            } else if (contractBalance >= 2500000 * 1e18) {
                finalValue = (_deposit.mul(208333333333335).mul(durationInHours).div(1e18));
                return finalValue;
            } else {
                finalValue =( _deposit.mul(125000000000000).mul(durationInHours).div(1e18));
                return finalValue;
            }

        }

    function getContractBalance() public view returns (uint256) {
        return CAFToken.balanceOf(address(this));
    }
}