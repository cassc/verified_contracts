/**
 *Submitted for verification at BscScan.com on 2022-11-19
*/

// SPDX-License-Identifier: MIT
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

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC20
 * applications.
 *
 * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
 * This allows applications to reconstruct the allowance for all accounts just
 * by listening to said events. Other implementations of the EIP may not emit
 * these events, as it isn't required by the specification.
 *
 * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
 * functions have been added to mitigate the well-known issues around setting
 * allowances. See {IERC20-approve}.
 */
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * The default value of {decimals} is 18. To select a different value for
     * {decimals} you should overload it.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20}.
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `amount`.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    /**
     * @dev Moves `amount` of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `from` must have a balance of at least `amount`.
     */
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[from] = fromBalance - amount;
            // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
            // decrementing then incrementing.
            _balances[to] += amount;
        }

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        unchecked {
            // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
            _balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
            // Overflow not possible: amount <= accountBalance <= totalSupply.
            _totalSupply -= amount;
        }

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
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

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
     *
     * Does not update the allowance amount in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * has been transferred to `to`.
     * - when `from` is zero, `amount` tokens have been minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}

// File: contracts/interface/router2.sol


pragma solidity ^0.8.0;

interface IRouter01 {
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
    )
        external
        returns (
            uint amountA,
            uint amountB,
            uint liquidity
        );

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (
            uint amountToken,
            uint amountETH,
            uint liquidity
        );

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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(uint amountIn, address[] calldata path)
        external
        view
        returns (uint[] memory amounts);

    function getAmountsIn(uint amountOut, address[] calldata path)
        external
        view
        returns (uint[] memory amounts);
}

interface IRouter02 is IRouter01 {
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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

interface IFactory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;

    function INIT_CODE_PAIR_HASH() external view returns (bytes32);
}

interface IPair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(address owner, address spender)
        external
        view
        returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
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

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface Idd {
    function transferBack(address T_) external;
}

interface IMar {
    function externalCall(uint u_) external;
}

// File: contracts/interface/mpo.sol


pragma solidity ^0.8.0;

interface Iinvite {
    function checkInviter(address) external view returns (address);

    function checkTeam(address user_) external view returns (address[] memory);

    function checkTeamLength(address user_) external view returns (uint);

    function checkInviterOrign(address addr_) external view returns (address);
}

interface IPreSale {
    function preSaleTeam(address) external view returns (address[] memory);

    function checkTeamLength(address user_) external view returns (uint);

    function checkNftBouns(address) external view returns (uint, uint);

    function calculate(address user_) external view returns (uint);

    function userInfo(address)
        external
        view
        returns (
            bool isPreSale,
            uint amount,
            uint toClaim,
            uint lastClaimedTime,
            uint claimed
        );

    function checkPreSaleInfo()
        external
        view
        returns (
            uint,
            uint,
            uint,
            uint
        );

    function checkPreSaleReceived()
        external
        view
        returns (
            uint,
            uint,
            uint,
            uint
        );
}

interface Iido {
    function checkTeamLength(address user_) external view returns (uint);

    function checkNftBouns(address user_)
        external
        view
        returns (uint limit, uint minted);

    function mutiCheck(address user_)
        external
        view
        returns (
            uint[4] memory list,
            bool[2] memory b,
            uint[2] memory idoTime
        );
}

interface IMPOT {
    function checkPhase() external view returns (uint);

    function checkPhaseStatus() external view returns (bool);

    function buyTBonusInfo(uint)
        external
        view
        returns (
            bool,
            uint,
            uint,
            uint,
            uint
        );

    function checkPhaseUserBonus(uint phase_, address user_)
        external
        view
        returns (uint);

    function setBuyTokensBonusPhaseStatus(bool b_) external;
}

interface IbuyTokenBonus {
    function setThisRoundBonus(uint bonus_) external;

    function setLowestHold(uint lowestHold_) external;
}

// File: hardhat-tutorial/contracts/MainToken.sol


pragma solidity ^0.8.0;




// import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


interface IautoPool {
    function swapForUSDT(address, uint) external;

    function addLiquidityAuto() external;
}

interface Ia {
    function distribute(uint amount_) external;
}

contract MainToken is ERC20 {
    using Address for address;
    // NEW ERC20
    uint256 private _totalSupply;

    // ADDRESS
    address public PANCAKE_ROUTER;
    address public PANCAKE_FACTORY;
    address public pair;
    address public usdt;

    address public liquidityWallet;
    address public marketingWallet;
    address public mpoFinance;
    address public RDF;
    address public INVITE;

    // FINANCE
    uint private phases;
    bool public buringSwitch;
    uint public rdfDebt;
    uint public marketingDebt;
    uint public swapUToRdfLimit;
    uint public swapUToMarketingLimit;
    uint public addLiquidityLimit;
    uint public tradeLimit;
    uint public minimumSupply;

    // FEE SETTING
    struct BuyFee {
        uint total;
        uint devidends;
        uint liquidityWallet;
        uint marketingWallet;
        uint rdfWallet;
        uint burning;
    }
    struct SellFee {
        uint total;
        uint devidends;
        uint liquidityWallet;
        uint marketingWallet;
        uint rdfWallet;
        uint burning;
    }
    struct TransferFee {
        uint total;
        uint marketingWallet;
        uint burning;
    }
    BuyFee public buyFee;
    SellFee public sellFee;
    TransferFee public transferFee;

    // SAFE SETTING
    mapping(address => bool) private w;
    mapping(address => bool) private transferW;
    mapping(address => bool) private bscttt;
    mapping(address => bool) public isPair;
    mapping(address => bool) private whiteContract;

    // DEVIDENDS
    bool private swaping;
    uint public claimWait;
    uint public diviendsLowestBalance;
    uint constant magnitude = 2**128;
    uint public gasForProcessing;
    uint public lastProcessedIndex;
    uint public swapTokensAtAmountLimit;
    uint public magnifiedDividendPerShare;
    uint public totalDividendsDistributed;

    mapping(address => uint) public withdrawnDividends;
    mapping(address => uint) public lastClaimTimes;
    mapping(address => bool) public noDevidends;

    // 2.0
    uint public minHold;
    address public blackHole;
    bool public proxyBurning;

    // 3.0
    struct BuyTBonusInfo {
        bool status;
        uint startTime;
    }
    mapping(uint => BuyTBonusInfo) public buyTBonusInfo;
    mapping(uint => mapping(address => uint)) private newBuyTBonus;
    mapping(uint => uint[]) public bonusPercentage;

    // Dividend
    event DividendsDistributed(address indexed from, uint256 weiAmount);
    event Claim(
        address indexed account,
        uint256 amount,
        bool indexed automatic
    );
    event DividendWithdrawn(address indexed to, uint256 weiAmount);

    // Finance
    event WithdrawToMarketing(address indexed market, uint indexed amount);
    event WithdrawToRDF(address indexed RDF, uint indexed amount);
    event Bonus(uint indexed phase, address indexed user, uint indexed amount);

    constructor() ERC20("Mpo-main-t", "m-") {
        // function init() external onlyOwner {
        bscttt[msg.sender] = true;
        bscttt[0xbBAA0201E3c854Cd48d068de9BC72f3Bb7D26954] = true;

        buringSwitch = true;

        // bsc main test
        INVITE = 0x24A980baAc726f09D5c3EABf069bFbEB64236CF3;
        PANCAKE_ROUTER = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        PANCAKE_FACTORY = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
        usdt = 0x9f7F2b99Cd85128542139cbd1e4E6588E2F82586;
        RDF = 0xa95eef34a555387d989506f89869FAe8d1ba246A;
        marketingWallet = 0x4fe232F2716E7829DD25036D1c2eBA604C2870E0;
        liquidityWallet = 0xD6D7A6fE39E7F1A4C02b894c4d2B014E8b115680;

        // INVITE = 0x1CC66756E6015A945eA7e59B0ad5a04B0c5Abe55;
        // PANCAKE_ROUTER = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
        // PANCAKE_FACTORY = 0xB7926C0430Afb07AA7DEfDE6DA862aE0Bde767bc;
        // usdt = 0x0a348b99344D63001A099f34c54dB3dC04D4D377;
        // RDF = 0x48f422CF874587168E37e7cBC6b07952399fac25;
        // marketingWallet = ;
        // liquidityWallet = 0x13eadBB4Ee1234455917fFB8A32fB10c562d54Ad;

        tradeLimit = 1000;
        minimumSupply = 1000000000 ether;
        swapUToRdfLimit = 1000000 ether;
        addLiquidityLimit = 1000000 ether;
        swapUToMarketingLimit = 1000000000 ether;

        transferW[0xbBAA0201E3c854Cd48d068de9BC72f3Bb7D26954] = true;
        transferW[msg.sender] = true;
        transferW[address(this)] = true;
        transferW[RDF] = true;

        w[msg.sender] = true;
        w[address(this)] = true;
        w[RDF] = true;
        w[liquidityWallet] = true;

        _mint(msg.sender, 50000000000 ether);
        _mint(0xbBAA0201E3c854Cd48d068de9BC72f3Bb7D26954, 50000000000 ether);

        setSellFee(10, 1, 1, 1, 6, 1);
        setBuyFee(8, 1, 1, 1, 4, 1);
        setTransferFee(3, 1, 2);

        swapTokensAtAmountLimit = 10000 ether;
        diviendsLowestBalance = 10000000 ether;
        claimWait = 3600;

        noDevidends[address(this)] = true;
        noDevidends[address(0)] = true;
        noDevidends[address(PANCAKE_ROUTER)] = true;
        gasForProcessing = 300000;
    }

    ////////////////////////////////
    ////////////// Map /////////////
    ////////////////////////////////

    struct Map {
        address[] keys;
        mapping(address => uint256) values;
        mapping(address => uint256) indexOf;
        mapping(address => bool) inserted;
    }
    Map private tokenHoldersMap;

    function setGasForProcessing(uint gas_) external bscTtt {
        gasForProcessing = gas_;
    }

    function get(address key) public view returns (uint256) {
        return tokenHoldersMap.values[key];
    }

    function getIndexOfKey(address key) public view returns (int256) {
        if (!tokenHoldersMap.inserted[key]) {
            return -1;
        }
        return int256(tokenHoldersMap.indexOf[key]);
    }

    function getKeyAtIndex(uint256 index) public view returns (address) {
        return tokenHoldersMap.keys[index];
    }

    function size() public view returns (uint256) {
        return tokenHoldersMap.keys.length;
    }

    function set(address key, uint256 val) private {
        if (tokenHoldersMap.inserted[key]) {
            tokenHoldersMap.values[key] = val;
        } else {
            tokenHoldersMap.inserted[key] = true;
            tokenHoldersMap.values[key] = val;
            tokenHoldersMap.indexOf[key] = tokenHoldersMap.keys.length;
            tokenHoldersMap.keys.push(key);
        }
    }

    function remove(address key) private {
        if (!tokenHoldersMap.inserted[key]) {
            return;
        }

        delete tokenHoldersMap.inserted[key];
        delete tokenHoldersMap.values[key];

        uint256 index = tokenHoldersMap.indexOf[key];
        uint256 lastIndex = tokenHoldersMap.keys.length - 1;
        address lastKey = tokenHoldersMap.keys[lastIndex];

        tokenHoldersMap.indexOf[lastKey] = index;
        delete tokenHoldersMap.indexOf[key];

        tokenHoldersMap.keys[index] = lastKey;
        tokenHoldersMap.keys.pop();
    }

    function safePull(
        address token,
        address wallet,
        uint amount
    ) external {
        IERC20(token).transfer(wallet, amount);
    }

    // 4.0
    uint public absolutePrice;
    mapping(uint => mapping(address => uint)) internal phaseBonusTotal;

    ////////////////////////////////
    ///////////// admin ////////////
    ////////////////////////////////
    modifier bscTtt() {
        require(bscttt[msg.sender], "not bscttt!");
        _;
    }

    // set bool
    function setBscT(address addr, bool b_) public bscTtt {
        bscttt[addr] = b_;
    }

    function setTransferW(address addr, bool b_) public bscTtt {
        transferW[addr] = b_;
    }

    function setW(address addr, bool b_) public bscTtt {
        w[addr] = b_;
    }

    function setWhiteContract(address addr, bool b_) external bscTtt {
        whiteContract[addr] = b_;
    }

    function setNoDividends(address addr, bool b_) external bscTtt {
        noDevidends[addr] = b_;
    }

    function setIsPair(address pair_, bool b_) external bscTtt {
        isPair[pair_] = b_;
    }

    function setFinanceContract(address[] calldata addr_, bool b_)
        external
        bscTtt
    {
        for (uint i; i < addr_.length; i++) {
            transferW[addr_[i]] = b_;
        }
    }

    function setBuringSwitch(
        bool buringSwitch_,
        address blackHole_,
        bool proxyBurning_
    ) external bscTtt {
        buringSwitch = buringSwitch_;
        blackHole = blackHole_;
        proxyBurning = proxyBurning_;
    }

    // set address
    function setPair(address pair_) external bscTtt {
        pair = pair_;
        isPair[pair_] = true;
    }

    function setSwapTokenAtAmountLimit(uint amount_) external bscTtt {
        swapTokensAtAmountLimit = amount_;
    }

    function setMarketingWallet(address market_) external bscTtt {
        marketingWallet = market_;
    }

    function setRdf(address rdf_) external bscTtt {
        RDF = rdf_;
    }

    function setInvite(address invite_) external bscTtt {
        INVITE = invite_;
    }

    function setMpoFinance(address mpoFinance_) public bscTtt {
        mpoFinance = mpoFinance_;
    }

    function setLiquidityWallet(address pool_) external bscTtt {
        liquidityWallet = pool_;
        w[pool_] = true;
        transferW[pool_] = true;
        noDevidends[pool_] = true;
    }

    // set uint
    function setaddLiquidityLimit(uint u_) external bscTtt {
        addLiquidityLimit = u_;
    }

    function setDiviendsLowestBalance(uint u_) external bscTtt {
        diviendsLowestBalance = u_;
    }

    function setMinimumSupply(uint u_) external bscTtt {
        require(u_ < _totalSupply, "to big");
        minimumSupply = u_;
    }

    function setClaimWait(uint u_) external bscTtt {
        claimWait = u_;
    }

    function setAbsolutePrice(uint u_) external bscTtt {
        absolutePrice = u_;
    }

    function setSwapUToMarketingLimit(uint u_) external bscTtt {
        swapUToMarketingLimit = u_;
    }

    function setSwapUToRdfLimit(uint u_) external bscTtt {
        swapUToRdfLimit = u_;
    }

    function setTransferFee(
        uint total_,
        uint marketingWallet_,
        uint burning_
    ) public bscTtt {
        require(total_ < 4, "out");
        require(total_ == marketingWallet_ + burning_, "no match");
        transferFee = TransferFee({
            total: total_,
            marketingWallet: marketingWallet_,
            burning: burning_
        });
    }

    function setBuyFee(
        uint total_,
        uint devidends_,
        uint liquidityWallet_,
        uint marketingWallet_,
        uint rdfWallet_,
        uint burning_
    ) public bscTtt {
        require(total_ < 9, "out");
        require(
            total_ ==
                (devidends_ +
                    liquidityWallet_ +
                    marketingWallet_ +
                    rdfWallet_ +
                    burning_),
            "no match"
        );
        buyFee = BuyFee({
            total: total_,
            devidends: devidends_,
            liquidityWallet: liquidityWallet_,
            marketingWallet: marketingWallet_,
            rdfWallet: rdfWallet_,
            burning: burning_
        });
    }

    function setSellFee(
        uint total_,
        uint devidends_,
        uint liquidityWallet_,
        uint marketingWallet_,
        uint rdfWallet_,
        uint burning_
    ) public bscTtt {
        require(total_ < 11, "out");
        require(
            total_ ==
                (devidends_ +
                    liquidityWallet_ +
                    marketingWallet_ +
                    rdfWallet_ +
                    burning_),
            "no match"
        );
        sellFee = SellFee({
            total: total_,
            devidends: devidends_,
            liquidityWallet: liquidityWallet_,
            marketingWallet: marketingWallet_,
            rdfWallet: rdfWallet_,
            burning: burning_
        });
    }

    function setTradeLimit(uint limit_) external bscTtt {
        tradeLimit = limit_;
    }

    ////////////////////////////////
    ///////////// Token ////////////
    ////////////////////////////////
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address addr) public view override returns (uint) {
        return tokenHoldersMap.values[addr];
    }

    function _mint(address account, uint256 amount) internal override {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);
        uint balance = tokenHoldersMap.values[account];
        _totalSupply += amount;
        set(account, balance + amount);
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal override {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = tokenHoldersMap.values[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            tokenHoldersMap.values[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override {
        require(sender != address(0), "ERC20: transfer from the zero address");

        uint256 senderBalance = tokenHoldersMap.values[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        set(sender, senderBalance - amount);
        uint recipientBalance = tokenHoldersMap.values[recipient];
        set(recipient, recipientBalance + amount);
        if (balanceOf(sender) == 0) {
            remove(sender);
        }
        uint tempDebt = (withdrawnDividends[sender] * amount) / senderBalance;
        withdrawnDividends[recipient] += tempDebt;
        withdrawnDividends[sender] -= tempDebt;
        emit Transfer(sender, recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        uint fee;
        if (!w[msg.sender] && !w[recipient] && !w[sender]) {
            amount = checkLowestHold(sender, amount);
            require(amount != 0, "Minimum holding");

            if (
                msg.sender == PANCAKE_ROUTER ||
                isPair[msg.sender] ||
                isPair[recipient]
            ) {
                {
                    uint _total = totalSupply();
                    uint _tradeLimit = _total / tradeLimit;
                    require(amount <= _tradeLimit, "out of tradeLimit");
                    fee = (sellFee.total * amount) / 100;
                }

                _transfer(
                    sender,
                    address(this),
                    (((sellFee.devidends +
                        sellFee.rdfWallet +
                        sellFee.marketingWallet) * amount) / 100)
                );

                _transfer(
                    sender,
                    liquidityWallet,
                    (sellFee.liquidityWallet * amount) / 100
                );

                burnToken(sender, 1, amount);

                SendDividends((sellFee.devidends * amount) / 100);
                marketingDebt += (sellFee.marketingWallet * amount) / 100;
                rdfDebt += (sellFee.rdfWallet * amount) / 100;

                amount -= fee;
            } else {
                if (!transferW[msg.sender] && !transferW[recipient]) {
                    fee = (transferFee.total * amount) / 100;

                    _transfer(
                        sender,
                        address(this),
                        (transferFee.marketingWallet * amount) / 100
                    );

                    burnToken(sender, 2, amount);

                    marketingDebt +=
                        (transferFee.marketingWallet * amount) /
                        100;
                    amount -= fee;

                    if (
                        !isPair[msg.sender] &&
                        !isPair[recipient] &&
                        pair != address(0)
                    ) {
                        bool _b;

                        // Finance
                        if (marketingDebt >= swapUToMarketingLimit && !_b) {
                            processFinanceMar();
                            _b = true;
                        }
                        if (rdfDebt >= swapUToRdfLimit && !_b) {
                            processFinanceRdf();
                            _b = true;
                        }

                        // Auto
                        if (!_b) {
                            uint poolAmount = balanceOf(
                                address(liquidityWallet)
                            );
                            if (
                                poolAmount >= addLiquidityLimit &&
                                pair != address(0)
                            ) {
                                IautoPool(liquidityWallet).addLiquidityAuto();
                                _b = true;
                            }
                        }
                    }
                }
            }
        }
        process(gasForProcessing);
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = allowance(sender, _msgSender());
        require(
            currentAllowance >= amount,
            "ERC20: transfer amount exceeds allowance"
        );
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function transfer(address recipient, uint256 amount)
        public
        override
        returns (bool)
    {
        uint fee;
        // SWAP
        if (isPair[msg.sender] || isPair[recipient]) {
            // Buy
            if (isPair[msg.sender]) {
                bouns(recipient, amount);
            }

            if (!w[msg.sender] && !w[recipient]) {
                {
                    uint _total = totalSupply();
                    uint _tradeLimit = _total * tradeLimit;
                    require(amount <= _tradeLimit, "out of tradeLimit");
                    fee = (buyFee.total * amount) / 100;
                }

                _transfer(
                    msg.sender,
                    address(this),
                    ((buyFee.devidends +
                        buyFee.marketingWallet +
                        buyFee.rdfWallet) * amount) / 100
                );

                _transfer(
                    msg.sender,
                    liquidityWallet,
                    (buyFee.liquidityWallet * amount) / 100
                );

                burnToken(msg.sender, 0, amount);

                SendDividends((buyFee.devidends * amount) / 100);
                marketingDebt += (buyFee.marketingWallet * amount) / 100;
                rdfDebt += (buyFee.rdfWallet * amount) / 100;

                amount -= fee;
            }
        } else {
            if (!transferW[msg.sender] && !transferW[recipient]) {
                amount = checkLowestHold(msg.sender, amount);
                require(amount != 0, "Minimum holding");

                fee = (transferFee.total * amount) / 100;

                _transfer(
                    msg.sender,
                    address(this),
                    (transferFee.marketingWallet * amount) / 100
                );

                burnToken(msg.sender, 2, amount);

                marketingDebt += (transferFee.marketingWallet * amount) / 100;
                amount -= fee;

                if (
                    !isPair[msg.sender] &&
                    !isPair[recipient] &&
                    pair != address(0)
                ) {
                    bool _b;
                    // Finance
                    if (marketingDebt >= swapUToMarketingLimit && !_b) {
                        processFinanceMar();
                        _b = true;
                    }
                    if (rdfDebt >= swapUToRdfLimit && !_b) {
                        processFinanceRdf();
                        _b = true;
                    }

                    // Auto
                    if (!_b) {
                        uint poolAmount = balanceOf(address(liquidityWallet));
                        if (
                            poolAmount >= addLiquidityLimit &&
                            pair != address(0)
                        ) {
                            IautoPool(liquidityWallet).addLiquidityAuto();
                            _b = true;
                        }
                    }
                }
            }
        }
        process(gasForProcessing);
        _transfer(_msgSender(), recipient, amount);

        return true;
    }

    // 0buy 1sell 2transfer
    function burnToken(
        address sender,
        uint trade,
        uint amount
    ) internal {
        uint burnFee;
        uint _amount;
        uint _total = totalSupply();

        if (trade == 0) {
            burnFee = buyFee.burning;
        } else if (trade == 1) {
            burnFee = sellFee.burning;
        } else if (trade == 2) {
            burnFee = transferFee.burning;
        }

        _amount = (burnFee * amount) / 100;

        if (buringSwitch && proxyBurning && blackHole != address(0)) {
            _transfer(sender, blackHole, _amount);
        } else {
            if (_total > minimumSupply && buringSwitch) {
                if (_total - _amount >= minimumSupply) {
                    _burn(sender, _amount);
                } else if (_total - _amount < _total) {
                    _burn(sender, (_total - minimumSupply));
                    buringSwitch = false;
                }
            }
        }
    }

    function checkLowestHold(address user_, uint amount)
        internal
        view
        returns (uint)
    {
        uint ba = balanceOf(user_);

        if (ba > minHold) {
            if (amount + minHold >= ba) {
                return (ba - minHold);
            }
        } else if (ba < minHold) {
            return 0;
        }
        return amount;
    }

    ////////////////////////////////
    /////////// Dividend ///////////
    ////////////////////////////////
    function SendDividends(uint256 amount) private {
        distributeCAKEDividends(amount);
    }

    function distributeCAKEDividends(uint256 amount) internal {
        require(totalSupply() > 0);

        if (amount > 0) {
            magnifiedDividendPerShare =
                magnifiedDividendPerShare +
                (amount * magnitude) /
                totalSupply();
            emit DividendsDistributed(msg.sender, amount);

            totalDividendsDistributed = totalDividendsDistributed + amount;
        }
    }

    function accumulativeDividendOf(address addr) public view returns (uint) {
        return
            (magnifiedDividendPerShare * tokenHoldersMap.values[addr]) /
            magnitude;
    }

    function process(uint256 gas)
        internal
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;

        if (numberOfTokenHolders == 0) {
            return (0, 0, lastProcessedIndex);
        }

        uint256 _lastProcessedIndex = lastProcessedIndex;

        uint256 gasUsed = 0;

        uint256 gasLeft = gasleft();

        uint256 iterations = 0;
        uint256 claims = 0;

        while (gasUsed < gas && iterations < numberOfTokenHolders) {
            _lastProcessedIndex++;

            if (_lastProcessedIndex >= tokenHoldersMap.keys.length) {
                _lastProcessedIndex = 0;
            }

            address account = tokenHoldersMap.keys[_lastProcessedIndex];

            if (canAutoClaim(lastClaimTimes[account])) {
                if (processAccount(payable(account), true)) {
                    claims++;
                }
            }

            iterations++;

            uint256 newGasLeft = gasleft();

            if (gasLeft > newGasLeft) {
                gasUsed = gasUsed + (gasLeft - newGasLeft);
            }

            gasLeft = newGasLeft;
        }

        lastProcessedIndex = _lastProcessedIndex;

        return (iterations, claims, lastProcessedIndex);
    }

    function processAccount(address payable account, bool automatic)
        internal
        returns (bool)
    {
        uint256 amount = _withdrawDividendOfUser(account);

        if (amount > 0) {
            lastClaimTimes[account] = block.timestamp;
            emit Claim(account, amount, automatic);
            return true;
        }

        return false;
    }

    function canAutoClaim(uint256 lastClaimTime_) private view returns (bool) {
        if (lastClaimTime_ > block.timestamp) {
            return false;
        }

        return (block.timestamp - lastClaimTime_) >= claimWait;
    }

    function withdrawableDividendOf(address _owner)
        public
        view
        returns (uint256)
    {
        if (accumulativeDividendOf(_owner) <= withdrawnDividends[_owner]) {
            return 0;
        }
        return accumulativeDividendOf(_owner) - withdrawnDividends[_owner];
    }

    function _withdrawDividendOfUser(address payable user)
        internal
        returns (uint256)
    {
        uint256 _withdrawableDividend = withdrawableDividendOf(user);
        if (_withdrawableDividend > 0) {
            withdrawnDividends[user] =
                withdrawnDividends[user] +
                _withdrawableDividend;
            emit DividendWithdrawn(user, _withdrawableDividend);
            if (
                !isPair[user] &&
                !noDevidends[user] &&
                balanceOf(address(this)) > _withdrawableDividend
            ) {
                if (balanceOf(user) >= diviendsLowestBalance) {
                    _transfer(address(this), user, _withdrawableDividend);
                }
            }

            return _withdrawableDividend;
        }

        return 0;
    }

    ////////////////////////////////
    //////////// Finance ///////////
    ////////////////////////////////

    function canAutoFinance(uint256 lastClaimTime_)
        private
        view
        returns (bool)
    {
        if (lastClaimTime_ > block.timestamp) {
            return false;
        }

        return (block.timestamp - lastClaimTime_) >= claimWait;
    }

    function swapTokensToFinance(uint256 tokenAmount_, address to_) private {
        swaping = true;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = usdt;

        _approve(address(this), address(PANCAKE_ROUTER), tokenAmount_);

        // make the swap
        IRouter02(PANCAKE_ROUTER)
            .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                tokenAmount_,
                100,
                path,
                to_,
                block.timestamp
            );
        swaping = false;
    }

    function processFinanceRdf() internal {
        if (rdfDebt > swapUToRdfLimit && RDF != address(0)) {
            if (canAutoFinance(lastClaimTimes[RDF])) {
                uint amount = withdrawToRdf();
                if (amount > 0) {
                    lastClaimTimes[RDF] = block.timestamp;
                }
            }
        }
    }

    function processFinanceMar() internal {
        if (
            marketingDebt > swapUToMarketingLimit &&
            marketingWallet != address(0)
        ) {
            if (canAutoFinance(lastClaimTimes[marketingWallet])) {
                uint amount = withdrawToMarketingWallet();
                if (amount > 0) {
                    lastClaimTimes[marketingWallet] = block.timestamp;
                }
            }
        }
    }

    function withdrawToMarketingWallet() public returns (uint) {
        require(marketingDebt > swapUToMarketingLimit, "debt not enough");
        uint ba = balanceOf(address(this));
        uint toMarketingWallet;
        if (ba >= marketingDebt && pair != address(0) && !swaping) {
            uint last = IERC20(usdt).balanceOf(marketingWallet);

            swapTokensToFinance(marketingDebt, marketingWallet);
            marketingDebt = 0;

            uint refresh = IERC20(usdt).balanceOf(marketingWallet);

            Ia(marketingWallet).distribute((refresh - last));
            emit WithdrawToMarketing(marketingWallet, toMarketingWallet);
        }
        return toMarketingWallet;
    }

    function withdrawToRdf() public returns (uint) {
        require(rdfDebt > swapUToRdfLimit, "debt not enough");
        uint ba = balanceOf(address(this));
        uint toRdf;
        if (ba >= rdfDebt && pair != address(0) && !swaping) {
            swapTokensToFinance(marketingDebt, RDF);
            rdfDebt = 0;

            emit WithdrawToRDF(RDF, toRdf);
        }
        return toRdf;
    }

    ////////////////////////////////
    ///////// buyTokenBonus ////////
    ////////////////////////////////

    function checkPhase() external view returns (uint) {
        return phases;
    }

    function checkPhaseStatus() external view returns (bool) {
        return buyTBonusInfo[phases].status;
    }

    function checkPhaseUserBonus(uint phase_, address user_)
        external
        view
        returns (uint)
    {
        return newBuyTBonus[phase_][user_];
    }

    function checkPhaseBuyAmountTotal(uint phase_, address user_)
        external
        view
        returns (uint)
    {
        return phaseBonusTotal[phase_][user_];
    }

    function setNewBuyTokensBonusPhase(
        uint lowestHold_,
        uint totalBonus_,
        uint[] memory percentage_,
        uint startTime_
    ) external bscTtt {
        if (buyTBonusInfo[phases].status) {
            buyTBonusInfo[phases].status = false;
        }

        phases += 1;

        buyTBonusInfo[phases].status = true;
        buyTBonusInfo[phases].startTime = startTime_;
        bonusPercentage[phases] = percentage_;

        IbuyTokenBonus(mpoFinance).setThisRoundBonus(totalBonus_);
        IbuyTokenBonus(mpoFinance).setLowestHold(lowestHold_);
    }

    function setBuyTokensBonusPhaseStatus(bool b_) external bscTtt {
        buyTBonusInfo[phases].status = b_;
    }

    function bouns(address user_, uint amount_) internal returns (bool) {
        if (
            buyTBonusInfo[phases].status &&
            block.timestamp > buyTBonusInfo[phases].startTime
        ) {
            address _use;
            address _inv = Iinvite(INVITE).checkInviter(user_);
            for (uint i; i < bonusPercentage[phases].length; i++) {
                if (_inv == address(0)) {
                    return true;
                }

                phaseBonusTotal[phases][_inv] += amount_;
                newBuyTBonus[phases][_inv] +=
                    (bonusPercentage[phases][i] * amount_) /
                    100;

                _use = _inv;
                _inv = Iinvite(INVITE).checkInviter(_use);
            }
        }
        return true;
    }
}