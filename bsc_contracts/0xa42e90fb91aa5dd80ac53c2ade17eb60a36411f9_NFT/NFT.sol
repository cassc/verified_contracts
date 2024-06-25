/**
 *Submitted for verification at BscScan.com on 2022-10-05
*/

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

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
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

// File: @openzeppelin/contracts/utils/Counters.sol


// OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)

pragma solidity ^0.8.0;

/**
 * @title Counters
 * @author Matt Condon (@shrugs)
 * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
 * of elements in a mapping, issuing ERC721 ids, or counting request ids.
 *
 * Include with `using Counters for Counters.Counter;`
 */
library Counters {
    struct Counter {
        // This variable should never be directly accessed by users of the library: interactions must be restricted to
        // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
        // this feature: see https://github.com/ethereum/solidity/issues/4637
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
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

// File: @openzeppelin/contracts/utils/Strings.sol


// OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
    uint8 private constant _ADDRESS_LENGTH = 20;

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }

    /**
     * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
     */
    function toHexString(address addr) internal pure returns (string memory) {
        return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
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

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;




/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
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
        }
        _balances[to] += amount;

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
        _balances[account] += amount;
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
        }
        _totalSupply -= amount;

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

// File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

// File: @openzeppelin/contracts/utils/introspection/ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

// File: @openzeppelin/contracts/token/ERC721/IERC721.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;


/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}

// File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)

pragma solidity ^0.8.0;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// File: @openzeppelin/contracts/token/ERC721/ERC721.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)

pragma solidity ^0.8.0;








/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721-balanceOf}.
     */
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }

    /**
     * @dev See {IERC721Metadata-name}.
     */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
     * @dev See {IERC721Metadata-symbol}.
     */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    /**
     * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
     * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
     * by default, can be overridden in child contracts.
     */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
     * @dev See {IERC721-approve}.
     */
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not token owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        _requireMinted(tokenId);

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        _setApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
        _safeTransfer(from, to, tokenId, data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);

        _afterTokenTransfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);

        _afterTokenTransfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     *
     * Emits a {Transfer} event.
     */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits an {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Approve `operator` to operate on all of `owner` tokens
     *
     * Emits an {ApprovalForAll} event.
     */
    function _setApprovalForAll(
        address owner,
        address operator,
        bool approved
    ) internal virtual {
        require(owner != operator, "ERC721: approve to caller");
        _operatorApprovals[owner][operator] = approved;
        emit ApprovalForAll(owner, operator, approved);
    }

    /**
     * @dev Reverts if the `tokenId` has not been minted yet.
     */
    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    /**
     * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
     * The call is not executed if the target address is not a contract.
     *
     * @param from address representing the previous owner of the given token ID
     * @param to target address that will receive the tokens
     * @param tokenId uint256 ID of the token to be transferred
     * @param data bytes optional data to send along with the call
     * @return bool whether the call correctly returned the expected magic value
     */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory data
    ) private returns (bool) {
        if (to.isContract()) {
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
                } else {
                    /// @solidity memory-safe-assembly
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}

    /**
     * @dev Hook that is called after any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}

// File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)

pragma solidity ^0.8.0;


/**
 * @dev ERC721 token with storage based token URI management.
 */
abstract contract ERC721URIStorage is ERC721 {
    using Strings for uint256;

    // Optional mapping for token URIs
    mapping(uint256 => string) private _tokenURIs;

    /**
     * @dev See {IERC721Metadata-tokenURI}.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();

        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }

        return super.tokenURI(tokenId);
    }

    /**
     * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    /**
     * @dev See {ERC721-_burn}. This override additionally checks to see if a
     * token-specific URI was set for the token, and if so, it deletes the token URI from
     * the storage mapping.
     */
    function _burn(uint256 tokenId) internal virtual override {
        super._burn(tokenId);

        if (bytes(_tokenURIs[tokenId]).length != 0) {
            delete _tokenURIs[tokenId];
        }
    }
}

// File: NFT.sol


pragma solidity ^0.8.17;







contract NFT is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenIdCounter;

    bool public isTestnet = block.chainid == 97;

    address public busdAddress =
        isTestnet
            ? 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee
            : 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;

    address public admin = 0x0D0095Ac3d4E5F01c6B625A971bA893b42E5AEf6;
    address public defaultReferralAccount =
        0x2198354afa0bCb24ddd0344d69D89a88B8876674;

    bool public isContractLocked = false;

    uint256 public lengthOfSubscription = 90 days;
    uint256 public subscriptionPercentage = 97;
    uint256 public matchingBonus = 10;
    uint256 public championBonus = 3;
    uint256 public createNftFee = 4000000000000000; // 0.004 BNB
    uint256 public minWeeklyTurnoverPerLeg = 250 ether;
    uint256 public weekTurnover = 0;
    uint256 public globalCap = 53;
    uint256 public championBonusMinAmount = 2000 ether;

    uint256[] public directSalesPercentage = [20, 22, 25, 27, 30];
    uint256[] public binaryPercentage = [10, 12, 15, 17, 20];

    // Addresses
    address[] public addresses;
    mapping(address => bool) public hasAddress;

    // Volume
    mapping(address => uint256) public addressToDirectCustomersVolume;
    mapping(address => uint256) public addressToWeeklyDirectCustomersVolume;
    mapping(address => uint256) public addressToEarnings;
    mapping(address => uint256) public addressToClaimed;
    mapping(address => uint256) public addressToLastClaimedTimestamp;
    mapping(address => uint256) public addressToMinRank;
    uint256[] public minParity = [
        1500 ether,
        5000 ether,
        25000 ether,
        100000 ether
    ];
    uint256[] public salesToAchieveRank = [
        1500 ether,
        5000 ether,
        25000 ether,
        50000 ether
    ];

    // Extra bonus
    uint256[] public extraBonusMinAmount = [200 ether, 500 ether, 2000 ether];
    uint256[] public extraBonusPerc = [3, 5, 10];

    // Legs
    mapping(address => address) public addressToSponsor;
    mapping(address => address) public addressToLeg1Address;
    mapping(address => address) public addressToLeg2Address;
    mapping(address => bool) public addressToIsRightLegSelected;
    mapping(address => uint256) public addressToLeftTurnover;
    mapping(address => uint256) public addressToRightTurnover;

    // Price
    mapping(uint256 => uint256) public tokenIdToPrice;

    // Subscriptions
    mapping(address => uint256) public subscriberToTimestamp;
    mapping(address => uint256) public addressToPenalty;
    mapping(uint256 => uint256) public tokenIdToSubsLength;

    mapping(address => bool) public isFounder;
    uint256 public remainingFounders = 250;
    uint256 public founderBonusPercentage = 1;

    constructor() ERC721("FUTURIA", "FUTURIA") {}

    modifier onlyAdmin() {
        require(
            msg.sender == owner() ||
                msg.sender == admin ||
                msg.sender == defaultReferralAccount
        );
        _;
    }

    function checkIfActiveSubscription(address addr)
        public
        view
        returns (bool)
    {
        if (subscriberToTimestamp[addr] == 0) {
            // Subscription not found
            return false;
        }

        if (
            block.timestamp > subscriberToTimestamp[addr] + lengthOfSubscription
        ) {
            // Subscription has expired
            return false;
        }

        return true;
    }

    function hasMatchingBonus(address addr) public view returns (bool) {
        bool hasActiveSubs = checkIfActiveSubscription(addr);

        if (!hasActiveSubs || rankOf(addr) < 2) {
            return false;
        }

        return true;
    }

    function hasChampionBonus(address addr) public view returns (bool) {
        bool hasActiveSubs = checkIfActiveSubscription(addr);
        uint256 profits = addressToEarnings[addr];
        uint256 rank = rankOf(addr);

        if (!hasActiveSubs || profits < championBonusMinAmount || rank < 3) {
            return false;
        }

        return true;
    }

    function getChampionBonusAmount() public view returns (uint256) {
        return (weekTurnover * championBonus) / 100;
    }

    function getFoundersBonusAmount() public view returns (uint256) {
        return (weekTurnover * founderBonusPercentage) / 100;
    }

    function getDirectCommissions(address addr) public view returns (uint256) {
        uint256 weeklyDirectCustomersVolume = addressToWeeklyDirectCustomersVolume[
                addr
            ];
        uint256 rank = rankOf(addr);
        uint256 percentage = directSalesPercentage[rank - 1];

        uint256 commissions = (weeklyDirectCustomersVolume * percentage) / 100;
        return commissions;
    }

    function getIndirectCommissions(address addr)
        public
        view
        returns (uint256)
    {
        bool hasActiveSubs = checkIfActiveSubscription(addr);
        uint256 parity = getParity(addr);

        if (!hasActiveSubs || parity < minWeeklyTurnoverPerLeg) {
            return 0;
        }

        uint256 rank = rankOf(addr);
        uint256 binaryPerc = binaryPercentage[rank - 1];
        uint256 binaryExtraBonus = getBinaryExtraBonus(addr);
        uint256 percentage = binaryExtraBonus + binaryPerc;

        uint256 commissions = (parity * percentage) / 100;
        return commissions;
    }

    function getWeeklyLegsTurnover(address rootAddress)
        public
        view
        returns (uint256[] memory)
    {
        address leg1Address = addressToLeg1Address[rootAddress];
        address leg2Address = addressToLeg2Address[rootAddress];
        uint256[] memory weeklyLegsTurnover = new uint256[](2);

        weeklyLegsTurnover[0] =
            getTreeSum(leg1Address) +
            addressToLeftTurnover[rootAddress];
        weeklyLegsTurnover[1] =
            getTreeSum(leg2Address) +
            addressToRightTurnover[rootAddress];

        return weeklyLegsTurnover;
    }

    function getCapAmount() public view returns (uint256) {
        return (globalCap * weekTurnover) / 100;
    }

    function getBinaryExtraBonus(address addr) public view returns (uint256) {
        uint256 weeklyVolume = addressToWeeklyDirectCustomersVolume[addr];

        if (weeklyVolume >= extraBonusMinAmount[2]) {
            return extraBonusPerc[2];
        } else if (weeklyVolume >= extraBonusMinAmount[1]) {
            return extraBonusPerc[1];
        } else if (weeklyVolume >= extraBonusMinAmount[0]) {
            return extraBonusPerc[0];
        }

        return 0;
    }

    function getParity(address addr) public view returns (uint256) {
        uint256[] memory weeklyLegsTurnover = getWeeklyLegsTurnover(addr);
        uint256 leftTurnover = weeklyLegsTurnover[0];
        uint256 rightTurnover = weeklyLegsTurnover[1];

        return leftTurnover >= rightTurnover ? rightTurnover : leftTurnover;
    }

    function rankOf(address addr) public view returns (uint256) {
        uint256 sales = addressToDirectCustomersVolume[addr];
        uint256 salesToAchieveRank2 = salesToAchieveRank[0];
        uint256 salesToAchieveRank3 = salesToAchieveRank[1];
        uint256 salesToAchieveRank4 = salesToAchieveRank[2];
        uint256 salesToAchieveRank5 = salesToAchieveRank[3];
        uint256 rankPenalty = addressToPenalty[addr];
        uint256 rank = 1;
        uint256 minRank = addressToMinRank[addr];
        uint256 parity = getParity(addr);

        if (sales >= salesToAchieveRank5 || parity >= minParity[3]) {
            rank = 5;
        } else if (sales >= salesToAchieveRank4 || parity >= minParity[2]) {
            rank = 4;
        } else if (sales >= salesToAchieveRank3 || parity >= minParity[1]) {
            rank = 3;
        } else if (
            sales >= salesToAchieveRank2 ||
            isFounder[addr] ||
            parity >= minParity[0]
        ) {
            rank = 2;
        }

        if (minRank > rank) {
            rank = minRank;
        }

        rank = rank - rankPenalty;

        if (rank < 1) {
            return 1;
        }

        return rank;
    }

    function claimableAmountOf(address addr) public view returns (uint256) {
        uint256 earningsInWei = addressToEarnings[addr];

        return earningsInWei;
    }

    function saveAddressIfNeeed(address addr) internal {
        if (!hasAddress[addr]) {
            hasAddress[addr] = true;
            addresses.push(addr);
        }
    }

    function claim() public payable nonReentrant {
        uint256 busdAmountInWei = claimableAmountOf(msg.sender);
        uint256 busdBalance = ERC20(busdAddress).balanceOf(address(this));

        require(busdAmountInWei > 0, "BUSD amount must be larger than 0");
        require(busdBalance > 0, "Not enough tokens in the reserve");

        addressToEarnings[msg.sender] = 0;
        saveAddressIfNeeed(msg.sender);
        addressToLastClaimedTimestamp[msg.sender] = block.timestamp;
        addressToClaimed[msg.sender] += busdAmountInWei;
        transferBUSD(busdAmountInWei);
    }

    function setTokenIdSubs(uint256 tokenId, uint256 subsLength) external {
        address nftOwner = ownerOf(tokenId);
        require(
            msg.sender == nftOwner ||
                msg.sender == owner() ||
                msg.sender == admin,
            "User not authorized"
        );

        tokenIdToSubsLength[tokenId] = subsLength;
    }

    function setTokenIdPrice(uint256 tokenId, uint256 price) external {
        address nftOwner = ownerOf(tokenId);
        require(
            msg.sender == nftOwner ||
                msg.sender == owner() ||
                msg.sender == admin,
            "User not authorized"
        );
        tokenIdToPrice[tokenId] = price;
    }

    function buyNFT(uint256 tokenId) public nonReentrant {
        uint256 amount = tokenIdToPrice[tokenId];
        address owner = ownerOf(tokenId);

        saveAddressIfNeeed(msg.sender);
        transferFromBUSD(msg.sender, address(this), amount);
        _transfer(owner, msg.sender, tokenId);
        distributeProfits(owner, amount);
    }

    function addToTree(address rootAddress, address newUser) internal {
        address leftLegAddr = addressToLeg1Address[rootAddress];
        address rightLegAddr = addressToLeg2Address[rootAddress];

        if (leftLegAddr == address(0)) {
            addressToLeg1Address[rootAddress] = newUser;
        } else if (rightLegAddr == address(0) && leftLegAddr != newUser) {
            addressToLeg2Address[rootAddress] = newUser;
        } else {
            // 2 legs occupied
            bool isRightLegSelected = addressToIsRightLegSelected[rootAddress];
            if (isRightLegSelected) {
                addToTree(rightLegAddr, newUser);
            } else {
                addToTree(leftLegAddr, newUser);
            }
        }
    }

    function subscribe(uint256 tokenId, address referralAddress)
        public
        nonReentrant
    {
        require(
            referralAddress != msg.sender,
            "Referral address must be different from recipient"
        );

        uint256 subsPrice = tokenIdToPrice[tokenId];
        uint256 volume = (subsPrice * subscriptionPercentage) / 100;
        address sponsor = addressToSponsor[msg.sender];

        if (referralAddress == address(0)) {
            referralAddress = defaultReferralAccount;
        }

        if (sponsor == address(0)) {
            sponsor = referralAddress;
            addressToSponsor[msg.sender] = sponsor;
            addToTree(sponsor, msg.sender);
        }

        weekTurnover += volume;
        subscriberToTimestamp[msg.sender] = block.timestamp;

        if (remainingFounders > 0) {
            isFounder[msg.sender] = true;
            remainingFounders--;
        }

        saveAddressIfNeeed(msg.sender);
        distributeProfits(sponsor, volume);
        transferFromBUSD(msg.sender, address(this), subsPrice);
    }

    function distributeProfits(address sponsor, uint256 amount) internal {
        updateDirectCustomersVolume(sponsor, amount);
        updateWeeklyDirectCustomersVolume(sponsor, amount);
    }

    function transferFromBUSD(
        address sender,
        address recipient,
        uint256 amount
    ) internal {
        uint256 allowance = allowanceBUSD(msg.sender, address(this));
        require(allowance >= amount, "Check the BUSD allowance");

        ERC20(busdAddress).transferFrom(sender, recipient, amount);
    }

    function transferBUSD(uint256 amount) internal {
        ERC20(busdAddress).transfer(msg.sender, amount);
    }

    function allowanceBUSD(address owner, address spender)
        public
        view
        returns (uint256)
    {
        return ERC20(busdAddress).allowance(owner, spender);
    }

    function updateDirectCustomersVolume(address addr, uint256 amount)
        internal
    {
        addressToDirectCustomersVolume[addr] += amount;
    }

    function updateWeeklyDirectCustomersVolume(address addr, uint256 amount)
        internal
    {
        addressToWeeklyDirectCustomersVolume[addr] += amount;
    }

    function safeMint(
        uint256 quantity,
        address to,
        string memory uri,
        uint256 price,
        uint256 subsLength
    ) onlyAdmin public payable nonReentrant  {
        require(!isContractLocked, "Contract is locked");
  
        if (
            admin != address(0) && msg.sender != owner() && msg.sender != admin
        ) {
            require(msg.value >= createNftFee, "Insufficient BNB value");
        }

        for (uint256 i; i < quantity; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, uri);
            tokenIdToPrice[tokenId] = price;
            tokenIdToSubsLength[tokenId] = subsLength;
        }

        saveAddressIfNeeed(to);
    }

    function setSelectedLeg(bool isRightLegSelected) external {
        addressToIsRightLegSelected[msg.sender] = isRightLegSelected;
        saveAddressIfNeeed(msg.sender);
    }

    // View functions
    function totalSupply() public view virtual returns (uint256) {
        return _tokenIdCounter.current();
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function getTreeSum(address rootAddress)
        public
        view
        virtual
        returns (uint256)
    {
        address leg1Address = addressToLeg1Address[rootAddress];
        address leg2Address = addressToLeg2Address[rootAddress];
        uint256 sum = addressToWeeklyDirectCustomersVolume[rootAddress];

        if (leg1Address != address(0)) {
            sum += getTreeSum(leg1Address);
        }

        if (leg2Address != address(0)) {
            sum += getTreeSum(leg2Address);
        }

        return sum;
    }

    // Admin functions
    function setPercentages(
        uint256[] calldata _directSalesPercentage,
        uint256[] calldata _binaryPercentage,
        uint256[] calldata _salesToAchieveRank,
        uint256 _createNftFee,
        uint256 _minWeeklyTurnoverPerLeg,
        uint256 _globalCap,
        uint256 _subscriptionPercentage,
        uint256 _matchingBonus,
        uint256 _championBonus
    ) external onlyAdmin {
        directSalesPercentage = _directSalesPercentage;
        binaryPercentage = _binaryPercentage;
        salesToAchieveRank = _salesToAchieveRank;
        championBonus = _championBonus;
        createNftFee = _createNftFee;

        if (_minWeeklyTurnoverPerLeg != minWeeklyTurnoverPerLeg) {
            minWeeklyTurnoverPerLeg = _minWeeklyTurnoverPerLeg;
        }

        if (_globalCap != globalCap) {
            globalCap = _globalCap;
        }

        if (_subscriptionPercentage != subscriptionPercentage) {
            subscriptionPercentage = _subscriptionPercentage;
        }

        if (matchingBonus != _matchingBonus) {
            matchingBonus = _matchingBonus;
        }
    }

    function addToTreeOnlyAdmin(address rootAddress, address newUser)
        external
        onlyAdmin
    {
        address leftLegAddr = addressToLeg1Address[rootAddress];
        address rightLegAddr = addressToLeg2Address[rootAddress];

        if (leftLegAddr == address(0)) {
            addressToLeg1Address[rootAddress] = newUser;
        } else if (rightLegAddr == address(0) && leftLegAddr != newUser) {
            addressToLeg2Address[rootAddress] = newUser;
        } else {
            // 2 legs occupied
            bool isRightLegSelected = addressToIsRightLegSelected[rootAddress];
            if (isRightLegSelected) {
                addToTree(rightLegAddr, newUser);
            } else {
                addToTree(leftLegAddr, newUser);
            }
        }
    }

    function setWeeklyEarnings() public onlyAdmin {
        uint256 totalEarnings = getFoundersBonusAmount() +
            getChampionBonusAmount();
        uint256 capAmount = getCapAmount();
        uint256 divider = 1;
        uint256 champions = 0;
        uint256 founders = 0;

        for (uint256 i; i < addresses.length; i++) {
            address addr = addresses[i];
            uint256 earnings = getDirectCommissions(addr) +
                getIndirectCommissions(addr);

            if (hasMatchingBonus(addr)) {
                earnings += (matchingBonus * earnings) / 100;
            }

            if (hasChampionBonus(addr)) {
                champions += 1;
            }

            if (isFounder[addr]) {
                founders += 1;
            }

            totalEarnings += earnings;
        }

        if (totalEarnings > capAmount) {
            divider = totalEarnings / capAmount + 1;
        }

        for (uint256 i; i < addresses.length; i++) {
            address addr = addresses[i];

            setDirectCommissions(addr, divider);
            setIndirectCommissions(addr, divider);

            if (hasChampionBonus(addr)) {
                addressToEarnings[addr] +=
                    getChampionBonusAmount() /
                    (divider * champions);
            }

            if (isFounder[addr]) {
                addressToEarnings[addr] +=
                    getFoundersBonusAmount() /
                    (divider * founders);
            }
        }

        resetWeek();
    }

    function setDirectCommissions(address addr, uint256 divider)
        public
        onlyAdmin
    {
        uint256 commissions = getDirectCommissions(addr);

        addressToEarnings[addr] += commissions / divider;
    }

    function setIndirectCommissions(address addr, uint256 divider)
        public
        onlyAdmin
    {
        uint256[] memory weeklyLegsTurnover = getWeeklyLegsTurnover(addr);
        uint256 leftTurnover = weeklyLegsTurnover[0];
        uint256 rightTurnover = weeklyLegsTurnover[1];
        uint256 commissions = getIndirectCommissions(addr);

        if (commissions == 0) {
            addressToLeftTurnover[addr] = leftTurnover;
            addressToRightTurnover[addr] = rightTurnover;
        } else if (leftTurnover >= rightTurnover) {
            addressToLeftTurnover[addr] = rightTurnover - leftTurnover;
            addressToRightTurnover[addr] = 0;
        } else {
            addressToLeftTurnover[addr] = 0;
            addressToRightTurnover[addr] = leftTurnover - rightTurnover;
        }

        addressToEarnings[addr] += commissions / divider;
    }

    function stopSubscription(address addr, uint256 rankPenalty)
        external
        onlyAdmin
    {
        subscriberToTimestamp[addr] = 0;
        setPenalty(addr, rankPenalty);
    }

    function setMinParity(uint256[] calldata _minParity) public onlyAdmin {
        minParity = _minParity;
    }

    function setChampionBonusMinAmount(uint256 _championBonusMinAmount)
        public
        onlyAdmin
    {
        championBonusMinAmount = _championBonusMinAmount;
    }

    function resetWeek() public onlyAdmin {
        weekTurnover = 0;

        for (uint256 i; i < addresses.length; i++) {
            address addr = addresses[i];

            addressToMinRank[addr] = rankOf(addr);
            addressToWeeklyDirectCustomersVolume[addr] = 0;
        }
    }

    function renewSubscription(address addr, uint256 tokenId)
        external
        onlyAdmin
    {
        uint256 subsPrice = tokenIdToPrice[tokenId];
        uint256 volume = (subsPrice * subscriptionPercentage) / 100;
        address sponsor = addressToSponsor[addr];

        weekTurnover += volume;
        subscriberToTimestamp[addr] = block.timestamp;
        saveAddressIfNeeed(addr);
        distributeProfits(sponsor, volume);
        transferFromBUSD(addr, address(this), subsPrice);
    }

    function setLengthOfSubscription(uint256 _lengthOfSubscription)
        external
        onlyAdmin
    {
        lengthOfSubscription = _lengthOfSubscription;
    }

    function setPenalty(address addr, uint256 rankPenalty) public onlyAdmin {
        addressToPenalty[addr] = rankPenalty;
        saveAddressIfNeeed(addr);
    }

    function distributeProfitsonlyAdmin(address addr, uint256 amount)
        external
        onlyAdmin
    {
        saveAddressIfNeeed(addr);
        distributeProfits(addr, amount);
    }

    function setDirectCustomersVolume(address addr, uint256 amountInWei)
        external
        onlyAdmin
    {
        saveAddressIfNeeed(addr);
        addressToDirectCustomersVolume[addr] = amountInWei;
    }

    function setLegs(
        address rootAddress,
        address leg1Address,
        address leg2Address
    ) external onlyAdmin {
        require(
            rootAddress != leg1Address && leg1Address != leg2Address,
            "Root address, leg1 address and leg2 address must be different"
        );

        if (leg1Address != address(0)) {
            addressToLeg1Address[rootAddress] = leg1Address;
        }

        if (leg2Address != address(0)) {
            addressToLeg2Address[rootAddress] = leg2Address;
        }

        saveAddressIfNeeed(rootAddress);
        saveAddressIfNeeed(leg1Address);
        saveAddressIfNeeed(leg2Address);
    }

    function setWeeklyDirectCustomersVolume(address addr, uint256 amountInWei)
        external
        onlyAdmin
    {
        saveAddressIfNeeed(addr);
        addressToWeeklyDirectCustomersVolume[addr] = amountInWei;
    }

    function setAddressToMinRank(address addr, uint256 rank)
        external
        onlyAdmin
    {
        addressToMinRank[addr] = rank;
    }

    function setAddressToLeftTurnover(address addr, uint256 turnover)
        external
        onlyAdmin
    {
        addressToLeftTurnover[addr] = turnover;
    }

    function setAddressToRightTurnover(address addr, uint256 turnover)
        external
        onlyAdmin
    {
        addressToRightTurnover[addr] = turnover;
    }

    function setaddressToSponsor(address addr1, address addr2)
        external
        onlyAdmin
    {
        addressToSponsor[addr1] = addr2;
    }

    function setAddressToLeg1Address(address addr1, address addr2)
        external
        onlyAdmin
    {
        addressToLeg1Address[addr1] = addr2;
    }

    function setAddressToLeg2Address(address addr1, address addr2)
        external
        onlyAdmin
    {
        addressToLeg2Address[addr1] = addr2;
    }

    function setLockContract() external virtual onlyAdmin {
        isContractLocked = !isContractLocked;
    }

    function setExtraBonus(
        uint256[] calldata _extraBonusMinAmount,
        uint256[] calldata _extraBonusPerc
    ) external virtual onlyAdmin {
        extraBonusMinAmount = _extraBonusMinAmount;
        extraBonusPerc = _extraBonusPerc;
    }

    function setAdmin(address _admin) external virtual onlyAdmin {
        if (admin != _admin) {
            admin = _admin;
        }
    }

    function setDefaultReferralAccount(address _defaultReferralAccount)
        external
        virtual
        onlyAdmin
    {
        defaultReferralAccount = _defaultReferralAccount;
    }

    function setFounderBonusPercentage(uint256 _founderBonusPercentage)
        external
        virtual
        onlyAdmin
    {
        founderBonusPercentage = _founderBonusPercentage;
    }

    function setTokenURI(uint256 tokenId, string memory uri)
        public
        virtual
        onlyAdmin
    {
        require(!isContractLocked, "Contract is locked");
        _setTokenURI(tokenId, uri);
    }

    function burn(uint256 tokenId) public virtual onlyAdmin {
        require(!isContractLocked, "Contract is locked");
        _burn(tokenId);
    }

    function withdrawBNB() external payable onlyAdmin {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }

    function withdrawBUSD(uint256 busdAmountInWei) external payable onlyAdmin {
        if (busdAmountInWei > 0) {
            transferBUSD(busdAmountInWei);
        }
    }

    // Internal
    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    /**
     * Override isApprovedForAll to auto-approve MLM's proxy contract
     */
    function isApprovedForAll(address _owner, address _operator)
        public
        view
        override(ERC721)
        returns (bool isOperator)
    {
        // if MLM's ERC721 Proxy Address is detected, auto-return true
        if (_operator == address(this)) {
            return true;
        }

        // otherwise, use the default ERC721.isApprovedForAll()
        return ERC721.isApprovedForAll(_owner, _operator);
    }
}