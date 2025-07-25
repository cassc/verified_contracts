/**
 *Submitted for verification at Etherscan.io on 2020-10-28
*/

// File: @openzeppelin/contracts/GSN/Context.sol


pragma solidity ^0.6.0;

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

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol


pragma solidity ^0.6.0;

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

// File: contracts/Poll.sol


pragma solidity >=0.6.0 <0.7.0;


contract Poll is Ownable {
    WalletRegistry walletRegistry;
    Token token;

    // Designates when the poll is over
    uint256 public end;

    string question;

    struct Option {
        uint256 id;
        string text;
        uint256 votes; // Represented in weis
    }

    Option[] options;

    mapping(address => bool) private voted;

    constructor(
        WalletRegistry _walletRegistry,
        Token _token,
        string memory _question,
        uint256 _end
    ) public {
        walletRegistry = _walletRegistry;
        token = _token;
        question = _question;
        end = _end;
    }

    function addOption(uint256 optionId, string memory text) public onlyOwner {
        options.push(Option(optionId, text, 0));
    }

    function vote(address account, uint256 optionId) public returns (bool) {
        Controller controller = Controller(msg.sender);
        require(
            controller.votingPermissions(account),
            "This account cannot vote"
        );
        require(controller.balances(account) > 0, "No balance to vote");
        require(
            walletRegistry.exists(account),
            "Sender is not a registered account"
        );
        require(!voted[account], "Account already voted");
        require(end > block.timestamp, "Voting period is already over");

        for (uint256 index = 0; index < options.length; index++) {
            if (options[index].id == optionId) {
                options[index].votes += controller.balances(account);
                voted[account] = true;
                return true;
            }
        }

        revert("Not a valid option");
    }

    function optionText(uint256 index) public view returns (string memory) {
        return options[index].text;
    }

    function optionVotes(uint256 index) public view returns (uint256) {
        return options[index].votes;
    }
}

// File: contracts/WalletRegistry.sol


pragma solidity >=0.6.0 <0.7.0;


contract WalletRegistry is Ownable {
    mapping(address => bool) private wallets;

    function addWallet(address _wallet) public onlyOwner {
        wallets[_wallet] = true;
    }

    function exists(address _wallet) public view returns (bool) {
        return wallets[_wallet];
    }
}

// File: @openzeppelin/contracts/math/SafeMath.sol



pragma solidity ^0.6.0;

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
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: contracts/Controller.sol


pragma solidity >=0.6.0 <0.7.0;





contract Controller is Ownable {
    using SafeMath for uint256;

    WalletRegistry walletRegistry;
    Token token;

    // Token balances
    mapping(address => uint256) public balances;

    // Designates whether a user is able to vote
    mapping(address => bool) public votingPermissions;

    // Initial vested amounts
    mapping(address => uint256) public initialVestedAmounts;

    // New amounts transferred
    mapping(address => mapping(uint256 => uint256)) public newVestedAmounts;

    // Vesting transferred
    mapping(address => uint256) public vestingsTransferred;

    // Vesting period starts for each wallet
    mapping(address => uint256) public startVestings;

    // Vesting periods
    uint256 public firstVestingPeriodStart = 90;
    uint256 public secondVestingPeriodStart = 180;
    uint256 public thirdVestingPeriodStart = 270;
    uint256 public fourthVestingPeriodStart = 365;

    uint256 public firstVestingPeriodStartDays = 90 days;
    uint256 public secondVestingPeriodStartDays = 180 days;
    uint256 public thirdVestingPeriodStartDays = 270 days;
    uint256 public fourthVestingPeriodStartDays = 365 days;

    event EnableVoting();
    event ConfigureVesting(
        address account,
        uint256 startVesting,
        uint256 initialVestedAmount
    );
    event AddNewVestedAmount(uint256 amount);
    event Transfer(address to, uint256 amount);
    event Vote(address indexed account, address indexed poll, uint256 option);

    modifier onlyRegistered() {
        require(
            walletRegistry.exists(msg.sender),
            "Sender is not a registered account"
        );
        _;
    }

    modifier onlyToken() {
        require(msg.sender == address(token), "Sender is not ERC20 token BHF");
        _;
    }

    constructor(WalletRegistry _walletRegistry, Token _token) public {
        walletRegistry = _walletRegistry;
        token = _token;
    }

    function enableVoting(address account) public onlyOwner {
        require(votingPermissions[account] == false, "Voting already enabled");

        votingPermissions[account] = true;

        emit EnableVoting();
    }

    function configureVesting(
        address account,
        uint256 _initialVestedAmount,
        uint256 _startVesting
    ) public onlyOwner {
        require(
            initialVestedAmounts[account] == 0,
            "Vesting already configured"
        );

        startVestings[account] = _startVesting;
        initialVestedAmounts[account] = _initialVestedAmount;

        emit ConfigureVesting(account, _startVesting, _initialVestedAmount);
    }

    function addNewVestedAmount(address account, uint256 amount)
        public
        onlyOwner
    {
        require(initialVestedAmounts[account] != 0, "Vesting not configured");
        require(amount > 0, "Increase is 0");

        newVestedAmounts[account][nextVestingPeriod(
            account
        )] = newVestedAmounts[account][nextVestingPeriod(account)].add(amount);

        emit AddNewVestedAmount(amount);
    }

    function transfer(address account, uint256 amount) public onlyRegistered {
        require(
            availableToTransfer(msg.sender) >= amount,
            "Wallet: Amount is subject to vesting or no balance"
        );
        require(
            token.transfer(account, amount),
            "Wallet: Could not complete the transfer"
        );

        balances[msg.sender] = balances[msg.sender].sub(amount);
        manageTransferredAmount(amount);

        emit Transfer(account, amount);
    }

    function manageTransferredAmount(uint256 amount) internal {
        if (freeFromVesting(msg.sender) > vestingsTransferred[msg.sender]) {
            if (amount <= freeFromVesting(msg.sender)) {
                vestingsTransferred[msg.sender] = vestingsTransferred[msg
                    .sender]
                    .add(amount);
            } else {
                vestingsTransferred[msg.sender] = freeFromVesting(msg.sender);
            }
        }
    }

    function vote(Poll poll, uint256 option) public onlyRegistered {
        require(poll.vote(msg.sender, option), "Could not vote");

        emit Vote(msg.sender, address(poll), option);
    }

    function availableToTransfer(address account)
        public
        view
        returns (uint256)
    {
        return nonVestedAmount(account).add(transferrableVesting(account));
    }

    function transferrableVesting(address account)
        public
        view
        returns (uint256)
    {
        return freeFromVesting(account) - vestingsTransferred[account];
    }

    function freeFromVesting(address account) internal view returns (uint256) {
        /*
        Amount free from vesting calculed from the total vesting amount, it doen't take
        tranferred vesting into account.
        */
        uint256 _freeFromVesting = 0;
        uint256 _currentVestingPeriod = currentVestingPeriod(account);
        uint256 _totalVestedAmountAvailable = totalVestedAmountAvailable(
            account
        );

        if (_currentVestingPeriod == fourthVestingPeriodStart) {
            _freeFromVesting = _totalVestedAmountAvailable; // 100%
        } else if (_currentVestingPeriod == thirdVestingPeriodStart) {
            _freeFromVesting = (_totalVestedAmountAvailable.mul(300)).div(1000); // 30%
        } else if (_currentVestingPeriod == secondVestingPeriodStart) {
            _freeFromVesting = (_totalVestedAmountAvailable.mul(225)).div(1000); // 22.5%
        } else if (_currentVestingPeriod == firstVestingPeriodStart) {
            _freeFromVesting = (_totalVestedAmountAvailable.mul(150)).div(1000); // 15.0%
        } else {
            _freeFromVesting = (_totalVestedAmountAvailable.mul(75)).div(1000); // 7.5%
        }

        return _freeFromVesting;
    }

    function increaseBalance(address account, uint256 amount) public onlyToken {
        balances[account] = balances[account].add(amount);
    }

    function totalNewVestedAmounts(address account)
        internal
        view
        returns (uint256)
    {
        uint256 nextVestingPeriod = nextVestingPeriod(account);

        if (nextVestingPeriod == firstVestingPeriodStart) {
            return newVestedAmounts[account][firstVestingPeriodStart];
        } else if (nextVestingPeriod == secondVestingPeriodStart) {
            return
                newVestedAmounts[account][firstVestingPeriodStart].add(
                    newVestedAmounts[account][secondVestingPeriodStart]
                );
        } else if (nextVestingPeriod == thirdVestingPeriodStart) {
            return
                newVestedAmounts[account][firstVestingPeriodStart]
                    .add(newVestedAmounts[account][secondVestingPeriodStart])
                    .add(newVestedAmounts[account][thirdVestingPeriodStart]);
        } else {
            return
                newVestedAmounts[account][firstVestingPeriodStart]
                    .add(newVestedAmounts[account][secondVestingPeriodStart])
                    .add(newVestedAmounts[account][thirdVestingPeriodStart])
                    .add(newVestedAmounts[account][fourthVestingPeriodStart]);
        }
    }

    function totalVestedAmountAvailable(address account)
        internal
        view
        returns (uint256)
    {
        return totalNewVestedAmounts(account) + initialVestedAmounts[account];
    }

    function totalVestedAmount(address account)
        internal
        view
        returns (uint256)
    {
        return
            newVestedAmounts[account][firstVestingPeriodStart]
                .add(newVestedAmounts[account][secondVestingPeriodStart])
                .add(newVestedAmounts[account][thirdVestingPeriodStart])
                .add(newVestedAmounts[account][fourthVestingPeriodStart])
                .add(initialVestedAmounts[account]);
    }

    function currentVestingPeriod(address account)
        internal
        view
        returns (uint256)
    {
        uint256 currentTime = time();
        if (
            startVestings[account] <= currentTime &&
            currentTime <
            startVestings[account].add(firstVestingPeriodStartDays)
        ) {
            // Not stored since this is a dummy period in relation to new amounts in vesting
            return 0;
        } else if (
            startVestings[account].add(firstVestingPeriodStartDays) <=
            currentTime &&
            currentTime <
            startVestings[account].add(secondVestingPeriodStartDays)
        ) {
            return firstVestingPeriodStart;
        } else if (
            startVestings[account].add(secondVestingPeriodStartDays) <=
            currentTime &&
            currentTime <
            startVestings[account].add(thirdVestingPeriodStartDays)
        ) {
            return secondVestingPeriodStart;
        } else if (
            startVestings[account].add(thirdVestingPeriodStartDays) <=
            currentTime &&
            currentTime <
            startVestings[account].add(fourthVestingPeriodStartDays)
        ) {
            return thirdVestingPeriodStart;
        } else {
            return fourthVestingPeriodStart;
        }
    }

    function nextVestingPeriod(address account)
        internal
        view
        returns (uint256)
    {
        /*
        Returns the next vesting period, if last period is active keeps returning
        the last one
        */
        if (time() <= startVestings[account].add(firstVestingPeriodStartDays)) {
            return firstVestingPeriodStart;
        } else if (
            time() <= startVestings[account].add(secondVestingPeriodStartDays)
        ) {
            return secondVestingPeriodStart;
        } else if (
            time() <= startVestings[account].add(thirdVestingPeriodStartDays)
        ) {
            return thirdVestingPeriodStart;
        } else {
            return fourthVestingPeriodStart;
        }
    }

    function nonVestedAmount(address account) internal view returns (uint256) {
        /* 
            Returns the amount managed by the contract but not related to vesting
            in any meanings
        */
        uint256 remainingVesting = totalVestedAmount(account).sub(
            vestingsTransferred[account]
        );

        return balances[account].sub(remainingVesting);
    }

    function time() public virtual view returns (uint256) {
        return block.timestamp;
    }
}

// File: @openzeppelin/contracts/token/ERC20/IERC20.sol



pragma solidity ^0.6.0;

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

// File: @openzeppelin/contracts/utils/Address.sol



pragma solidity ^0.6.2;

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
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol



pragma solidity ^0.6.0;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 * For a generic mechanism see {ERC20MinterPauser}.
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
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    /**
     * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
     * a default value of 18.
     *
     * To select a different value for {decimals}, use {_setupDecimals}.
     *
     * All three of these values are immutable: they can only be set once during
     * construction.
     */
    constructor (string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;
        _decimals = 18;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5,05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
     * called.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view override returns (uint256) {
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
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
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
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
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
     * - the caller must have allowance for ``sender``'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
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
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
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
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
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
    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

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
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

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
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

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
    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Sets {decimals} to a value other than the default one of 18.
     *
     * WARNING: This function should only be called from the constructor. Most
     * applications that interact with token contracts will not expect
     * {decimals} to ever change, and may work incorrectly if it does.
     */
    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

// File: contracts/Token.sol


pragma solidity >=0.6.0 <0.7.0;




contract Token is ERC20 {
    Controller controller;

    address burnerAddress;

    constructor(uint256 _totalSupply, address _burnerAddress)
        public
        ERC20("Blue Hill", "BHF")
    {
        _mint(msg.sender, _totalSupply);
        burnerAddress = _burnerAddress;
        controller = Controller(address(0));
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        require(
            msg.sender != burnerAddress,
            "Cannot transfer from burner address"
        );
        _transfer(msg.sender, recipient, amount);

        return true;
    }

    // Method to deposit tokens in the controller
    function depositController(address account, uint256 amount) public {
        controller.increaseBalance(account, amount);
        transfer(address(controller), amount);
    }

    // Total supply removing burned tokens
    function totalAvailable() public view returns (uint256) {
        return super.totalSupply() - balanceOf(burnerAddress);
    }

    function setController(Controller _controller) public {
        require(
            address(controller) == address(0),
            "Controller address already set."
        );
        controller = _controller;
    }
}