import "./SafeMath.sol";
import "./IDEXStuff.sol";


//SPDX-License-Identifier: MITa

pragma solidity ^0.8.7;

/**
 * Standard SafeMath, stripped down to just add/sub/mul/div
 */


/**
 * BEP20 standard interface.
 */
/* Interface for the DividendDistributor */
interface IDividendDistributor {
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
    function setShare(address shareholder, uint256 amount) external;
    function deposit() external payable;
    function process(uint256 gas) external;
}

/* Our DividendDistributor contract responsible for distributing the earn token */
contract DividendDistributor is IDividendDistributor {
    using SafeMath for uint256;

    address _token;

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }

    // EARN
    IBEP20  BUSD = IBEP20(0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56);
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    IDEXRouter router;

    address[] shareholders;
    mapping (address => uint256) shareholderIndexes;
    mapping (address => uint256) shareholderClaims;

    mapping (address => Share) public shares;

    uint256 public totalShares;
    uint256 public totalDividends;
    uint256 public totalDistributed;
    uint256 public dividendsPerShare;
    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;

    uint256 public minPeriod = 30 * 60;
    uint256 public minDistribution = 1 * (10 ** 12);

    uint256 currentIndex;

    bool initialized;
    modifier initialization() {
        require(!initialized);
        _;
        initialized = true;
    }

    modifier onlyToken() {
        require(msg.sender == _token); _;
    }

    constructor (address _router) {
        router = _router != address(0)
            ? IDEXRouter(_router)
            : IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        _token = msg.sender;
    }

    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external override onlyToken {
        minPeriod = _minPeriod;
        minDistribution = _minDistribution;
    }

    function setShare(address shareholder, uint256 amount) external override onlyToken {
        if(shares[shareholder].amount > 0){
            distributeDividend(shareholder);
        }

        if(amount > 0 && shares[shareholder].amount == 0){
            addShareholder(shareholder);
        }else if(amount == 0 && shares[shareholder].amount > 0){
            removeShareholder(shareholder);
        }

        totalShares = totalShares.sub(shares[shareholder].amount).add(amount);
        shares[shareholder].amount = amount;
        shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
    }

    function deposit() external payable override onlyToken {
        uint256 balanceBefore = BUSD.balanceOf(address(this));

        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = address(BUSD);

        router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: msg.value}(
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amount = BUSD.balanceOf(address(this)).sub(balanceBefore);

        totalDividends = totalDividends.add(amount);
        dividendsPerShare = dividendsPerShare.add(dividendsPerShareAccuracyFactor.mul(amount).div(totalShares));
    }

    function process(uint256 gas) external override onlyToken {
        uint256 shareholderCount = shareholders.length;

        if(shareholderCount == 0) { return; }

        uint256 gasUsed = 0;
        uint256 gasLeft = gasleft();

        uint256 iterations = 0;

        while(gasUsed < gas && iterations < shareholderCount) {
            if(currentIndex >= shareholderCount){
                currentIndex = 0;
            }

            if(shouldDistribute(shareholders[currentIndex])){
                distributeDividend(shareholders[currentIndex]);
            }

            gasUsed = gasUsed.add(gasLeft.sub(gasleft()));
            gasLeft = gasleft();
            currentIndex++;
            iterations++;
        }
    }
    
    function shouldDistribute(address shareholder) internal view returns (bool) {
        return shareholderClaims[shareholder] + minPeriod < block.timestamp
                && getUnpaidEarnings(shareholder) > minDistribution;
    }

    function distributeDividend(address shareholder) internal {
        if(shares[shareholder].amount == 0){ return; }

        uint256 amount = getUnpaidEarnings(shareholder);
        if(amount > 0){
            totalDistributed = totalDistributed.add(amount);
            BUSD.transfer(shareholder, amount);
            shareholderClaims[shareholder] = block.timestamp;
            shares[shareholder].totalRealised = shares[shareholder].totalRealised.add(amount);
            shares[shareholder].totalExcluded = getCumulativeDividends(shares[shareholder].amount);
        }
    }
    
    function claimDividend(address shareholder) external onlyToken{
        distributeDividend(shareholder);
    }

    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }

        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;

        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }

        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }

    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
    }

    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }

    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
}

/* Token contract */
contract DeerRun is IBEP20, Auth {
    using SafeMath for uint256;

    // Addresses
    address BUSD = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; 
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address DEV = 0x3411B759fE6BA39D7a963d01ac4632ba285f5D63;

    // These are owner by default
    address private autoLiquidityReceiver;
    address private marketingFeeReceiver;

    // Name and symbol
    string constant _name = "Deer Run";
    string constant _symbol = "DeeR";
    uint8 constant _decimals = 9;

    // Total supply
    uint256 _totalSupply = 1000000 * (10 ** _decimals); // 1mill

    // Max wallet and TX
    uint256 public _maxBuyTxAmount = _totalSupply * 100 / 10000; 
    uint256 public _maxSellTxAmount = _totalSupply * 100 / 10000;
    uint256 public _maxWalletToken = ( _totalSupply * 25 ) / 10000; // 2.5% or 2B tokens

    // Mappings
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;
    mapping (address => bool) isFeeExempt;
    mapping (address => bool) isTxLimitExempt;
    mapping (address => bool) isTimelockExempt;
    mapping (address => bool) isDividendExempt;
    mapping (address => bool) public isBlacklisted;
    
    // Buy Fees
    uint256 public liquidityFeeBuy = 1; 
    uint256 public marketingFeeBuy = 1;
    uint256 public devFeeBuy = 1;
    uint256 public totalFeeBuy = 3;

    // Sell fees
    uint256 public liquidityFeeSell = 1;
    uint256 public rewardFeeSell = 3;
    uint256 public marketingFeeSell = 1;
    uint256 public devFeeSell = 1;
    uint256 public totalFeeSell = 6;

    // Fee variables
    uint256 liquidityFee;
    uint256 buybackFee;
    uint256 rewardFee;
    uint256 marketingFee;
    uint256 devFee;
    uint256 totalFee;
    uint256 feeDenominator = 100;

    // GREED
    uint256 GREEDTriggeredAt;
    uint256 GREEDDuration = 3600;
    
    // Dead blocks
    uint256 deadBlocks = 3;

    // Sell amount of tokens when a sell takes place
    uint256 public swapThreshold = 1000 * 10**_decimals; // 2% of supply

    // Liquidity
    uint256 targetLiquidity = 200;
    uint256 targetLiquidityDenominator = 100;

    DividendDistributor distributor;
    uint256 distributorGas = 500000;


    // Other variables
    IDEXRouter public router;
    address public pair;
    bool public tradingOpen = false;
    bool public swapEnabled = true;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    /* Token constructor */
    constructor () Auth(msg.sender) {

        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;

        distributor = new DividendDistributor(address(router));
        
        // Should be the owner wallet/token distributor
        address _presaler = msg.sender;
        isFeeExempt[_presaler] = true;
        isTxLimitExempt[_presaler] = true;
        
        // No timelock for these people
        isTimelockExempt[msg.sender] = true;
        isTimelockExempt[address(0x00)] = true;
        isTimelockExempt[address(this)] = true;
        isTimelockExempt[DEV] = true;
        
        // Exempt from dividend
        isDividendExempt[pair] = true;
        isDividendExempt[address(this)] = true;
        isDividendExempt[address(0x00)] = true;

        // Set the marketing and liq receiver to the owner as default
        autoLiquidityReceiver = msg.sender;
        marketingFeeReceiver = 0x28D7FB4a69BE90197c57E04485CbE14D4Eea4eC3;

        _balances[_presaler] = _totalSupply;
        emit Transfer(address(0), _presaler, _totalSupply);
    }

    receive() external payable { }

    function totalSupply() external view override returns (uint256) { return _totalSupply; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function name() external pure override returns (string memory) { return _name; }
    function getOwner() external view override returns (address) { return owner; }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, type(uint256).max);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != type(uint256).max){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }
        return _transferFrom(sender, recipient, amount);
    }

    // settting the max wallet in percentages
    // NOTE: 1% = 100
     function setMaxWalletPercent(uint256 maxWallPercent) external onlyOwner() {
        _maxWalletToken = _totalSupply.mul(maxWallPercent).div(10000);

    }

    // Main transfer function
    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        // Check if trading is enabled
        if(!authorizations[sender] && !authorizations[recipient]){
            require(tradingOpen,"Trading not enabled yet");
        }

        // Check if address is blacklisted
        require(!isBlacklisted[recipient] && !isBlacklisted[sender], 'Address is blacklisted');

        // Check if buying or selling
        bool isSell = recipient == pair; 

        // Set buy or sell fees
        setCorrectFees(isSell);

        // Check max wallet
        checkMaxWallet(sender, recipient, amount);
   
        // Checks maxTx
        checkTxLimit(sender, amount, recipient, isSell);

        // Check if we are in GREEDTime
        bool GREEDMode = inGREEDTime();

        // Check if we should do the swapback
        if(shouldSwapBack()){ swapBack(); }

        //Exchange tokens
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        uint256 amountReceived = shouldTakeFee(sender) ? takeFee(sender, amount, isSell, GREEDMode) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);

        // Dividend tracker
        if(!isDividendExempt[sender]) {
            try distributor.setShare(sender, _balances[sender]) {} catch {}
        }

        if(!isDividendExempt[recipient]) {
            try distributor.setShare(recipient, _balances[recipient]) {} catch {} 
        }

        try distributor.process(distributorGas) {} catch {}

        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    // Do a normal transfer
    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    // Set the correct fees for buying or selling
    function setCorrectFees(bool isSell) internal {
        if(isSell){
            liquidityFee = liquidityFeeSell;
            rewardFee = rewardFeeSell;
            marketingFee = marketingFeeSell;
            devFee = devFeeSell;
            totalFee = totalFeeSell;
        } else {
            liquidityFee = liquidityFeeBuy;
            rewardFee = 0;
            marketingFee = marketingFeeBuy;
            devFee = devFeeBuy;
            totalFee = totalFeeBuy;
        }
    }

    // Check if we are in GREED time
    function inGREEDTime() public view returns (bool){
        if(GREEDTriggeredAt.add(GREEDDuration) > block.timestamp){
            return true;
        } else {
            return false;
        }
    }


    // Check for maxTX
    function checkTxLimit(address sender, uint256 amount, address recipient, bool isSell) internal view {
        if (recipient != owner){
            if(isSell){
                require(amount <= _maxSellTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
            } else {
                require(amount <= _maxBuyTxAmount || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "TX Limit Exceeded");
            }
        }
    }


    // Check maxWallet
    function checkMaxWallet(address sender, address recipient, uint256 amount) internal view {
        if (!authorizations[sender] && recipient != owner && recipient != address(this)  && recipient != address(0x00) && recipient != pair && recipient != marketingFeeReceiver && recipient != autoLiquidityReceiver && recipient != DEV){
            uint256 heldTokens = balanceOf(recipient);
            require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");
        }
    }

    // Check if sender is not feeExempt
    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    // Take the normal total Fee or the GREED Fee
    function takeFee(address sender, uint256 amount, bool isSell, bool GREEDMode) internal returns (uint256) {
        uint256 feeAmount;
        
        // Check if we are GREEDd
        if (GREEDMode){
            if(isSell){
                // We are selling so up the selling tax to 1.5x
                feeAmount = amount.mul(totalFee).mul(3).div(2).div(feeDenominator);
            } else {
                // We are buying so cut our taxes in half
                feeAmount = amount.mul(totalFee).div(2).div(feeDenominator);
            }
        } else {
            feeAmount = amount.mul(totalFee).div(feeDenominator);
        }

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);

        return amount.sub(feeAmount);
    }

    // Check if we should sell tokens
    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    // switch Trading
    function tradingStatus() public onlyOwner {
        tradingOpen = true;
    }

    // Enable GREED
    function enableGREED(uint256 _seconds) public authorized {
        GREEDTriggeredAt = block.timestamp;
        GREEDDuration = _seconds;
    }

    // Disable the GREED mode
    function disableGREED() external authorized {
        GREEDTriggeredAt = 0;
    }

    // Blacklist/unblacklist an address
    function blacklistAddress(address _address, bool _value) public authorized{
        isBlacklisted[_address] = _value;
    }

    // Main swapback to sell tokens for WBNB
    function swapBack() internal swapping {
        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
        uint256 amountToLiquify = swapThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = swapThreshold.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        uint256 balanceBefore = address(this).balance;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountBNB = address(this).balance.sub(balanceBefore);
        uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2));
        uint256 amountBNBLiquidity = amountBNB.mul(dynamicLiquidityFee).div(totalBNBFee).div(2);
        uint256 rewardBNB = amountBNB.mul(rewardFee).div(totalBNBFee.mul(2));
        try distributor.deposit{value: rewardBNB}() {} catch {}

        (bool successRewardWallet, /* bytes memory data */) = payable(0x4D0197738056452467401B11a8479Ba3a417a9F6).call{value: rewardBNB, gas: 30000}("");
        (bool successMarketing, /* bytes memory data */) = payable(marketingFeeReceiver).call{value: amountBNB.mul(marketingFee).div(totalBNBFee), gas: 30000}("");
        (bool successDev, /* bytes memory data */) = payable(DEV).call{value: amountBNB.mul(devFee).div(totalBNBFee), gas: 30000}(""); 

        require(successMarketing, "marketing receiver rejected the transfer");
        require(successDev, "dev receiver rejected the transfer");
        require(successRewardWallet, 'reward wallet rejected the transfer');

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                autoLiquidityReceiver,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
    }

    // Set max buy TX 
    function setBuyTxLimitInPercent(uint256 maxBuyTxPercent) external authorized {
        _maxBuyTxAmount = _totalSupply.mul(maxBuyTxPercent).div(10000);
    }

    // Set max sell TX 
    function setSellTxLimitInPercent(uint256 maxSellTxPercent) external authorized {
        _maxSellTxAmount = _totalSupply.mul(maxSellTxPercent).div(10000);
    }

    // Exempt from dividend
    function setIsDividendExempt(address holder, bool exempt) external authorized {
        require(holder != address(this) && holder != pair);
        isDividendExempt[holder] = exempt;
        if(exempt){
            distributor.setShare(holder, 0);
        }else{
            distributor.setShare(holder, _balances[holder]);
        }
    }

    // Exempt from fee
    function setIsFeeExempt(address holder, bool exempt) external authorized {
        isFeeExempt[holder] = exempt;
    }

    // Exempt from max TX
    function setIsTxLimitExempt(address holder, bool exempt) external authorized {
        isTxLimitExempt[holder] = exempt;
    }

    // Exempt from buy CD
    function setIsTimelockExempt(address holder, bool exempt) external authorized {
        isTimelockExempt[holder] = exempt;
    }

    // Set our buy fees
    function setBuyFees(uint256 _liquidityFeeBuy, uint256 _marketingFeeBuy, uint256 _devFeeBuy) external authorized {
        require(_liquidityFeeBuy + _marketingFeeBuy + _devFeeBuy < 5,"Buy fees cant be more than 5%");
        require(_marketingFeeBuy >=1);
        liquidityFeeBuy = _liquidityFeeBuy;
        marketingFeeBuy = _marketingFeeBuy;
        devFeeBuy = _devFeeBuy;
        totalFeeBuy = _liquidityFeeBuy.add(_marketingFeeBuy).add(_devFeeBuy);
    }

    // Set our sell fees
    function setSellFees(uint256 _liquidityFeeSell, uint256 _rewardFeeSell, uint256 _marketingFeeSell, uint256 _devFeeSell) external authorized {
        require(_liquidityFeeSell + _marketingFeeSell + _devFeeSell < 5,"Buy fees cant be more than 5%");
        require(_rewardFeeSell < 12, "because of jeeters");
        require(_marketingFeeSell>= 1);
        liquidityFeeSell = _liquidityFeeSell;
        rewardFeeSell = _rewardFeeSell;
        marketingFeeSell = _marketingFeeSell;
        devFeeSell = _devFeeSell;
        totalFeeSell = _liquidityFeeSell.add(_rewardFeeSell).add(_marketingFeeSell).add(_devFeeSell);
    }

    // Set swapBack settings
    function setSwapBackSettings(bool _enabled, uint256 _amount) external authorized {
        swapEnabled = _enabled;
        swapThreshold = _totalSupply * _amount / 10000; 
    }

    // Set target liquidity
    function setTargetLiquidity(uint256 _target, uint256 _denominator) external authorized {
        targetLiquidity = _target;
        targetLiquidityDenominator = _denominator;
    }

    // Send BNB to marketingwallet
    function manualSend() external authorized {
        uint256 contractETHBalance = address(this).balance;
        payable(DEV).transfer(contractETHBalance);
    }
    
    // Set criteria for auto distribution
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external authorized {
        distributor.setDistributionCriteria(_minPeriod, _minDistribution);
    }
    
    // Let people claim there dividend
    function claimDividend() external {
        distributor.claimDividend(msg.sender);
    }
    
    // Check how much earnings are unpaid
    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        return distributor.getUnpaidEarnings(shareholder);
    } 

    // Set gas for distributor
    function setDistributorSettings(uint256 gas) external authorized {
        require(gas < 750000);
        distributorGas = gas;
    }
    
    // Get the circulatingSupply
    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(address(0x00))).sub(balanceOf(address(0x00)));
    }

    // Get the liquidity backing
    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
        return accuracy.mul(balanceOf(pair).mul(2)).div(getCirculatingSupply());
    }

    // Get if we are over liquified or not
    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
        return getLiquidityBacking(accuracy) > target;
    }
    
    event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
    event BuybackMultiplierActive(uint256 duration);
}