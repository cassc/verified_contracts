/**
 *Submitted for verification at BscScan.com on 2023-03-07
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;


contract Owner {

    address private owner;
    
    event OwnerSet(address indexed oldOwner, address indexed newOwner);
    
    modifier isOwner() {
       
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    
   
    constructor(address _owner) {
        owner = _owner;
        emit OwnerSet(address(0), owner);
    }

 
    function changeOwner(address newOwner) public isOwner {
        emit OwnerSet(owner, newOwner);
        owner = newOwner;
    }

    
    function getOwner() public view returns (address) {
        return owner;
    }
}


abstract contract ReentrancyGuard {
 
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

   
    modifier nonReentrant() {
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        _status = _ENTERED;

        _;

  
        _status = _NOT_ENTERED;
    }
}


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

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    
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

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
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

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

   
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }

        return true;
    }

  
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        _afterTokenTransfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);

        _afterTokenTransfer(address(0), account, amount);
    }

   
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);

        _afterTokenTransfer(account, address(0), amount);
    }

  
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}

   
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}


contract Stakes is Owner, ReentrancyGuard {

    ERC20 public asset;

    struct Record {
        uint256 from;
        uint256 amount;
        uint256 gain;
        uint256 penalization;
        uint256 to;
        bool ended;
    }

    uint16 public interest_rate;
    uint256 public maturity;
    uint8 public penalization;
    uint256 public lower_amount;

    mapping(address => Record[]) public ledger;

    event StakeStart(address indexed user, uint256 value, uint256 index);
    event StakeEnd(address indexed user, uint256 value, uint256 penalty, uint256 interest, uint256 index);
    
    constructor(ERC20 _erc20, address _owner, uint16 _rate, uint256 _maturity, uint8 _penalization, uint256 _lower) Owner(_owner) {
        require(_penalization<=100, "Penalty has to be an integer between 0 and 100");
        asset = _erc20;
        interest_rate = _rate;
        maturity = _maturity;
        penalization = _penalization;
        lower_amount = _lower;
    }
    
    function start(uint256 _value) external nonReentrant {
        
        require(_value >= lower_amount, "Invalid value");
        require(asset.transferFrom(msg.sender, address(this), _value));
        ledger[msg.sender].push(Record(block.timestamp, _value, 0, 0, 0, false));
        emit StakeStart(msg.sender, _value, ledger[msg.sender].length-1);
    }

    function end(uint256 i) external nonReentrant {

        require(i < ledger[msg.sender].length, "Invalid index");
        require(ledger[msg.sender][i].ended==false, "Invalid stake");
        
        if(block.timestamp - ledger[msg.sender][i].from < maturity) {
            uint256 _penalization = ledger[msg.sender][i].amount * penalization / 100;
            require(asset.transfer(msg.sender, ledger[msg.sender][i].amount - _penalization));
            require(asset.transfer(getOwner(), _penalization));
            ledger[msg.sender][i].penalization = _penalization;
            ledger[msg.sender][i].to = block.timestamp;
            ledger[msg.sender][i].ended = true;
            emit StakeEnd(msg.sender, ledger[msg.sender][i].amount, _penalization, 0, i);
        } else {
            uint256 _interest = get_gains(msg.sender, i);
            if (asset.allowance(getOwner(), address(this)) >= _interest && asset.balanceOf(getOwner()) >= _interest) {
                require(asset.transferFrom(getOwner(), msg.sender, _interest));
            } else {
                _interest = 0;
            }
            require(asset.transfer(msg.sender, ledger[msg.sender][i].amount));
            ledger[msg.sender][i].gain = _interest;
            ledger[msg.sender][i].to = block.timestamp;
            ledger[msg.sender][i].ended = true;
            emit StakeEnd(msg.sender, ledger[msg.sender][i].amount, 0, _interest, i);
        }
    }

    function set(uint256 _lower, uint256 _maturity, uint16 _rate, uint8 _penalization) external isOwner {
        require(_penalization<=100, "Invalid value");
        lower_amount = _lower;
        maturity = _maturity;
        interest_rate = _rate;
        penalization = _penalization;
    }
    
    function get_gains(address _address, uint256 _rec_number) public view returns (uint256) {
        uint256 _record_seconds = block.timestamp - ledger[_address][_rec_number].from;
        uint256 _year_seconds = 365*24*60*60;
        return _record_seconds * ledger[_address][_rec_number].amount * interest_rate / 100 / _year_seconds;
    }

    function ledger_length(address _address) external view returns (uint256) {
        return ledger[_address].length;
    }

}