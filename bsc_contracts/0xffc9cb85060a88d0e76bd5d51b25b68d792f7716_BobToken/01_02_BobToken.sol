// Author @i_am_blockchain (฿lockchain ฿ob)
// TG: https://t.me/BobToken_Portal
// Website: https://bobtoken.xyz
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Library.sol";

contract BobToken is Ownable, IBEP20{
    uint256 private constant _totalSupply = 1000000*(10**9);
    uint8 private constant _decimals = 9;
    uint256 private _maxWalletSize=10000*(10**9);
    uint256 private _maxTx=5000*(10**9);
    uint8 public swapThreshold=20;
    bool private _tradingEnabled=false;
    bool public swapEnabled;
    bool private _inSwap;
    bool private _addingLP;
    bool private _removingLP;
    IPancakeRouter02 private _pancakeRouter;
    address public pancakeRouterAddress=0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public pancakePairAddress;
    address public marketingWallet=0x4F864aA90943c9b0F255D609830652C8bd380BCD;
    address public burnWallet=0x000000000000000000000000000000000000dEaD;
    mapping(address=>bool) private _blacklist;
    mapping(address=>uint256) private _balances;
    mapping(address=>mapping(address => uint256)) private _allowances;
    mapping(address=>bool)private _excludeFromFees;
    mapping(address=>bool)private _marketMakers;
    Taxes private _taxes;
    struct Taxes {uint8 buyTax;uint8 sellTax;uint16 burnTax;uint16 liquidityTax;uint16 marketingTax;}
    modifier LockTheSwap {_inSwap=true;_;_inSwap=false; }
    event OwnerBlacklist(address account,bool enabled);
    event OwnerUpdatePrimaryTaxes(uint8 buyTax,uint8 sellTax);
    event OwnerUpdateSecondaryTaxes(uint16 liquidityTax,uint16 marketingTax,uint16 burnTax);
    event OwnerSetSwapEnabled(bool enabled);
    event OwnerTriggerSwap(uint8 swapThreshold,bool ignoreLimits);
    event OwnerUpdateSwapThreshold(uint8 swapThreshold);
    constructor() {
        _updateBalance(address(this),_totalSupply);
        _pancakeRouter = IPancakeRouter02(pancakeRouterAddress);
        pancakePairAddress = IPancakeFactory(_pancakeRouter.factory()).createPair(address(this), _pancakeRouter.WETH());
        _approve(address(this), address(_pancakeRouter), type(uint256).max);
        _marketMakers[pancakePairAddress]=true;
        _excludeFromFees[msg.sender]=_excludeFromFees[address(this)]=_excludeFromFees[burnWallet]=true;
        _taxes=Taxes(10,10,1,20,80);
        emit Transfer(address(0),address(this),_totalSupply);
    }
    function _transfer(address sender, address recipient, uint256 amount) private {
        require(sender != address(0) && recipient != address(0));
        bool isExcluded=_excludeFromFees[sender]||_excludeFromFees[recipient]||_inSwap||_addingLP||_removingLP;
        bool isBuy=_marketMakers[sender];
        bool isSell=_marketMakers[recipient];
        if(isExcluded)_transferExcluded(sender,recipient,amount);
        else {
            require(_tradingEnabled);
            if(isBuy)_buyTokens(sender,recipient,amount);
            else if(isSell) {
                if(!_inSwap&&swapEnabled)_swapContractTokens(swapThreshold,false);
                _sellTokens(sender,recipient,amount);
            } else {
                require(!_blacklist[sender]&&!_blacklist[recipient]);
                require(_balances[recipient]+amount<=_maxWalletSize);
                _transferExcluded(sender,recipient,amount);
            }
        }
    }
    function _buyTokens(address sender,address recipient,uint256 amount) private {
        require(!_blacklist[recipient]);
        require(_balances[recipient]+amount<=_maxWalletSize);
        uint256 taxedTokens=amount*_taxes.buyTax/100;
        _transferIncluded(sender,recipient,amount,taxedTokens,0);
    }
    function _sellTokens(address sender,address recipient,uint256 amount) private {
        require(!_blacklist[sender]);
        require(amount<=_maxTx);
        uint256 taxedTokens=amount*_taxes.sellTax/100;
        uint256 burnTokens=taxedTokens*_taxes.burnTax/100;
        _transferIncluded(sender,recipient,amount,taxedTokens,burnTokens);
    }
    function _transferIncluded(address sender,address recipient,uint256 amount,uint256 taxedTokens,uint256 burnTokens) private {
        _updateBalance(sender,_balances[sender]-amount);
        _updateBalance(address(this),_balances[address(this)]+(taxedTokens-burnTokens));
        if(burnTokens>0) _updateBalance(burnWallet,_balances[burnWallet]+burnTokens);
        _updateBalance(recipient,_balances[recipient]+(amount-taxedTokens));
        emit Transfer(sender,recipient,amount-taxedTokens);
    }
    function _transferExcluded(address sender,address recipient,uint256 amount) private {
        _updateBalance(sender,_balances[sender]-amount);
        _updateBalance(recipient,_balances[recipient]+amount);
        emit Transfer(sender,recipient,amount);
    }
    function _updateBalance(address account,uint256 newBalance) private {
        _balances[account]=newBalance;
    }
    function _swapContractTokens(uint8 _swapThreshold,bool ignoreLimits) private LockTheSwap {
        uint256 contractTokens=_balances[address(this)];
        uint256 toSwap=_swapThreshold*_balances[pancakePairAddress]/1000;
        if(contractTokens<toSwap)
            if(ignoreLimits)
                toSwap=contractTokens;
            else return;
        uint256 totalLPTokens=toSwap*_taxes.liquidityTax/100;
        uint256 tokensLeft=toSwap-totalLPTokens;
        uint256 LPTokens=totalLPTokens/2;
        uint256 LPBNBTokens=totalLPTokens-LPTokens;
        toSwap=tokensLeft+LPBNBTokens;
        uint256 oldBNB=address(this).balance;
        _swapTokensForBNB(toSwap);
        uint256 newBNB=address(this).balance-oldBNB;
        uint256 LPBNB=(newBNB*LPBNBTokens)/toSwap;
        _addLiquidity(LPTokens,LPBNB);
        uint256 remainingBNB=newBNB-LPBNB;
        uint256 marketingBNB=remainingBNB;
        (bool sent,)=marketingWallet.call{value: (marketingBNB)}("");
        require(sent);
    }
//////////////////////////////////////////////////////////////////////////////////////////////
    receive() external payable {}
    function _swapTokensForBNB(uint256 amount) private {
        address[] memory path=new address[](2);
        path[0]=address(this);
        path[1]=_pancakeRouter.WETH();
        _inSwap=true;
        _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amount,
            0,
            path,
            address(this),
            block.timestamp
        );
        _inSwap=false;
    }
    function _addLiquidity(uint256 amountTokens,uint256 amountBNB) private {
        _addingLP=true;
        _pancakeRouter.addLiquidityETH{value: amountBNB}(
            address(this),
            amountTokens,
            0,
            0,
            owner(),
            block.timestamp
        );
        _addingLP=false;
    }
//////////////////////////////////////////////////////////////////////////////////////////////
    function ownerCreatePool() public payable onlyOwner {
        require(IBEP20(pancakePairAddress).totalSupply() == 0);
        uint256 contractBalance = _balances[address(this)];
        uint256 teamTokens=contractBalance*10/100;
        uint256 contractTokens=contractBalance*10/100;
        uint256 liquidityTokens=contractBalance-(teamTokens+contractTokens);
        _transferExcluded(address(this), msg.sender, teamTokens);
        _addLiquidity(liquidityTokens, msg.value);
        require(IBEP20(pancakePairAddress).totalSupply() > 0);
    }
    function ownerEnableTrading() public onlyOwner {
        require(!_tradingEnabled);
        _tradingEnabled=true;
    }
    function ownerUpdateMaxTx(uint256 maxTx) public onlyOwner {
        require(maxTx<=_totalSupply/2&&maxTx>=5000);
        _maxTx=maxTx*(10**9);
    }
    function ownerUpdateMaxWallet(uint256 maxWallet) public onlyOwner {
        require(maxWallet>=5000); // 0.005 %
        _maxWalletSize=maxWallet*(10**9);
    }
    function ownerUpdateMarketingWallet(address _marketingWallet) public onlyOwner {
        require(_marketingWallet!=address(0));
        marketingWallet=_marketingWallet;
    }
    function ownerBlacklist(address account,bool enabled) public onlyOwner {
        _blacklist[account]=enabled;
        emit OwnerBlacklist(account,enabled);
    }
    function ownerBulkBlacklist(address[] calldata addresses,bool flag) public onlyOwner {
        for (uint256 x;x<addresses.length;++x) {
            _blacklist[addresses[x]]=flag;
        }
    }
    function ownerUpdatePrimaryTaxes(uint8 buyTax,uint8 sellTax) public onlyOwner {
        require(buyTax<=15&&sellTax<=15);
        _taxes.buyTax=buyTax;
        _taxes.sellTax=sellTax;
        emit OwnerUpdatePrimaryTaxes(buyTax,sellTax);
    }
    function ownerUpdateSecondaryTaxes(uint16 liquidityTax,uint16 marketingTax,uint16 burnTax) public onlyOwner {
        require((liquidityTax+marketingTax)<=100);
        _taxes.liquidityTax=liquidityTax;
        _taxes.marketingTax=marketingTax;
        _taxes.burnTax=burnTax;
        emit OwnerUpdateSecondaryTaxes(liquidityTax,marketingTax,burnTax);
    }
    function ownerSetSwapEnabled(bool enabled) public onlyOwner {
        swapEnabled=enabled;
        emit OwnerSetSwapEnabled(enabled);
    }
    function ownerTriggerSwap(uint8 _swapThreshold,bool ignoreLimits) public onlyOwner {
        require(_swapThreshold<=50);
        _swapContractTokens(_swapThreshold,ignoreLimits);
        emit OwnerTriggerSwap(_swapThreshold,ignoreLimits);
    }
    function ownerUpdateSwapThreshold(uint8 _swapThreshold) public onlyOwner {
        require(_swapThreshold>=1&&_swapThreshold<=50);
        swapThreshold=_swapThreshold;
        emit OwnerUpdateSwapThreshold(_swapThreshold);
    }
    function ownerExcludeFromFees(address account,bool excluded) public onlyOwner {
        _excludeFromFees[account]=excluded;
    }
    function ownerWithdrawStrandedToken(address strandedToken) public onlyOwner {
        IBEP20 token=IBEP20(strandedToken);
        token.transfer(owner(),token.balanceOf(address(this)));
    }
    function ownerWithdrawBNB() public onlyOwner {
        (bool success,)=msg.sender.call{value:(address(this).balance)}("");
        require(success);
    }
//////////////////////////////////////////////////////////////////////////////////////////////
    function allTaxes() external view returns (
        uint8 buyTax,
        uint8 sellTax,
        uint16 liquidityTax,
        uint16 marketingTax,
        uint16 burnTax) {
            buyTax=_taxes.buyTax;
            sellTax=_taxes.sellTax;
            liquidityTax=_taxes.liquidityTax;
            marketingTax=_taxes.marketingTax;
            burnTax=_taxes.burnTax;
        }
    function showMaxTx() external view returns(uint256) {
        return _maxTx;
    }
    function showMaxWallet() external view returns(uint256) {
        return _maxWalletSize;
    }
//////////////////////////////////////////////////////////////////////////////////////////////
    function _approve(address owner, address spender, uint256 amount) private {
        require((owner != address(0) && spender != address(0)), "Owner/Spender address cannot be 0.");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function transfer(address recipient, uint256 amount) external override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        uint256 allowance_ = _allowances[sender][msg.sender];
        _transfer(sender, recipient, amount);
        require(allowance_ >= amount);
        _approve(sender, msg.sender, allowance_ - amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }
    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }
    function allowance(address owner_, address spender) external view override returns (uint256) {
        return _allowances[owner_][spender];
    }
    function balanceOf(address account) external view override returns (uint256) {
        return _balances[account];
    }
    function name() external pure override returns (string memory) {
        return "Bob Token";
    }
    function symbol() external pure override returns (string memory) {
        return "BOB";
    }
    function totalSupply() external pure override returns (uint256) {
        return _totalSupply;
    }
    function decimals() external pure override returns (uint8) {
        return _decimals;
    }
    function getOwner() external view override returns (address) {
        return owner();
    }
    
}