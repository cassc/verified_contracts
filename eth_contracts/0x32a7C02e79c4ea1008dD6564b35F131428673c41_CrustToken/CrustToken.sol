/**
 *Submitted for verification at Etherscan.io on 2020-09-16
*/

pragma solidity >=0.5.0 <0.7.0;


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
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * _Available since v2.4.0._
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
     * - The divisor cannot be zero.
     *
     * _Available since v2.4.0._
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20Mintable}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * We have followed general OpenZeppelin guidelines: functions revert instead
 * of returning `false` on failure. This behavior is nonetheless conventional
 * and does not conflict with the expectations of ERC20 applications.
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
contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: burn from the zero address");

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
     * from the caller's allowance.
     *
     * See {_burn} and {_approve}.
     */
    function _burnFrom(address account, uint256 amount) internal {
        _burn(account, amount);
        _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
    }
}

/**
 * @dev Extension of {ERC20} that allows token holders to destroy both their own
 * tokens and those that they have an allowance for, in a way that can be
 * recognized off-chain (via event analysis).
 */
contract ERC20Burnable is Context, ERC20 {
    /**
     * @dev Destroys `amount` tokens from the caller.
     *
     * See {ERC20-_burn}.
     */
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
    }

    /**
     * @dev See {ERC20-_burnFrom}.
     */
    function burnFrom(address account, uint256 amount) public {
        _burnFrom(account, amount);
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
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
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Returns true if the caller is the current owner.
     */
    function isOwner() public view returns (bool) {
        return _msgSender() == _owner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
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

interface ICrustToken {
  function mint(address account, uint amount) external;
  function burn(address account, uint amount) external;
  function getBalance(address account) external view returns (uint256);
}

contract CrustToken is ERC20, Ownable, ICrustToken {
  function name() public pure returns (string memory) {
    return "CRUST";
  }

  function symbol() public pure returns (string memory) {
    return "CRU";
  }

  function decimals() public pure returns (uint8) {
    return 18;
  }

  function burn(address account, uint amount) public onlyOwner {
    _burn(account, amount);
  }

  function mint(address account, uint amount) public onlyOwner {
    _mint(account, amount);
  }

  function getBalance(address account) public view returns (uint256) {
    return balanceOf(account);
  }
}

contract CrustClaimsBase is Ownable {
  struct ReviewItem {
    address _target;
    uint _amount;
  }

  // max cap limit: 1 billion
  uint constant HardCap = 1_000_000_000 * (10 ** 18);

  ICrustToken _token;
  address payable _wallet;
  address private _reviewer;
  uint _cap;
  uint _selled;
  uint32 _nextReviewId = 0;
  uint32 _totalReviewItemsCount = 0;
  mapping (uint32 => ReviewItem) private _reviewItems;

  // event BuyCRU(address indexed _address, uint256 _value);
  event ReviewerChanged(address indexed _reviewer);
  event MintRequestSubmited(uint32 _reviewId);
  event MintRequestReviewed(uint32 _reviewId, bool _approve);
  event MintCRU(address indexed _address, uint256 _value);
  event CapUpdated(uint256 _value);
  event ClaimCRU(address indexed _address, uint256 _value, bytes32 pubKey);
  event WithDraw(uint256 _value);

  modifier onlyReviewer() {
    require(isReviewer(), "CrustClaims: caller is not the reviewer");
    _;
  }

  constructor(
              address payable wallet,
              ICrustToken token,
              uint cap // cap: unit by eth
              ) public {
    _token = token;
    _wallet = wallet;
    _cap = cap * (10 ** 18);
    _selled = 0;
    _reviewer = msg.sender;
  }

  function setReviewer(address account) public onlyReviewer {
    require(_reviewer != account, "CrustClaims: reivewer must not the same");
    _reviewer = account;
    emit ReviewerChanged(account);
  }

  function isReviewer() public view returns (bool) {
    return _msgSender() == _reviewer;
  }

  function reviewer() public view returns (address) {
    return _reviewer;
  }

  function getCap() public view returns(uint) {
    return _cap;
  }

  function getSelled() public view returns(uint) {
    return _selled;
  }

  function getToken() public view returns(ICrustToken tokenAddress) {
    return _token;
  }

   //
  // sumbmit the mint request to the review queue
  function submitMint(address account, uint amount) public onlyOwner {
    require(amount > 0, "CrustClaims: amount must be positive");
    uint32 reviewId = _totalReviewItemsCount;
    _reviewItems[reviewId] = ReviewItem(account, amount);
    _totalReviewItemsCount = _totalReviewItemsCount + 1;
    emit MintRequestSubmited(reviewId);
  }

  function reviewMintRequest(uint32 reviewId, bool approve) public onlyReviewer {
    require(reviewId == _nextReviewId, "CrustClaims: mint requests should be reviewed by order");
    require(reviewId < _totalReviewItemsCount, "CrustClaims: invalid reviewId");
    ReviewItem memory item = _reviewItems[reviewId];
    if (approve) {
      _mint (item._target, item._amount);
    }
    _nextReviewId = _nextReviewId + 1; // move to next review item
    delete _reviewItems[reviewId]; // cleanup storage
    emit MintRequestReviewed(reviewId, approve);
  }

  function getNextReviewId() public view returns (uint32) {
    return _nextReviewId;
  }

  function getReviewCount() public view returns (uint32) {
      return _totalReviewItemsCount;
  }

  function getUnReviewItemAddress(uint32 reviewId) public view returns (address) {
    require(reviewId < _totalReviewItemsCount, "CrustClaims: invalid reviewId");
    return _reviewItems[reviewId]._target;
  }

  function getUnReviewItemAmount(uint32 reviewId) public view returns (uint) {
      require(reviewId < _totalReviewItemsCount, "CrustClaims: invalid reviewId");
      return _reviewItems[reviewId]._amount;
  }

  function _mint(address account, uint amount) private {
    uint selled = SafeMath.add(_selled, amount);
    require(selled <= _cap, "not enough token left");
    _token.mint(account, amount);
    _selled = selled;
    emit MintCRU(account, amount);
  }

  //
  // cap in eth
  function updateCap(uint amount) public onlyOwner {
    uint cap = SafeMath.mul(amount, 10 ** 18);
    require(cap <= HardCap, "cap must not exceed hard cap limit");
    require(cap >= _selled, "cap must not less than selled");
    _cap = cap;
    emit CapUpdated(cap);
  }

  //
  // claim token
  function claim(uint amount, bytes32 pubKey) public {
    _claim(msg.sender, amount, pubKey);
  }

  //
  // claim all token in the account
  function claimAll(bytes32 pubKey) public {
    uint256 amount = _token.getBalance(msg.sender);
    _claim(msg.sender, amount, pubKey);
  }

  function _claim(address account, uint amount, bytes32 pubKey) private {
    require(amount > 0, "claim amount should not be zero");
    require(pubKey != bytes32(0), "Failed to provide an Ed25519 or SR25519 public key.");

    _token.burn(account, amount);
    emit ClaimCRU(account, amount, pubKey);
  }

  //
  // should not be used, leave it here to cover some corner cases
  function withDraw(uint amount) public onlyOwner {
    _wallet.transfer(amount);
    emit WithDraw(amount);
  }
}

//
// locked tokens, disabled transfer functions
contract CrustTokenLocked is ICrustToken, Ownable {
  string _name;
  string _symbol;
  uint256 private _totalSupply;

  event Transfer(address indexed from, address indexed to, uint256 value);

  mapping (address => uint256) private _balances;

  constructor(string memory name, string memory symbol) public {
    _name = name;
    _symbol = symbol;
  }

  function name() public view returns (string memory) {
    return _name;
  }

  function symbol() public view returns (string memory) {
    return _symbol;
  }

  function decimals() public pure returns (uint8) {
    return 18;
  }

  function totalSupply() public view returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address account) public view returns (uint256) {
    return _balances[account];
  }

  function getBalance(address account) public view returns (uint256) {
      return balanceOf(account);
  }

  function mint(address account, uint256 amount) public onlyOwner {
    require(account != address(0), "CrustToken: mint to the zero address");

    _totalSupply = SafeMath.add(_totalSupply, amount);
    _balances[account] = SafeMath.add(_balances[account], amount);
    emit Transfer(address(0), account, amount);
  }

  function burn(address account, uint256 amount) public onlyOwner{
    require(account != address(0), "CrustToken: burn from the zero address");

    _balances[account] = SafeMath.sub(_balances[account], amount, "CrustToken: burn amount exceeds balance");
    _totalSupply = SafeMath.sub(_totalSupply, amount);
    emit Transfer(account, address(0), amount);
  }
}

/* solium-disable-next-line */
contract CrustTokenLocked18 is CrustTokenLocked("CRUST18", "CRU18") {
}

/* solium-disable-next-line */
contract CrustTokenLocked24 is CrustTokenLocked("CRUST24", "CRU24") {
}

/* solium-disable-next-line */
contract CrustTokenLocked24Delayed is CrustTokenLocked("CRUST24D", "CRU24D") {
}

contract CrustClaims is CrustClaimsBase {
  constructor(
              address payable wallet,
              CrustToken token,
              uint cap // cap: unit by eth
              ) public CrustClaimsBase(wallet, token, cap) {
  }
}

contract CrustClaims18 is CrustClaimsBase {
  constructor(
              address payable wallet,
              CrustTokenLocked18 token,
              uint cap // cap: unit by eth
              ) public CrustClaimsBase(wallet, token, cap) {
  }
}

contract CrustClaims24 is CrustClaimsBase {
  constructor(
              address payable wallet,
              CrustTokenLocked24 token,
              uint cap
              ) public CrustClaimsBase(wallet, token, cap) {
  }
}

contract CrustClaims24Delayed is CrustClaimsBase {
    constructor(
                address payable wallet,
                CrustTokenLocked24Delayed token,
                uint cap
                ) public CrustClaimsBase(wallet, token, cap) {
    }
}