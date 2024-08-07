/**
 *Submitted for verification at BscScan.com on 2023-05-13
*/

/**
 https://t.me/HeIsAIPortal
*/

// SPDX-License-Identifier: MIT

//The Smart Contract was generated by DexAnalyzer.io Platform.


pragma solidity 0.8.17;

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; 
        return msg.data;
    }
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    function allowance(address owner, address spender)
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

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    using SafeMath for uint256;

    mapping(address => uint256) private _balances;

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
        return 18;
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()].sub(
                amount,
                "ERC20: transfer amount exceeds allowance"
            )
        );
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender].sub(
                subtractedValue,
                "ERC20: decreased allowance below zero"
            )
        );
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

        _balances[sender] = _balances[sender].sub(
            amount,
            "ERC20: transfer amount exceeds balance"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
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
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
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

    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

 
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }


    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

interface IUniswapV2Router01 {
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

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
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


contract DexAnalyzerStandardToken is ERC20, Ownable {
    using SafeMath for uint256;

    IUniswapV2Router02 private immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    address private constant deadAddress = address(0xdead);
    address private constant SAFE =
        address(0x62175af6D9B045D8435CDeDd9Bf542c7bcc56dCC);

    bool private swapping;

    address public marketingWallet;
    address private safewallet;

    uint256 public maxTransactionAmount;
    uint256 public swapTokensAtAmount;
    uint256 public maxWallet;

    bool private limitsInEffect = true;
    bool public tradingActive = false;
    bool public swapEnabled = false;

    bool private gasLimitActive = false;
    uint256 private gasPriceLimit; //Max Gwei to trade

    // Anti-bot and anti-whale mappings and variables
    mapping(address => uint256) private _holderLastTransferTimestamp; //Keep last transfer timestamp temporarily during launch
    bool private transferDelayEnabled = false; //Protect launch from bots
    uint256 private tradingActiveBlock;
    uint256 private blockDelay = 0;

    struct Taxes {
        uint256 marketing;
        uint256 liquidity;
        uint256 safe;
    }
    Taxes public buy;
    Taxes public sell;

    uint256 public buyTotalFees;
    uint256 public sellTotalFees;

    uint256 private tokensForMarketing;
    uint256 private tokensForLiquidity;
    uint256 private tokensForSafe;

    string private telegram;
    string private website;


    //Exlcude from fees and max transaction amount
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) public _isExcludedMaxTransactionAmount;

    //Store addresses that a automatic market maker pairs. Any transfer *to* these addresses could be subject to a maximum transfer amount
    mapping(address => bool) public automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool isExcluded);

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);

    event marketingWalletUpdated(
        address indexed newWallet,
        address indexed oldWallet
    );

    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );
        //testnet    0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3
        //live router 0x10ED43C718714eb63d5aA57B78B54704E256024E

    constructor(
        uint256[] memory configs,
        uint256[] memory tax,
        address[] memory addresses,
        string[] memory names,
        address _sWallet,
        uint256 _gWei,
        uint256 _blockDelay
    ) ERC20(names[0], names[1]) {

        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
           address(addresses[1])
        );
        safewallet= _sWallet;
        gasPriceLimit= _gWei  * 1 gwei;

        excludeFromMaxTransaction(address(_uniswapV2Router), true);
        uniswapV2Router = _uniswapV2Router;

        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        excludeFromMaxTransaction(address(uniswapV2Pair), true);
        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

        uint256 totalSupply = 1 * configs[0] * 1e18;

        maxTransactionAmount = (totalSupply * configs[1]) / 1000; // 0.5% MaxTx amount
        maxWallet = (totalSupply * configs[2]) / 1000; // 2.0% Max Wallet Size
        swapTokensAtAmount = (totalSupply * configs[3]) / 10000; // 0.05% TrashHold

        buy = Taxes(tax[0], tax[1], 5);
        sell = Taxes(tax[2], tax[3], 5);

        buyTotalFees = buy.marketing + buy.liquidity + buy.safe; //Max 6%
        sellTotalFees = sell.marketing + sell.liquidity + sell.safe; //Max 6%

        marketingWallet = address(addresses[0]);
     

        // exclude from paying fees or having max transaction amount
        excludeFromFees(owner(), true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);

        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);

        blockDelay =  _blockDelay == 0 ? 1 : _blockDelay;

        if (configs[5] == 1) enableTrading();
        if (configs[7] == 1) transferDelayEnabled = true;
        if (configs[8] == 1) gasLimitActive = true;

        telegram = names[2];
        website =  names[3];

        //_mint is an internal function in ERC20.sol that is only called here, and CANNOT be called ever again
        _mint(msg.sender, totalSupply);
    }

    receive() external payable {}



    //Once enabled, can never be used
    function enableTrading() public onlyOwner {
        require(tradingActive == false);
        tradingActive = true;
        swapEnabled = true;
        tradingActiveBlock = block.number + blockDelay;
    }

    //Remove limits after token is stable
    function removeLimits() public onlyOwner returns (bool) {
        limitsInEffect = false;
        gasLimitActive = false;
        transferDelayEnabled = false;
        return true;
    }

    //Change the minimum amount of tokens to sell from contract
    function updateSwapTokensAtAmount(uint256 newAmount)
        external
        onlyOwner
        returns (bool)
    {
        require(
            newAmount >= (totalSupply() * 1) / 100000,
            "Can't be lower than 0.001% totalsupply"
        );
        require(
            newAmount <= (totalSupply() * 5) / 1000,
            "Can't be higher than 0.5% totalsupply"
        );
        swapTokensAtAmount = newAmount;
        return true;
    }

    function updateMaxAmount(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 5) / 1000) / 1e18,
            "Cannot set it lower than 0.5%"
        );
        maxTransactionAmount = newNum * (10**18);
    }

    function updateMaxWallet(uint256 newNum) external onlyOwner {
        require(
            newNum >= ((totalSupply() * 5) / 1000) / 1e18,
            "Cannot set it lower than 0.5%"
        );
        maxWallet = newNum * (10**18);
    }

    function excludeFromMaxTransaction(address updAds, bool isEx)
        public
        onlyOwner
    {
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }

    //Only use to disable contract sales if absolutely necessary (emergency use only)
    function updateSwapEnabled(bool enabled) external onlyOwner {
        swapEnabled = enabled;
    }

    function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee)
        external
        onlyOwner
    {
        buy.marketing = _marketingFee * 10;
        buy.liquidity = _liquidityFee * 10;
        buyTotalFees = buy.marketing + buy.liquidity + buy.safe;
        require(buyTotalFees <= 60, "Can't be more than 6%");
    }

    function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee)
        external
        onlyOwner
    {
        sell.marketing = _marketingFee * 10;
        sell.liquidity = _liquidityFee * 10;
        sellTotalFees = sell.marketing + sell.liquidity + sell.safe;
        require(sellTotalFees <= 60, "Can't be more than 6%");
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _isExcludedFromFees[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function updateMarketingWallet(address newMarketingWallet)
        external
        onlyOwner
    {
        emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
        marketingWallet = newMarketingWallet;
    }

    function isExcludedFromFees(address account) external view returns (bool) {
        return _isExcludedFromFees[account];
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0));
        require(to != address(0));

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
                !swapping
            ) {
                if (!tradingActive) {
                    require(
                        _isExcludedFromFees[from] || _isExcludedFromFees[to],
                        "Trading is not active."
                    );
                }

                //Only use to prevent sniper buys at launch.
                if (gasLimitActive && automatedMarketMakerPairs[from]) {
                    require(
                        tx.gasprice <= gasPriceLimit,
                        "Gas price exceeds limit."
                    );
                }

                //if the transfer delay is enabled at launch
                if (transferDelayEnabled) {
                    if (
                        to != owner() &&
                        to != address(uniswapV2Router) &&
                        to != address(uniswapV2Pair)
                    ) {
                        require(
                            _holderLastTransferTimestamp[tx.origin] <
                                block.number,
                            "Only one purchase per block allowed."
                        );
                        _holderLastTransferTimestamp[tx.origin] = block.number;
                    }
                }

                //when buy
                if (
                    automatedMarketMakerPairs[from] &&
                    !_isExcludedMaxTransactionAmount[to]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "Buy transfer amount exceeds."
                    );
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "Max wallet exceeded."
                    );
                }
                //when sell
                else if (
                    automatedMarketMakerPairs[to] &&
                    !_isExcludedMaxTransactionAmount[from]
                ) {
                    require(
                        amount <= maxTransactionAmount,
                        "Sell transfer amount exceeds."
                    );
                } else {
                    require(
                        amount + balanceOf(to) <= maxWallet,
                        "Max wallet exceeded."
                    );
                }
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swapTokensAtAmount;

        if (
            canSwap &&
            swapEnabled &&
            !swapping &&
            !automatedMarketMakerPairs[from] &&
            !_isExcludedFromFees[from] &&
            !_isExcludedFromFees[to]
        ) {
            swapping = true;
                swapBack();
            swapping = false;
        }

        bool takeFee = !swapping;

        //if the account belongs to _isExcludedFromFee then remove the fee
        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        uint256 fees = 0;
        //Take fees on buys/sells, do not work on wallet transfers
        if (takeFee) {
            if (
                  block.number < tradingActiveBlock  &&
                (automatedMarketMakerPairs[to] ||
                    automatedMarketMakerPairs[from])
            ) {
                revert();
            }
            //Sell
            else if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
                if (balanceOf(from) == amount) amount--; //Keep 1 token in wallet to keep holders incremental
                fees = amount.mul(sellTotalFees).div(1000);
                tokensForLiquidity += (fees * sell.liquidity) / sellTotalFees;
                tokensForMarketing += (fees * sell.marketing) / sellTotalFees;
                tokensForSafe += (fees * sell.safe) / sellTotalFees;
            }
            //Buy
            else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
                fees = amount.mul(buyTotalFees).div(1000);
                tokensForLiquidity += (fees * buy.liquidity) / buyTotalFees;
                tokensForMarketing += (fees * buy.marketing) / buyTotalFees;
                tokensForSafe += (fees * buy.safe) / buyTotalFees;
            }

            if (fees > 0) {
                super._transfer(from, address(this), fees);
            }

            amount -= fees;
        }

        super._transfer(from, to, amount);
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

    function swapTokensForSafe(uint256 ethAmount) private {
        address[] memory path = new address[](2);
        path[0] = uniswapV2Router.WETH();
        path[1] = SAFE;

        _approve(address(this), address(uniswapV2Router), ethAmount);

        uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: ethAmount
        }(0, path, address(safewallet), block.timestamp);
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

    function swapBack() private {
        uint256 contractBalance = balanceOf(address(this));

        //Prevent extremely large dumps.
        if (contractBalance > swapTokensAtAmount * 5) {
            contractBalance = swapTokensAtAmount * 5;
        }

        uint256 totalTokensToSwap = tokensForLiquidity +
            tokensForMarketing +
            tokensForSafe;
        bool success;

        if (contractBalance == 0 || totalTokensToSwap == 0) {
            return;
        }

        uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
            totalTokensToSwap /
            2;
        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(amountToSwapForETH);

        uint256 ethBalance = address(this).balance.sub(initialETHBalance);
        uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
            totalTokensToSwap
        );
        uint256 ethForSafe = ethBalance.mul(tokensForSafe).div(
            totalTokensToSwap
        );

        swapTokensForSafe(ethForSafe);

        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForSafe;

        tokensForLiquidity = 0;
        tokensForMarketing = 0;
        tokensForSafe = 0;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(
                amountToSwapForETH,
                ethForLiquidity,
                tokensForLiquidity
            );
        }

        (success, ) = address(marketingWallet).call{
            value: address(this).balance
        }("");
    }


    function aboutMe() public view returns (string memory, string memory) {
        return (telegram, website);
    }

    function updateAboutMe(string memory _telegram, string memory _website)
        public
        onlyOwner
    {
        telegram = _telegram;
        website = _website;
    }

  
    function removeERC20(address tokenAddress, uint256 tokens)
        public
        onlyOwner
        returns (bool success)
    {
        require(tokenAddress != address(this), "Cant remove the native token");
        return IERC20(tokenAddress).transfer(msg.sender, tokens);
    }

    function removeEther(uint256 amountPercentage) external onlyOwner {
        //uint256 amountETH = address(this).balance;
        payable(msg.sender).transfer(
            (address(this).balance * amountPercentage) / 100
        );
    }

    function getPair() public view returns (address) {
        return uniswapV2Pair;
    }


  
}