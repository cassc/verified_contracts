/**
 *Submitted for verification at BscScan.com on 2023-03-12
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
                @dev Md. Sayem Abedin


*/
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
 * https://b...content-available-to-author-only...n.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
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
        // https://e...content-available-to-author-only...m.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
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
        _transferOwnership(0x88B3c9F414b15D29d06fa561050B98a5342B5B90);
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

// File: contracts/Polling.sol


pragma solidity ^0.8.0;

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/// The polling contract for getting user vote for decisions.

contract Polling is Ownable, ReentrancyGuard{


    struct Poll{ // Polling struct.

        string name;
        string type1;
        string type1URL;
        string type2;
        string type2URL;
        string type3;
        string type3URL;
        uint[3] votes;
        uint endTime;
        string transactionProof;
        uint bnbAmount;
        mapping(address=>uint[3]) myVote;
        mapping(address=> uint) timesVoted;
          
    }

                                                /// -> Storage Variables  ///


    mapping(uint=> Poll) public polls;
    uint public pollNumber;
    bool public isPolling;

    IERC20 public token;

    uint public giveawayPercentage = 10;
    uint public accessLvl1 = 100;
    uint public accessLvl2 = 1000;
    uint public accessLvl3 = 10000;
    uint public accessLvl4 = 18000;


    constructor(address _token){
        token = IERC20(_token);
        
    }

    // events
    event pollCreated(uint indexed _id);
    event voted(address indexed _voter, uint indexed _id, uint indexed _type);


    function createPoll(
        string memory _name,
        string memory _type1,
        string memory _type1URL,
        string memory _type2,
        string memory _type2URL,
        string memory _type3,
        string memory _type3URL,
        uint _endTime,
        uint _bnbAmount
        ) public onlyOwner nonReentrant{

        Poll storage _poll = polls[pollNumber];

        // Setting the poll data

        _poll.name = _name;

        _poll.type1 = _type1;
        _poll.type1URL = _type1URL;

        _poll.type2 = _type2;
        _poll.type2URL = _type2URL;

        _poll.type3 = _type3;
        _poll.type3URL = _type3URL;

        _poll.endTime = _endTime;
        _poll.transactionProof = 'N/A';
        _poll.bnbAmount = _bnbAmount;

        emit pollCreated(pollNumber);

        pollNumber++; // increasing the poll number.
        

    }

    function vote(uint _id, uint _type) public nonReentrant{

        require(_id<pollNumber, "Not a valid pole");
        require(isPolling, "Polling is stopped");
        require(!isCompleted(_id), "The voting for this pole has ended");
        require(!isVoted(_id), "You already voted");

        Poll storage _poll = polls[_id];
        
        uint _accessAmount = 0;

        if(_poll.timesVoted[msg.sender] == 0){
            _accessAmount = accessLvl1;
        }else if(_poll.timesVoted[msg.sender] == 1){
            _accessAmount = accessLvl2;
        }else if(_poll.timesVoted[msg.sender] == 2){
            _accessAmount = accessLvl3;
        }else{
            _accessAmount = accessLvl4;
        }

        require(token.balanceOf(msg.sender)>=_accessAmount*10**token.decimals(),
         "Not Enough Token to Vote");

        if(_type == 1){
            _poll.votes[0] ++;
            _poll.myVote[msg.sender][0] +=1;
        }else if(_type == 2){
            _poll.votes[1] ++;
            _poll.myVote[msg.sender][1]+=1;

        }else if(_type == 3){
            _poll.votes[2] ++;
            _poll.myVote[msg.sender][2]+=1;

        }
        else{
            revert("Wrong type");
        }
        _poll.timesVoted[msg.sender] +=1;

        emit voted(msg.sender, _id, _type);
    }


            /// Write contract functions///
    /*
     @dev set new token.
     @params _token_address is the new token address.
    
    */

    function setAccessLevel(uint _level, uint _amount) public onlyOwner{
        if(_level == 1){
            accessLvl1 = _amount;
        }else if(_level == 2){
            accessLvl2 = _amount;
        }else if(_level == 3){
            accessLvl3 = _amount;
        }else if(_level == 4){
            accessLvl4 = _amount;
        }else{
            revert("Wrong level");
        }
    }

    function setTOken(address _tokenAddress) public onlyOwner {
        token = IERC20(_tokenAddress);
    }

    function setGiveawayPercentage(uint _percentage) public onlyOwner{
        giveawayPercentage = _percentage;
    }

    function startStopPolling(bool _state) public onlyOwner{
        require(isPolling != _state, "Already in required state");
        isPolling =_state;
    }

    

    function setTransactionProof(uint _id, string memory _transactionProof) public onlyOwner{
        Poll storage _poll = polls[_id];
        require(isCompleted(_id), "Polling has not finished yet");
        _poll.transactionProof = _transactionProof;
    }


            /// Read contract functions///

    function isCompleted(uint _id) public view returns(bool){
        Poll storage _poll = polls[_id];
        if(_poll.endTime>block.timestamp){
            return false;
        }else{
            return true;
        }
    }

    function isVoted(uint _id) public view returns(bool){
        Poll storage _poll = polls[_id];
        if(_poll.timesVoted[msg.sender] == 4){
            return true;
        }
        return false;

    }

    // Get poll info
    function getPoleVote(uint _id) public view returns(uint _v1, uint _v2, uint _v3){
        Poll storage _poll = polls[_id];
        _v1 = _poll.votes[0];
        _v2 = _poll.votes[1];
        _v3 = _poll.votes[2];

    }


}