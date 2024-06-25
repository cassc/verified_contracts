/**
 *Submitted for verification at BscScan.com on 2022-12-15
*/

// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.7;

interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
   */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the token decimals.
   */
    function decimals() external view returns (uint8);

    /**
     * @dev Returns the token symbol.
   */
    function symbol() external view returns (string memory);

    /**
    * @dev Returns the token name.
  */
    function name() external view returns (string memory);

    /**
     * @dev Returns the bep token owner.
   */
    function getOwner() external view returns (address);

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
    function allowance(address _owner, address spender) external view returns (uint256);

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
    constructor() {}

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
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
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
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

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract Claiming is Ownable {
    using SafeMath for uint256;

    /**
     * Structure of an object to pass for allowance list
     */
    struct allowedUser {
        address wallet;
        uint256 amount;
    }

    struct userTokens {
        uint256 amount;
        uint256 initialAmount;
        uint unfreezeTime;
    }

    struct allUserTokens {
        uint256 amount;
        uint unfreezeTime;
        address addr;
    }

    IBEP20 public token;
    uint256 internal totalUnclaimed;
    uint freezePeriod;
    uint unfreezePercent;
    uint unfreezeInterval;
    address[] addresses;

    mapping(address => userTokens) allowanceAmounts;

    constructor(IBEP20 _token, uint _freezePeriod, uint _unfreezePercent, uint _unfreezeInterval) {
        require(_freezePeriod > 0, "freezePeriod must be grate than zero");
        token = _token;
        freezePeriod = _freezePeriod;
        unfreezePercent = _unfreezePercent;
        unfreezeInterval = _unfreezeInterval;
    }

    event UnsuccessfulTransfer(address recipient);



    /**
     * Ensures that contract has enough tokens for the transaction.
     */
    modifier enoughContractAmount(uint256 amount) {
        require(
            token.balanceOf(address(this)) >= amount,
            "Owned token amount is too small."
        );
        _;
    }

    /**
     * Ensures that only people from the allowance list can claim tokens.
     */
    modifier userHasClaimableTokens() {
        require(
            allowanceAmounts[msg.sender].amount > 0 && allowanceAmounts[msg.sender].unfreezeTime != 0 && allowanceAmounts[msg.sender].unfreezeTime < block.timestamp,
            "There is no tokens for the user to claim or the user is not allowed to do so."
        );
        _;
    }


    modifier hasContractTokens() {
        require(
            token.balanceOf(address(this)) > 0,
            "There is no tokens for the user to claim or the user is not allowed to do so."
        );
        _;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a <= b ? a : b;
    }

    /** @dev Transfers the spacified number of tokens to the user requesting
     *
     * Makes the allowance equal to zero
     * Transfers all allowed tokens from contract to the message sender
     * In case of failure restores the previous allowance amount
     *
     * Requirements:
     *
     * - message sender cannot be address(0) and has to be in AllowanceList
     */
    function claimRemainingTokens() public userHasClaimableTokens {
        require(msg.sender != address(0), "Sender is address zero");

        uint unfreezeTime = allowanceAmounts[msg.sender].unfreezeTime;
        uint256 initialAmount = allowanceAmounts[msg.sender].initialAmount;
        uint256 currentAmount = allowanceAmounts[msg.sender].amount;
        uint256 parts = min((block.timestamp - unfreezeTime + unfreezeInterval) / unfreezeInterval, 100 / unfreezePercent);
        uint256 availablePercents = parts * unfreezePercent;
        uint256 amount = initialAmount * availablePercents / 100 - (initialAmount - currentAmount);

        require(amount > 0, "No tokens to unfreeze");

        require(token.balanceOf(address(this)) >= amount, "Insufficient amount of tokens in contract");
        require(currentAmount >= amount, "Insufficient amount of tokens in contract");

        uint256 oldAmount = allowanceAmounts[msg.sender].amount;
        allowanceAmounts[msg.sender].amount = allowanceAmounts[msg.sender].amount.sub(amount);
        token.approve(address(this), amount);
        if (!token.transferFrom(address(this), msg.sender, amount)) {
            allowanceAmounts[msg.sender].amount = oldAmount;
            emit UnsuccessfulTransfer(msg.sender);
        } else {
            totalUnclaimed = totalUnclaimed.sub(amount);
        }
    }

    /** @dev Adds the provided address to Allowance list with allowed provided amount of tokens
     * Available only for the owner of contract
     */
    function addSingleUserToList(address addAddress, uint256 amount) public onlyOwner
    {
        require(addAddress != address(0), "Address must be set");
        require(amount > 0, "Amount must be grate than zero");
        require(token.allowance(msg.sender, address(this)) - amount > 0, "Allow enough tokens before sending");


        if (!token.transferFrom(msg.sender, address(this), amount)) {
            emit UnsuccessfulTransfer(msg.sender);
        } else {
            if (allowanceAmounts[addAddress].unfreezeTime == 0) {
                addresses.push(addAddress);
            }
            allowanceAmounts[addAddress].amount = allowanceAmounts[addAddress].amount.add(amount);
            allowanceAmounts[addAddress].initialAmount = allowanceAmounts[addAddress].amount;
            allowanceAmounts[addAddress].unfreezeTime = block.timestamp + freezePeriod; //60 * 60 * 24 * 365;
            totalUnclaimed = totalUnclaimed.add(amount);
        }
    }


    function immediatelyUnfreeze(address user, uint256 amount) public onlyOwner{
        require(allowanceAmounts[user].amount >= amount, "Insufficient amount of tokens in user");
        require(token.balanceOf(address(this)) >= amount,"Insufficient amount of tokens in contract");

        uint256 old = allowanceAmounts[user].amount;
        allowanceAmounts[user].amount = allowanceAmounts[user].amount.sub(amount);
        token.approve(address(this), amount);
        if (!token.transferFrom(address(this), user, amount)) {
            allowanceAmounts[user].amount = old;
            emit UnsuccessfulTransfer(msg.sender);
        } else {
            allowanceAmounts[user].initialAmount = allowanceAmounts[user].initialAmount.sub(amount);
            totalUnclaimed = totalUnclaimed.sub(amount);
        }
    }


    function allowedTokens() public view onlyOwner returns (uint256) {
        return token.allowance(msg.sender, address(this));
    }



    /** @dev Shows the amount of total unclaimed tokens in the contract
     */
    function totalUnclaimedTokens() public view onlyOwner returns (uint256) {
        return totalUnclaimed;
    }

    /** @dev Shows the residual tokens of the user sending request
     */
    function myStatus() public view returns (userTokens memory) {
        return allowanceAmounts[msg.sender];
    }

    function getFreezePeriod() public view returns (uint) {
        return freezePeriod;
    }

    function getUnfreezePercent() public view returns (uint) {
        return unfreezePercent;
    }

    function getUnfreezeInterval() public view returns (uint) {
        return unfreezeInterval;
    }

    /** @dev Shows the owner residual tokens of any address (owner only function)
     */
    function userStatus(address user)
    public
    view
    onlyOwner
    returns (userTokens memory)
    {
        return allowanceAmounts[user];
    }

    function findAll() public view onlyOwner returns(allUserTokens[] memory) {
        allUserTokens[] memory ret = new allUserTokens[](addresses.length);
        for (uint i = 0; i < addresses.length; i++) {
            userTokens memory ut = allowanceAmounts[addresses[i]];
            ret[i] = allUserTokens(ut.amount, ut.unfreezeTime, addresses[i]);
        }
        return ret;
    }

    /** @dev Shows the amount of total tokens in the contract
     */
    function tokenBalance() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

}