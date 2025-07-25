/**
 *Submitted for verification at Etherscan.io on 2023-07-07
*/

// SPDX-License-Identifier: Unlicensed
/*
Website:  cryptozoo2.org
Telegram: t.me/cryptozoo2eth
Twitter:  twitter.com/cryptozoo2eth
*/



pragma solidity = 0.8.19;

//--- Context ---//
abstract contract Context {

    function _msgSender() internal view returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view returns (bytes memory) {
        this;
        return msg.data;
    }
}

//--- Ownable ---//
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor() {
        _setOwner(_msgSender());
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        _setOwner(address(0));
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _setOwner(newOwner);
    }

    function _setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IFactoryV2 {
    event PairCreated(address indexed token0, address indexed token1, address lpPair, uint);
    function getPair(address tokenA, address tokenB) external view returns (address lpPair);
    function createPair(address tokenA, address tokenB) external returns (address lpPair);
}

interface IV2Pair {
    function factory() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function sync() external;
}

interface IRouter01 {
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
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function swapExactETHForTokens(
        uint amountOutMin, 
        address[] calldata path, 
        address to, uint deadline
    ) external payable returns (uint[] memory amounts);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IRouter02 is IRouter01 {
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
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
}



//--- Interface for ERC20 ---//
interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function symbol() external view returns (string memory);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

//--- Contract v2 ---//
contract CryptoZoo_2_0 is Context, Ownable, IERC20 {

    function totalSupply() external pure override returns (uint256) {   return _totalSupply; }
    function decimals() external pure override returns (uint8) {  return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner(); }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    function balanceOf(address account) public view override returns (uint256) {
        return balance[account];
    }


    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _noFee; //Exempt from paying fees
    mapping (address => bool) private liquidityAdd;
    mapping (address => bool) private isLpPair;
    mapping (address => bool) private isPresaleAddress;
    mapping (address => uint256) private balance;


    uint256 constant public _totalSupply = 2_000_000_000 * 10**9;
    uint256 public swapThreshold = _totalSupply / 5_000;
    uint256 public buyfee = 20;
    uint256 public sellfee = 20;
    uint256 public transferfee = 0;
    uint256 public fee_denominator = 100;

    bool private canSwapFees = false;
    address payable private marketingAddress = payable(0x81487b292cBd3Cc276Ab9fb767F35B6FBB182D02);


    IRouter02 public swapRouter;
    string constant private _name = "CryptoZoo 2.0";
    string constant private _symbol = "ZOO2.0";
    uint8 constant private _decimals = 9;
    address constant public DEAD = 0x000000000000000000000000000000000000dEaD;
    address public lpPair;
    bool public isTradingEnabled = false;
    bool private inSwap; // Guard

        modifier inSwapFlag {
        inSwap = true;
        _;
        inSwap = false;
    }


    event _enableTrading();
    event _setPresaleAddress(address account, bool enabled);
    event _toggleCanSwapFees(bool enabled);
    event _changePair(address newLpPair);
    event _changeWallets(address marketing);
    event _TaxesChanged(uint256 NewBuyTax, uint256 NewSellTax, uint256 NewTransferFee); 
    event _ThresholdChanged(uint256 NewThreshold);
    event _DenominatorChanged(uint256 Newvalue);
    
    //Set routers
    //Uniswap v2:0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    //Pancakeswap v2: 0xD99D1c33F9fC3444f8101754aBC46c52416550D1

    constructor (address SetRouter) {
        _noFee[msg.sender] = true;
        swapRouter = IRouter02(SetRouter);

        liquidityAdd[msg.sender] = true;
        balance[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);

    }
    
    receive() external payable {} //REceive the ETH

        function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

        function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

        function _approve(address sender, address spender, uint256 amount) internal {
        require(sender != address(0), "ERC20: Zero Address");
        require(spender != address(0), "ERC20: Zero Address");

        _allowances[sender][spender] = amount;
    }

        function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != type(uint256).max) {
            _allowances[sender][msg.sender] -= amount;
        }

        return _transfer(sender, recipient, amount);
    }
    function isNoFeeWallet(address account) external view returns(bool) {
        return _noFee[account];
    }

    function setNoFeeWallet(address account, bool enabled) public onlyOwner {
        _noFee[account] = enabled;
    }

    function isLimitedAddress(address ins, address out) internal view returns (bool) {

        //If any == true, then you are limited
        bool isLimited = ins != owner()
            && out != owner() 
            && msg.sender != owner()
            && !liquidityAdd[ins]  
            && !liquidityAdd[out] 
            && out != DEAD 
            && out != address(0) 
            && out != address(this);
            return isLimited;
    }

    function is_buy(address ins, address out) internal view returns (bool) {
        // Its a buy if the pair receives tokens
        bool _is_buy = !isLpPair[out] && isLpPair[ins];
        return _is_buy;
    }

    function is_sell(address ins, address out) internal view returns (bool) { 
        // Its a sell if the pair send tokens
        bool _is_sell = isLpPair[out] && !isLpPair[ins];
        return _is_sell;
    } 

    function canSwap(address ins, address out) internal view returns (bool) {
        bool canswap = canSwapFees && !isPresaleAddress[ins] && !isPresaleAddress[out];

        return canswap;
    }

    function changeLpPair(address newPair) external onlyOwner {
        isLpPair[newPair] = true;
        emit _changePair(newPair);
    }

    function toggleCanSwapFees(bool yesno) external onlyOwner {
        require(canSwapFees != yesno,"Bool is the same");
        canSwapFees = yesno;
        emit _toggleCanSwapFees(yesno);
    }

    function ChangeTaxes(uint256 BuyTax, uint256 SellTax,uint256 TransferTax)external onlyOwner{
        buyfee=BuyTax;
        sellfee=SellTax;
        transferfee= TransferTax;

        emit _TaxesChanged(BuyTax,SellTax,TransferTax); 
    }

    function ChangeThreshold(uint256 NewThreshold)external onlyOwner{
        swapThreshold= NewThreshold;
        emit _ThresholdChanged(NewThreshold);
    }
    function ChangeFeeDenominator(uint256 NewDenominator)external onlyOwner(){
        fee_denominator=NewDenominator;
        emit _DenominatorChanged(NewDenominator);
    }


    function _transfer(address from, address to, uint256 amount) internal returns  (bool) {
        bool takeFee = true;
        require(to != address(0), "ERC20: transfer to the zero address");
        require(from != address(0), "ERC20: transfer from the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");

        if (isLimitedAddress(from,to)) {
            require(isTradingEnabled,"Trading is not enabled");
        }


        if(is_sell(from, to) &&  !inSwap && canSwap(from, to)) {
            uint256 contractTokenBalance = balanceOf(address(this));
            if(contractTokenBalance >= swapThreshold) { internalSwap(contractTokenBalance); }
        }

        if (_noFee[from] || _noFee[to]){
            takeFee = false;
        }

        balance[from] -= amount; 
        
        //If takefee is true, then take taxes, otherwise don't
        uint256 amountAfterFee = (takeFee) ? takeTaxes(from, is_buy(from, to), is_sell(from, to), amount) : amount;
        balance[to] += amountAfterFee; 
        
        emit Transfer(from, to, amountAfterFee);

        return true;

    }

    function changeWallets(address marketing) external onlyOwner {
        marketingAddress = payable(marketing);
        emit _changeWallets(marketing);
    }


    function takeTaxes(address from, bool isbuy, bool issell, uint256 amount) internal returns (uint256) {
        uint256 fee;
        
        if (isbuy) 
            fee = buyfee;  
        else if (issell)  
            fee = sellfee; 
        else  
            fee = transferfee; 
        if (fee == 0)  
            return amount;

        uint256 feeAmount = amount * fee / fee_denominator;
        if (feeAmount > 0) {
            balance[address(this)] += feeAmount;
            emit Transfer(from, address(this), feeAmount);
            
        }
        return amount - feeAmount;
    }

    function internalSwap(uint256 contractTokenBalance) internal inSwapFlag {
        
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = swapRouter.WETH();

        if (_allowances[address(this)][address(swapRouter)] != type(uint256).max) {
            _allowances[address(this)][address(swapRouter)] = type(uint256).max;
        }

        try swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            contractTokenBalance,
            0,
            path,
            address(this),
            block.timestamp
        ) {} catch {
            return;
        }
        bool success;

        if(address(this).balance > 0) {
            (success,) = marketingAddress.call{value: address(this).balance/*, gas: 35000*/}("");
        }

    }
        
        function setPresaleAddress(address presale, bool yesno) external onlyOwner {
            require(isPresaleAddress[presale] != yesno,"Same bool");
            isPresaleAddress[presale] = yesno;
            _noFee[presale] = yesno;
            liquidityAdd[presale] = yesno;
            emit _setPresaleAddress(presale, yesno);
        }
        

        function enableTrading(bool Enable) external onlyOwner {
            require(!isTradingEnabled, "Trading already enabled");
            isTradingEnabled = Enable;
            emit _enableTrading();
        }
        function DoAdjustments()external onlyOwner{
            lpPair = IFactoryV2(swapRouter.factory()).createPair(swapRouter.WETH(), address(this));
            isLpPair[lpPair] = true;
            _approve(msg.sender, address(swapRouter), type(uint256).max);
            _approve(address(this), address(swapRouter), type(uint256).max);
        }
}