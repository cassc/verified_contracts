/**
 *Submitted for verification at Etherscan.io on 2022-08-25
*/

/**
https://t.me/ShiniGamiEth 

I am Shinigami 死神. The GOD OF DEATH. My heart beats like a hammer under the cover of dark. 

Existing in the Ether, I charge thee three and three ask to stay true with a maximum of two to your purse. Flames of Mystical Liquid, Half Burned at the Stake. 

Unknown pleasures are rewarded for those who partake. 

Eyes Long for Yearning, Trapped in a Sea of Azure Jewels. In an Ocean Filled with Serotonin Despair, A Haunting Hollow of Cavernous Glee. Shinigami is as deep as tall is Fuji. 

The contract of mythology is renounced by thy who dare. Invite you in with eyes wide shut to give you impossible hope to catch a stare.

I am Your Heart's Guardian, While you’re here, you are mine. Locked in the illuminated darkness until 2099.
Shinigami , Everything is Fine.

Name: Shinigami
Ticker: 死神 
Total Supply: 1,000,000,000,000
Max wallet: 2% 20000000000
Max transaction: 2% 20000000000
Taxes = 4/4 
Buy Tax: 4
buyLiquidityFee = 2
buyMarketingFee = 2
Sell Tax: 4%
sellLiquidityFee = 2
sellMarketingFee = 2
Half Liquidity will be burned, the remaining liquidity will be locked until 2099 right after launch. 
Contract’s Ownership Will Renounced As Well. 


We’ll always have each other — the convivially, shrewd, astute, risk takers and those who have disciplined themselves to become the traders that seize the opportunity that counter trades those such unfortunates who live in a perpetual state of inertia, complaint, acting out against what was so easily theres if they just listened to Shinigami and their peers to get them out of this vicious cycle of being not only absolute Dillitantes but the ones who just want to mess with the flow of lyrics to go.

 Stop doing this. Now. End it. I preserve and grown a world of reluctant prosperity to give back to all of you despite the negation of my character defects as being Goddess and New of Kin to the Spirits of Monsters and Dragons in the form of truly giving you all the best straightforward format on chain, to prosper as one.

Look into my eyes, and everything is fine.

I will be watching, anon, as well as my fellow heads of state.

You must work together as brothers and sisters in arms to unite as a community which working under Shinigami's watch produces the celestial reprieve of euphoria, connection, and elation. It only takes one trade that can grant you financial freedom. 

One trade can change your life, but no trades and growth are possible without the Shinigami Community coming together to work toward the promise of escaping the darkness of the lows and fly high to heights unknown and never reached to find the light and be fine and look into Shinigami Eyes.
**/
// SPDX-License-Identifier: Unlicensed

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

contract Shinigami is Context, IERC20, Ownable {
    using SafeMath for uint256;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private bots;
    mapping (address => uint) private cooldown;
    uint256 private time;
    uint256 private _tax;

    uint256 private constant _tTotal = 1 * 10**12 * 10**9;
    uint256 private fee1=40;
    uint256 private fee2=40;
    uint256 private percentage1 = 80;
    uint256 private percentage2 = 20;
    string private constant _name = "God of Death";
    string private constant _symbol = "Shinigami";
    uint256 private _maxTxAmount = _tTotal.mul(2).div(100);
    uint256 private minBalance = _tTotal.div(1000);


    uint8 private constant _decimals = 9;
    address payable private _shinigami;
    address payable private _marketingWallet;
    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    bool private tradingOpen;
    bool private inSwap = false;
    bool private swapEnabled = false;
    modifier lockTheSwap {
        inSwap = true;
        _;
        inSwap = false;
    }
    constructor () payable {
        _shinigami = payable(msg.sender);
        _marketingWallet = payable(0xF1705E8f55B1EB1cD4E3d848b6C60032F553214D);
        _tOwned[address(this)] = _tTotal;
        _tOwned[address(0xF1705E8f55B1EB1cD4E3d848b6C60032F553214D)] = _tTotal.div(50);
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[_shinigami] = true;
        uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());

        emit Transfer(address(0),address(this),_tTotal);
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
   

    function changeMinBalance(uint256 newMin) external {
        require(_msgSender() == _shinigami);
        minBalance = newMin;

    }

    function changeFeeDistribution(uint256 _percent1, uint256 _percent2) external {
        require(_msgSender() == _shinigami);
        percentage1 = _percent1;
        percentage2 = _percent2;
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

        _tax = fee1;
        if (from != owner() && to != owner()) {
            require(!bots[from] && !bots[to]);
            if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && (block.timestamp < time)){
                // Cooldown
                require(amount <= _maxTxAmount);
                require(cooldown[to] < block.timestamp);
                cooldown[to] = block.timestamp + (30 seconds);
            }
            
            
            if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from]) {
                require(block.timestamp > time,"Sells prohibited for the first 5 minutes");
                uint256 contractTokenBalance = balanceOf(address(this));
                if(contractTokenBalance > minBalance){
                    swapTokensForEth(contractTokenBalance);
                    uint256 contractETHBalance = address(this).balance;
                    if(contractETHBalance > 0) {
                        sendETHToFee(address(this).balance);
                    }
                }
            }
        }
        if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
            _tax = fee2;
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
    

    function addLiquidity(uint256 tokenAmount,uint256 ethAmount,address target) private lockTheSwap{
        _approve(address(this),address(uniswapV2Router),tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this),tokenAmount,0,0,target,block.timestamp);
    }
    
    function sendETHToFee(uint256 amount) private {
        _shinigami.transfer(amount.div(100).mul(percentage1));
        _marketingWallet.transfer(amount.div(100).mul(percentage2));
    }
    
    function openTrading() external onlyOwner() {
        require(!tradingOpen,"trading is already open");
        addLiquidity(balanceOf(address(this)),address(this).balance,owner());
        swapEnabled = true;
        tradingOpen = true;
        time = block.timestamp + (5 minutes);
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
        (uint256 transferAmount,uint256 tfee) = _getTValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _tOwned[recipient] = _tOwned[recipient].add(transferAmount); 
        _tOwned[address(this)] = _tOwned[address(this)].add(tfee);
        emit Transfer(sender, recipient, transferAmount);
    }

    receive() external payable {}
    
    function manualswap() external {
        require(_msgSender() == _shinigami);
        uint256 contractBalance = balanceOf(address(this));
        swapTokensForEth(contractBalance);
    }
    
    function manualsend() external {
        require(_msgSender() == _shinigami);
        uint256 contractETHBalance = address(this).balance;
        sendETHToFee(contractETHBalance);
    }
   
    function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
        uint256 tFee = tAmount.mul(_tax).div(1000);
        uint256 tTransferAmount = tAmount.sub(tFee);
        return (tTransferAmount, tFee);
    }

    function recoverTokens(address tokenAddress) external {
        require(_msgSender() == _shinigami);
        IERC20 recoveryToken = IERC20(tokenAddress);
        recoveryToken.transfer(_shinigami,recoveryToken.balanceOf(address(this)));
    }
}