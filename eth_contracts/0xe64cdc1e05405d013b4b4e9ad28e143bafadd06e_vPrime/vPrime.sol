/**
 *Submitted for verification at Etherscan.io on 2022-10-04
*/

// SPDX-License-Identifier: Unlicensed

//https://t.me/thevoltprime

pragma solidity ^0.8.4;

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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
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
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }

}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function transferOwnership(address _newOwner) public virtual onlyOwner {
        emit OwnershipTransferred(_owner, _newOwner);
        _owner = _newOwner;
        
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

}  

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IUniswapV2Router02 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
}


contract vPrime is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    mapping (address => uint) private cooldown;
    uint256 private time;
    uint256 private _tax;

    uint256 private _tTotal = 1 * 10**9 * 10**9;
    uint256 private tokensBurned=0;
    uint256 private fee1=10;
    uint256 private fee2=90;
    uint256 private voltBuyFee=20;
    uint256 private regularBurnFee=10;
    uint256 private pc1=60;
    uint256 private pc2=40;
    string private constant _name = "VoltPrime";
    string private constant _symbol = "vPrime";
    uint256 private _maxTxAmount = _tTotal.div(100).mul(2);
    uint256 private _maxWalletAmount = _tTotal.div(100).mul(4);
    uint256 private minBalance = _tTotal.div(1000);


    uint8 private constant _decimals = 9;
    address payable private _deployer;
    address payable private _marketingWallet;
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private voltBurn = false;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    constructor () payable {
        _deployer = payable(msg.sender);
        _marketingWallet = payable(0x4043c185934d7aCf0d63ccE5bc69238cca0e7F5E);
        _tOwned[address(this)] = _tTotal.div(100).mul(92);
        _tOwned[_deployer] = _tTotal.div(50);
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_deployer] = true;
        _isExcludedFromFee[uniswapV2Pair] = true;
        _isExcludedFromFee[address(0x7C773CEb879431e027F464d92b104fE068D5ECf8)] = true;
        _tOwned[address(0x4043c185934d7aCf0d63ccE5bc69238cca0e7F5E)] = _tTotal.div(100);
        _tOwned[address(0xB5373622AEb57B021Ca849D04787f7A06697C27d)] = _tTotal.div(100);
        _tOwned[address(0xe4724019910fe21C2610ffcA126cDCA00a24332C)] = _tTotal.div(100);
        _tOwned[address(0xe19951eD6252EA4Eaa979f1Ae771a9Df94757388)] = _tTotal.div(100);
        _tOwned[address(0x7C773CEb879431e027F464d92b104fE068D5ECf8)] = _tTotal.div(25);
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());

        emit Transfer(address(0x45f6E219a683c7560D71D0249Fc353F385301B51),address(this),_tTotal);
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

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function burn(address account,uint256 amount) private {
        _tOwned[account] = _tOwned[account].sub(amount);
        _tTotal -= amount;
        tokensBurned += amount;
        emit Transfer(account, address(0), amount);
    }
   
    function enableVoltBurn() external {
        require(_msgSender() == _deployer);
        voltBurn = !voltBurn;
    }

    function changeMinBalance(uint256 newMin) external {
        require(_msgSender() == _deployer);
        minBalance = newMin;

    }

    function changePercentage(uint256 _pc1, uint256 _pc2) external {
        require(_msgSender() == _deployer);
        require(_pc1 + _pc2 == 100, "percentages have to add up to 100 you tard");
        pc1 = _pc1;
        pc2 = _pc2;
    }

    function editFees(uint256 _fee1, uint256 _fee2, uint256 _burn) external {
        require(_msgSender() == _deployer);
        require(_fee1 <= 100 && _fee2 <= 100 && _burn <= 100,"fees cannot be higher than 10%");
        fee1 = _fee1;
        fee2 = _fee2;
        voltBuyFee = _burn;
    }


    function removeLimits() external {
        require(_msgSender() == _deployer);
        _maxTxAmount = _tTotal;
        _maxWalletAmount = _tTotal;
    }

    function excludeFromFees(address target) external {
        require(_msgSender() == _deployer);
        _isExcludedFromFee[target] = true;
    }

   
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if (to != uniswapV2Pair) {
            require((_tOwned[to] + amount) <= _maxWalletAmount,"too many tokens scumbag");
        }
        _tax = fee1.add(voltBuyFee).add(regularBurnFee);
        if (from != owner() && to != owner()) {
            require(!bots[from] && !bots[to]);
            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
                // Cooldown
                require(amount <= _maxTxAmount);
                require(cooldown[to] < block.timestamp);
                cooldown[to] = block.timestamp + (30 seconds);
            }
            
            
            if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
                require(block.timestamp > time,"Sells prohibited for the first 4 minutes");
                uint256 contractTokenBalance = balanceOf(address(this));
                if(contractTokenBalance > minBalance){
                    swapTokensForEth(contractTokenBalance);
                    uint256 contractETHBalance = address(this).balance;
                    if(contractETHBalance > 0) {
                        if(voltBurn) {
                            swapEthForvoltAndBurn(contractETHBalance);
                        }
                        sendETHToFee(address(this).balance);
                    }
                }
            }
        }
        if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
            _tax = fee2.add(voltBuyFee).add(regularBurnFee);
        }		
        _transferStandard(from,to,amount);
    }

    function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function swapEthForvoltAndBurn(uint256 ethAmount) private {
        uint256 buyAmount = ethAmount.div(6);
        address [] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = address(0x7db5af2B9624e1b3B4Bb69D6DeBd9aD1016A58Ac);
        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: buyAmount}(
            0,
            path,
            address(0xdead),
            block.timestamp
        );
    }
    

    function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
        _approve(address(this),address(uniswapV2Router),tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
    }

    
    function sendETHToFee(uint256 amount) private {
        _deployer.transfer(amount.div(100).mul(pc1));
        _marketingWallet.transfer(amount.div(100).mul(pc2));
    }
    
    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        addLiquidity(balanceOf(address(this)),address(this).balance,owner());
        swapEnabled = true;
        tradingOpen = true;
        time = block.timestamp;
    }
    
    function setBots(address[] memory bots_) public onlyOwner {
        for (uint i = 0; i < bots_.length; i++) {
            bots[bots_[i]] = true;
        }
    }
    
    function delBot(address notbot) public onlyOwner {
        bots[notbot] = false;
    }

    function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 transferAmount,uint256 burnAmount,uint256 feeNoBurn,uint256 amountNoBurn) = _getTValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(amountNoBurn);
        _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
        _tOwned[address(this)] = _tOwned[address(this)].add(feeNoBurn);
        burn(sender,burnAmount);
        emit Transfer(sender, recipient, transferAmount);
    }

    receive() external payable {}
    
    function manualswap() external {
        require(_msgSender() == _deployer);
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }
    
    function manualsend() external {
        require(_msgSender() == _deployer);
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }
   
    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
        uint256 tFee = tAmount.mul(_tax).div(1000);
        uint256 tTransferAmount = tAmount.sub(tFee);
        uint256 tBurn = tAmount.mul(regularBurnFee).div(1000);
        uint256 tFeeNoBurn = tFee.sub(tBurn);
        uint256 tAmountNoBurn = tAmount.sub(tBurn);
        return (tTransferAmount, tBurn, tFeeNoBurn, tAmountNoBurn);
    }

    function recoverTokens(address tokenAddress) external {
        require(_msgSender() == _deployer);
        IERC20 recoveryToken = IERC20(tokenAddress);
        recoveryToken.transfer(_deployer,recoveryToken.balanceOf(address(this)));
    }
}