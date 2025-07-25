/**
 *Submitted for verification at Etherscan.io on 2023-05-04
*/

// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Degen2Degen
{
    
    uint256 public totalSupply_;
    mapping(address => uint256) public balances_;
    mapping(address => mapping(address => uint256)) public allowances_;

    
    string public NAME = "Degen2Degen";
    string public SYMBOL = "D2D";
    uint8 public DECIMAL_AMOUNT = 18;

    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    
    constructor() {
        _mint(msg.sender, 69_420_000_000 ether);
    }

 
    function name() public view virtual returns (string memory)
    {
        return NAME;
    }

    function symbol() public view virtual returns (string memory)
    {
        return SYMBOL;
    }

    function decimals() public view virtual returns (uint8)
    {
        return DECIMAL_AMOUNT;
    }

    function totalSupply() public view virtual returns (uint256)
    {
        return totalSupply_;
    }

    function balanceOf(
        address account
    ) public view virtual returns (uint256)
    {
        return balances_[account];
    }

    //// Public Functions ////
    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function allowance(
        address owner,
        address spender
    ) public view virtual returns (uint256)
    {
        return allowances_[owner][spender];
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, allowances_[owner][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool)
    {
        address owner = _msgSender();
        uint256 currentAllowance = allowances_[owner][spender];
        require(currentAllowance >= subtractedValue, "Decreased allowance below zero.");
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual
    {
        require(from != address(0), "Transfer from the zero address.");
        require(to != address(0), "Transfer to the zero address.");

        uint256 fromBalance = balances_[from];
        require(fromBalance >= amount, "Transfer amount exceeds balance.");
        unchecked {
            balances_[from] = fromBalance - amount;
        }
        balances_[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _mint(
        address account,
        uint256 amount
    ) internal virtual
    {
        require(account != address(0), "Mint to the zero address.");

        totalSupply_ += amount;
        balances_[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(
        address account,
        uint256 amount
    ) internal virtual
    {
        require(account != address(0), "Burn from the zero address.");

        uint256 accountBalance = balances_[account];
        require(accountBalance >= amount, "Burn amount exceeds balance.");
        unchecked {
            balances_[account] = accountBalance - amount;
        }
        totalSupply_ -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual
    {
        require(owner != address(0), "Approve from the zero address.");
        require(spender != address(0), "Approve to the zero address.");

        allowances_[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual
    {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "Insufficient allowance.");
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}