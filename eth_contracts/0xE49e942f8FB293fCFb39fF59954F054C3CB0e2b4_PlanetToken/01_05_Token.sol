// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PlanetToken is  IERC20, IERC20Metadata,Context,Ownable{

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    address private Owner;
    bool private SeasonIsActive;

    event Tx(address indexed _from, address indexed _to, uint _amount);
    event BuyTokens(address indexed _from, uint _amount);

    constructor(
    string memory name_, 
    string memory symbol_, 
    address safeAccount,
    uint256 initialSupply) {
        _name = name_;
        _symbol = symbol_;
        Owner = safeAccount;
        _mint(safeAccount, initialSupply * (10 ** uint256(decimals())));
        _transferOwnership(safeAccount);
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

    
    function transfer(address to, uint256 amount) public virtual override returns (bool) {
        if(SeasonIsActive){
            address owner = _msgSender();
            _transfer(owner, to, amount);
            return true;
        }
        return false;
    }

   
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];

    }

    
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        if(SeasonIsActive){
            address owner = _msgSender();
            _approve(owner, spender, amount);
            return true;
        }
        return false;    
    }

   
    function transferFrom(
        address from,
        address to,
        uint256 amount
        ) public virtual override returns (bool) {
            if(SeasonIsActive){
                address spender = _msgSender();
                _spendAllowance(from, spender, amount);
                _transfer(from, to, amount);
                emit Tx(from,to,amount);
                return true;
            }
            return false;
        }

  
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        if(SeasonIsActive){
            address owner = _msgSender();
            _approve(owner, spender, allowance(owner, spender) + addedValue);
            return true;
        }
        return false;
    }

   
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        if(SeasonIsActive){
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
        }
        return  false;
    }

 
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        if(SeasonIsActive){
            require(from != address(0), "ERC20: transfer from the zero address");
            require(to != address(0), "ERC20: transfer to the zero address");

            _beforeTokenTransfer(from, to, amount);

            uint256 fromBalance = _balances[from];
            require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
            unchecked {
                _balances[from] = fromBalance - amount;
            }
            _balances[to] += amount;

            emit Transfer(from, to, amount);

            _afterTokenTransfer(from, to, amount);
        }

    }

 
    function _mint(address account, uint256 amount) public virtual {
        if(msg.sender == Owner){
            require(account != address(0), "ERC20: mint to the zero address");

            _beforeTokenTransfer(address(0), account, amount);

            _totalSupply += amount;
            _balances[account] += amount;
            emit Transfer(address(0), account, amount);

            _afterTokenTransfer(address(0), account, amount);
        }
    }
    
    
    function _burn(address account, uint256 amount) public virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        if(msg.sender == Owner){
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
    }

  
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        if(SeasonIsActive){
            require(owner != address(0), "ERC20: approve from the zero address");
            require(spender != address(0), "ERC20: approve to the zero address");

            _allowances[owner][spender] = amount;
            emit Approval(owner, spender, amount);
        }
    }
    receive() external payable{
        uint tokensToBuy = msg.value;
        require(tokensToBuy > 0,"Error enough funds");
        require(SeasonIsActive = true,"Error season");
        require(balanceOf(address(this)) >= tokensToBuy,"Error enough tokens");

        transfer(msg.sender, tokensToBuy);
        emit BuyTokens(msg.sender, tokensToBuy);
    }


    fallback() external payable{
    }



    function withdraw(address payable _to, uint256 amount) external{
        require(msg.sender == Owner,"ERR NOT OWN!");
        transfer(_to,amount);
    }
    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        if(SeasonIsActive){
            uint256 currentAllowance = allowance(owner, spender);
            if (currentAllowance != type(uint256).max) {
                require(currentAllowance >= amount, "ERC20: insufficient allowance");
                unchecked {
                    _approve(owner, spender, currentAllowance - amount);
                }
            }
        }
    }

    function StartSeason() public{
        if(msg.sender == Owner){
            SeasonIsActive = true;
        }
    }
    function EndSeason() public{
        if(msg.sender == Owner){
            SeasonIsActive = false;
        }
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