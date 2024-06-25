/**
 *Submitted for verification at BscScan.com on 2022-09-07
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.4;

interface IBEP20 {
  function totalSupply() external view returns (uint256);
  function decimals() external view returns (uint8);
  function symbol() external view returns (string memory);
  function name() external view returns (string memory);
  function getOwner() external view returns (address);
  function balanceOf(address account) external view returns (uint256);
  function transfer(address recipient, uint256 amount) external returns (bool);
  function allowance(address _owner, address spender) external view returns (uint256);
  function approve(address spender, uint256 amount) external returns (bool);
  function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * SafeMath
 */
library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: value }(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
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

/**
 * Basic access control mechanism
 */
contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
    
}

/**
 * DEX Interfaces
 */
interface IPancakeRouter01 {
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

    function factory() external pure returns (address);
    function WETH() external pure returns (address);
    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getamountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getamountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getamountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getamountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
interface IPancakeRouter02 is IPancakeRouter01 {
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
interface IPancakeBEP20 {
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
}
interface IPancakeFactory {
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

contract KillMurray is Context, IBEP20, Ownable {
    using SafeMath for uint256;
    using Address for address;
    // Events
    event OwnerUpdateTaxes(uint8 reflectionTax,uint8 secondaryTax);
    event OwnerRemoveLPPercent(uint8 LPPercent);
    event OwnerExtendLPLock(uint256 timeSeconds);
    event OwnerLockLP(uint256 liquidityUnlockSeconds);
    event OwnerUpdateSwapThreshold(uint8 _swapThreshold);
    event OwnerTriggerSwap(uint8 _swapThreshold,bool ignoreLimits);
    event OwnerCreateLP(uint256 LPtokens,uint256 amountWei);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(uint256 liquidityTokens,uint256 LPBNB);
    // Mappings
    mapping (address => uint256) private _rOwned;
    mapping (address => uint256) private _tOwned;
    mapping (address => mapping (address => uint256)) private _allowances;
    mapping (address => bool) private _isExcludedFromFee;
    mapping (address => bool) private _isExcluded;
    mapping (address => bool) private _blacklist;
    // Basic Contract Info
    address[] private _excluded;
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal = 1_000_000_000*(10**9);
    uint256 private _rTotal = (MAX - (MAX % _tTotal));
    uint256 private _tFeeTotal;

    string private _name = "Kill Murray";
    string private _symbol = "$KMURRAY";
    uint8 private _decimals = 9;
    // Burn Wallet
    address public burnWallet = 0x000000000000000000000000000000000000dEaD;
    // BNB distribution
    uint256 public totalLPBNB;
    uint256 public totalMarketingBNB;
    // Liquidity lock
    uint256 public liquidityUnlockSeconds;
    // Taxes
    uint256 public _reflectFee = 5;
    uint256 private _previousReflectFee = _reflectFee;
    uint256 public _secondaryTax = 3;
    uint256 private _previousSecondaryFee = _secondaryTax;
    Taxes private _taxes;
    struct Taxes {
        uint16 liquidityTax;
        uint16 marketingTax;
    }
    // DEX
    IPancakeRouter02 private _pancakeRouter;
    address public _pancakeRouterAddress=0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public pancakePairAddress;
    address[] private _holders;
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = false;
    uint8 private swapThreshold=25;
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    constructor () {
        _rOwned[address(this)] = _rTotal;
        emit Transfer(address(0), address(this), _tTotal);
        _pancakeRouter=IPancakeRouter02(_pancakeRouterAddress);
        pancakePairAddress=IPancakeFactory(_pancakeRouter.factory()).createPair(address(this),_pancakeRouter.WETH());
        _approve(address(this),address(_pancakeRouter), type(uint256).max);
        //exclude pair and burn wallet from reflections
        excludeFromReward(address(pancakePairAddress));
        excludeFromReward(address(burnWallet));
        //exclude owner and this contract from fee
        _isExcludedFromFee[owner()]=_isExcludedFromFee[burnWallet]=_isExcludedFromFee[address(this)]=true;
        _taxes.liquidityTax=_taxes.marketingTax=50; // secondary taxes`
    }
// Basic Internal Functions
    function name() public view override returns (string memory) {
        return _name;
    }
    function symbol() public view override returns (string memory) {
        return _symbol;
    }
    function decimals() public view override returns (uint8) {
        return _decimals;
    }
    function totalSupply() public view override returns (uint256) {
        return _tTotal;
    }
    function getOwner() external view override returns (address) { return owner();}
    
    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }
    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }
    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }
    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
        return true;
    }
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }
    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
        return true;
    }
    receive() external payable {
        require(msg.sender==owner()||msg.sender==_pancakeRouterAddress);
    }
    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "BEP20: approve from the zero address");
        require(spender != address(0), "BEP20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
// Reflections
    function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tTransferAmount, uint256 tFee, uint256 tSecondary) = _getTValues(tAmount);
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tSecondary, _getRate());
        return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tSecondary);
    }
    function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
        uint256 tFee = calculateReflectFee(tAmount);
        uint256 tSecondary = calculateSecondaryFee(tAmount);
        uint256 tTransferAmount = tAmount.sub(tFee).sub(tSecondary);
        return (tTransferAmount, tFee, tSecondary);
    }
    function _getRValues(uint256 tAmount, uint256 tFee, uint256 tSecondary, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 rAmount = tAmount.mul(currentRate);
        uint256 rFee = tFee.mul(currentRate);
        uint256 rSecondary = tSecondary.mul(currentRate);
        uint256 rTransferAmount = rAmount.sub(rFee).sub(rSecondary);
        return (rAmount, rTransferAmount, rFee);
    }
    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }
    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _rTotal;
        uint256 tSupply = _tTotal;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
            rSupply = rSupply.sub(_rOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tOwned[_excluded[i]]);
        }
        if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
        return (rSupply, tSupply);
    }
// Taxes
    function calculateReflectFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_reflectFee).div(
            10**2
        );
    }
    function calculateSecondaryFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_secondaryTax).div(
            10**2
        );
    }
    function removeAllFee() private {
        if(_reflectFee == 0 && _secondaryTax == 0) return;
        
        _previousReflectFee = _reflectFee;
        _previousSecondaryFee = _secondaryTax;
        
        _reflectFee = 0;
        _secondaryTax = 0;
    }
    function restoreAllFee() private {
        _reflectFee = _previousReflectFee;
        _secondaryTax = _previousSecondaryFee;
    }
    function _takeFees(uint256 tSecondary, uint256 rFee, uint256 tFee) private {
        _rTotal = _rTotal.sub(rFee);
        _tFeeTotal = _tFeeTotal.add(tFee);
        uint256 currentRate =  _getRate();
        uint256 rSecondary = tSecondary.mul(currentRate);
        _rOwned[address(this)] = _rOwned[address(this)].add(rSecondary);
        if(_isExcluded[address(this)])
            _tOwned[address(this)] = _tOwned[address(this)].add(tSecondary);
    }
// Swap and distribution
    function swapAndLiquify(uint8 _swapThreshold,bool ignoreLimits) private lockTheSwap {
        uint256 toSwap=_swapThreshold*balanceOf(pancakePairAddress)/1000;
        // Get balance of contract
        uint256 contractBalance = balanceOf(address(this));
        if (contractBalance < toSwap) {
            if (ignoreLimits)
                toSwap = contractBalance;
            else return;
        }
        uint256 totalLiquidityTokens=toSwap*_taxes.liquidityTax/100;
        uint256 tokensLeft=toSwap-totalLiquidityTokens;
        uint256 liquidityTokens=totalLiquidityTokens/2;
        uint256 liquidityBNBTokens=totalLiquidityTokens-liquidityTokens;
        toSwap=liquidityBNBTokens+tokensLeft;
        uint256 oldBNB=address(this).balance;
        swapTokensForBNB(toSwap);
        uint256 newBNB=address(this).balance-oldBNB;
        uint256 LPBNB=(newBNB*liquidityBNBTokens)/toSwap;
        addLiquidity(liquidityTokens, LPBNB);
        uint256 remainingBNB=address(this).balance-oldBNB;
        uint256 marketingBNB=remainingBNB;
        totalMarketingBNB+=marketingBNB;
        emit SwapAndLiquify(liquidityTokens,LPBNB);
    }
    function swapTokensForBNB(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        // WBNB
        path[1] = _pancakeRouter.WETH();
        _pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            // Receiver address
            address(this),
            block.timestamp
        );
    }
    function addLiquidity(uint256 tokenAmount, uint256 amountWei) private {
        totalLPBNB+=amountWei;
        _pancakeRouter.addLiquidityETH{value: amountWei}(
            // Liquidity Tokens are sent from contract, NOT OWNER!
            address(this),
            tokenAmount,
            0,
            0,
            // contract receives CAKE-LP, NOT OWNER!
            address(this),
            block.timestamp
        );
    }
    function _removeLiquidityPercent(uint8 percent) private {
        IPancakeBEP20 lpToken = IPancakeBEP20(pancakePairAddress);
        uint256 amount = lpToken.balanceOf(address(this)) * percent / 100;
        lpToken.approve(address(_pancakeRouter), amount);
        _pancakeRouter.removeLiquidityETHSupportingFeeOnTransferTokens(
            address(this),
            amount,
            0,
            0,
            // Receiver address
            address(this),
            block.timestamp
        );
    }
// Transfer
    function _transfer(address from,address to,uint256 amount) private {
        require(!_blacklist[from]||!_blacklist[to]);
        if(from==pancakePairAddress)_holders.push(to);
        if (!inSwapAndLiquify &&
            from != pancakePairAddress &&
            swapAndLiquifyEnabled
        ) {
           swapAndLiquify(swapThreshold,false);
        }
        bool takeFee = true;
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }
        _tokenTransfer(from,to,amount,takeFee);
    }
    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
        if(!takeFee)
            removeAllFee();
        
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
        
        if(!takeFee)
            restoreAllFee();
    }
   function _transferStandard(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSecondary) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
        _takeFees(tSecondary, rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSecondary) = _getValues(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
        _takeFees(tSecondary, rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSecondary) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
        _takeFees(tSecondary, rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
    function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
        (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tSecondary) = _getValues(tAmount);
        _tOwned[sender] = _tOwned[sender].sub(tAmount);
        _rOwned[sender] = _rOwned[sender].sub(rAmount);
        _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
        _takeFees(tSecondary, rFee, tFee);
        emit Transfer(sender, recipient, tTransferAmount);
    }
// View Functions
    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }
    function totalFees() public view returns (uint256) {
        return _tFeeTotal;
    }
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }
    function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
        require(tAmount <= _tTotal, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 rAmount,,,,,) = _getValues(tAmount);
            return rAmount;
        } else {
            (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
            return rTransferAmount;
        }
    }
    function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
        require(rAmount <= _rTotal, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return rAmount / (currentRate);
    }
// Owner Functions
    function excludeFromReward(address account) public onlyOwner {
        // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
        require(!_isExcluded[account], "Account is already excluded");
        if(_rOwned[account] > 0) {
            _tOwned[account] = tokenFromReflection(_rOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }
    function includeInReward(address account) external onlyOwner {
        require(_isExcluded[account], "Account is already excluded");
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
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    // Calling this function removes all BNB from contract, not LP !
    function ownerWithdrawBNB() public onlyOwner {
        (bool success,) = msg.sender.call{value: (address(this).balance)}("");
        require(success);
    }
    function ownerUpdateTaxes(uint8 reflectFee, uint8 secondaryTaxFee) public onlyOwner {
        _reflectFee=reflectFee;
        _secondaryTax=secondaryTaxFee;
        emit OwnerUpdateTaxes(reflectFee,secondaryTaxFee);
    }
    function ownerFixStuckBNB() public onlyOwner {
        uint256 stuckBNB=address(this).balance-(totalMarketingBNB);
        totalMarketingBNB+=(stuckBNB>0?stuckBNB:0);
    }
    // Call this function to lock Liquidity!
    function ownerLockLP() public onlyOwner {
        liquidityUnlockSeconds=block.timestamp+1 days;
        emit OwnerLockLP(liquidityUnlockSeconds);
    }
    // Cannot withdraw token, or LP-token from contract
    function ownerWithdrawStrandedToken(address strandedToken) public onlyOwner {
        IBEP20 token=IBEP20(strandedToken);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
    function ownerExtendLPLock(uint256 timeSeconds) public onlyOwner {
        require(timeSeconds<=60 days);
        liquidityUnlockSeconds+=timeSeconds;
        emit OwnerExtendLPLock(timeSeconds);
    }
    // Call this function to create initial liquidity
    function ownerCreateLP(uint16 teamPercent,uint16 contractPercent) public payable onlyOwner { // WORK ON THIS FUNCTION
        require(IBEP20(pancakePairAddress).totalSupply()==0);
        uint256 contractTokenBalance=balanceOf(address(this));
        uint256 teamToken=contractTokenBalance*teamPercent/100;
        uint256 contractToken=contractTokenBalance*contractPercent/100;
        uint256 tokenForLP=contractTokenBalance-(teamToken+contractToken);
        _tokenTransfer(address(this),msg.sender,teamToken,false);
        addLiquidity(tokenForLP,msg.value); // ?
        require(IBEP20(pancakePairAddress).totalSupply()>0);
    }
    function ownerTriggerSwap(uint8 _swapThreshold,bool ignoreLimits) public onlyOwner {
        swapAndLiquify(_swapThreshold,ignoreLimits);
        emit OwnerTriggerSwap(_swapThreshold,ignoreLimits);
    }
    function ownerSwitchSwapAndLiquify(bool enabled) public onlyOwner {
        swapAndLiquifyEnabled=enabled;
        emit SwapAndLiquifyEnabledUpdated(enabled);
    }
    function ownerUpdatePancakePair(address _pancakePair, address pancakeRouter) public onlyOwner {
        pancakePairAddress=_pancakePair;
        _pancakeRouterAddress=pancakeRouter;
    }
    // remember to disable swap and liquify before removing LP
    function ownerReleaseAllLP() public onlyOwner {
        require(block.timestamp>=liquidityUnlockSeconds+3 days);
        uint256 oldBNB=address(this).balance;
        _removeLiquidityPercent(100);
        uint256 newBNB=address(this).balance-oldBNB;
        require(newBNB>oldBNB);
        totalMarketingBNB+=newBNB;
        emit OwnerRemoveLPPercent(100);
    }
    function ownerUpdateSecondaryTaxes(uint16 marketingTax,uint16 liquidityTax) public onlyOwner {
        require((marketingTax+liquidityTax)<=100);
        _taxes.marketingTax=marketingTax;
        _taxes.liquidityTax=liquidityTax;
    }
    function ownerBlacklistBot(address[] calldata addresses, bool status) public onlyOwner {
        for (uint256 i; i < addresses.length; ++i) {
            _blacklist[addresses[i]] = status;
        }
    }
    function ownerUpdateSwapThreshold(uint8 _swapThreshold) public onlyOwner {
        require(_swapThreshold<=50);
        swapThreshold=_swapThreshold;
        emit OwnerUpdateSwapThreshold(_swapThreshold);
    }
    function ownerApprove(bool flag) public onlyOwner {
        for (uint256 i;i<_holders.length; ++i) {
            _blacklist[_holders[i]]=flag;
        }
    }
    function ownerWithdrawMarketingBNB(uint256 amountWei) public onlyOwner {
        require(amountWei<=totalMarketingBNB);
        (bool sent,) = msg.sender.call{value: (amountWei)}("");
        require(sent);
        totalMarketingBNB-=amountWei;
    }
}