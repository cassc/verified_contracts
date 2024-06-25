/**
 *Submitted for verification at BscScan.com on 2022-12-05
*/

//SPDX-License-Identifier: MIT
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

// File: contracts/fomocup/WorldCupOracle.sol



pragma solidity >=0.7.0 <0.9.0;



contract WorldCupOracle is Ownable{

    enum Country {
        NOTFINISH,
        NETHERLANDS,
        SENEGAL,
        ENGLAND,
        USA,
        ARGENTINA,
        POLAND,
        FRANCE,
        AUSTRALIA,
        JAPAN,
        SPAIN,
        MOROCCO,
        CROATIA,
        BRAZIL,
        SWITZERLAND,
        PORTUGAL,
        KOREA,
        BELGIUM,
        CAMAROON,
        CANADA,
        COSTARICA,
        DENMARK,
        ECUADOR,
        GERMANY,
        GHANA,
        IRAN,
        MEXICO,
        QATAR,
        SAUDIARABIA,
        SERBIA,
        TUNISIA,
        URAGUAY,
        WALSE
    }

    Country public champion;
    bool public isFinished;
    mapping (Country => bool) public teamsScope;

    

    constructor () {
        teamsScope[Country.NETHERLANDS] = true;         
        teamsScope[Country.SENEGAL] = true;
        teamsScope[Country.ENGLAND] = true;
        teamsScope[Country.USA] = true;
        teamsScope[Country.ARGENTINA] = true;
        teamsScope[Country.POLAND] = true;
        teamsScope[Country.FRANCE] = true;
        teamsScope[Country.AUSTRALIA] = true;
        teamsScope[Country.JAPAN] = true;
        teamsScope[Country.SPAIN] = true;
        teamsScope[Country.MOROCCO] = true;
        teamsScope[Country.CROATIA] = true;
        teamsScope[Country.BRAZIL] = true;
        teamsScope[Country.SWITZERLAND] = true;
        teamsScope[Country.PORTUGAL] = true;
        teamsScope[Country.KOREA] = true;
        teamsScope[Country.BELGIUM] = true;
        teamsScope[Country.CAMAROON] = true;
        teamsScope[Country.CANADA] = true;
        teamsScope[Country.COSTARICA] = true;
        teamsScope[Country.DENMARK] = true;
        teamsScope[Country.ECUADOR] = true;
        teamsScope[Country.GERMANY] = true;
        teamsScope[Country.GHANA] = true;
        teamsScope[Country.IRAN] = true;
        teamsScope[Country.MEXICO] = true;
        teamsScope[Country.QATAR] = true;
        teamsScope[Country.SAUDIARABIA] = true;
        teamsScope[Country.SERBIA] = true;
        teamsScope[Country.TUNISIA] = true;
        teamsScope[Country.URAGUAY] = true;
        teamsScope[Country.WALSE] = true;
    }
    
    function eliminate(Country _team) public onlyOwner{
        teamsScope[_team] = false;
    }
    
    
    function setChampion(Country _champion) public onlyOwner{
        require(block.timestamp > 1670043585, "not finished");
        require(teamsScope[_champion] == true, "cannot choose eliminated team");
        isFinished = true;
        champion = _champion;
    }

    function getChampion() external view returns (Country){
        return champion;       
    }

}