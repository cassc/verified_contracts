/**
 *Submitted for verification at BscScan.com on 2022-12-19
*/

// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/utils/math/SafeMath.sol

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
            if  (c < a) return (false, 0);
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
            if  (b > a) return (false, 0);
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
            // benefit is lost if  'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if  (a == 0) return (true, 0);
            uint256 c = a * b;
            if  (c / a != b) return (false, 0);
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
            if  (b == 0) return (false, 0);
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
            if  (b == 0) return (false, 0);
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

// OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specif ic functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modif ier
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
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if  called by any account other than the owner.
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

// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)

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
 * these events, as it isn't required by the specif ication.
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
     * The default value of {decimals} is 18. To select a dif ferent value for
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
     * For example, if  `decimals` equals `2`, a balance of `505` tokens should
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
     * NOTE: if  `amount` is the maximum `uint256`, the allowance is not updated on
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
     * NOTE: Does not update the allowance if  the current allowance
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
     * @dev Moves `amount` of tokens from `sender` to `recipient`.
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
     * Revert if  not enough allowance is available.
     *
     * Might emit an {Approval} event.
     */
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if  (currentAllowance != type(uint256).max) {
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

// File: ninja-usdt.sol

pragma solidity ^0.8.4;

contract BotTrader is Ownable {

	using SafeMath for uint256;
	
	IERC20 public token = IERC20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);

	uint256 private EGGS_TO_HATCH_1MINERS = 1080000;
	uint256 private PSN = 10000;
	uint256 private PSNH = 5000;
	uint256 private devFeeVal = 6;
	uint private withdrawnFee = 6;
	bool private initialized = false;

	address payable public devAddress1; // s
    address payable public devAddress2; // o
    address payable public devAddress3; // a
    address payable public devAddress4; // k

    address payable public markAddress; // f
    
	uint256 public marketEggs;

	struct User {
		uint256 invest;
		uint256 withdraw;
		uint256 hatcheryMiners; // Total balance (invest + refferrals)
		uint256 claimedEggs;
		uint256 lastHatch;
		uint checkpoint;
		address referrals;
        uint256 botLevel;
        address[] yourReferrals;
        uint256 refEarnings;
	}

	mapping (address => User) public users;

	uint public totalInvested;
	uint256 constant internal TIME_STEP = 1 days;

	constructor() {
		devAddress1 = payable(address(0x9c9f7C2c185AE2e076faeA8ee821A0f3fafc2950)); // s
        devAddress2 = payable(address(0xd35762a92cb3A83664FbC87bEFe7930a0a9b1A3C)); // o
        devAddress3 = payable(address(0xF8Aaf52fb65137428bb02ed71Fa9ceAf572828D7)); // a
        devAddress4 = payable(address(0x8667d16463F440b7eC170B1eCA4DCe7FF7C05fB0)); // k

		markAddress = payable(address(0x01e2fe78F6507619a6904C0Ef36F3959c3Fca7fA)); // f


	}

	modifier initializer() {
		require(initialized, "initialized is false");
		_;
	}

     modifier checkOwner() {
        require(
            msg.sender == devAddress1 || msg.sender == devAddress2 || msg.sender == devAddress3 || msg.sender == devAddress4 ||
                msg.sender == owner(),
            "try again later"
        );
        _;
    }

    modifier setBotLevelDefault() {
        User storage user = users[msg.sender];
        if (user.botLevel == 0) user.botLevel += 1;
        _;
    }

	modifier checkUser_() {
		require(checkUser(), "try again later");
		_;
	}

	function checkUser() public view returns (bool) {
		uint256 check = block.timestamp.sub(users[msg.sender].checkpoint);
		if (check > TIME_STEP) {
			return true;
		}
		return false;
	}

    function buyEggs(uint _amount, address ref) external initializer setBotLevelDefault {

        require(_amount > 0, "MIN 5 BUSD");
        
		token.transferFrom(msg.sender, address(this), _amount);

		User storage user = users[msg.sender];
 
		uint256 eggsBought = calculateEggBuy(_amount,SafeMath.sub(getBalance(),_amount));
		eggsBought = SafeMath.sub(eggsBought, SafeMath.div(devFee(eggsBought), 100));
		uint256 fee = devFee(_amount);
		payFees(fee);

		if (user.invest == 0) {
			user.checkpoint = block.timestamp;
		}

		user.invest += _amount;
		user.claimedEggs = SafeMath.add(user.claimedEggs, eggsBought);

		hatchEggs(ref);
		totalInvested += _amount;
	}

    function sellEggs() external initializer checkUser_ {

		User storage user = users[msg.sender];

		uint256 hasEggs = getMyEggs(msg.sender);
		uint256 eggValue = calculateEggSell(hasEggs);
		uint256 fee = withdrawFee(eggValue);
		user.claimedEggs = 0;
		user.lastHatch = block.timestamp;
		user.checkpoint = block.timestamp;
		marketEggs = SafeMath.add(marketEggs,hasEggs);
		payFees(fee);
		user.withdraw += eggValue;

        if (user.botLevel == 1) {
            transferHandler(msg.sender, SafeMath.div(SafeMath.mul(SafeMath.sub(eggValue, SafeMath.div(devFee(eggValue), 100)), 10), 100));
        } else if (user.botLevel == 2) {
            transferHandler(msg.sender, SafeMath.div(SafeMath.mul(SafeMath.sub(eggValue, SafeMath.div(devFee(eggValue), 100)), 20), 100));
        } else if (user.botLevel >= 3) {
            transferHandler(msg.sender, SafeMath.div(SafeMath.mul(SafeMath.sub(eggValue, SafeMath.div(devFee(eggValue), 100)), 30), 100));
        }

	}

    function hatchEggs(address ref) public initializer payable {		
		
		if (ref == msg.sender) {
			ref = address(0);
		}

		User storage user = users[msg.sender];

		if (user.referrals == address(0) && user.referrals != msg.sender) {
			user.referrals = ref;
            users[ref].yourReferrals.push(msg.sender);
		}

		uint256 eggsUsed = getMyEggs(msg.sender);
		uint256 newMiners = SafeMath.div(eggsUsed,EGGS_TO_HATCH_1MINERS);
		user.hatcheryMiners = SafeMath.add(user.hatcheryMiners,newMiners);
		user.claimedEggs = 0;
		user.lastHatch = block.timestamp;
		user.checkpoint = block.timestamp;

        transferHandler(ref, SafeMath.div(SafeMath.mul(msg.value, 14), 100));

        users[ref].refEarnings += SafeMath.div(SafeMath.mul(msg.value, 14), 100);

	}

    function buyBot(uint256 amount) external payable {

        User storage user = users[msg.sender];
        
        require(user.botLevel >= 3, "You already have the max level (Level 3)");

        if (user.botLevel == 1) {
            require(amount >= 10 ether, "Price for Level 2 is $10");
            token.transferFrom(msg.sender, address(this), amount);
            user.botLevel = user.botLevel + 1;

        } else if (user.botLevel == 2) {
            require(amount >= 20 ether, "Price for Level 3 is $20");
            token.transferFrom(msg.sender, address(this), amount);
            user.botLevel = user.botLevel + 1;

        }
         
    }

    function payFees(uint _amount) internal {
		transferHandler(devAddress1, _amount.div(6));
        transferHandler(devAddress2, _amount.div(6));
        transferHandler(devAddress3, _amount.div(6));
        transferHandler(devAddress4, _amount.div(6));

		transferHandler(markAddress, _amount.div(3));
	}

	function calculateEggSell(uint256 eggs) public view returns(uint256) {
		uint _cal = calculateTrade(eggs,marketEggs,getBalance());
		_cal += _cal.mul(5).div(100);
		return _cal;
	}

	function beanRewards(address adr) public view returns(uint256) {
		uint256 hasEggs = getMyEggs(adr);
		uint256 eggValue = calculateEggSell(hasEggs);
		return eggValue;
	}

	function calculateTrade(uint256 rt,uint256 rs, uint256 bs) private view returns(uint256) {
        
		uint a =PSN.mul(bs);
		uint b =PSNH;

		uint c =PSN.mul(rs);
		uint d =PSNH.mul(rt);

		uint h =c.add(d).div(rt);
		
		// SafeMath.div(
		// 	SafeMath.add(
		// 		SafeMath.mul(PSN,rs)
		// 		,SafeMath.mul(PSNH,rt)),rt);

		// return SafeMath.div(
		// 	SafeMath.mul(PSN,bs)
		// 	,SafeMath.add(PSNH,
		// 	SafeMath.div(
		// 	SafeMath.add(
		// 		SafeMath.mul(PSN,rs)
		// 		,SafeMath.mul(PSNH,rt)),rt)));

		return a.div(b.add(h));
	}
	
	function calculateEggBuy(uint256 eth,uint256 contractBalance) public view returns(uint256) {
		return calculateTrade(eth,contractBalance,marketEggs);
	}
	
	function calculateEggBuySimple(uint256 eth) public view returns(uint256) {
		return calculateEggBuy(eth,getBalance());
	}
	
	function devFee(uint256 _amount) private view returns(uint256) {
		return SafeMath.div(SafeMath.mul(_amount,devFeeVal),100);
	}

	function withdrawFee(uint256 _amount) private view returns(uint256) {
		return SafeMath.div(SafeMath.mul(_amount,withdrawnFee),100);
	}
	
	function seedMarket() public onlyOwner {
		require(marketEggs == 0);
		initialized = true;
		marketEggs = 108000000000;
	}
	
	function getBalance() public view returns(uint256) {
		return 	token.balanceOf(address(this));
	}
	
	function getMyMiners(address adr) public view returns(uint256) {
		User memory user =users[adr];
		return user.hatcheryMiners;
	}
	
	function getMyEggs(address adr) public view returns(uint256) {
		User memory user =users[adr];
		return SafeMath.add(user.claimedEggs,getEggsSinceLastHatch(adr));
	}
	
	function getEggsSinceLastHatch(address adr) public view returns(uint256) {
		User memory user =users[adr];
		uint256 secondsPassed=min(EGGS_TO_HATCH_1MINERS,SafeMath.sub(block.timestamp,user.lastHatch));
		return SafeMath.mul(secondsPassed,user.hatcheryMiners);
	}
	
	function min(uint256 a, uint256 b) private pure returns (uint256) {
		return a < b ? a : b;
	}

	function getSellEggs(address user_) public view returns(uint eggValue) {
		uint256 hasEggs = getMyEggs(user_);
		eggValue = calculateEggSell(hasEggs);
	}

	function getPublicData() external view returns(uint _totalInvest, uint _balance) {
		_totalInvest = totalInvested;
		_balance = getBalance();
	}

	function userData(address user_) external view returns (
        uint256 hatcheryMiners_,
        uint256 claimedEggs_,
        uint256 lastHatch_,
        uint256 sellEggs_,
        uint256 eggsMiners_,
        address referrals_,
        uint256 checkpoint,
        uint256 _botLevel,
        address[] memory _yourReferrals) {

        User memory user =users[user_];
        hatcheryMiners_=getMyMiners(user_);
        claimedEggs_=getMyEggs(user_);
        lastHatch_=user.lastHatch;
        referrals_=user.referrals;
        sellEggs_=getSellEggs(user_);
        eggsMiners_=getEggsSinceLastHatch(user_);
        checkpoint=user.checkpoint;
        _botLevel= user.botLevel;
        _yourReferrals = user.yourReferrals;
	}

	function transferHandler(address _to, uint _amount) internal {
		token.transferFrom( address(this), _to, _amount);  // transferTo(to, amount)
	}

	function getDAte() public view returns(uint256) {
		return block.timestamp;
	}

    function getMyBotLevel(address _user) public view returns(uint256) {
		User memory user = users[_user];
		return user.botLevel;
	}

    function setBotLevel(address _user, uint256 _level) public onlyOwner {
        User storage user = users[_user];
        user.botLevel = _level;
    }

}