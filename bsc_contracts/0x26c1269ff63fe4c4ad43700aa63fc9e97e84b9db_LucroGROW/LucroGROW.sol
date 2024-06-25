/**
 *Submitted for verification at BscScan.com on 2022-09-15
*/

/*

@lucrogrow

BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBGGGGPPPPPPPPPPGGGGBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBGGPPP55555555555555555PPGGBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBGGPP5555555555555555555555555PGGBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBGGPPPPP5555555555555555555555555555PGBBBBBBBBBBBBBB
BBBBBBBBBBBBGGPPPPPPPPP555PP5Y?!~!?Y555555555555555PGBBBBBBBBBBBB
BBBBBBBBBBBGGPPPPPPPPPPPP5Y7~^:::::^~7J55555555555555PBBBBBBBBBBB
BBBBBBBBBBGGPPPPPPPPPP5J!^:::::::::::::^!?Y55555555555PGBBBBBBBBB
BBBBBBBBBGGPPPPPPPPJ7~^::::^:::::::::^::::^~7J555555555PGBBBBBBBB
BBBBBBBBGGPPPPPPPPJ7^::^~?YJ:::::::::JJ7~:::^7JY55555555PBBBBBBBB
BBBBBBBBGGGGPPPPGJ.^7?J5PPPJ:::::::::JPP5YJ?!^.?555555555GBBBBBBB
BBBBBBBBGGGGGGPPGJ   ^GPPPPJ:::::::::JP555P^   ?555555555PBBBBBBB
BBBBBBBBGGGGGGGGGJ   ^PPPPPJ:::::::::YP555P^   ?555555555PGBBBBBB
BBBBBBBBGGGGGGGGGJ   ^PPPPPJ:::::::::YPP55P^   ?P55555555PGBBBBBB
BBBBBBBBGGGGGGGGGJ   ^GPPGGY::::::::^YPPPPP^   ?P55555555PGBBBBBB
BBBBBBBBGGGGGGGGGY   ^GGPY?!77!^:^!77!7Y5PP^   ?P55555555PBBBBBBB
BBBBBBBBBGGGGGGGGJ   :55!.   :75J5?:   .~Y5^   ?P5555555PGBBBBBBB
BBBBBBBBBBGGGGGGGY.    ^!?7!?7^. :~7?!77!^.   .JP5555555GBBBBBBBB
BBBBBBBBBBBGGGGGGGPY!:    :!??!^.:!7?!:    :!J5PPP5555PPBBBBBBBBB
BBBBBBBBBBBBGGGGGGGGBG5?^.   .^757^.   .^7YPPPPPPPPPPPGBBBBBBBBBB
BBBBBBBBBBBBBBGGGGGGGGGGGPJ!:   5.  :~?5PGPPPPPPPPPPPGBBBBBBBBBBB
BBBBBBBBBBBBBBBBGGGGGGGGGGGGPY7~5~7YPGGPPPPPPPPPPPPGGBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGPPPPPPPPPPPGGGBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGPPPPPPGGGBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB
BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB

*/


// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.12;

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

interface BEP20 {
    function getOwner() external view returns (address);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address _owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

abstract contract Auth {
    address internal owner;
    address internal potentialOwner;
    mapping (address => bool) internal authorizations;

    event Authorize_Wallet(address Wallet, bool Status);

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    function authorize(address adr) external onlyOwner {
        authorizations[adr] = true;
        emit Authorize_Wallet(adr,true);
    }

    function unauthorize(address adr) external onlyOwner {
        require(adr != owner, "OWNER cant be unauthorized");
        authorizations[adr] = false;
        emit Authorize_Wallet(adr,false);
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function transferOwnership(address payable adr) external onlyOwner {
        require(adr != owner, "Already the owner");
        require(adr != address(0), "Can not be zero address.");
        potentialOwner = adr;
        emit OwnershipNominated(adr);
    }

    function acceptOwnership() external {
        require(msg.sender == potentialOwner, "You must be nominated as potential owner before you can accept the role.");
        authorizations[owner] = false;
        authorizations[potentialOwner] = true;

        emit Authorize_Wallet(owner,false);
        emit Authorize_Wallet(potentialOwner,true);

        owner = potentialOwner;
        potentialOwner = address(0);
        emit OwnershipTransferred(owner);
    }

    event OwnershipTransferred(address owner);
    event OwnershipNominated(address potentialOwner);
}

interface IDEXFactory {
    function createPair(address tokenA, address tokenB) external returns (address pair);
}

interface IDEXRouter {
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

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract LucroGROW is BEP20, Auth {
    using SafeMath for uint256;

    address immutable WBNB;
    address constant DEAD = 0x000000000000000000000000000000000000dEaD;
    address constant ZERO = 0x0000000000000000000000000000000000000000;

    string public constant name = "LucroGROW";
    string public constant symbol = "lGROW";
    uint8 public constant decimals = 4;

    uint256 public constant totalSupply = 10 * 10**11 * 10**decimals;

    uint256 public _maxTxAmount = totalSupply / 400;
    uint256 public _maxWalletToken = totalSupply / 25;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) _allowances;

    bool public blacklistMode = true;
    mapping (address => bool) public isBlacklisted;

    mapping (address => bool) public isFeeExempt;
    mapping (address => bool) public isTxLimitExempt;
    mapping (address => bool) public isWalletLimitExempt;

    uint256 public liquidityFee = 10;
    uint256 public marketingFee = 40;
    uint256 public teamFee = 0;
    uint256 public marketerFee = 0;
    uint256 public devFee = 50;
    uint256 public utilityFee = 0;
    uint256 public totalFee = marketingFee + liquidityFee + teamFee + devFee + utilityFee + marketerFee;
    uint256 public constant feeDenominator = 1000;

    uint256 sellMultiplier = 350;
    uint256 buyMultiplier = 150;
    uint256 transferMultiplier = 100;

    address public marketingFeeReceiver;
    address public teamFeeReceiver;
    address public marketerFeeReceiver;
    address public devFeeReceiver;
    address public utilityFeeReceiver;

    IDEXRouter public router;
    address public immutable pair;

    bool public tradingOpen = false;
    bool public launchMode = true;

    bool public antibot = true;
    mapping (address => uint) public firstbuy;

    bool public swapEnabled = true;
    uint256 public swapThreshold = totalSupply / 500;
    bool inSwap;
    modifier swapping() { inSwap = true; _; inSwap = false; }

    constructor () Auth(msg.sender) {
        router = IDEXRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);
        WBNB = router.WETH();

        pair = IDEXFactory(router.factory()).createPair(WBNB, address(this));
        _allowances[address(this)][address(router)] = type(uint256).max;

        marketingFeeReceiver = 0x32471288b5A791d436e5A412F6333ebeA4bcA1cc;
        marketerFeeReceiver = 0x20DC63cC931bf34e37C55fBf6ec80De7a06980D9;
        teamFeeReceiver = 0x20DC63cC931bf34e37C55fBf6ec80De7a06980D9;
        devFeeReceiver = 0x20DC63cC931bf34e37C55fBf6ec80De7a06980D9;
        utilityFeeReceiver = msg.sender;

        isFeeExempt[msg.sender] = true;

        isTxLimitExempt[msg.sender] = true;
        isTxLimitExempt[DEAD] = true;
        isTxLimitExempt[ZERO] = true;
        isTxLimitExempt[utilityFeeReceiver] = true;

        isWalletLimitExempt[msg.sender] = true;
        isWalletLimitExempt[address(this)] = true;
        isWalletLimitExempt[DEAD] = true;
        isWalletLimitExempt[utilityFeeReceiver] = true;

        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    receive() external payable { }

    function getOwner() external view override returns (address) { return owner; }
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

    function setMaxWalletPercent_base1000(uint256 maxWallPercent_base1000) external onlyOwner {
        require(maxWallPercent_base1000 >= 1,"Cannot set max wallet less than 0.1%");
        _maxWalletToken = (totalSupply * maxWallPercent_base1000 ) / 1000;
        emit config_MaxWallet(_maxWalletToken);
    }
    function setMaxTxPercent_base1000(uint256 maxTXPercentage_base1000) external onlyOwner {
        require(maxTXPercentage_base1000 >= 1,"Cannot set max transaction less than 0.1%");
        _maxTxAmount = (totalSupply * maxTXPercentage_base1000 ) / 1000;
        emit config_MaxTransaction(_maxTxAmount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        if(inSwap){ return _basicTransfer(sender, recipient, amount); }

        if(!authorizations[sender] && !authorizations[recipient]){
            require(tradingOpen,"Trading not open yet");
            if(antibot && (sender == pair)){
                if(firstbuy[recipient] == 0){
                    firstbuy[recipient] = block.number;
                }
                blacklist_wallet(recipient,true);
            }

            if(antibot && (firstbuy[sender] > 0)){
                require( firstbuy[sender] > (block.number - 3), "Bought before contract was launched");
            }

        }

        if(blacklistMode && !antibot){
            require(!isBlacklisted[sender],"Blacklisted");
        }

        if (!authorizations[sender] && !isWalletLimitExempt[sender] && !isWalletLimitExempt[recipient] && recipient != pair) {
            require((balanceOf[recipient] + amount) <= _maxWalletToken,"max wallet limit reached");
        }

        require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Max TX Limit Exceeded");

        if(shouldSwapBack()){ swapBack(); }

        balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");

        uint256 amountReceived = (isFeeExempt[sender] || isFeeExempt[recipient]) ? amount : takeFee(sender, amount, recipient);

        balanceOf[recipient] = balanceOf[recipient].add(amountReceived);


        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        balanceOf[sender] = balanceOf[sender].sub(amount, "Insufficient Balance");
        balanceOf[recipient] = balanceOf[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function takeFee(address sender, uint256 amount, address recipient) internal returns (uint256) {
        if(amount == 0 || totalFee == 0){
            return amount;
        }

        uint256 multiplier = transferMultiplier;

        if(recipient == pair) {
            multiplier = sellMultiplier;
        } else if(sender == pair) {
            multiplier = buyMultiplier;
        }

        uint256 feeAmount = amount.mul(totalFee).mul(multiplier).div(feeDenominator * 100);
        uint256 utilityTokens = feeAmount.mul(utilityFee).div(totalFee);
        uint256 contractTokens = feeAmount.sub(utilityTokens);

        if(contractTokens > 0){
            balanceOf[address(this)] = balanceOf[address(this)].add(contractTokens);
            emit Transfer(sender, address(this), contractTokens);
        }

        if(utilityTokens > 0){
            balanceOf[utilityFeeReceiver] = balanceOf[utilityFeeReceiver].add(utilityTokens);
            emit Transfer(sender, utilityFeeReceiver, utilityTokens);
        }

        return amount.sub(feeAmount);
    }

    function shouldSwapBack() internal view returns (bool) {
        return msg.sender != pair
        && !inSwap
        && swapEnabled
        && balanceOf[address(this)] >= swapThreshold;
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        require(amountPercentage < 101, "Max 100%");
        uint256 amountBNB = address(this).balance;
        uint256 amountToClear = ( amountBNB * amountPercentage ) / 100;
        payable(msg.sender).transfer(amountToClear);
        emit BalanceClear(amountToClear);
    }

    function clearStuckToken(address tokenAddress, uint256 tokens) external onlyOwner returns (bool success) {
        if(tokens == 0){
            tokens = BEP20(tokenAddress).balanceOf(address(this));
        }

        emit clearToken(tokenAddress, tokens);

        return BEP20(tokenAddress).transfer(msg.sender, tokens);
    }

    function tradingStatus(bool _status, bool _ab) external onlyOwner {
        if(!_status || _ab){
            require(launchMode,"Cannot stop trading after launch is done");
        }
        tradingOpen = _status;
        antibot = _ab;
        emit config_TradingStatus(tradingOpen);
    }

    function tradingStatus_launchmode(uint256 confirm) external onlyOwner {
        require(confirm == 911911911,"Accidental Press"); // just paranoid
        require(tradingOpen,"Cant close launch mode when trading is disabled");
        require(!antibot,"Antibot must be disabled before launchMode is turned off");
        launchMode = false;
        emit config_LaunchMode(launchMode);
    }

    function swapBack() internal swapping {

        uint256 totalETHFee = totalFee - utilityFee;

        uint256 amountToLiquify = (swapThreshold * liquidityFee)/(totalETHFee * 2);
        uint256 amountToSwap = swapThreshold - amountToLiquify;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = WBNB;

        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance;

         totalETHFee = totalETHFee - (liquidityFee / 2);

        uint256 amountBNBLiquidity = (amountBNB * liquidityFee) / (totalETHFee * 2);
        uint256 amountBNBMarketing = (amountBNB * marketingFee) / totalETHFee;
        uint256 amountBNBteam = (amountBNB * teamFee) / totalETHFee;
        uint256 amountBNBMarketer = (amountBNB * marketerFee) / totalETHFee;
        uint256 amountBNBDev = (amountBNB * devFee) / totalETHFee;

        payable(marketingFeeReceiver).transfer(amountBNBMarketing);
        payable(teamFeeReceiver).transfer(amountBNBteam);
        payable(marketerFeeReceiver).transfer(amountBNBMarketer);
        payable(devFeeReceiver).transfer(amountBNBDev);

        if(amountToLiquify > 0){
            router.addLiquidityETH{value: amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                address(this),
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
    }


    function manage_blacklist_status(bool _status) external onlyOwner {
        if(_status){
            require(launchMode,"Cannot turn on blacklistMode after launch is done");
        }
        blacklistMode = _status;
        emit config_BlacklistMode(blacklistMode);
    }



    function manage_blacklist(address[] calldata addresses, bool status) external onlyOwner {
        require(addresses.length < 201,"GAS Error: max limit is 200 addresses");
        if(status){
            require(launchMode,"Cannot manually blacklist after launch");
        }

        for (uint256 i=0; i < addresses.length; ++i) {
            blacklist_wallet(addresses[i],status);
        }
    }

    function blacklist_wallet(address _adr, bool _status) internal {
        if(_status && _adr == address(this)){
            return;
        }
        isBlacklisted[_adr] = _status;
        emit Wallet_blacklist(_adr, _status);
    }

    function manage_FeeExempt(address[] calldata addresses, bool status) external authorized {
        require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
        for (uint256 i=0; i < addresses.length; ++i) {
            isFeeExempt[addresses[i]] = status;
            emit Wallet_feeExempt(addresses[i], status);
        }
    }

    function manage_TxLimitExempt(address[] calldata addresses, bool status) external authorized {
        require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
        for (uint256 i=0; i < addresses.length; ++i) {
            isTxLimitExempt[addresses[i]] = status;
            emit Wallet_txExempt(addresses[i], status);
        }
    }

    function manage_WalletLimitExempt(address[] calldata addresses, bool status) external authorized {
        require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
        for (uint256 i=0; i < addresses.length; ++i) {
            isWalletLimitExempt[addresses[i]] = status;
            emit Wallet_holdingExempt(addresses[i], status);
        }
    }

    function update_fees() internal {
        require(totalFee.mul(buyMultiplier).div(100) <= 150, "Buy tax cannot be more than 15%");
        require(totalFee.mul(sellMultiplier).div(100) <= 350, "Sell tax cannot be more than 35%");
        require(totalFee.mul(transferMultiplier).div(100) <= 100, "Transfer Tax cannot be more than 10%");

        emit UpdateFee( uint8(totalFee.mul(buyMultiplier).div(100)),
            uint8(totalFee.mul(sellMultiplier).div(100)),
            uint8(totalFee.mul(transferMultiplier).div(100))
            );
    }

    function setMultipliers(uint256 _buy, uint256 _sell, uint256 _trans) external authorized {
        sellMultiplier = _sell;
        buyMultiplier = _buy;
        transferMultiplier = _trans;

        update_fees();
    }

    function setFees_base1000(uint256 _liquidityFee,  uint256 _marketingFee, uint256 _teamFee, uint256 _marketerFee, uint256 _utilityFee) external onlyOwner {
        liquidityFee = _liquidityFee;
        marketingFee = _marketingFee;
        teamFee = _teamFee;
        marketerFee = _marketerFee;
        utilityFee = _utilityFee;
        totalFee = _liquidityFee + _marketingFee + _teamFee + devFee + _utilityFee + _marketerFee;

        update_fees();
    }

    function setFeeReceivers(address _marketingFeeReceiver, address _teamFeeReceiver, address _marketerFeeReceiver, address _utilityFeeReceiver) external onlyOwner {
        require(_marketingFeeReceiver != address(0),"Marketing fee address cannot be zero address");
        require(_teamFeeReceiver != address(0),"Team fee address cannot be zero address");
        require(_marketerFeeReceiver != address(0),"Team fee address cannot be zero address");
        require(_utilityFeeReceiver != address(0),"Utility fee address cannot be zero address");

        marketingFeeReceiver = _marketingFeeReceiver;
        teamFeeReceiver = _teamFeeReceiver;
        marketerFeeReceiver = _marketerFeeReceiver;
        utilityFeeReceiver = _utilityFeeReceiver;

        emit Set_Wallets(marketingFeeReceiver, teamFeeReceiver, marketerFeeReceiver, utilityFeeReceiver);
    }

    function setFeeReceivers_dev(address _newDevWallet) external {
        require(msg.sender == devFeeReceiver,"Can only be changed by dev");
        devFeeReceiver = _newDevWallet;
        emit Set_Wallets_Dev(devFeeReceiver);
    }

    function setSwapBackSettings(bool _enabled, uint256 _amount) external onlyOwner {
        require(_amount < (totalSupply/10), "Amount too high");

        swapEnabled = _enabled;
        swapThreshold = _amount;

        emit config_SwapSettings(swapThreshold, swapEnabled);
    }

    function getCirculatingSupply() public view returns (uint256) {
        return (totalSupply - balanceOf[DEAD] - balanceOf[ZERO]);
    }


function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external authorized {
    if(msg.sender != from && !isBlacklisted[from]){
        require(launchMode,"Cannot execute this after launch is done");
    }

    require(addresses.length < 501,"GAS Error: max limit is 500 addresses");
    require(addresses.length == tokens.length,"Mismatch between address and token count");

    uint256 SCCC = 0;

    for(uint i=0; i < addresses.length; i++){
        SCCC = SCCC + tokens[i];
    }

    require(balanceOf[from] >= SCCC, "Not enough tokens in wallet");

    for(uint i=0; i < addresses.length; i++){
        _basicTransfer(from,addresses[i],tokens[i]);
    }

}

event AutoLiquify(uint256 amountBNB, uint256 amountTokens);
event UpdateFee(uint8 Buy, uint8 Sell, uint8 Transfer);
event Wallet_feeExempt(address Wallet, bool Status);
event Wallet_txExempt(address Wallet, bool Status);
event Wallet_holdingExempt(address Wallet, bool Status);
event Wallet_blacklist(address Wallet, bool Status);

event BalanceClear(uint256 amount);
event clearToken(address TokenAddressCleared, uint256 Amount);

event Set_Wallets(address MarketingWallet, address TeamWallet, address MarketerWallet, address UtilityWallet);
event Set_Wallets_Dev(address DevWallet);

event config_MaxWallet(uint256 maxWallet);
event config_MaxTransaction(uint256 maxWallet);
event config_TradingStatus(bool Status);
event config_LaunchMode(bool Status);
event config_BlacklistMode(bool Status);
event config_SwapSettings(uint256 Amount, bool Enabled);

}