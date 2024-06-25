/**
 *Submitted for verification at BscScan.com on 2022-11-01
*/

/**

  _      _     _             _                                      
 | |    (_)   | |           | |                                 
 | |     _ ___| |_ ___ _ __ | |__   ___  _   _ _ __ __ _ 
 | |    | / __| __/ _ \ '_ \| '_ \ / _ \| | | | '__/ _` |
 | |____| \__ \ ||  __/ | | | |_) | (_) | |_| | | | (_| |
 |______|_|___/\__\___|_| |_|_.__/ \___/ \__,_|_|  \__, |
                                                    __/ |
                                                   |___/  

 * SPDX-License-Identifier: MIT
 *
 * Tokenomics:
 *  Max Supply: 100,000,000
 *  Decimals: 18
 *  Token Name: LisCoin
 *  Symbol: LIS
 * 
 * 
 * Buy Tax 5% :            Sell Tax 5% :
 *  Development      1%      Liquidity      1%
 *  Marketing        4%      Marketing      4% 
 
 **/

 pragma solidity ^0.8.11;

 abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return (msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; 
        return msg.data;
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

interface IERC20Metadata is IERC20 {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

contract ERC20 is Context, IERC20, IERC20Metadata {
    mapping (address => uint256) internal _balances;

    mapping (address => mapping (address => uint256)) internal _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    constructor (string memory name_, string memory symbol_) {
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

    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);

        uint256 currentAllowance = _allowances[sender][_msgSender()];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
        _approve(sender, _msgSender(), currentAllowance - amount);

        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
        _approve(_msgSender(), spender, currentAllowance - subtractedValue);

        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        uint256 senderBalance = _balances[sender];
        require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
        _balances[sender] = senderBalance - amount;
        _balances[recipient] += amount;

        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        _balances[account] = accountBalance - amount;
        _totalSupply -= amount;

        emit Transfer(account, address(0), amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}

 /*
 * This contract is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;
    mapping (address => bool) internal authorizations;


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor ()  {
        address msgSender = _msgSender();
        _owner = msgSender;
        authorizations[_owner] = true;
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
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided (seconds)
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp> _lockTime , "Contract is still locked");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }

    //Modifier to require caller to be authorized
    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    //Authorize address.
    function authorize(address account) public onlyOwner {
        authorizations[account] = true;
    }

    // Remove address authorization.
    function unauthorize(address account) public onlyOwner {
        authorizations[account] = false;
    }

    // Return address authorization status
    function isAuthorized(address account) public view returns (bool) {
        return authorizations[account];
    }
}
interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

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
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

library Address{
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
}

contract LisCoin is Context, Ownable, ERC20  {
    using Address for address payable;

    mapping (address => bool) private _isExcludedFromFees;
    mapping (address => bool) private _isExcludedFromMaxSellTxLimit;
    mapping (address=>bool) private _isBlacklisted;

    address payable public devWallet = payable(0x63EA9710319aEF792040B1bc8CaAb800038024f7);
    address payable public buybackWallet = payable(0x63EA9710319aEF792040B1bc8CaAb800038024f7);
    address public liquidityWallet;
    address constant private  DEAD = 0x000000000000000000000000000000000000dEaD;

    // Buying fees
    uint8 public buyDevFee = 3;

    // Selling fees
    uint8 public sellBuybackFee = 4;
    uint8 public sellLiquidityFee = 1;

    uint256 public totalSellFees;
    uint256 public totalBuyFees;

    // Limits
    uint256 public maxSellLimit =  10000_000 * 10**18; // 10M
    
    // Allows to know the distribution of tokens collected from taxes
    uint256 private _devCurrentAccumulatedFees;
    uint256 private _buybackCurrentAccumulatedFees;

    // LP system
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    uint256 public _accumulatedTokensLimit = 10000_000 * 10**18;
    bool private _isLiquefying;
    modifier lockTheSwap {
    if (!_isLiquefying) {
        _isLiquefying = true;
        _;
        _isLiquefying = false;
    }}

    // Before this date, only certain addresses can send tokens
    uint256 public tradingEnabledTimestamp = 1657393200; // Sat Jul 09 2022 19:00:00 GMT+0000
    // Only these addresses will be able to send token before the launch.
    // Generally it is the owner and the address of the presale which are added
    mapping (address => bool) private _canSendTokensBeforeTradingIsEnabled;


    // Any transfer to these addresses could be subject to some sell/buy taxes
    mapping (address => bool) public automatedMarketMakerPairs;

    event ExcludeFromFees(address indexed account, bool isExcluded);
    event ExcludeFromMaxSellTxLimit(address indexed account, bool isExcluded);
    event BlackList(address indexed account, bool isBlacklisted);

    event AddAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event UniswapV2RouterUpdated(address indexed newAddress, address indexed oldAddress);
    event UniswapV2MainPairUpdated(address indexed newAddress, address indexed oldAddress);

    event LiquidityWalletUpdated(address indexed newLiquidityWallet, address indexed oldLiquidityWallet);
    event DevWalletUpdated(address indexed newDevWallet, address indexed oldDevWallet);
    event BuybackWalletUpdated(address indexed newBuybackWallet, address indexed oldBuybackWallet);

    event Burn(uint256 amount);

    event SellFeesUpdated(uint8 liquidityFee, uint8 buybackFee);
    event BuyFeesUpdated(uint8 devFee);

    event MaxSellLimitUpdated(uint256 amount);

    event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived,uint256 tokensIntoLiquidity);

    constructor() ERC20("LisCoin", "LIS") {
        // Create supply
        _mint(msg.sender, 100_000_000 * 10**18);

        totalSellFees = sellLiquidityFee + sellBuybackFee;
        totalBuyFees = buyDevFee;

        liquidityWallet = owner();

        uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);
         // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
            .createPair(address(this), uniswapV2Router.WETH());
        _setAutomatedMarketMakerPair(uniswapV2Pair, true);

        _canSendTokensBeforeTradingIsEnabled[owner()] = true;

        // Exclude the project addresses of the different limits
        address[2] memory projectAddresses = [
        owner(),
        address(this)];

        for (uint i=0; i<projectAddresses.length; i++) {
            excludeFromAllFeesAndLimits(projectAddresses[i],true);
        }
    }

    function excludeFromAllFeesAndLimits(address account, bool excluded) public authorized {
        excludeFromFees(account,excluded);
        excludeFromMaxSellLimit(account,excluded);
    }

    function excludeFromFees(address account, bool excluded) public authorized {
        require(_isExcludedFromFees[account] != excluded, "LIS: Account has already the value of 'excluded'");
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    function excludeFromMaxSellLimit(address account, bool excluded) public authorized {
        require(_isExcludedFromMaxSellTxLimit[account] != excluded, "LIS: Account has already the value of 'excluded'");
        _isExcludedFromMaxSellTxLimit[account] = excluded;

        emit ExcludeFromMaxSellTxLimit(account, excluded);
    }

    function blackList(address _account ) public authorized {
        require(!_isBlacklisted[_account], "LIS: This address is already blacklisted");
        require(_account != owner(), "LIS: Blacklisting the owner is not allowed");
        require(_account != address(0), "LIS: Blacklisting the 0 address is not allowed");
        require(_account != uniswapV2Pair, "LIS: Blacklisting the pair address is not allowed");
        require(_account != address(this), "LIS: Blacklisting the contract address is not allowed");

        _isBlacklisted[_account] = true;
        emit BlackList(_account,true);
    }
    
    function removeFromBlacklist(address _account) public authorized {
        require(_isBlacklisted[_account], "LIS: This address already whitelisted");
        _isBlacklisted[_account] = false;
        emit BlackList(_account,false);
    }

    function setAutomatedMarketMakerPair(address pair, bool value) public authorized {
        require(pair != uniswapV2Pair, "LIS: The main pair cannot be removed from automatedMarketMakerPairs");

        _setAutomatedMarketMakerPair(pair, value);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        require(automatedMarketMakerPairs[pair] != value, "LIS: Automated market maker pair is already set to that value");
        automatedMarketMakerPairs[pair] = value;

        _isExcludedFromMaxSellTxLimit[pair] = value;

        emit AddAutomatedMarketMakerPair(pair, value);
    }

    function updateUniswapV2Router(address newAddress) public onlyOwner {
        require(newAddress != address(uniswapV2Router), "LIS: The router has already that address");
        emit UniswapV2RouterUpdated(newAddress, address(uniswapV2Router));
        uniswapV2Router = IUniswapV2Router02(newAddress);
    }

    function updateMainUniswapPair(address newAddress) external onlyOwner {
        require(newAddress != address(uniswapV2Pair), "LIS: The pair address has already that address");
        emit UniswapV2MainPairUpdated(newAddress, address(uniswapV2Pair));
        uniswapV2Pair = newAddress;
        _setAutomatedMarketMakerPair(newAddress, true);
    }

    function setBuyFee(uint8 devFee) external onlyOwner {
        tryToDistributeTokensManually();
        uint8 newTotalBuyFees = devFee;
        require(newTotalBuyFees <= 5 && newTotalBuyFees >=0,"LIS: Total fees must be between 0 and 5");
        buyDevFee = devFee;
        totalBuyFees = newTotalBuyFees;
        emit BuyFeesUpdated(devFee);
    }

    function setSellFees(uint8 liquidityFee, uint8 buybackFee) external onlyOwner {
        tryToDistributeTokensManually();
        uint8 newTotalSellFees = liquidityFee + buybackFee;
        require(newTotalSellFees <= 10 && newTotalSellFees >=0, "LIS: Total fees must be between 0 and 10");
        sellLiquidityFee = liquidityFee;
        sellBuybackFee = buybackFee;
        totalSellFees = newTotalSellFees;
        emit SellFeesUpdated(liquidityFee, buybackFee);
    }

    function setMaxSellLimit(uint256 amount) external onlyOwner {
        require(amount >= 1000 && amount <= 100_000_000, "LIS: Amount must be bewteen 1000 and 100 000 000");
        maxSellLimit = amount *10**18;
        emit MaxSellLimitUpdated(amount);
    }


    function setAccumulatedTokensLimit(uint256 amount) external onlyOwner {
        require(amount >= 1 && amount <= 100_000_000, "LIS: Amount must be bewteen 1 and 100 000 000");
        _accumulatedTokensLimit = amount *10**18;

    }

    function setTradingEnabledTimestamp(uint256 timestamp) external onlyOwner {
        require(tradingEnabledTimestamp > block.timestamp, "LIS: Changing the timestamp is not allowed if the listing has already started");
        tradingEnabledTimestamp = timestamp;
    }

    // For adding presale addresses
    function addPresaleAddresses(address account) external authorized {
        require(!_canSendTokensBeforeTradingIsEnabled[account],"LIS: This account is already added");
        _canSendTokensBeforeTradingIsEnabled[account] = true;
    }

    function setLiquidityWallet(address newWallet) public onlyOwner {
        require(newWallet != liquidityWallet, "LIS: The liquidity wallet has already this address");
        emit LiquidityWalletUpdated(newWallet, liquidityWallet);
        liquidityWallet = newWallet;
    }
    function setDevWallet(address payable newWallet) external onlyOwner {
        require(newWallet != devWallet, "LIS: The dev wallet has already this address");
        emit DevWalletUpdated(newWallet,devWallet);
        devWallet = newWallet;
    }

    function setBuybackWallet(address payable newWallet) external onlyOwner {
        require(newWallet != buybackWallet, "LIS: The buyback wallet has already this address");
        emit BuybackWalletUpdated(newWallet,buybackWallet);
        buybackWallet = newWallet;
    }

    function burn(uint256 amount) external returns (bool) {
        _transfer(_msgSender(), DEAD, amount);
        emit Burn(amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal override {
        require(from != address(0), "LIS: Transfer from the zero address");
        require(to != address(0), "LIS: Transfer to the zero address");
        require(amount >= 0, "LIS: Transfer amount must be greater or equals to zero");
        require(!_isBlacklisted[to], "LIS: Recipient is backlisted");
        require(!_isBlacklisted[from], "LIS: Sender is backlisted");

        bool tradingIsEnabled = block.timestamp >= tradingEnabledTimestamp;
        // Only whitelisted addresses can send tokens before the launch
        if(!tradingIsEnabled) {
            require(_canSendTokensBeforeTradingIsEnabled[from], "LIS: This account is not allowed to send tokens before trading is enabled");
        }
        bool isBuyTransfer = automatedMarketMakerPairs[from];
        bool isSellTransfer = automatedMarketMakerPairs[to];

        if(!_isLiquefying) {
            if(tradingIsEnabled && isSellTransfer && from != address(uniswapV2Router) && !_isExcludedFromMaxSellTxLimit[from])
                require(tradingIsEnabled && amount <= maxSellLimit, "LIS: Amount exceeds the maxSellTxLimit.");
            }


        bool takeFee = tradingIsEnabled && !_isLiquefying && (isBuyTransfer || isSellTransfer);
        // Remove fees if one of the address is excluded from fees
        if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) takeFee = false;
        // All transfers submitted to the tax, are subject to the cooldown system as well

        uint256 contractTokenBalance = balanceOf(address(this));
        bool canSwap = contractTokenBalance >= _accumulatedTokensLimit;

        if(tradingIsEnabled && canSwap &&!_isLiquefying &&!automatedMarketMakerPairs[from] /* not during buying */) {
            _isLiquefying = true;
            swapAndDistribute();
            _isLiquefying = false;
        }
        uint256 amountWithFees = amount;
        if(takeFee) {
            // Buy
            if(isBuyTransfer){
                amountWithFees = amount - amount * totalBuyFees / 100;
                _devCurrentAccumulatedFees+= amount * buyDevFee / 100;
            }
            // Sell 
            else if(isSellTransfer)  {
                amountWithFees = amount - amount * totalSellFees / 100;
                _buybackCurrentAccumulatedFees+= amount * sellBuybackFee / 100;
            }
            if(amount != amountWithFees) super._transfer(from, address(this), amount - amountWithFees);
        }
        super._transfer(from, to, amountWithFees);

    }

    function swapAndDistribute() private {
        uint256 totalTokens = balanceOf(address(this));
        uint256 liquidityCurrentAccumulatedFee = totalTokens - _devCurrentAccumulatedFees - _buybackCurrentAccumulatedFees;
        uint256 liquidityTokensToNotSwap = liquidityCurrentAccumulatedFee / 2;
        uint256 totalTokensToSwap = totalTokens - liquidityTokensToNotSwap;

        uint256 initialBalance = address(this).balance;
        // Swap tokens for BNB
        swapTokensForBNB(totalTokensToSwap);
        // BNBs available thanks to the swap
        uint256 newBalance = address(this).balance - initialBalance;
        uint256 devAmount = newBalance * _devCurrentAccumulatedFees / totalTokensToSwap;
        uint256 buybackAmount = newBalance * _buybackCurrentAccumulatedFees / totalTokensToSwap;
        uint256 liquidityAmount = newBalance - devAmount - buybackAmount;

        // add liquidity to the main pair
        _devCurrentAccumulatedFees = 0;
        _buybackCurrentAccumulatedFees = 0;

        addLiquidity(liquidityTokensToNotSwap, liquidityAmount);
        devWallet.sendValue(devAmount);
        buybackWallet.sendValue(buybackAmount);
        emit SwapAndLiquify(totalTokensToSwap, newBalance, liquidityTokensToNotSwap);
    }

    function swapTokensForBNB(uint256 tokenAmount) private {
        // generate the uniswap pair path of token -> weth
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // make the swap
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of BNB
            path,
            address(this),
            block.timestamp
        );
        
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        
        // approve token transfer to cover all possible scenarios
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        // add the liquidity
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // slippage is unavoidable
            0, // slippage is unavoidable
            liquidityWallet,
            block.timestamp
        );
        
    }

    function tryToDistributeTokensManually() public payable authorized {        
        if(
            getTradingIsEnabled() && 
            !_isLiquefying
        ) {
            _isLiquefying = true;

            swapAndDistribute();

            _isLiquefying = false;
        }
    } 
    // To distribute airdrops easily
    function batchTokensTransfer(address[] calldata _holders, uint256[] calldata _amounts) external authorized {
        require(_holders.length <= 200);
        require(_holders.length == _amounts.length);
            for (uint i = 0; i < _holders.length; i++) {
              if (_holders[i] != address(0)) {
                super._transfer(_msgSender(), _holders[i], _amounts[i]);
            }
        }
    }

    function getStuckBNBs(address payable to) external onlyOwner {
        require(address(this).balance > 0, "LIS: There are no BNBs in the contract");
        to.transfer(address(this).balance);
    } 

    function getCirculatingSupply() external view returns (uint256) {
        return totalSupply() - balanceOf(DEAD) - balanceOf(address(0));
    }

    function getTradingIsEnabled() public view returns (bool) {
        return block.timestamp >= tradingEnabledTimestamp;
    }

    function isExcludedFromFees(address account) public view returns(bool) {
        return _isExcludedFromFees[account];
    }

    function isExcludedFromMaxSellLimit(address account) public view returns(bool) {
        return _isExcludedFromMaxSellTxLimit[account];
    }

    function isBlacklisted(address account) public view returns(bool) {
        return _isBlacklisted[account];
    }


    receive() external payable {
  	}

}