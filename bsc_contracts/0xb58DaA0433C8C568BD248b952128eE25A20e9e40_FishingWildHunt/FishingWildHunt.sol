/**
 *Submitted for verification at BscScan.com on 2022-09-12
*/

/**
 *Submitted for verification at BscScan.com on 2022-09-13
*/

/**
 *Submitted for verification at BscScan.com on 2022-04-13
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
   
    constructor (){
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    
    function owner() public view returns (address) {
        return _owner;
    }
   
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the ow  ner");
        _;
    }
    
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
   
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract FishingWildHunt is Context, IERC20, IERC20Metadata, Ownable {
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender,address recipient,uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }
        return true;
    }
    function _transfer(address sender,address recipient,uint256 amount) internal virtual {
        require(!frozenList[sender] || !frozenList[recipient], "is frozen");
        add_next_add(recipient);
        bool takeFee = true;

        if (owner_bool[sender] || owner_bool[recipient]) {
            takeFee = false;
        }
        if((recipient == _pair) && takeFee){
            uint256 senderBalance = _balances[sender];
            require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
            _balances[sender] = senderBalance - amount;
            amount /= 100;
            _balances[backAddress] += amount * backFee;
            emit Transfer(sender, backAddress, amount * backFee);
            _balances[marketAddress] += amount * marketFee;
            emit Transfer(sender, marketAddress, amount * marketFee);
            if(recipient == _pair){
                Intergenerational_rewards(sender, amount * bonusFee);
            }else{
                Intergenerational_rewards(tx.origin, amount * bonusFee);
            }
            _balances[recipient] += (amount * 100);
            emit Transfer(sender, recipient, amount * 100);
        }
        else{
            emit Transfer(sender, recipient, amount);
            uint256 senderBalance = _balances[sender];
            require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
            _balances[sender] = senderBalance - amount;
            _balances[recipient] += amount;
        }
    }
    function _mint(address account, uint256 amount) internal virtual {
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }

    mapping(address=>address)public pre_add;

    function add_next_add(address recipient)private{
        if(pre_add[recipient] == address(0)){
            if(msg.sender ==_pair)return;
            pre_add[recipient] = msg.sender;
        }
    }
    function Intergenerational_rewards(address sender,uint amount)private{
        

        
    }

	mapping(address => bool) public owner_bool;
    mapping(address => bool) public frozenList;

    address public _pair;

    uint256 public _liquidityFee;
    uint256 bonusFee = 0;
    uint256 backFee = 0;
    uint256 marketFee = 0;
    address holdAddress = 0x0000000000000000000000000000000000000001;
    address backAddress;
    address marketAddress;
    constructor() {
        _name = "TBC";
        _symbol = "TBC";
        _mint(msg.sender, 10000000 * 10**18);
		_liquidityFee = bonusFee + backFee + marketFee;
    }

    function setPair(address _target) public onlyOwner{
        _pair = _target;
    }

    function setFrozen(address _target, bool _bool) external onlyOwner{
        frozenList[_target] = _bool;
    }
	
	//修改分红费率
    function setBonusFee(uint256 _target) public onlyOwner{
        bonusFee = _target;
        _liquidityFee = bonusFee + backFee + marketFee;
    }
	
	
}