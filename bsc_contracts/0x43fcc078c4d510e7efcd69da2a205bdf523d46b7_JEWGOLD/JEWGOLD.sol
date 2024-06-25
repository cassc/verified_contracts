/**
 *Submitted for verification at BscScan.com on 2022-11-30
*/

// Happy Merchant Inu (TICKER: JEWGOLD) - the world's first token paying PAXG Gold rewards and raising money for foreskin regeneration research!

/*                                                                         
                                                                                
                                       ,@,@/,@@    @@ .  &@                     
                                   .#,@ & @@,      , @ @@, @                    
                                 @@ @ @#                  @,*@@                 
                               @ @ @                                            
                              @ #@@#@  (                          @             
                              @  @ @ @  &@                         @            
                            @ @@%@  @%@,&@@@                        ,           
                         #% *@ @ @ *@@@  *     @   @ @ &(   %#@#,@/  @          
                [email protected]       @@@#@   @@@ @ @@      @@        @&@  ,@ @ @@ @@        
              #       %    (@@     @@ (/@    @ @    @@   @ @       @@( /        
            @   &      &    @ &   @  @@         @@@ #@@  &@  @    @@@ @         
           @   @        @   @ &@ #   @*            ,  @@@,,          @          
          *              /  @  # @@  @@  @@                            @        
         @    @           , @#      @#  /,                              &       
         &*   @             @      [email protected]#(@   @@@ @      .  @@      (       @      
        &     @            @@/ .   @ @@%/ & /@.#@@  @@@#@  /@@           .      
       &     #@              /  @ % @@# &@ [email protected]@@*@@@@@@@@ @ @ @@  *(             
       @     @*             *    *,%/@@@#,@  @  (/ , @ @@%%% @ *@ @  @@   /     
       @     @               /   @  @@    @@@@ @  @ #@,&        @@ .            
       @       @             %    &@%@(@%@@@@(@  @ ,@@ @/   @  @                
      (       *@              @  @@ (#@@ @   @ %        @@, @ @@                
      @       @                /   @   @# @@@@ @@@@ @*       @&&*               
      @         &                 &[email protected]& @  % @@@ @  @#@ @@@&@,@  % % %           
    @          @,                  @     /@  ,@@/@@@#@[email protected]@@ @*     &@            
    @           *                  @(  @%, &,@ @@( @ @&@ @@     @   %   @       
                                    / @&@  @@@ @/ @*@@@#@        @%(      #     
    &            @ #                 @   %@  @   @*  @                   *@     
                  @              ..   ,                @     @   @%       .     
                   @                 #                 (@    @  @ , & @ &       
                    .                *                 @#   @           @       
                      %             (       /         @@    @@@    @&           
                        &                  ,       ,                            
                          @            # @    @                                 
                            /*  ,       @@                                      
                                            
*/                             
//SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.4;

library SafeMath {
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
    }
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
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
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");
        return c;
    }
}

interface IBEP20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function symbol() external view returns (string memory);
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint8);
    function balanceOf(address account) external view returns (uint256);
    function name() external view returns (string memory);
    function getOwner() external view returns (address);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
    function WETH() external pure returns (address);
    function factory() external pure returns (address);
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
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
}

abstract contract Ownable {
    address public owner;
    address public creator;
    mapping (address => bool) internal authorizations;
    constructor(address owner_) {
        owner = owner_;
    }
    modifier onlyOwner() {
        require(isOwner(msg.sender), "Ownership required."); _;
    }
    modifier authorized() {
        require(isAuthorized(msg.sender) || isCreator(msg.sender), "!AUTHORIZED"); _;
    }
    function authorize(address adr) public authorized {
        authorizations[adr] = true;
    }    
    function isCreator(address account) public view returns (bool) {
        return account == creator;
    }
    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }
    function transferOwnership(address payable adr) public onlyOwner {
        address oldOwner = owner;
        owner = adr;
        emit OwnershipTransferred(oldOwner, owner);
    }
	function renouceOwnership() public onlyOwner {
		emit OwnershipTransferred(owner, address(0));
		owner = address(0);
	}
    event OwnershipTransferred(address from, address to);
}

interface IDividendDistributor {
    function setShare(address shareholder, uint256 amount) external;
    function process(uint256 gas) external;
    function claimDividend() external;
    function deposit() external payable;
    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) external;
}

contract DividendDistributor is IDividendDistributor {
    using SafeMath for uint256;
    address _token;
	
    IBEP20 BUSD = IBEP20(0x7950865a9140cB519342433146Ed5b40c6F210f7); // Mainnet
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // Mainnet
//    IBEP20 BUSD = IBEP20(0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee); // Testnet
//    address WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd; // Testnet

    struct Share {
        uint256 amount;
        uint256 totalExcluded;
        uint256 totalRealised;
    }
    IDEXRouter router;
    mapping (address => Share) public shares;
    mapping (address => uint256) shareholderIndexes;
    uint256 public totalShares;
    uint256 public dividendsPerShare;
    uint256 public dividendsPerShareAccuracyFactor = 10 ** 36;
    address[] shareholders;
    mapping (address => uint256) shareholderClaims;
    uint256 public minPeriod = 1 hours; // min 1 hour delay
    uint256 public minDistribution = 1 * (10 ** 1); // 1 BUSD minimum auto send
    uint256 public totalDividends;
    uint256 public totalDistributed;
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
            : IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); // Mainnet
//  		: IDEXRouter(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); // Testnet
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
    function getCumulativeDividends(uint256 share) internal view returns (uint256) {
        return share.mul(dividendsPerShare).div(dividendsPerShareAccuracyFactor);
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
    function claimDividend() external override {
        distributeDividend(msg.sender);
    }
    function removeShareholder(address shareholder) internal {
        shareholders[shareholderIndexes[shareholder]] = shareholders[shareholders.length-1];
        shareholderIndexes[shareholders[shareholders.length-1]] = shareholderIndexes[shareholder];
        shareholders.pop();
    }
    function getUnpaidEarnings(address shareholder) public view returns (uint256) {
        if(shares[shareholder].amount == 0){ return 0; }
        uint256 shareholderTotalDividends = getCumulativeDividends(shares[shareholder].amount);
        uint256 shareholderTotalExcluded = shares[shareholder].totalExcluded;
        if(shareholderTotalDividends <= shareholderTotalExcluded){ return 0; }
        return shareholderTotalDividends.sub(shareholderTotalExcluded);
    }
    function addShareholder(address shareholder) internal {
        shareholderIndexes[shareholder] = shareholders.length;
        shareholders.push(shareholder);
    }
}

contract JEWGOLD is IBEP20, Ownable {
    using SafeMath for uint256;
    string constant _name = "Happy Merchant Inu";
    string constant _symbol = "JEWGOLD";
    uint8 constant _decimals = 9;
    uint256 _totalSupply = 3 * 10 ** 8 * (10 ** _decimals);
    uint256 public liquidityFee = 15;
    uint256 public burnFee = 0;
    uint256 public reflectionFee = 30;
    uint256 public marketingFee = 15;
    uint256 public buybackFee = 10;
    uint256 public _maxTxAmount = _totalSupply / 100;
    uint256 public _maxHold = _totalSupply / 50;
    address public marketingFeeReceiver = 0xD5870aA191dB3a14B1534C1c242731ae829C45D5;
    address public buybackFeeReceiver = 0x8383719D1AA4390E22bb5c5a4beE57B8a89F5Ef4;

    address BUSD = 0x7950865a9140cB519342433146Ed5b40c6F210f7; // Mainnet
	address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // Mainnet
//	address BUSD = 0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee; // Testnet
//  address WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd; // Testnet

    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    mapping (address => bool) isTxLimitExempt;
    mapping (address => uint256) _balances;
    mapping (address => mapping (address => uint256)) _allowances;
    mapping (address => bool) isMaxHoldExempt;
    mapping (address => bool) isFeeExempt;
    mapping (address => bool) isDividendExempt;
    mapping(address=>bool) isBlacklisted;
    uint256 targetLiquidity = 20;
    uint256 targetLiquidityDenominator = 100;
    uint256 public feeDenominator = 1000;
    uint256 totalFee = liquidityFee + reflectionFee + marketingFee + buybackFee + burnFee;
    address public autoLiquidityReceiver;
    address[] public pairs;
    IDEXRouter public router;
    address pancakeV2BNBPair;
    DividendDistributor distributor;
    uint256 distributorGas = 600000;
    uint256 public launchedAt;
    bool public isTxLimited = true;
    bool public liquifyEnabled = true;
    bool public feesOnNormalTransfers = true;
    bool public swapEnabled = true;
    bool inSwap;
    uint256 public swapThreshold = _totalSupply / 100; // 0.02%
    modifier swapping() { inSwap = true; _; inSwap = false; }
    event SwapBackSuccess(uint256 amount);
    event Launched(uint256 blockNumber, uint256 timestamp);
    event BuybackTransfer(bool status);
    event SwapBackFailed(string message);
    event AutoLiquify(uint256 amountBNB, uint256 amountBOG);
    event MarketTransfer(bool status);
    constructor () Ownable(msg.sender) {
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E); // Mainnet
//		router = IDEXRouter(0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3); // Testnet
        
		autoLiquidityReceiver = DEAD;
        pancakeV2BNBPair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
        _allowances[address(this)][address(router)] = ~uint256(0);
        pairs.push(pancakeV2BNBPair);
        distributor = new DividendDistributor(address(router));
        address owner_ = msg.sender;
        isDividendExempt[DEAD] = true;
        isMaxHoldExempt[DEAD] = true;
        isMaxHoldExempt[pancakeV2BNBPair] = true;
        isDividendExempt[pancakeV2BNBPair] = true;
        isMaxHoldExempt[address(this)] = true;
        isFeeExempt[address(this)] = true;
        isDividendExempt[address(this)] = true;
        isTxLimitExempt[address(this)] = true;
        isFeeExempt[owner_] = true;
        isTxLimitExempt[owner_] = true;
        isMaxHoldExempt[owner_] = true;
        _balances[owner_] = _totalSupply;
        emit Transfer(address(0), owner_, _totalSupply);
    }
    receive() external payable { }
    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }
    function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
    function decimals() external pure override returns (uint8) { return _decimals; }
    function name() external pure override returns (string memory) { return _name; }
    function symbol() external pure override returns (string memory) { return _symbol; }
    function getOwner() external view override returns (address) { return owner; }
    function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
    function totalSupply() external view override returns (uint256) { return _totalSupply; }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return _transferFrom(msg.sender, recipient, amount);
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if(_allowances[sender][msg.sender] != ~uint256(0)){
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender].sub(amount, "Insufficient Allowance");
        }
        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        require(!isBlacklisted[sender] && !isBlacklisted[recipient], "Recipient is backlisted");
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }
        checkTxLimit(sender, amount);
        if(shouldSwapBack()){ swapBack(swapThreshold); }
        if(!launched() && recipient == pancakeV2BNBPair){ require(_balances[sender] > 0); launch(); }
        if(!isMaxHoldExempt[recipient]){
            require((_balances[recipient] + (amount - amount * totalFee / feeDenominator))<= _maxHold, "Wallet cannot hold more than 1%");
        
        }
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        uint256 amountReceived = shouldTakeFee(sender, recipient) ? takeFee(sender, amount) : amount;
        _balances[recipient] = _balances[recipient].add(amountReceived);
        if(!isDividendExempt[sender]){ try distributor.setShare(sender, _balances[sender]) {} catch {} }
        if(!isDividendExempt[recipient]){ try distributor.setShare(recipient, _balances[recipient]) {} catch {} }
        try distributor.process(distributorGas) {} catch {}
        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, ~uint256(0));
    }

    function getTotalFee() public view returns (uint256) {
        if(launchedAt + 1 >= block.number){ return feeDenominator.sub(1); }
        return totalFee;
    }

    function shouldTakeFee(address sender, address recipient) internal view returns (bool) {
        if (isFeeExempt[sender] || isFeeExempt[recipient] || !launched()) return false;
        address[] memory liqPairs = pairs;
        for (uint256 i = 0; i < liqPairs.length; i++) {
            if (sender == liqPairs[i] || recipient == liqPairs[i]) return true;
        }
        return feesOnNormalTransfers;
    }

    function isSell(address recipient) internal view returns (bool) {
        address[] memory liqPairs = pairs;
        for (uint256 i = 0; i < liqPairs.length; i++) {
            if (recipient == liqPairs[i]) return true;
        }
        return false;
    }

    function checkTxLimit(address sender, uint256 amount) internal view {
        require(amount <= _maxTxAmount || isTxLimitExempt[sender] || !isTxLimited, "TX Limit Exceeded");
    }

    function takeFee(address sender, uint256 amount) internal returns (uint256) {
        uint256 feeAmount = amount.mul(getTotalFee()).div(feeDenominator);
        uint256 burnAmount = feeAmount.mul(burnFee).div(totalFee);
        uint256 finalFee = feeAmount.sub(burnAmount);
        _balances[address(this)] = _balances[address(this)].add(finalFee);
        _balances[DEAD] = _balances[DEAD].add(burnAmount);
        emit Transfer(sender, DEAD, burnAmount);
        emit Transfer(sender, address(this), finalFee);
        return amount.sub(feeAmount);
    }

    function setIsMaxHoldExempt(address holder, bool exempt) public authorized() {
        isMaxHoldExempt[holder] = exempt;
    }

    function setIsTxLimitExempt(address holder, bool exempt) public authorized() {
        isTxLimitExempt[holder] = exempt;
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pancakeV2BNBPair
        && !inSwap
        && swapEnabled
        && _balances[address(this)] >= swapThreshold;
    }

    function launch() internal {
        launchedAt = block.number;
        emit Launched(block.number, block.timestamp);
    }

    function setIsDividendExempt(address holder, bool exempt) public authorized() {
        require(holder != address(this) && holder != pancakeV2BNBPair);
        isDividendExempt[holder] = exempt;
        if(exempt){
            distributor.setShare(holder, 0);
        }else{
            distributor.setShare(holder, _balances[holder]);
        }
    }

    function launched() internal view returns (bool) {
        return launchedAt != 0;
    }

    function blackList(address _user) public onlyOwner {
        require(!isBlacklisted[_user], "user already blacklisted");
        isBlacklisted[_user] = true;
        // emit events as well
    }
    
    function removeFromBlacklist(address _user) public authorized {
        require(isBlacklisted[_user], "user already whitelisted");
        isBlacklisted[_user] = false;
        // emit events as well
    }

    function burnStuckToken (uint256 amount) external authorized {
        _transferFrom(address(this), DEAD, amount);
    }

    function setIsFeeExempt(address holder, bool exempt) public authorized() {
        isFeeExempt[holder] = exempt;
    }

    function setDistributionCriteria(uint256 _minPeriod, uint256 _minDistribution) public authorized() {
        distributor.setDistributionCriteria(_minPeriod, _minDistribution);
    }

    function setDistributorSettings(uint256 gas) public authorized() {
        require(gas <= 1000000);
        distributorGas = gas;
    }

    function enableTxLimit(bool enabled) external authorized {
        isTxLimited = enabled;
    }

    function setFeesOnNormalTransfers(bool _enabled) public authorized() {
        feesOnNormalTransfers = _enabled;
    }

    function setFees(uint256 _liquidityFee, uint256 _reflectionFee, uint256 _marketingFee, uint256 _buybackFee, uint256 _burnFee, uint256 _feeDenominator) public authorized() {
        liquidityFee = _liquidityFee;
        reflectionFee = _reflectionFee;
        marketingFee = _marketingFee;
        buybackFee = _buybackFee;
        burnFee = _burnFee;
        totalFee = _liquidityFee.add(_reflectionFee).add(_marketingFee).add(_buybackFee).add(_burnFee);
        feeDenominator = _feeDenominator;
        require(totalFee < feeDenominator/8);
    }

    function setFeeReceivers(address _buybackFeeReciever, address _autoLiquidityReceiver, address _marketingFeeReceiver) public authorized() {
        buybackFeeReceiver = _buybackFeeReciever;
        autoLiquidityReceiver = _autoLiquidityReceiver;
        marketingFeeReceiver = _marketingFeeReceiver;
    }

    function setSwapBackSettings(bool _enabled, uint256 _amount) public authorized() {
        swapEnabled = _enabled;
        swapThreshold = _amount;
    }

    function setLiquifyEnabled(bool _enabled) public authorized() {
        liquifyEnabled = _enabled;
    }

    function triggerSwapBack(uint256 contractSellAmount) external authorized() {
        swapBack(contractSellAmount);
    }

    function getCirculatingSupply() public view returns (uint256) {
        return _totalSupply.sub(balanceOf(DEAD)).sub(balanceOf(ZERO));
    }

    function addPair(address pair) public authorized() {
        pairs.push(pair);
    }

    function claimDividend() external {
        distributor.claimDividend();
    }

    function clearStuckBNB() external authorized() {
        payable(marketingFeeReceiver).transfer(address(this).balance);
    }

    function setMaxHoldPercentage(uint256 percent) public authorized() {
         _maxHold = (_totalSupply / 100) * percent;
         require(percent > 1);
    }    

    function setLaunchedAt(uint256 launched_) public authorized() {
        launchedAt = launched_;
    }
    
    function removeLastPair() public authorized() {
        pairs.pop();
    }
    function getLiquidityBacking(uint256 accuracy) public view returns (uint256) {
        return accuracy.mul(balanceOf(pancakeV2BNBPair).mul(2)).div(getCirculatingSupply());
    }
    function isOverLiquified(uint256 target, uint256 accuracy) public view returns (bool) {
        return getLiquidityBacking(accuracy) > target;
    }

    function swapBack(uint256 internalThreshold) internal swapping {
        uint256 dynamicLiquidityFee = isOverLiquified(targetLiquidity, targetLiquidityDenominator) ? 0 : liquidityFee;
        uint256 amountToLiquify = internalThreshold.mul(dynamicLiquidityFee).div(totalFee).div(2);
        uint256 amountToSwap = internalThreshold.sub(amountToLiquify);
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;
        uint256 balanceBefore = address(this).balance;
        try router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        ) {
            uint256 amountBNB = address(this).balance.sub(balanceBefore);
            uint256 totalBNBFee = totalFee.sub(dynamicLiquidityFee.div(2));
            uint256 amountBNBLiquidity = amountBNB.mul(dynamicLiquidityFee).div(totalBNBFee).div(2);
            uint256 amountBNBReflection = amountBNB.mul(reflectionFee).div(totalBNBFee);
            uint256 amountBNBMarketing = amountBNB.mul(marketingFee).div(totalBNBFee);
            uint256 amountBNBBuyback = amountBNB.mul(buybackFee).div(totalBNBFee);
            try distributor.deposit{value: amountBNBReflection}() {} catch {}
            (bool marketSuccess, ) = payable(marketingFeeReceiver).call{value: amountBNBMarketing, gas: 30000}("");
            (bool buybackSuccess, ) = payable(buybackFeeReceiver).call{value: amountBNBBuyback, gas: 30000}("");
            emit MarketTransfer(marketSuccess);
            emit BuybackTransfer(buybackSuccess);
            if(amountToLiquify > 0){
                try router.addLiquidityETH{ value: amountBNBLiquidity }(
                    address(this),
                    amountToLiquify,
                    0,
                    0,
                    autoLiquidityReceiver,
                    block.timestamp
                ) {
                    emit AutoLiquify(amountToLiquify, amountBNBLiquidity);
                } catch {
                    emit AutoLiquify(0, 0);
                }
            }
            emit SwapBackSuccess(amountToSwap);
        } catch Error(string memory e) {
            emit SwapBackFailed(string(abi.encodePacked("SwapBack failed with error ", e)));
        } catch {
            emit SwapBackFailed("SwapBack failed without an error message from pancakeSwap");
        }
    }
}