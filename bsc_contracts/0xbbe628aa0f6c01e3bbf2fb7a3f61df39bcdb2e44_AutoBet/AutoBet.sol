/**
 *Submitted for verification at BscScan.com on 2022-09-15
*/

// SPDX-License-Identifier: MIT
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
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
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

// File: @chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol


pragma solidity ^0.8.0;

interface KeeperCompatibleInterface {
  /**
   * @notice method that is simulated by the keepers to see if any work actually
   * needs to be performed. This method does does not actually need to be
   * executable, and since it is only ever simulated it can consume lots of gas.
   * @dev To ensure that it is never called, you may want to add the
   * cannotExecute modifier from KeeperBase to your implementation of this
   * method.
   * @param checkData specified in the upkeep registration so it is always the
   * same for a registered upkeep. This can easilly be broken down into specific
   * arguments using `abi.decode`, so multiple upkeeps can be registered on the
   * same contract and easily differentiated by the contract.
   * @return upkeepNeeded boolean to indicate whether the keeper should call
   * performUpkeep or not.
   * @return performData bytes that the keeper should call performUpkeep with, if
   * upkeep is needed. If you would like to encode data to decode later, try
   * `abi.encode`.
   */
  function checkUpkeep(bytes calldata checkData) external returns (bool upkeepNeeded, bytes memory performData);

  /**
   * @notice method that is actually executed by the keepers, via the registry.
   * The data returned by the checkUpkeep simulation will be passed into
   * this method to actually be executed.
   * @dev The input to this method should not be trusted, and the caller of the
   * method should not even be restricted to any single registry. Anyone should
   * be able call it, and the input should be validated, there is no guarantee
   * that the data passed in is the performData returned from checkUpkeep. This
   * could happen due to malicious keepers, racing keepers, or simply a state
   * change while the performUpkeep transaction is waiting for confirmation.
   * Always validate the data passed in.
   * @param performData is the data which was passed back from the checkData
   * simulation. If it is encoded, it can easily be decoded into other types by
   * calling `abi.decode`. This data should not be trusted, and should be
   * validated against the contract's current state.
   */
  function performUpkeep(bytes calldata performData) external;
}

// File: @chainlink/contracts/src/v0.8/KeeperBase.sol


pragma solidity ^0.8.0;

contract KeeperBase {
  error OnlySimulatedBackend();

  /**
   * @notice method that allows it to be simulated via eth_call by checking that
   * the sender is the zero address.
   */
  function preventExecution() internal view {
    if (tx.origin != address(0)) {
      revert OnlySimulatedBackend();
    }
  }

  /**
   * @notice modifier that allows it to be simulated via eth_call by checking
   * that the sender is the zero address.
   */
  modifier cannotExecute() {
    preventExecution();
    _;
  }
}

// File: @chainlink/contracts/src/v0.8/KeeperCompatible.sol


pragma solidity ^0.8.0;



abstract contract KeeperCompatible is KeeperBase, KeeperCompatibleInterface {}

// File: Keeper.sol


pragma solidity ^0.8.0;

// Farmageddon Lottery Keeper Automation 

// KeeperCompatible.sol imports the functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol



interface Pred{
    function claimable(uint256 epoch, address user) external view returns (bool);
    function currentEpoch() external view returns (uint256);
    function minBetAmount() external view returns (uint256);
    function betBear(uint256 epoch) external payable;  
    function betBull(uint256 epoch) external payable;
    function claim(uint256[] calldata epochs) external;

}

contract AutoBet is KeeperCompatibleInterface, Ownable {
    // initialize variables for lottery

    uint256 betAmount = 5000000000000000;
    uint256 currentRound;
    Pred public pred;

    constructor(address predAddress) {
        pred = Pred(predAddress);
    }

    function changeBetAmount(uint256 newBet) external onlyOwner {
        require(newBet > pred.minBetAmount(), "must be more than min");
        betAmount = newBet;
    }
    function setCurrentRound() public {
        currentRound = pred.currentEpoch();
    }

    function rng() internal view returns(uint256 value) {
        uint256 seed = block.difficulty + block.gaslimit * block.number; 
        uint256 randomness = uint256(keccak256(abi.encodePacked(seed)));
        value = uint256(randomness % 2);
    }

  
    function checkUpkeep(bytes calldata) view external override returns (bool upkeepNeeded, bytes memory) {
        // perform upkeep when timestamp is equal or more than upkeepTime
        
        upkeepNeeded = currentRound + 1 == pred.currentEpoch();
    }


    // Function for Chainlink Keeper calls to perfrom lottery actiona
    function performUpkeep(bytes calldata /* performData */) external override {
        require(currentRound + 1 == pred.currentEpoch(), "Not required");
        
        currentRound++;
        bool canClaim = pred.claimable(currentRound-2, address(this));
        if(canClaim){
            uint256[] memory claim = new uint256[](1);
            claim[1] = currentRound-2;
            pred.claim(claim);
        }
        
        uint256 random = rng();
        if(random == 0) pred.betBear{value: betAmount}(currentRound);
        else pred.betBull{value: betAmount}(currentRound);      
    }    

    function manualUpkeep() external {
        require(currentRound + 1 == pred.currentEpoch(), "Not required");
        
        currentRound++;
        bool canClaim = pred.claimable(currentRound-2, address(this));
        if(canClaim){
            uint256[] memory claim = new uint256[](1);
            claim[1] = currentRound-2;
            pred.claim(claim);
        }
        
        uint256 random = rng();
        if(random == 0) pred.betBear{value: betAmount}(currentRound);
        else pred.betBull{value: betAmount}(currentRound);      
    } 

    function checkClaim(uint256 epoch) external view returns (bool) {
        return pred.claimable(epoch, address(this));
    }

    function claimManual(uint256[] calldata epochs) external onlyOwner {
        pred.claim(epochs);
    }


    receive() external payable {}

  function withdrawBNB() external onlyOwner {
    require(payable(msg.sender).send(address(this).balance));
  }


}