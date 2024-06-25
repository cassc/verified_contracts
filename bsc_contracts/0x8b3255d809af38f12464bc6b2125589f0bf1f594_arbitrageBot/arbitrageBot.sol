/**
 *Submitted for verification at BscScan.com on 2023-01-31
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.17;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

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

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
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

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

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
    )
    external
    payable
    returns (uint amountToken, uint amountETH, uint liquidity);

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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

abstract contract Context {
    function msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        setOwner(msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        setOwner(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        setOwner(newOwner);
    }

    function setOwner(address newOwner) private {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract arbitrageBot is Ownable {
    // base assets
    address public _busd;
    address public _wbnb;
    address public _token1;
    address public _token2;
    address public _router;

    uint256 public nativePriceOne;
    uint256 public nativePriceCeiling;

    constructor() {
        _busd = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56;
        _wbnb = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
        _token1 = 0xbA2aE424d960c26247Dd6c32edC70B295c744C43; // DOGECOIN
        _token2 = 0xF8A0BF9cF54Bb92F17374d9e9A321E6a111a51bD; // CHAINLINK
        _router = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Pancakeswap v2
    } 

	function swap(address router, address tokenIn, address tokenOut, uint256 amount) private {
		IERC20(tokenIn).approve(router, amount);
		address[] memory path;
		path = new address[](2);
		path[0] = tokenIn;
		path[1] = tokenOut;
		uint deadline = block.timestamp + 300;
		IUniswapV2Router02(router).swapExactTokensForTokens(amount, 1, path, address(this), deadline);
	}

	function getAmountOutMin(address router, address tokenIn, address tokenOut, uint256 amount) public view returns (uint256) {
		address[] memory path;
		path = new address[](2);
		path[0] = tokenIn;
		path[1] = tokenOut;
		uint256[] memory amountOutMins = IUniswapV2Router02(router).getAmountsOut(amount, path);
		return amountOutMins[path.length -1];
	}

    function sellDividends_token2(uint256 amount) external onlyOwner {
        swap(_router,_token2, _busd,amount);   
    }

    function buyBack_token2(uint256 amount) external onlyOwner {
        swap(_router, _busd, _token2, amount);
    }

    // example _busd as token 1 - _token1 as token 2 - _wbnb as token 3 - _busd back to token 1
    function estimateTriangularTrade(address token1, address token2,address token3, uint256 amount) external view returns (uint256) {
		uint256 amtBack1 = getAmountOutMin(_router, token1, token2, amount);
		uint256 amtBack2 = getAmountOutMin(_router, token2, token3, amtBack1);
        uint256 amtBack3 = getAmountOutMin(_router, token3, token1, amtBack2);
		return amtBack3;
    }

  function triangularTrade(address token1, address token2, address token3, uint256 amount) external onlyOwner {    
        // log start balance
        uint token1InitialBalance = IERC20(token1).balanceOf(address(this));
        uint token2InitialBalance = IERC20(token2).balanceOf(address(this));
        uint token3InitialBalance = IERC20(token3).balanceOf(address(this));

        // swap from base to mid
        swap(_router, token1, token2, amount);
        uint token2Balance = IERC20(token2).balanceOf(address(this));
        uint tradeableAmount2 = token2Balance - token2InitialBalance;

        // get the value
        swap(_router, token2, token3, tradeableAmount2);
        uint token3Balance = IERC20(token3).balanceOf(address(this));
        uint tradeableAmount3 = token3Balance - token3InitialBalance;

        // swap back to base
        swap(_router, token3, token1, tradeableAmount3);

        // log the end balance
        uint endBalance = IERC20(token1).balanceOf(address(this));

        // ensure trade is profitable
        require(endBalance > token1InitialBalance, "Trade Reverted, No Profit Made");
    }

    function estimateQtrade(address token1, address token2, address token3, address token4, uint256 amount) external view returns (uint256) {
		uint256 amtBack1 = getAmountOutMin(_router, token1, token2, amount);
		uint256 amtBack2 = getAmountOutMin(_router, token2, token3, amtBack1);
        uint256 amtBack3 = getAmountOutMin(_router, token3, token4, amtBack2);
        uint256 amtBack4 = getAmountOutMin(_router, token4, token1, amtBack3);
		return amtBack4;
	}

    function qTradeBase_busd(address token2, address token3, address token4, uint256 amount) external onlyOwner {        
        // log start balance
        uint token1InitialBalance = IERC20(_busd).balanceOf(address(this));
        uint token2InitialBalance = IERC20(token2).balanceOf(address(this));
        uint token3InitialBalance = IERC20(token3).balanceOf(address(this));
        uint token4InitialBalance = IERC20(token4).balanceOf(address(this));

        // swap from base to mid
        swap(_router, _busd, token2, amount);
        uint token2Balance = IERC20(token2).balanceOf(address(this));
        uint tradeableAmount2 = token2Balance - token2InitialBalance;

        // get the value
        swap(_router, token2, token3, tradeableAmount2);
        uint token3Balance = IERC20(token3).balanceOf(address(this));
        uint tradeableAmount3 = token3Balance - token3InitialBalance;
    
        swap(_router, token3, token4, tradeableAmount3);
        uint token4Balance = IERC20(token4).balanceOf(address(this));
        uint tradeableAmount4 = token4Balance - token4InitialBalance;

        // swap back to base
        swap(_router, token4, _busd, tradeableAmount4);

        // log the end balance
        uint endBalance = IERC20(_busd).balanceOf(address(this));

        // ensure trade is profitable
        require(endBalance > token1InitialBalance, "Trade Reverted, No Profit Made");
    }

    function qTradeBase_wbnb(address token2, address token3, address token4, uint256 amount) external onlyOwner {
        // log start balances
        uint token1InitialBalance = IERC20(_wbnb).balanceOf(address(this));
        uint token2InitialBalance = IERC20(token2).balanceOf(address(this));
        uint token3InitialBalance = IERC20(token3).balanceOf(address(this));
        uint token4InitialBalance = IERC20(token4).balanceOf(address(this));

        // swap from base to mid
        swap(_router, _wbnb, token2, amount);
        uint token2Balance = IERC20(token2).balanceOf(address(this));
        uint tradeableAmount2 = token2Balance - token2InitialBalance;

        // get the value
        swap(_router, token2, token3, tradeableAmount2);
        uint token3Balance = IERC20(token3).balanceOf(address(this));
        uint tradeableAmount3 = token3Balance - token3InitialBalance;

        swap(_router, token3, token4, tradeableAmount3);
        uint token4Balance = IERC20(token4).balanceOf(address(this));
        uint tradeableAmount4 = token4Balance - token4InitialBalance;

        // swap back to base
        swap(_router, token4, _wbnb, tradeableAmount4);

        // log the end balance
        uint endBalance = IERC20(_wbnb).balanceOf(address(this));

        // ensure trade is profitable
        require(endBalance > token1InitialBalance, "Trade Reverted, No Profit Made");
    }

	function getBalance (address tokenContractAddress) external view  returns (uint256) {
		uint balance = IERC20(tokenContractAddress).balanceOf(address(this));
		return balance;
	}
	
	function recoverBnb() external onlyOwner {
		payable(msg.sender).transfer(address(this).balance);
	}

	function recoverTokens(address tokenAddress) external onlyOwner {
		IERC20 token = IERC20(tokenAddress);
		token.transfer(msg.sender, token.balanceOf(address(this)));
	}
	
	receive() external payable {}
}