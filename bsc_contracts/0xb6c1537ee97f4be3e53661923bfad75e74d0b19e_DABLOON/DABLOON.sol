/**
 *Submitted for verification at BscScan.com on 2022-11-25
*/

pragma solidity 0.8.10;


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









contract DABLOON is Context, IERC20 { 

    using SafeMath for uint256;
    using Address for address;

    // External functions restricted to owner
    modifier onlyOwner {
        require(owner() == _msgSender(), "Must be owner");
        _;
    }










    /*

    EVENTS

    */


    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived,uint256 tokensIntoLiqudity);
    event OwnershipTransferRequest(address indexed suggested_newOwner);
    event renounceOwnership_Requested(bool renounceOwnership_Requested);
    event requestUpdate_MultiSig_Wallet(address indexed suggested_MultiSig_Wallet);
    event multiSig_Wallet_Updated(address indexed old_MultiSigWallet, address indexed new_MultiSig_Wallet);
    event updated_PreLaunch_Access(address indexed WalletAddress, bool PreLaunchAccess);
    event updated_LimitExempt(address indexed WalletAddress, bool LimitExempt);
    event updated_bypassLimits(address indexed WalletAddress, bool Bypass_Limits);
    event updated_Set_Pair(address indexed WalletAddress, bool Set_As_Pair);
    event updated_ExcludeFromFee(address indexed WalletAddress, bool ExcludedFromFee);
    event updated_ExcludeFromReward(address indexed WalletAddress);
    event updated_IncludeInReward(address indexed WalletAddress);
    event updated_Fees(uint _FeeBuy_Total, uint _FeeBuy_Reflection, uint _FeeBuy_Tokens, uint _FeeSell_Total, uint _FeeSell_Reflection, uint _FeeSell_Tokens);
    event updated_Fee_Split(uint256 percent_to_BNB_Wallet, uint256 percent_to_Liquidity);
    event updated_free_transfers(bool free_to_transfer_wallet2wallet);
    event updated_Liquidity_Wallet(address indexed old_Liquidity_Wallet, address indexed new_Liquidity_Wallet);
    event updated_BNB_Wallet(address indexed old_BNB_Wallet, address indexed new_BNB_Wallet);
    event updated_Token_Wallet(address indexed old_Token_Wallet, address indexed new_Token_Wallet);
    event updated_Wallet_Limits(uint256 Max_Hold_Limit, uint256 Max_Transaction_Limit);
    event tradeOpened(bool Trade_Open);
    









    /*
    
    ADDRESS MAPPINGS

    */


    mapping (address => mapping (address => uint256)) private _allowances;      // Allowance
    mapping (address => uint256) private _rOwned;                               // Reflected balance
    mapping (address => uint256) private _tOwned;                               // True balance
    mapping (address => bool) public _isExcludedFromFee;                        // Does not pay transaction fees
    mapping (address => bool) public _isExcluded;                               // Excluded from RFI rewards
    mapping (address => bool) public _isPair;                                   // Liquidity pair
    mapping (address => bool) public _limitExempt;                              // Excluded from transaction and hold limits
    mapping (address => bool) public _bypassLimits;                             // Can send over limits to limited wallets
    mapping (address => bool) public _preLaunchAccess;                          // Access before trade is open
    









    /*
    
    SET ADDRESSES

    */


    // Owner is set in constructor during deployment
    address private _owner;                                             

    // Wallets for fee processing
    address payable public Wallet_BNB           = payable(0x684cc7a8804CcAcfB08373706d2BA22eafC7e26E); 
    address payable public Wallet_Tokens        = payable(0x684cc7a8804CcAcfB08373706d2BA22eafC7e26E);
    address payable public Wallet_LP            = payable(0x684cc7a8804CcAcfB08373706d2BA22eafC7e26E);

    // Track burns to make token deflationary
    address payable public constant Wallet_Burn = payable(0x000000000000000000000000000000000000dEaD); 

    // Multi-Sig confirmation wallet
    address public Wallet_Multi_Sig = 0xC28b4a51A54FcDE3dc38794704a5e25884748798;

    // Array of wallets excluded from rewards
    address[] private _excluded;
                                     
    // Initial liquidity pair for GEN/BNB (Pair is set in constructor during deployment)
    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;
    









    /*

    BASIC TOKEN INFO

    */


    string private constant _name       = "Dabloons"; 
    string private constant _symbol     = "DAB";

    uint256 private constant _decimals  = 18;
    uint256 private constant MAX        = ~uint256(0);
    uint256 private _tTotal             = 1 * 10**9 * 10**_decimals; 
    uint256 private _rTotal             = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;
    









    /*

    FEES

    */ 

  
    // Total fees
    uint256 public _FeeBuy_Total        = 9;       // Total Fee on Buys - Includes Reflection and token fees
    uint256 public _FeeSell_Total       = 9;       // Total Fee on Sells - Includes Reflection and token fees

    // Reflection rewards
    uint256 public _FeeBuy_Reflection   = 0;        // RFI to holders on Buys
    uint256 public _FeeSell_Reflection  = 3;        // RFI to holders on Sells

    // Token fees (for giveaways, burns etc)
    uint256 public _FeeBuy_Tokens       = 0;        // Fee Taken in Tokens on Buys
    uint256 public _FeeSell_Tokens      = 0;        // Fee Taken in Tokens on Sells

    // BNB Fee Splits, Total Must = 100
    uint256 public Split_BNB            = 50;       // Percent of fee that goes to external BNB wallet (Team/Marketing/Development)
    uint256 public Split_LP             = 50;       // Percent of fee for auto liquidity
    









    /*
    
    INIT RFI UINTS

    */

    uint256 private rRef;
    uint256 private rTok;
    uint256 private rFee;
    uint256 private rTransferAmount;
    uint256 private tAmount;
    uint256 private rAmount;
    uint256 private tRef;
    uint256 private tTok;
    uint256 private tFee;
    uint256 private tTransferAmount;
    









    /*

    INIT BOOLS

    */


    bool public freeSwap = true;                    // No fee to transfer between wallets
    bool public swapAndLiquifyEnabled = true;
    bool public inSwapAndLiquify;
    bool public TradeOpen;
    









    /*
    
    LIMITS AND TRIGGERS

    */             
   

    // Wallet limits 
    uint256 public Max_Hold = _tTotal / 100;        // 1% of total supply
    uint256 public Max_Tran = _tTotal / 100;        // 1% of total supply

    // Swap and Liquify trigger limits
    uint256 public Swap_BNB     = 1 * 10**17;       // BNB swap target (in Wei) 0.2 BNB - Set to 0 stop auto updates
    uint256 public Swap_TOK     = 1000**_decimals;  // Number of tokens to trigger swap (Updated on each swap to match target Swap_BNB) 
    uint256 public Swap_TOK_MAX = _tTotal / 200;    // The max limit for the token swap (To prevent large swaps due to big price swings)
   
    







    /*
    
    CONSTRUCTOR

    */

    // Constructors are only called once, during contract deployment
    constructor () {

        // Set owner and transfer supply 
        _owner = msg.sender;
        _rOwned[owner()] = _rTotal;
        emit OwnershipTransferred(address(0), _owner);
        emit Transfer(address(0), owner(), _tTotal);
        
        // Set pancake router address
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); 

        // Create liquidity pair
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;

    }
    









    /*

    MULTI-SIG PROTECTION

    */


    // Used for MultiSig - Ownership transfer, renounce and confirmation wallet updates
    bool public multiSig_Renounce_Ownership_ASKED   = false;
    bool public multiSig_Transfer_Ownership_ASKED   = false;
    bool public multiSig_Update_2nd_Wallet_ASKED    = false;

    // Suggested wallets are set to current wallets to avoid the appearance of the zero address being suggested during deployment

    // Transfer Ownership - Suggested new owner wallet (must be confirmed)
    address public suggested_New_Owner_Wallet = _owner;

    // Update Confirmation Wallet for Multi-Sig - Suggested new wallet (must be confirmed)
    address public suggested_New_MultiSig_2nd_Wallet = Wallet_Multi_Sig;

    // Transfer Ownership - Requires Multi-Sig
    function multiSig_Transfer_Ownership_ASK(address newOwner_Request) external onlyOwner {

        require(!multiSig_Transfer_Ownership_ASKED, "Already asked, wait confirmation");
        require(newOwner_Request != address(0), "New owner can not be zero address");
        multiSig_Transfer_Ownership_ASKED = true;
        suggested_New_Owner_Wallet = newOwner_Request;
        emit OwnershipTransferRequest(newOwner_Request);
    }

    function multiSig_Transfer_Ownership_CONFIRM(bool true_or_false) external {

        require(msg.sender == Wallet_Multi_Sig, "Confirmation wallet must confirm");
        require (multiSig_Transfer_Ownership_ASKED, "Transfering Ownership not requested");

        if (true_or_false){

        // Transfer ownership and reset ask permissions
        emit OwnershipTransferred(_owner, suggested_New_Owner_Wallet);
        _owner = suggested_New_Owner_Wallet;
        multiSig_Transfer_Ownership_ASKED = false;

        // Set new owner privileges
        // Previous owner privileges are NOT automatically removed - revoke manually if desired

        _isExcludedFromFee[owner()] = true;
        _limitExempt[owner()] = true;

        } else {

        // Reset ask permissions
        multiSig_Transfer_Ownership_ASKED = false;

        }
    }

    // Renounce Ownership - Requires Multi-Sig
    function multiSig_Renounce_Ownership_ASK() external onlyOwner {

        require (!multiSig_Renounce_Ownership_ASKED, "Already asked, wait confirmation");
        multiSig_Renounce_Ownership_ASKED = true;
        emit renounceOwnership_Requested(multiSig_Renounce_Ownership_ASKED);
    }

    function multiSig_Renounce_Ownership_CONFIRM(bool true_or_false) external {

        require(msg.sender == Wallet_Multi_Sig, "Confirmation wallet must confirm");
        require(multiSig_Renounce_Ownership_ASKED, "Renounce not requested");

        if (true_or_false){

        // Renounce ownership of contract
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);

        } else {

        // Reset ask permissions
        multiSig_Renounce_Ownership_ASKED = false;

        }
    }

    // Update MultiSig 2nd Wallet - Requires Multi-Sig
    function multiSig_Update_2nd_Wallet_ASK(address payable new_MultiSig_2nd_Wallet) external onlyOwner {

        require(suggested_New_MultiSig_2nd_Wallet != address(0), "Can not be zero address");
        require(!multiSig_Update_2nd_Wallet_ASKED, "Already asked, wait confirmation");
        suggested_New_MultiSig_2nd_Wallet = new_MultiSig_2nd_Wallet;
        multiSig_Update_2nd_Wallet_ASKED = true;
        emit requestUpdate_MultiSig_Wallet(new_MultiSig_2nd_Wallet);

    }

    function multiSig_Update_2nd_Wallet_CONFIRM(bool true_or_false) external {

        require(msg.sender == Wallet_Multi_Sig, "Confirmation wallet must confirm");
        require(multiSig_Update_2nd_Wallet_ASKED, "Change not requested");
        if(true_or_false){
                multiSig_Update_2nd_Wallet_ASKED = false;
                emit multiSig_Wallet_Updated(Wallet_Multi_Sig, suggested_New_MultiSig_2nd_Wallet);
                Wallet_Multi_Sig = suggested_New_MultiSig_2nd_Wallet;
            } else {
                multiSig_Update_2nd_Wallet_ASKED = false;
            }
        }
    









    /*

    STANDARD FUNCTIONS AND ERC20/BEP20 COMPLIANCE
    
    */

    function name() external pure returns (string memory) {
        return _name;
    }

    function symbol() external pure returns (string memory) {
        return _symbol;
    }

    function decimals() external pure returns (uint256) {
        return _decimals;
    }

    function totalSupply() external view override returns (uint256) {
        return _tTotal;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function allowance(address theOwner, address spender) external view override returns (uint256) {
        return _allowances[theOwner][spender];
    }

    function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function approve(address spender, uint256 amount) external override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function _approve(address theOwner, address spender, uint256 amount) private {
        require(theOwner != address(0) && spender != address(0), "ERR: zero address");
        _allowances[theOwner][spender] = amount;
        emit Approval(theOwner, spender, amount);
    }
   
    function tokenFromReflection(uint256 _rAmount) internal view returns(uint256) {
        require(_rAmount <= _rTotal, "Amount must be less than total reflections");
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

    function openTrade() external onlyOwner {
        TradeOpen = true;
        emit tradeOpened(TradeOpen);
    }
    

    







    /*

    UPDATE MAPPINGS

    */


    // PreLaunch Access - able to buy and sell when trade is closed 
    function mapping_PreLaunch_Access(address account, bool true_or_false) external onlyOwner {    
        _preLaunchAccess[account] = true_or_false;
        emit updated_PreLaunch_Access(account, true_or_false);
    }

    // Limit Exempt - Excluded from wallet and transaction limits
    function mapping_Limit_Exempt(address account, bool true_or_false) external onlyOwner {    
        _limitExempt[account] = true_or_false;
        emit updated_LimitExempt(account, true_or_false);
    }

    // ByPassLimits - Can send over Trans Limit to any wallet
    function mapping_bypassLimits(address account, bool true_or_false) external onlyOwner {    
        _bypassLimits[account] = true_or_false;
        emit updated_bypassLimits(account, true_or_false);
    }

    // Set as liquidity pair
    function mapping_Set_Pair(address account, bool true_or_false) external onlyOwner {    
        _isPair[account] = true_or_false;
        emit updated_Set_Pair(account, true_or_false);
    }

    // Set a wallet address so that it does not have to pay transaction fees
    function mapping_excludeFromFee(address account, bool true_or_false) external onlyOwner {
        _isExcludedFromFee[account] = true_or_false;
        emit updated_ExcludeFromFee(account, true_or_false);
    }

    // Exclude wallet from RFI - LOOP RISK OF OUT OF GAS! LIMIT TO ESSENTIAL WALLETS! (Contract, Pair and Burn ONLY!)
    function mapping_excludeFromReward(address account) external onlyOwner {
        require(!_isExcluded[account], "Account already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
        emit updated_ExcludeFromReward(account);
    }

    // Include wallet in RFI
    function mapping_includeInReward(address account) external onlyOwner {
        require(_isExcluded[account], "Account already included");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
        emit updated_IncludeInReward(account);
    }
    









    /*

    FEES  

    */


    // Set buy and sell fees
    function _set_Fees(

                        uint256 Buy_Total, 
                        uint256 Buy_Reflection, 
                        uint256 Buy_Tokens,

                        uint256 Sell_Total,
                        uint256 Sell_Reflection,
                        uint256 Sell_Tokens

                        ) external onlyOwner {

                        // Reflection and token fee must be included in total fee on buy and sell
                        require(Buy_Total   >= (Buy_Reflection + Buy_Tokens), "Total Fee Must Include Reflection and Token Fee");
                        require(Sell_Total  >= (Sell_Reflection + Sell_Tokens), "Total Fee Must Include Reflection and Token Fee");

                        // Buy and sell total fee limited to 12 to protect buyers
                        require(Buy_Total   <= 12, "Over max limit");
                        require(Sell_Total  <= 12, "Over max limit");

                        _FeeBuy_Total       = Buy_Total;
                        _FeeBuy_Reflection  = Buy_Reflection;
                        _FeeBuy_Tokens      = Buy_Tokens;

                        _FeeSell_Total      = Sell_Total;
                        _FeeSell_Reflection = Sell_Reflection;
                        _FeeSell_Tokens     = Sell_Tokens;

                        emit updated_Fees(_FeeBuy_Total, _FeeBuy_Reflection, _FeeBuy_Tokens, _FeeSell_Total, _FeeSell_Reflection, _FeeSell_Tokens);
    }

    // Set fee processing percent split
    function _set_Fees_Split(

                        uint256 _Split_BNB,
                        uint256 _Split_Liquidity

                        ) external onlyOwner {


                        // Total must equal 100
                        require(_Split_BNB + _Split_Liquidity == 100, "Total fee splits must be 100");


                        Split_BNB   = _Split_BNB;
                        Split_LP    = _Split_Liquidity;

                        emit updated_Fee_Split(Split_BNB, Split_LP);

    }

    // Toggle 'Fee-Free-Transfers' (No Fee to Transfer Between Wallets)
    function _set_Fee_FreeSwap(bool true_or_false) external onlyOwner {
        freeSwap = true_or_false;
        emit updated_free_transfers(true_or_false);

    }
    









    /*

    UPDATE WALLETS

    */


    // Update the LP wallet
    function Wallet_Update_Cake_LP(address payable wallet) external onlyOwner {

        // To send the Auto LP tokens to Burn change this to 0x000000000000000000000000000000000000dEaD
        emit updated_Liquidity_Wallet(Wallet_LP, wallet);
        Wallet_LP = wallet;
    }

    // Update the BNB wallet
    function Wallet_Update_BNB(address payable wallet) external onlyOwner {

        // Can't be zero address
        require(wallet != address(0), "Can not be zero address");
        emit updated_BNB_Wallet(Wallet_BNB, wallet);
        Wallet_BNB = wallet;
    }

    // Update the Token wallet - Must be limit exempt!
    function Wallet_Update_Tokens(address payable wallet) external onlyOwner {

        // Can't be zero address
        require(wallet != address(0), "Can not be zero address");
        emit updated_Token_Wallet(Wallet_Tokens, wallet);

        // Update old wallet
        _limitExempt[Wallet_Tokens] = false;

        Wallet_Tokens = wallet;
        
        // Update new wallet
        _limitExempt[Wallet_Tokens] = true;
    }
    









    /*

    UPDATE LIMITS

    */


    // Wallet Holding and Transaction Limits
    function set_Limits_For_Wallets(

        uint256 max_Tran_Tokens,
        uint256 max_Hold_Tokens

        ) external onlyOwner {

        // Buyer protection - can not be set to zero
        require(max_Hold_Tokens > 0, "Must be greater than zero");
        require(max_Tran_Tokens > 0, "Must be greater than zero");
        
        Max_Hold = max_Hold_Tokens * 10**_decimals;
        Max_Tran = max_Tran_Tokens * 10**_decimals;

        emit updated_Wallet_Limits(Max_Hold, Max_Tran);
    }


    

    





    /*
    
    SWAP AND LIQUIFY SETTINGS

    */


    // BNB target for auto swap trigger - Set to 0 to disable auto Swap_TOK update
    function Swap_BNB_Target(uint256 _Swap_BNB) external onlyOwner {
        Swap_BNB = _Swap_BNB;
    }

    // Manually set token swap target (If BNB target = 0)
    function Swap_Token_Amount(uint256 _Swap_TOK) external onlyOwner {
        Swap_TOK = _Swap_TOK;
    }

    // Set max limit for token swap target
    function Swap_Token_Amount_MAX(uint256 _Swap_TOK_MAX) external onlyOwner {
        Swap_TOK_MAX = _Swap_TOK_MAX;
    }

    // Toggle on and off to activate auto fee processing
    function Swap_And_Liquify_Enabled(bool true_or_false) external onlyOwner {
        swapAndLiquifyEnabled = true_or_false;
        emit SwapAndLiquifyEnabledUpdated(true_or_false);
    }

    // Manual 'SwapAndLiquify' Trigger 
    function Swap_Now(uint256 percent_Of_Tokens_To_Liquify) external onlyOwner {
        require(!inSwapAndLiquify, "Processing liquidity"); 
        if (percent_Of_Tokens_To_Liquify > 100){percent_Of_Tokens_To_Liquify == 100;}
        uint256 tokensOnContract = balanceOf(address(this));
        uint256 sendTokens = tokensOnContract * percent_Of_Tokens_To_Liquify / 100;
        swapAndLiquify(sendTokens);
    }










    /*
    
    TOKEN TRANSFER CONTROL

    */


    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {


        // Check if trade is open
        if (!TradeOpen)
            {
            require(_preLaunchAccess[from] || _preLaunchAccess[to], "Trade not open");
            }


        // Wallet Limit
        if (!_limitExempt[to] && from != owner())
            {
            uint256 heldTokens = balanceOf(to);
            require((heldTokens + amount) <= Max_Hold, "Over wallet max");
            }


        // Transaction limit
        if ((!_limitExempt[to] || !_limitExempt[from]) && !_bypassLimits[from])
            {
            require(amount <= Max_Tran, "Over transaction limit");
            }


        // Standard checks and compliance
        require(from != address(0) && to != address(0), "0 address detected");
        require(amount > 0, "Amount must be greater than 0");


        // Do we need to process fees (Trigger Swap and Liquify)? 
        if(_isPair[to] && !inSwapAndLiquify && swapAndLiquifyEnabled)
            {   
            // Check the Contract Token Balance to see if ready for swap
            uint256 CTB = balanceOf(address(this));
            if(CTB >= Swap_TOK){swapAndLiquify(Swap_TOK);}
            }


        // Transfer Tokens
        _tokenTransfer(from,to,amount);

    }
    









    /*

    FEE PROCESSING - SWAP AND LIQUIFY

    */


    // Process the fees 
    function swapAndLiquify(uint256 SL_TOKENS) private {

            // Lock the swap
            inSwapAndLiquify = true;
            
            // Get tokens to swap
            uint256 LP_TOK = SL_TOKENS * Split_LP / 200;
            uint256 swapTokens = SL_TOKENS - LP_TOK;

            // Swap tokens
            uint256 BeforeSwap = address(this).balance;
            swapTokensForBNB(swapTokens);

            // Calculate BNB for liquidity
            uint256 Swapped = address(this).balance - BeforeSwap;
            uint256 LP_BNB = Swapped * Split_LP / (200 - Split_LP);

            // Add liquidity
            if (LP_TOK != 0){
            addLiquidity(LP_TOK, LP_BNB);
            emit SwapAndLiquify(LP_TOK, LP_BNB, LP_TOK);
            }

            // Send BNB to marketing and development
            uint256 BNB_Now = address(this).balance;
            if (BNB_Now > 0){
            Wallet_BNB.transfer(BNB_Now);
            }

            // Calculate the next swap trigger - set manually if Swap_BNB is set to 0
            if (Swap_BNB != 0){
            Swap_TOK = swapTokens * Swap_BNB / Swapped;
            // Limit the swap
            if (Swap_TOK > Swap_TOK_MAX){Swap_TOK = Swap_TOK_MAX;}
            }

            // Unlock the swap
            inSwapAndLiquify = false;
    }


    // Swap tokens to BNB
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


    // Add Liquidity
    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {

        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, 
            0, 
            Wallet_LP,
            block.timestamp
        );
    }


    // Allow contract to receive BNB
    receive() external payable {}


    // Purge random tokens from the contract
    function Purge_Tokens(address random_Token_Address, uint256 percent_of_Tokens) external onlyOwner returns(bool _sent){
        uint256 totalRandom = IERC20(random_Token_Address).balanceOf(address(this));
        uint256 removeRandom = totalRandom * percent_of_Tokens / 100;
        _sent = IERC20(random_Token_Address).transfer(msg.sender, removeRandom);

    }
    









    /*

    TAKE FEES

    */


    // Take non-token fees and add to contract
    function _takeFee(uint256 _tFee, uint256 _rFee) private {

        _rOwned[address(this)] = _rOwned[address(this)] + _rFee;
        if(_isExcluded[address(this)])
        _tOwned[address(this)] = _tOwned[address(this)] + _tFee;
    }

    // Adjust RFI 
    function _takeRef(uint256 _tRef, uint256 _rRef) private {

        _rTotal = _rTotal - _rRef;
        _tFeeTotal = _tFeeTotal + _tRef;
    }

    // Take token fee and send to token wallet
    function _takeTok(uint256 _tTok, uint256 _rTok) private {

        _rOwned[Wallet_Tokens] = _rOwned[Wallet_Tokens] + _rTok;
        if(_isExcluded[Wallet_Tokens])
        _tOwned[Wallet_Tokens] = _tOwned[Wallet_Tokens] + _tTok;
    }
    









    /*

    TRANSFER TOKENS AND CALCULATE FEES

    */


    // Transfer Tokens and Calculate Fees
    function _tokenTransfer(address sender, address recipient, uint256 amount) private {

        // Calculate the transfer fees
        tAmount = amount;

        if (_isExcludedFromFee[recipient] || _isExcludedFromFee[sender]){

        tRef = 0;
        tTok = 0;
        tFee = 0;

        } else if (_isPair[recipient]){

        tRef = tAmount * _FeeSell_Reflection / 100;
        tTok = tAmount * _FeeSell_Tokens / 100;
        tFee = tAmount * (_FeeSell_Total - _FeeSell_Reflection - _FeeSell_Tokens) / 100;

        } else if (_isPair[sender]){
       
        tRef = tAmount * _FeeBuy_Reflection / 100;
        tTok = tAmount * _FeeBuy_Tokens / 100;
        tFee = tAmount * (_FeeBuy_Total - _FeeBuy_Reflection - _FeeBuy_Tokens) / 100;

        } else if (!_isPair[recipient] && !_isPair[sender] && freeSwap){

        tRef = 0;
        tTok = 0;
        tFee = 0;

        } else if (!_isPair[recipient] && !_isPair[sender] && !freeSwap){

        tRef = tAmount * _FeeSell_Reflection / 100;
        tTok = tAmount * _FeeSell_Tokens / 100;
        tFee = tAmount * (_FeeSell_Total - _FeeSell_Reflection - _FeeSell_Tokens) / 100;
        
        }

        // Calculate reflected fees for RFI
        uint256 RFI_Rate = _getRate(); 

        rAmount = tAmount * RFI_Rate;

        rRef = tRef * RFI_Rate;
        rTok = tTok * RFI_Rate;
        rFee = tFee * RFI_Rate;

        tTransferAmount = tAmount - (tRef + tFee + tTok);
        rTransferAmount = rAmount - (rRef + rFee + rTok);
        
        // Swap tokens based on RFI status of sender and recipient
        if (_isExcluded[sender] && !_isExcluded[recipient]) {

        _tOwned[sender] = _tOwned[sender] - tAmount;
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        emit Transfer(sender, recipient, tTransferAmount);

        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {

        _rOwned[sender] = _rOwned[sender] - rAmount;
        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        emit Transfer(sender, recipient, tTransferAmount);

        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {

        _rOwned[sender]     = _rOwned[sender] - rAmount;
        _rOwned[recipient]  = _rOwned[recipient] + rTransferAmount;

        emit Transfer(sender, recipient, tTransferAmount);

        } else if (_isExcluded[sender] && _isExcluded[recipient]) {

        _tOwned[sender] = _tOwned[sender] - tAmount;
        _rOwned[sender] = _rOwned[sender] - rAmount;
        _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
        _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;

        emit Transfer(sender, recipient, tTransferAmount);

        } else {

        _rOwned[sender]     = _rOwned[sender] - rAmount;
        _rOwned[recipient]  = _rOwned[recipient] + rTransferAmount;

        emit Transfer(sender, recipient, tTransferAmount);

        }

        // Take fees if required
        if(tFee != 0){_takeFee(tFee, rFee);}
        if(tTok != 0){_takeTok(tTok, rTok);}
        if(tRef != 0){_takeRef(tRef, rRef);}

        // Make burn deflationary
        if(recipient == Wallet_Burn){

        _tTotal = _tTotal - tTransferAmount;
        _rTotal = _rTotal - rTransferAmount;

        }

    }

}