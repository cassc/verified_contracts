/**
 *Submitted for verification at BscScan.com on 2022-12-15
*/

// SPDX-License-Identifier: Unlicensed 
// This contract is not open source and can not be copied/forked

pragma solidity 0.8.17;
 
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
        return a + b;}
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;}
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;}
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;}
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {require(b <= a, errorMessage);
            return a - b;}}
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        unchecked {require(b > 0, errorMessage);
            return a / b;}}
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
        require(address(this).balance >= amount, "insufficient balance");
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "unable to send, recipient reverted");
    }
    
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "low-level call failed");
    }
    
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "low-level call with value failed");
    }
    
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "insufficient balance for call");
        require(isContract(target), "call to non-contract");
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }
    
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "low-level static call failed");
    }
    
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "static call to non-contract");
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }


    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "low-level delegate call failed");
    }
    
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "delegate call to non-contract");
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





contract ShivaInu is Context, IERC20 { 

    using SafeMath for uint256;
    using Address for address;
   
    // Contract Wallets
    address private _owner = payable(0x3DAb70CC5B688aa2E46217Cd793eF7bFeAA69cA3);

    address public Wallet_Liquidity = _owner;                    // LP Token Collection Wallet for Auto LP 
    address public Wallet_Tokens = _owner;                       // Token Fee Collection Wallet
    address payable public Wallet_BNB = payable(_owner);         // BNB Fee Collection Wallet 

    // Token Info
    string private  _name = "Shiva Inu";
    string private  _symbol = "SHIV";
    uint256 private _decimals = 18;
    uint256 private _tTotal = 1_000_000_000 * 10**_decimals;

    // Token social links will appear on BSCScan
    string private _Website;
    string private _Telegram;
    string private _LP_Locker_URL;

    // Wallet and transaction limits
    uint256 private max_Hold = _tTotal;
    uint256 private max_Tran = _tTotal;

    // Fees - Set fees before opening trade
    uint256 public _Fee__Buy_Burn;
    uint256 public _Fee__Buy_Liquidity;
    uint256 public _Fee__Buy_BNB;
    uint256 public _Fee__Buy_Reflection;
    uint256 public _Fee__Buy_Tokens;

    uint256 public _Fee__Sell_Burn;
    uint256 public _Fee__Sell_Liquidity;
    uint256 public _Fee__Sell_BNB;
    uint256 public _Fee__Sell_Reflection;
    uint256 public _Fee__Sell_Tokens;

    // Upper limit for fee processing trigger
    uint256 private swap_Max = _tTotal / 100;

    // Total fees that are processed on buys and sells for swap and liquify calculations
    uint256 private _SwapFeeTotal_Buy;
    uint256 private _SwapFeeTotal_Sell;

    // Supply Tracking for RFI
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    uint256 private constant MAX = ~uint256(0);

    // Set factory
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    constructor () {

        // Transfer token supply to owner wallet
        _rOwned[_owner]     = _rTotal;

        // Set PancakeSwap Router Address
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);

        
        // Create initial liquidity pair with BNB on PancakeSwap factory
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;

        // Wallets that are excluded from holding limits
        _isLimitExempt[_owner] = true;
        _isLimitExempt[address(this)] = true;
        _isLimitExempt[Wallet_Burn] = true;
        _isLimitExempt[uniswapV2Pair] = true;
        _isLimitExempt[Wallet_Tokens] = true;

        // Wallets that are excluded from fees
        _isExcludedFromFee[_owner] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[Wallet_Burn] = true;

        // Set the initial liquidity pair
        _isPair[uniswapV2Pair] = true;    

        // Exclude from Rewards
        _isExcluded[Wallet_Burn] = true;
        _isExcluded[uniswapV2Pair] = true;
        _isExcluded[address(this)] = true;

        // Push excluded wallets to array
        _excluded.push(Wallet_Burn);
        _excluded.push(uniswapV2Pair);
        _excluded.push(address(this));

        // Wallets granted access before trade is open
        _isWhiteListed[_owner] = true;

        // Emit Supply Transfer to Owner
        emit Transfer(address(0), _owner, _tTotal);

        // Emit ownership transfer
        emit OwnershipTransferred(address(0), _owner);

    }

    
    // Events
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event updated_Wallet_Limits(uint256 max_Tran, uint256 max_Hold);
    event updated_Buy_fees(uint256 Marketing, uint256 Liquidity, uint256 Reflection, uint256 Burn, uint256 Tokens);
    event updated_Sell_fees(uint256 Marketing, uint256 Liquidity, uint256 Reflection, uint256 Burn, uint256 Tokens);
    event updated_SwapAndLiquify_Enabled(bool Swap_and_Liquify_Enabled);
    event updated_trade_Open(bool TradeOpen);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensIntoLiqudity);


    // Restrict function to contract owner only 
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }


    // Address mappings
    mapping (address => uint256) private _tOwned;                               // Tokens Owned
    mapping (address => uint256) private _rOwned;                               // Reflected balance
    mapping (address => mapping (address => uint256)) private _allowances;      // Allowance to spend another wallets tokens
    mapping (address => bool) public _isExcludedFromFee;                        // Wallets that do not pay fees
    mapping (address => bool) public _isExcluded;                               // Excluded from RFI rewards
    mapping (address => bool) public _isWhiteListed;                            // Wallets that have access before trade is open
    mapping (address => bool) public _isLimitExempt;                            // Wallets that are excluded from HOLD and TRANSFER limits
    mapping (address => bool) public _isPair;                                   // Address is liquidity pair
    mapping (address => bool) public _isSnipe;                                  // Sniper!
    address[] private _excluded;                                                // Array of wallets excluded from rewards


    // Token information 
    function Token_Information() external view returns(string memory Token_Name,
                                                       string memory Token_Symbol,
                                                       uint256 Number_of_Decimals,
                                                       address Owner_Wallet,
                                                       uint256 Transaction_Limit,
                                                       uint256 Max_Wallet,
                                                       uint256 Fee_When_Buying,
                                                       uint256 Fee_When_Selling,
                                                       string memory Website,
                                                       string memory Telegram,
                                                       string memory Liquidity_Lock_URL) {

                                                           
        uint256 Total_buy =  _Fee__Buy_Burn         +
                             _Fee__Buy_Liquidity    +
                             _Fee__Buy_BNB          +
                             _Fee__Buy_Reflection   +
                             _Fee__Buy_Tokens       ;

        uint256 Total_sell = _Fee__Sell_Burn        +
                             _Fee__Sell_Liquidity   +
                             _Fee__Sell_BNB         +
                             _Fee__Sell_Reflection  +
                             _Fee__Sell_Tokens      ;

        // Return Token Data
        return (_name,
                _symbol,
                _decimals,
                _owner,
                max_Tran / 10 ** _decimals,
                max_Hold / 10 ** _decimals,
                Total_buy,
                Total_sell,
                _Website,
                _Telegram,
                _LP_Locker_URL
                );

    }
    

    // Burn (dead) address
    address public constant Wallet_Burn = 0x000000000000000000000000000000000000dEaD; 

    // Swap triggers
    uint256 private swapTrigger = 11;   
    uint256 private swapCounter = 1;    
    
    // SwapAndLiquify - Automatically processing fees and adding liquidity                                   
    bool public inSwapAndLiquify;
    bool public swapAndLiquifyEnabled; 

    // Launch settings
    bool public TradeOpen;
    bool private LaunchPhase;
    uint256 private LaunchTime;

    // No fee on wallet-to-wallet transfers
    bool noFeeW2W = true;

    // Deflationary Burn - Tokens Sent to Burn are removed from total supply if set to true
    bool public deflationaryBurn;

    // Take fee tracker
    bool private takeFee;

    // Default is false
    function Contract_Options_01__Deflationary_Burn(bool true_or_false) external onlyOwner {
        deflationaryBurn = true_or_false;
    }

    // Default is true
    function Contract_Options_02__No_Fee_Wallet_Transfers(bool true_or_false) public onlyOwner {
        noFeeW2W = true_or_false;
    }

    // Set Buy Fees
    function Contract_SetUp_01__Fees_on_Buy(

        uint256 BNB_on_BUY, 
        uint256 Liquidity_on_BUY, 
        uint256 Reflection_on_BUY, 
        uint256 Burn_on_BUY,  
        uint256 Tokens_on_BUY

        ) external onlyOwner {

        // Buyer protection: max fee can not be set over 20%
        require (BNB_on_BUY          + 
                 Liquidity_on_BUY    + 
                 Reflection_on_BUY   + 
                 Burn_on_BUY         + 
                 Tokens_on_BUY       <= 20, "E01"); 

        // Update fees
        _Fee__Buy_BNB        = BNB_on_BUY;
        _Fee__Buy_Liquidity  = Liquidity_on_BUY;
        _Fee__Buy_Reflection = Reflection_on_BUY;
        _Fee__Buy_Burn       = Burn_on_BUY;
        _Fee__Buy_Tokens     = Tokens_on_BUY;

        // Fees that will need to be processed during swap and liquify
        _SwapFeeTotal_Buy    = _Fee__Buy_BNB + _Fee__Buy_Liquidity;

        emit updated_Buy_fees(_Fee__Buy_BNB, _Fee__Buy_Liquidity, _Fee__Buy_Reflection, _Fee__Buy_Burn, _Fee__Buy_Tokens);
    }

    // Set Sell Fees
    function Contract_SetUp_02__Fees_on_Sell(

        uint256 BNB_on_SELL,
        uint256 Liquidity_on_SELL, 
        uint256 Reflection_on_SELL, 
        uint256 Burn_on_SELL,
        uint256 Tokens_on_SELL

        ) external onlyOwner {

        // Buyer protection: max fee can not be set over 20%
        require (BNB_on_SELL        + 
                 Liquidity_on_SELL  + 
                 Reflection_on_SELL + 
                 Burn_on_SELL       + 
                 Tokens_on_SELL     <= 20, "E02"); 

        // Update fees
        _Fee__Sell_BNB        = BNB_on_SELL;
        _Fee__Sell_Liquidity  = Liquidity_on_SELL;
        _Fee__Sell_Reflection = Reflection_on_SELL;
        _Fee__Sell_Burn       = Burn_on_SELL;
        _Fee__Sell_Tokens     = Tokens_on_SELL;

        // Fees that will need to be processed during swap and liquify
        _SwapFeeTotal_Sell   = _Fee__Sell_BNB + _Fee__Sell_Liquidity;

        emit updated_Sell_fees(_Fee__Sell_BNB, _Fee__Sell_Liquidity, _Fee__Sell_Reflection, _Fee__Sell_Burn, _Fee__Sell_Tokens);
    }

    // Wallet Holding and Transaction Limits (Enter token amount, excluding decimals)
    function Contract_SetUp_03__Wallet_Limits(

        uint256 Max_Tokens_Per_Transaction,
        uint256 Max_Total_Tokens_Per_Wallet 

        ) external onlyOwner {

        // Buyer protection - Limits must be set to greater than 0.1% of total supply
        require(Max_Tokens_Per_Transaction >= _tTotal / 1000 / 10**_decimals, "E03");
        require(Max_Total_Tokens_Per_Wallet >= _tTotal / 1000 / 10**_decimals, "E04");
        
        max_Tran = Max_Tokens_Per_Transaction * 10**_decimals;
        max_Hold = Max_Total_Tokens_Per_Wallet * 10**_decimals;

        emit updated_Wallet_Limits(max_Tran, max_Hold);

    }

    // Set Project Wallets
    function Contract_SetUp_04__Set_Wallets(

        address Token_Fee_Wallet, 
        address payable BNB_Fee_Wallet, 
        address Liquidity_Collection_Wallet

        ) external onlyOwner {

        // Update Token Fee Wallet
        require(Token_Fee_Wallet != address(0), "E05");
        Wallet_Tokens = Token_Fee_Wallet;

        // Make limit exempt
        _isLimitExempt[Token_Fee_Wallet] = true;

        // Update BNB Fee Wallet
        require(BNB_Fee_Wallet != address(0), "E06");
        Wallet_BNB = payable(BNB_Fee_Wallet);

        // To send the auto liquidity tokens directly to burn update to 0x000000000000000000000000000000000000dEaD
        Wallet_Liquidity = Liquidity_Collection_Wallet;

    }

    // Set Project Links
    function Contract_SetUp_05__Update_Socials(

        string memory Website_URL, 
        string memory Telegram_URL, 
        string memory Liquidity_Locker_URL

        ) external onlyOwner{

        _Website         = Website_URL;
        _Telegram        = Telegram_URL;
        _LP_Locker_URL   = Liquidity_Locker_URL;

    }



    // Open trade: Buyer Protection - one way switch - trade can not be paused once opened
    function Contract_SetUp_06__OpenTrade() external onlyOwner {

        // Can only use once!
        require(!TradeOpen, "E07");
        TradeOpen = true;
        swapAndLiquifyEnabled = true;
        LaunchPhase = true;
        LaunchTime = block.timestamp;

        emit updated_trade_Open(TradeOpen);
        emit updated_SwapAndLiquify_Enabled(swapAndLiquifyEnabled); 
    }




    // Setting an address as a liquidity pair
    function Maintenance_01__Add_Liquidity_Pair(

        address Wallet_Address,
        bool true_or_false)

         external onlyOwner {
        _isPair[Wallet_Address] = true_or_false;
        _isLimitExempt[Wallet_Address] = true_or_false;
    } 

    // Transfer the contract to to a new owner
    function Maintenance_02__Transfer_Ownership(address payable newOwner) public onlyOwner {
        require(newOwner != address(0), "E08");

        // Remove old owner status 
        _isLimitExempt[owner()]     = false;
        _isExcludedFromFee[owner()] = false;
        _isWhiteListed[owner()]     = false;


        // Emit ownership transfer
        emit OwnershipTransferred(_owner, newOwner);

        // Transfer owner
        _owner = newOwner;

    }

    // Renounce ownership of the contract 
    function Maintenance_03__Renounce_Ownership() public virtual onlyOwner {
        // Due to a possible exploit, renouncing is not compatible with no-fee wallet-to-wallet transfers
        require(!noFeeW2W, "Can not renounce and have no-fee wallet transfers!");
        // Remove old owner status 
        _isLimitExempt[owner()]     = false;
        _isExcludedFromFee[owner()] = false;
        _isWhiteListed[owner()]     = false;
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }







    /*

    --------------
    FEE PROCESSING
    --------------

    */


    // Default is True. Contract will process fees into Marketing and Liquidity etc. automatically
    function Processing_01__Auto_Process(bool true_or_false) external onlyOwner {
        swapAndLiquifyEnabled = true_or_false;
        emit updated_SwapAndLiquify_Enabled(true_or_false);
    }


    // Manually process fees
    function Processing_02__Process_Now (uint256 Percent_of_Tokens_to_Process) external onlyOwner {
        require(!inSwapAndLiquify, "E09"); 
        if (Percent_of_Tokens_to_Process > 100){Percent_of_Tokens_to_Process == 100;}
        uint256 tokensOnContract = balanceOf(address(this));
        uint256 sendTokens = tokensOnContract * Percent_of_Tokens_to_Process / 100;
        swapAndLiquify(sendTokens);

    }

    // Update count for swap trigger - Number of transactions to wait before processing accumulated fees (default is 10)
    function Processing_03__Update_Swap_Trigger_Count(uint256 Transaction_Count) external onlyOwner {
        // Counter is reset to 1 (not 0) to save gas, so add one to swapTrigger
        swapTrigger = Transaction_Count + 1;
    }


    // Remove random tokens from the contract
    function Processing_04__Remove_Random_Tokens(

        address random_Token_Address,
        uint256 number_of_Tokens

        ) external onlyOwner {
            // Can not purge the native token!
            require (random_Token_Address != address(this), "E10");
            IERC20(random_Token_Address).transfer(msg.sender, number_of_Tokens);
            
    }

    // Wallet will not get reflections
    function Rewards_Exclude_Wallet(address account) public onlyOwner() {
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }


    // Wallet will get reflections - DEFAULT
    function Rewards_Include_Wallet(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }
    

    /*

    ---------------
    WALLET SETTINGS
    ---------------

    */


    // Grants access when trade is closed - Default false (true for contract owner)
    function Wallet_Settings_01__PreLaunch_Access(

        address Wallet_Address,
        bool true_or_false

        ) external onlyOwner {    
        _isWhiteListed[Wallet_Address] = true_or_false;
    }

    // Excludes wallet from transaction and holding limits - Default false
    function Wallet_Settings_02__Exempt_From_Limits(

        address Wallet_Address,
        bool true_or_false

        ) external onlyOwner {  
        _isLimitExempt[Wallet_Address] = true_or_false;
    }

    // Excludes wallet from fees - Default false
    function Wallet_Settings_03__Exclude_From_Fees(

        address Wallet_Address,
        bool true_or_false

        ) external onlyOwner {
        _isExcludedFromFee[Wallet_Address] = true_or_false;

    }









    /*

    -----------------------------
    BEP20 STANDARD AND COMPLIANCE
    -----------------------------

    */

    function owner() public view returns (address) {
        return _owner;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint256) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "Decreased allowance below zero"));
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
   
    function tokenFromReflection(uint256 _rAmount) internal view returns(uint256) {
        require(_rAmount <= _rTotal, "E11");
        uint256 currentRate =  _getRate();
        return _rAmount / currentRate;
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply / tSupply;
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply - _rOwned[_excluded[i]];
            tSupply = tSupply - _tOwned[_excluded[i]];
        }
        if (rSupply < _rTotal / _tTotal) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "Allowance exceeded"));
        return true;
    }

    // Transfer BNB via call to reduce possibility of future 'out of gas' errors
    function send_BNB(address _to, uint256 _amount) internal returns (bool SendSuccess) {
                                
        (SendSuccess,) = payable(_to).call{value: _amount}("");

    }









    /*

    -----------------------
    TOKEN TRANSFER HANDLING
    -----------------------

    */

    // Main transfer checks and settings 
    function _transfer(
        address from,
        address to,
        uint256 amount
      ) private {


        // Allows owner to add liquidity safely, eliminating the risk of someone maliciously setting the price 
        if (!TradeOpen){
        require(_isWhiteListed[from] || _isWhiteListed[to], "E12");
        }


        // Launch Phase
        if (LaunchPhase && to != address(this) && _isPair[from] && to != owner())
            {

            // End Launch Phase after Launch_Length ( 5 Minutes)
            if (block.timestamp > LaunchTime + (60 * 5))

                    {
                        LaunchPhase = false;
                    }

                else

                    {

                        // Stop snipers    
                        require(!_isSnipe[to], "E13");

                        // Detect and restrict snipers
                        if (block.timestamp <= LaunchTime + 5) {
                            require(amount <= _tTotal / 10000, "E14");
                            _isSnipe[to] = true;
                            }
                    }

            }

        // Wallet Limit
        if (!_isLimitExempt[to] && from != owner())
            {
            uint256 heldTokens = balanceOf(to);
            require((heldTokens + amount) <= max_Hold, "E15");
            }


        // Transaction limit - To send over the transaction limit the sender AND the recipient must be limit exempt
        if (!_isLimitExempt[to] || !_isLimitExempt[from])
            {
            require(amount <= max_Tran, "E16");
            }


        // Compliance and safety checks
        require(from != address(0), "E17");
        require(to != address(0), "E18");
        require(amount > 0, "E19");



        // Check if fee processing is possible
        if( _isPair[to] &&
            !inSwapAndLiquify &&
            swapAndLiquifyEnabled
            )
            {

            // Check that enough transactions have passed since last swap
            if(swapCounter >= swapTrigger){

                // Check number of tokens on contract
                uint256 contractTokens = balanceOf(address(this));

                    // Only trigger fee processing if there are tokens to swap!
                    if (contractTokens > 0){

                        // Limit number of tokens that can be swapped 
                        if (contractTokens <= swap_Max){
                            swapAndLiquify (contractTokens);
                            } else {
                            swapAndLiquify (swap_Max);
                            }
                    }
                } 
            }


        // Default: Only charge a fee on buys and sells, no fee for wallet transfers
        takeFee = true;
        if((!_isPair[from] && !_isPair[to] && noFeeW2W) || _isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }

        _tokenTransfer(from, to, amount, takeFee);

    }


    /*
    
    ------------
    PROCESS FEES
    ------------

    */

    function swapAndLiquify(uint256 Tokens) private {

        // Lock swapAndLiquify function
        inSwapAndLiquify        = true;  

        uint256 _FeesTotal      = (_SwapFeeTotal_Buy + _SwapFeeTotal_Sell);
        uint256 LP_Tokens       = Tokens * (_Fee__Buy_Liquidity + _Fee__Sell_Liquidity) / _FeesTotal / 2;
        uint256 Swap_Tokens     = Tokens - LP_Tokens;

        // Swap tokens for BNB
        uint256 contract_BNB    = address(this).balance;
        swapTokensForBNB(Swap_Tokens);
        uint256 returned_BNB    = address(this).balance - contract_BNB;

        // Double fees instead of halving LP fee to prevent rounding errors if fee is an odd number
        uint256 fee_Split = _FeesTotal * 2 - (_Fee__Buy_Liquidity + _Fee__Sell_Liquidity);

        // Calculate the BNB values for each fee (excluding BNB wallet)
        uint256 BNB_Liquidity   = returned_BNB * (_Fee__Buy_Liquidity + _Fee__Sell_Liquidity) / fee_Split;

        // Add liquidity 
        if (LP_Tokens != 0){
            addLiquidity(LP_Tokens, BNB_Liquidity);
            emit SwapAndLiquify(LP_Tokens, BNB_Liquidity, LP_Tokens);
        }

        // Send remaining BNB to BNB wallet
        contract_BNB = address(this).balance;

        if(contract_BNB > 0){

            send_BNB(Wallet_BNB, contract_BNB);
        }


        // Reset transaction counter (reset to 1 not 0 to save gas)
        swapCounter = 1;

        // Unlock swapAndLiquify function
        inSwapAndLiquify = false;
    }



    // Swap tokens for BNB
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



    // Add liquidity and send Cake LP tokens to liquidity collection wallet
    function addLiquidity(uint256 tokenAmount, uint256 BNBAmount) private {

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: BNBAmount}(
            address(this),
            tokenAmount,
            0, 
            0,
            Wallet_Liquidity, 
            block.timestamp
        );
    } 








    /*
    
    ----------------------------------
    TRANSFER TOKENS AND CALCULATE FEES
    ----------------------------------

    */


    uint256 private rAmount;

    uint256 private tBurn;
    uint256 private tTokens;
    uint256 private tReflect;
    uint256 private tSwapFeeTotal;

    uint256 private rBurn;
    uint256 private rReflect;
    uint256 private rTokens;
    uint256 private rSwapFeeTotal;
    uint256 private tTransferAmount;
    uint256 private rTransferAmount;

    

    // Transfer Tokens and Calculate Fees
    function _tokenTransfer(address sender, address recipient, uint256 tAmount, bool Fee) private {

        
        if (Fee){

            if(_isPair[recipient]){

                // Sell fees
                tBurn           = tAmount * _Fee__Sell_Burn       / 100;
                tTokens         = tAmount * _Fee__Sell_Tokens     / 100;
                tReflect        = tAmount * _Fee__Sell_Reflection / 100;
                tSwapFeeTotal   = tAmount * _SwapFeeTotal_Sell    / 100;

            } else {

                // Buy fees
                tBurn           = tAmount * _Fee__Buy_Burn        / 100;
                tTokens         = tAmount * _Fee__Buy_Tokens      / 100;
                tReflect        = tAmount * _Fee__Buy_Reflection  / 100;
                tSwapFeeTotal   = tAmount * _SwapFeeTotal_Buy     / 100;

            }

        } else {

                // No fee - wallet to wallet transfer or exempt wallet 
                tBurn           = 0;
                tTokens         = 0;
                tReflect        = 0;
                tSwapFeeTotal   = 0;

        }

        // Calculate reflected fees for RFI
        uint256 RFI     = _getRate(); 

        rAmount         = tAmount       * RFI;
        rBurn           = tBurn         * RFI;
        rTokens         = tTokens       * RFI;
        rReflect        = tReflect      * RFI;
        rSwapFeeTotal   = tSwapFeeTotal * RFI;

        tTransferAmount = tAmount - (tBurn + tTokens + tReflect + tSwapFeeTotal);
        rTransferAmount = rAmount - (rBurn + rTokens + rReflect + rSwapFeeTotal);

        
        // Swap tokens based on RFI status of sender and recipient
        if (_isExcluded[sender] && !_isExcluded[recipient]) {

            _tOwned[sender] -= tAmount;
            _rOwned[sender] -= rAmount;

                if (deflationaryBurn && recipient == Wallet_Burn) {

                // Remove tokens from Total Supply 
                _tTotal -= tTransferAmount;
                _rTotal -= rTransferAmount;

                } else {

                _rOwned[recipient] += rTransferAmount;

                }

            emit Transfer(sender, recipient, tTransferAmount);

        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {

            _rOwned[sender] -= rAmount;

                if (deflationaryBurn && recipient == Wallet_Burn) {

                // Remove tokens from Total Supply 
                _tTotal -= tTransferAmount;
                _rTotal -= rTransferAmount;

                } else {

                _tOwned[recipient] += tTransferAmount;
                _rOwned[recipient] += rTransferAmount;

                }

            emit Transfer(sender, recipient, tTransferAmount);

        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {

            _rOwned[sender] -= rAmount;

                if (deflationaryBurn && recipient == Wallet_Burn) {

                // Remove tokens from Total Supply 
                _tTotal -= tTransferAmount;
                _rTotal -= rTransferAmount;

                } else {

                _rOwned[recipient] += rTransferAmount;

                }

            emit Transfer(sender, recipient, tTransferAmount);

        } else if (_isExcluded[sender] && _isExcluded[recipient]) {

            _tOwned[sender] -= tAmount;
            _rOwned[sender] -= rAmount;

                if (deflationaryBurn && recipient == Wallet_Burn) {

                // Remove tokens from Total Supply 
                _tTotal -= tTransferAmount;
                _rTotal -= rTransferAmount;

                } else {

                _tOwned[recipient] += tTransferAmount;
                _rOwned[recipient] += rTransferAmount;

                }

            emit Transfer(sender, recipient, tTransferAmount);

        } else {

            _rOwned[sender] -= rAmount;

                if (deflationaryBurn && recipient == Wallet_Burn) {

                // Remove tokens from Total Supply 
                _tTotal -= tTransferAmount;
                _rTotal -= rTransferAmount;

                } else {

                _rOwned[recipient] += rTransferAmount;

                }

            emit Transfer(sender, recipient, tTransferAmount);

        }


        // Take reflections
        if(tReflect > 0){

            _rTotal -= rReflect;
            _tFeeTotal += tReflect;
        }

        // Take tokens
        if(tTokens > 0){

            _rOwned[Wallet_Tokens] += rTokens;
            if(_isExcluded[Wallet_Tokens])
            _tOwned[Wallet_Tokens] += tTokens;

        }

        // Take fees that require processing during swap and liquify
        if(tSwapFeeTotal > 0){

            _rOwned[address(this)] += rSwapFeeTotal;
            if(_isExcluded[address(this)])
            _tOwned[address(this)] += tSwapFeeTotal;

            // Increase the transaction counter
            swapCounter++;
                
        }

        // Handle tokens for burn
        if(tBurn > 0){

            if (deflationaryBurn){

                // Remove tokens from total supply
                _tTotal = _tTotal - tBurn;
                _rTotal = _rTotal - rBurn;

            } else {

                // Send Tokens to Burn Wallet
                _rOwned[Wallet_Burn] += rBurn;
                if(_isExcluded[Wallet_Burn])
                _tOwned[Wallet_Burn] += tBurn;

            }

        }



    }


   

    // This function is required so that the contract can receive BNB during fee processing
    receive() external payable {}




}

/*

---------------------
**** ERROR CODES ****
---------------------

   
    E01 - Buy fees are limited of 20% max to protect buyers
    E02 - Sell fees are limited of 20% max to protect buyers
    E03 - The max transaction limit must be set to more than 0.1% of total supply
    E04 - The max wallet holding limit must be set to more than 0.1% of total supply
    E05 - A valid BSC wallet must be entered when updating the token fee wallet 
    E06 - A valid BSC wallet must be entered when updating the BNB fee wallet 
    E07 - Trade is already open
    E08 - A valid BSC wallet must be entered when transferring ownership
    E09 - Contract is currently processing fees, try later
    E10 - Can not remove the native token
    E11 - rAmount can not be greater than rTotal
    E12 - Trade is not open, only whitelisted wallets can trade
    E13 - Wallet was flagged as a snipe and can not purchase again during launch phase
    E14 - Purchase in first 5 seconds limit exceeded
    E15 - Purchase would exceed max wallet holding limit, trade cancelled
    E16 - Purchase would exceed max transaction limit, trade cancelled 
    E17 - Zero address error, please use a valid BSC address
    E18 - Zero address error, please use a valid BSC address
    E19 - Amount must be greater than 0

*/


// Not open source - Can not be used or forked without permission. Smart Contract Code by Gen, GenTokens.