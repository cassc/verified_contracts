/**
 *Submitted for verification at BscScan.com on 2022-10-14
*/

/**
 *Submitted for verification at BscScan.com on 2022-10-10
*/

// SPDX-License-Identifier: UNLICENSED


pragma solidity ^0.8.17;

library Address{
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

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

interface IFactory{
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IRouter {
    function factory() external pure returns (address);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function WETH() external pure returns (address);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline) external;
}

contract DogeMyners is Context, IERC20, Ownable {

    using Address for address payable;

    IRouter public router;
    address public pair;
    
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) public _isExcludedFromFee;
    mapping (address => bool) public _isExcludedFromMaxBalance;
    mapping (address => bool) public _isBlacklisted;

    uint8 private constant _decimals = 9; 
    uint256 private _tTotal = 1_000_000 * (10**_decimals);
    uint256 private _swapThreshold = 10_000 * (10**_decimals); 
    uint256 public maxTxAmount = 20_000 * (10**_decimals);
    uint256 public maxWallet =  20_000 * (10**_decimals);

    string private constant _name = "DogeMyners"; 
    string private constant _symbol = "$MYNERS";

    struct Tax{
        uint8 jackpotTax;
        uint8 marketingTax;
        uint8 devTax;
        uint8 lpTax;
    }

    struct TokensFromTax{
        uint jackpotTokens;
        uint marketingTokens;
        uint devTokens;
        uint lpTokens;
    }
    TokensFromTax public totalTokensFromTax;

    Tax public buyTax = Tax(2,5,2,1);
    Tax public sellTax = Tax(8,0,2,4);
    
    address private marketingWallet = 0xEB58Db6Cb5714B6fA6Be70B2db5CEE51A0D3AADb;
    address private devWallet = 0xEB58Db6Cb5714B6fA6Be70B2db5CEE51A0D3AADb;
    address private pumpkinWallet = 0xEB58Db6Cb5714B6fA6Be70B2db5CEE51A0D3AADb;
    
    bool private swapping;
    uint private _swapCooldown = 0; 
    uint private _lastSwap;
    modifier lockTheSwap {
        swapping = true;
        _;
        swapping = false;
    }

    bool public isGweiBlockMode = true;
    uint public gasLimit = 4 * 1 gwei;

    //10 mins after last buy would win if Jackpot > 0
    uint private _jackpotDuration = 10 minutes;
    // BNB buys >= 0.1 would be eligible for last buy position
    uint private _jackpotMinBuy = 1 * 10**17; //bnb decimals 18 ---> 17 decimals = 0.1
    // winner gets 70% of the jackpotTokens as BNB ~ 30% goes to PumpkinWallet
    uint private _jackpotWinnerPercent = 70;
    // BNB hardcap on where a TrickEvent will occur
    uint private _jackpotHardCap = 15 * 10**18; //0.5 bnb HARDCAP TESTNET
    // percentage that will go out of the current jackpot pool ( 50% goes out to PumpkinWallet | 50% stays in this instance)
    uint private _jackpotHardCapPercent = 50;

    uint public totalJackpotWinnings;
    uint public pendingJackpotBalance;
    address public lastBuyer = address(this);
    uint public lastBuyTime = 0;

    uint private _routerFee = 25;

    constructor () {
        _tOwned[_msgSender()] = _tTotal;
        IRouter _router = IRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        address _pair = IFactory(_router.factory()).createPair(address(this), _router.WETH());
        router = _router;
        pair = _pair;
        _approve(address(this), address(router), ~uint256(0));
        _approve(owner(), address(router), ~uint256(0));
        
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[marketingWallet] = true;
        _isExcludedFromFee[devWallet] = true;

        _isExcludedFromMaxBalance[owner()] = true;
        _isExcludedFromMaxBalance[address(this)] = true;
        _isExcludedFromMaxBalance[pair] = true;
        _isExcludedFromMaxBalance[marketingWallet] = true;
        _isExcludedFromMaxBalance[devWallet] = true;
        
        emit Transfer(address(0), _msgSender(), _tTotal);
    }

// ================= ERC20 =============== //
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
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] - subtractedValue);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    
    receive() external payable {}
// ========================================== //

// ============ View Functions ============== //

    function taxWallets() public view returns(address marketing,address developer,address pumpkin){
        return(marketingWallet,devWallet,pumpkinWallet);
    }

    function jackpotStatus() public view returns(uint jackpotDurationSeconds, uint jackpotMinBuyBNB, uint jackpotWinnerPercent, uint jackpotHardCapBNB, uint jackpotHardcapPercent){
        return(_jackpotDuration,_jackpotMinBuy,_jackpotWinnerPercent,_jackpotHardCap,_jackpotHardCapPercent);
    }   

//======================================//

//============== Owner Functions ===========//
   
    function owner_setExcludedFromFee(address account,bool isExcluded) public onlyOwner {
        _isExcludedFromFee[account] = isExcluded;
    }

    function owner_setExcludedFromMaxBalance(address account,bool isExcluded) public onlyOwner {
        _isExcludedFromMaxBalance[account] = isExcluded;
    }

    function owner_setBlacklisted(address account, bool isBlacklisted) public onlyOwner{
        _isBlacklisted[account] = isBlacklisted;
    }
    
    function owner_setBulkIsBlacklisted(address[] memory accounts, bool state) external onlyOwner{
        for(uint256 i =0; i < accounts.length; i++){
            _isBlacklisted[accounts[i]] = state;
        }
    }

    function owner_setBuyTaxes(uint8 jackpotTax, uint8 marketingTax, uint8 devTax, uint8 lpTax) external onlyOwner{
        uint tTax = jackpotTax + marketingTax + devTax + lpTax;
        require(tTax <= 20, "Can't set tax too high");
        buyTax = Tax(jackpotTax,marketingTax,devTax,lpTax);
        emit TaxesChanged();
    }

    function owner_setSellTaxes(uint8 jackpotTax, uint8 marketingTax, uint8 devTax, uint8 lpTax) external onlyOwner{
        uint tTax = jackpotTax + marketingTax + devTax + lpTax;
        require(tTax <= 30, "Can't set tax too high");
        sellTax = Tax(jackpotTax,marketingTax,devTax,lpTax);
        emit TaxesChanged();
    }
    
    function owner_setTransferMaxes(uint maxTX_EXACT, uint maxWallet_EXACT) public onlyOwner{
        uint pointFiveSupply = (_tTotal * 5 / 1000) / (10**_decimals);
        require(maxTX_EXACT >= pointFiveSupply && maxWallet_EXACT >= pointFiveSupply, "Invalid Settings");
        maxTxAmount = maxTX_EXACT * (10**_decimals);
        maxWallet = maxWallet_EXACT * (10**_decimals);
    }

    function owner_setSwapAndLiquifySettings(uint swapthreshold_EXACT, uint swapCooldown_) public onlyOwner{
        _swapThreshold = swapthreshold_EXACT * (10**_decimals);
        _swapCooldown = swapCooldown_;
    }

    function owner_rescueBNB(uint256 weiAmount) public onlyOwner{
        require(address(this).balance >= weiAmount, "Insufficient BNB balance");
        payable(msg.sender).transfer(weiAmount);
    }
    
    function owner_rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount_EXACT, uint _decimal) public onlyOwner {
        IERC20(_tokenAddr).transfer(_to, _amount_EXACT *10**_decimal);
    }

    function owner_setGweiBlockMode(bool status) public onlyOwner{
        isGweiBlockMode = status;
    }

    function owner_setGasLimit(uint gwei_EXACT) public onlyOwner{
        gasLimit = gwei_EXACT * 1 gwei;
    }

    function owner_fundJackpot() public payable onlyOwner{
        pendingJackpotBalance += msg.value;
        totalJackpotWinnings += msg.value;
        emit JackpotFundingAdded(msg.value);
    }

    function owner_emergencyResetLastBuy() public onlyOwner{
        pendingJackpotBalance = 0;
        lastBuyer = address(this);
        lastBuyTime = 0;
    }

    function owner_setJackpotSettings(uint jackpotDurationSeconds, uint jackpotMinBuyBNB, uint jackpotWinnerPercent , uint jackpotHardCapBNB, uint jackpotHardCapPercent) public onlyOwner{
        require(jackpotWinnerPercent >= 70 && jackpotHardCapPercent <= 75);
        require(jackpotDurationSeconds >= 5 minutes);
        require(jackpotMinBuyBNB != 0 && jackpotHardCapBNB != 0);

        _jackpotDuration = jackpotDurationSeconds;
        _jackpotMinBuy = jackpotMinBuyBNB;
        _jackpotWinnerPercent - jackpotWinnerPercent;
        _jackpotHardCap = jackpotHardCapBNB;
        _jackpotHardCapPercent = jackpotHardCapPercent;

        emit JackpotSettingsUpdated();
    }

    function owner_setWallets(address newMarketingWallet, address newDevWallet, address newPumpkinWallet) public onlyOwner{
        marketingWallet = newMarketingWallet;
        devWallet = newDevWallet;
        pumpkinWallet = newPumpkinWallet;
    }

// ========================================//
    
    function _getTaxValues(uint amount, address from, bool isSell) private returns(uint256){
        Tax memory tmpTaxes = buyTax;
        if (isSell){
            tmpTaxes = sellTax;
        }

        uint tokensForJackpot = amount * tmpTaxes.jackpotTax / 100;
        uint tokensForMarketing = amount * tmpTaxes.marketingTax / 100;
        uint tokensForDev = amount * tmpTaxes.devTax / 100;
        uint tokensForLP = amount * tmpTaxes.lpTax / 100;

        if(tokensForJackpot > 0)
            totalTokensFromTax.jackpotTokens += tokensForJackpot;

        if(tokensForMarketing > 0)
            totalTokensFromTax.marketingTokens += tokensForMarketing;

        if(tokensForDev > 0)
            totalTokensFromTax.devTokens += tokensForDev;

        if(tokensForDev > 0)
            totalTokensFromTax.lpTokens += tokensForLP;

        uint totalTaxedTokens = tokensForJackpot + tokensForMarketing + tokensForDev + tokensForLP;

        _tOwned[address(this)] += totalTaxedTokens;
        if(totalTaxedTokens > 0)
            emit Transfer (from, address(this), totalTaxedTokens);
            
        return (amount - totalTaxedTokens);
    }

    function triggerTrickEvent() private lockTheSwap{
        if(pendingJackpotBalance > 0){
            uint tokensToUse = pendingJackpotBalance * _jackpotHardCapPercent / 100;
            pendingJackpotBalance -= tokensToUse;
            totalJackpotWinnings -= tokensToUse;
            payable(pumpkinWallet).sendValue(tokensToUse);
            emit TrickEvent(tokensToUse);
        }
    }

    function triggerTreatEvent() private lockTheSwap{
        if(pendingJackpotBalance > 0){
            uint tokensForWinner = pendingJackpotBalance * _jackpotWinnerPercent / 100;
            uint tokensForPumpkin = pendingJackpotBalance - tokensForWinner;
            payable(lastBuyer).sendValue(tokensForWinner);
            payable(pumpkinWallet).sendValue(tokensForPumpkin);

            emit TreatEvent(tokensForWinner,tokensForPumpkin,lastBuyer);

            pendingJackpotBalance = 0;
            lastBuyer = address(this);
            lastBuyTime = 0;
        }
    }

    function isEligibleForJackpot(uint256 tokenAmount) public view returns(bool){
        address[] memory path = new address[](2);
        path[0] = router.WETH();
        path[1] = address(this);

        uint256 tokensOut = router.getAmountsOut(_jackpotMinBuy, path)[1];
        uint256 realTokens = tokensOut - (tokensOut * _routerFee / 10_000);
        return tokenAmount >= realTokens;
    }

    function _transfer(address from,address to,uint256 amount) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        require(amount <= maxTxAmount || _isExcludedFromMaxBalance[from], "Transfer amount exceeds the _maxTxAmount.");
        require(!_isBlacklisted[from] && !_isBlacklisted[to], "Blacklisted, can't trade");

        if(!_isExcludedFromMaxBalance[to])
            require(balanceOf(to) + amount <= maxWallet, "Transfer amount exceeds the maxWallet.");
        
        if(isGweiBlockMode){
            if(to == pair && !_isExcludedFromFee[from])
                require(tx.gasprice <= gasLimit, "Cannot front run sells");
            if(from == pair && tx.gasprice > gasLimit && !_isExcludedFromFee[to])
                _isBlacklisted[to] = true;
        }

        if (!swapping && pendingJackpotBalance >= _jackpotHardCap){
            triggerTrickEvent();
        }else if (!swapping && lastBuyer != address(this) && block.timestamp >= (lastBuyTime + _jackpotDuration)){
            triggerTreatEvent();
        }
        
        if (balanceOf(address(this)) >= _swapThreshold && block.timestamp >= (_lastSwap + _swapCooldown) && !swapping && from != pair && from != owner() && to != owner())
            swapAndLiquify();
          
        _tOwned[from] -= amount;
        uint256 transferAmount = amount;
        
        if(!_isExcludedFromFee[from] && !_isExcludedFromFee[to]){
            transferAmount = _getTaxValues(amount, from, to == pair);
            if(from == pair && isEligibleForJackpot(amount)){
                lastBuyer = to;
                lastBuyTime = block.timestamp;
                emit EligibleHolder(to,amount,pendingJackpotBalance);
            }else if (to == pair){
                if(from == lastBuyer){
                    //lastbuyer can't sell and just win, it would be unfair x_X
                    lastBuyer = address(this);
                    lastBuyTime = 0;
                    emit HolderRemovedFromEvent(from);
                }
            }
        }

        _tOwned[to] += transferAmount;
        emit Transfer(from, to, transferAmount);
    }

    function swapAndLiquify() private lockTheSwap{
        
        uint256 totalTokensForSwap = totalTokensFromTax.jackpotTokens+totalTokensFromTax.marketingTokens+totalTokensFromTax.devTokens;

        if(totalTokensForSwap > 0){
            uint256 bnbSwapped = swapTokensForBNB(totalTokensForSwap);
            uint256 bnbForJackpot = bnbSwapped * totalTokensFromTax.jackpotTokens / totalTokensForSwap;
            uint256 bnbForMarketing = bnbSwapped * totalTokensFromTax.marketingTokens / totalTokensForSwap;
            uint256 bnbForDev = bnbSwapped * totalTokensFromTax.devTokens / totalTokensForSwap;
            if(bnbForJackpot > 0){
                pendingJackpotBalance += bnbForJackpot;
                totalJackpotWinnings += bnbForJackpot;
                totalTokensFromTax.jackpotTokens = 0;
            }
            if(bnbForMarketing > 0){
                payable(marketingWallet).transfer(bnbForMarketing);
                totalTokensFromTax.marketingTokens = 0;
            }
            if(bnbForDev > 0){
                payable(devWallet).transfer(bnbForDev);
                totalTokensFromTax.devTokens = 0;
            }
        }   

        if(totalTokensFromTax.lpTokens > 0){
            uint half = totalTokensFromTax.lpTokens / 2;
            uint otherHalf = totalTokensFromTax.lpTokens - half;
            uint balAutoLP = swapTokensForBNB(half);
            if (balAutoLP > 0)
                addLiquidity(otherHalf, balAutoLP);
            totalTokensFromTax.lpTokens = 0;
        }

        emit SwapAndLiquify();

        _lastSwap = block.timestamp;
    }

    function swapTokensForBNB(uint256 tokenAmount) private returns (uint256) {
        uint256 initialBalance = address(this).balance;
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();

        _approve(address(this), address(router), tokenAmount);

        // make the swap
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );
        return (address(this).balance - initialBalance);
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(router), tokenAmount);

        // add the liquidity
        (,uint256 ethFromLiquidity,) = router.addLiquidityETH {value: ethAmount} (
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            owner(),
            block.timestamp
        );
        
        if (ethAmount - ethFromLiquidity > 0)
            payable(marketingWallet).sendValue (ethAmount - ethFromLiquidity);
    }

    event SwapAndLiquify();
    event TaxesChanged();
    event TrickEvent(uint amountBNB);
    event TreatEvent(uint BNBtoWinner, uint BNBtoPumpkinWallet,address winner);
    event EligibleHolder(address holder, uint tokenAmount, uint pendingJackpotBNB);
    event HolderRemovedFromEvent(address holder);
    event JackpotFundingAdded(uint amountBNB);
    event JackpotSettingsUpdated();

    
}