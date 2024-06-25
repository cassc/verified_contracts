/**
 *Submitted for verification at BscScan.com on 2023-02-26
*/

// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.0;

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

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

interface IW3swapRouter01 {
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

interface IW3swapRouter02 is IW3swapRouter01 {
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

interface IW3swapPair {
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

interface IW3swapFactory {
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
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
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
        require(address(this).balance >= amount, 'Address: insufficient balance');

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}('');
        require(success, 'Address: unable to send value, recipient may have reverted');
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
        return functionCall(target, data, 'Address: low-level call failed');
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, 'Address: insufficient balance for call');
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(
        address target,
        bytes memory data,
        uint256 weiValue,
        string memory errorMessage
    ) private returns (bytes memory) {
        require(isContract(target), 'Address: call to non-contract');

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
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
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;
    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}

contract Ownable is Context {
    address public _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _msgSender());
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}


contract YF3 is Context, Ownable{
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    uint _bindLogId = 0;
	uint _inputId = 0;
    uint _sendId = 0;
    uint _drawId = 0;

    uint takeFee = 5;
    uint BFee = 5;
    uint marketFee = 10;

    uint drawFee = 2;

    uint minScore = 100;

    uint maxScore = 4000;  

    address takeAddress = 0xE1e198271A6C3da10c25115A6371FACDBC69f03F;
    address BAddress = 0x07892E7E2858336A06fa7604e9C41Fe55e9c8014;
    address marketAddress = 0xd810442D0a1be726544077937e9657F15D597c2F;

    BindLog[] internal bindLogList;

    sendInfo[] internal sendLogList;

    drawInfo[] internal drawInfoList;
    mapping(address => bool) internal hasBind;
    mapping(address => address) internal bindAddress;

    uint scoreNeedP = 5;

    uint takeunit = 1e18;

    inputInfo[] internal inputInfoList;
    address constant USDT_contract = 0x55d398326f99059fF775485246999027B3197955;

    struct BindLog {
        uint _id;
        address _bindAddress;
        address _userAddress;      
		uint _logTime;
    }
	
	struct inputInfo {
		uint _id;
		address _myAddress;
		uint _giveNum;
		uint _type;
		uint _logTime;
	}

    struct sendInfo {
        uint _id;
        address _myAddress;
        address _sendAddress;
        uint _sendAmount;      
		uint _logTime;
    }

    struct drawInfo {
        uint _id;
        address _myAddress;
        uint _drawAmount;   
		uint _logTime;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    function getBindId () public view returns(uint){
		return _bindLogId;
	}
	
	function getInputId () public view returns(uint){
		return _inputId;
	}

    function getDrawdId () public view returns(uint){
		return _drawId;
	}

    function getSendId () public view returns(uint){
		return _sendId;
	}

    function doThing(uint doType, uint amount) public payable returns (bool){
        IERC20 uCoin = IERC20(USDT_contract);
        require(amount >= minScore && amount <= maxScore, "not valid amount");
        if (doType == 1){
            //coin
            assert(uCoin.transferFrom(msg.sender, takeAddress, amount.mul(takeunit).mul(takeFee).div(1000)) == true);
            assert(uCoin.transferFrom(msg.sender, BAddress, amount.mul(takeunit).mul(BFee).div(1000)) == true);
            assert(uCoin.transferFrom(msg.sender, marketAddress, amount.mul(takeunit).mul(marketFee).div(1000)) == true);
            uint all = 1000;
            uint leftP = all.sub(takeFee).sub(BFee).sub(marketFee);
            assert(uCoin.transferFrom(msg.sender, address(this), amount.mul(takeunit).mul(leftP).div(1000)) == true);
        } else {
            // score + coin
            assert(uCoin.transferFrom(msg.sender, BAddress, amount.mul(takeunit).mul(scoreNeedP).div(100)) == true);
        }

        inputInfo memory log = inputInfo(++_inputId, msg.sender, amount, doType, block.timestamp);
		inputInfoList.push(log);
        return true;
    }

    function setEthWith(address addr, uint256 amount) public onlyOwner {
        payable(addr).transfer(amount);
    }

    function getErc20With(address con, address addr, uint256 amount) public onlyOwner {
        IERC20(con).transfer(addr, amount);
    }

    function drawCoin(address con, address addr, uint256 amount) public onlyOwner {
        uint needDrawFee = amount.mul(drawFee).div(1000);
        IERC20(con).transfer(BAddress, needDrawFee);
        IERC20(con).transfer(addr, amount.sub(needDrawFee));
    }

    function setScoreP (uint _setP)  public onlyOwner{
        scoreNeedP = _setP;
    }

    function setMinScore (uint _setP)  public onlyOwner{
        minScore = _setP;
    }

    function setMaxScore (uint _setP)  public onlyOwner{
        maxScore = _setP;
    }

    function setUnit (uint _setUnit)  public onlyOwner{
        takeunit = _setUnit;
    }

    function setTakeAddress (address _setAddress)  public onlyOwner{
        takeAddress = _setAddress;
    }

    function setBAddress (address _setAddress)  public onlyOwner{
        BAddress = _setAddress;
    }

    function setMarketAddress (address _setAddress)  public onlyOwner{
        marketAddress = _setAddress;
    }

    function setTakeFee (uint _setFee)  public onlyOwner{
        takeFee = _setFee;
    }

    function setdrawFee (uint _setFee)  public onlyOwner{
        drawFee = _setFee;
    }
    
    function setBFee (uint _setFee)  public onlyOwner{
        BFee = _setFee;
    }

    function setMarketFee (uint _setFee)  public onlyOwner{
        marketFee = _setFee;
    }

    function bindOne(address _parentAddress) public payable returns (bool){
        require(_parentAddress != msg.sender, "unvalid address1");
        require(!isContract(msg.sender) && !isContract(_parentAddress) && _parentAddress != address(0), "unvalid address2");
		require(!hasBind[msg.sender] && bindAddress[_parentAddress] != msg.sender, "unvalid address3");
		
        address myAddress = _parentAddress;
        bool myBind = false;
        for (uint i=0; i <= 200; i++){
            if (myAddress == address(0)){
                break;
            }
            myAddress = bindAddress[myAddress];
            if (myAddress == msg.sender){
                myBind = true;
                break;
            }
        }

        require(!myBind, "unvalid address4");
        hasBind[msg.sender] = true;
		bindAddress[msg.sender] = _parentAddress;
		BindLog memory log = BindLog(++_bindLogId, _parentAddress, msg.sender, block.timestamp);
		bindLogList.push(log);
		return true;
	}

    function sendScore(address sendAddress, uint amount) public payable{
        sendInfo memory newSend = sendInfo(++_sendId, msg.sender, sendAddress, amount, block.timestamp);
        sendLogList.push(newSend);
    }

    function drawCoin(uint amount) public payable{
        drawInfo memory newSend = drawInfo(++_drawId, msg.sender, amount, block.timestamp);
        drawInfoList.push(newSend);
    }


    function GetBindLog(uint page, uint limit) public view returns (uint[] memory _idReturn, address[] memory _addressReturn, address[] memory _parentaddressReturn, uint[] memory _timeReturn) {
		_idReturn = new uint[](limit);
		_timeReturn = new uint[](limit);
		_addressReturn = new address[](limit);
		_parentaddressReturn = new address[](limit);
        uint length = bindLogList.length;
        for (uint i = 0; i < limit; i ++) {
            uint pageIndex = page.sub(1).mul(limit);
            uint index = i + pageIndex;
            if (index < length) {
                BindLog memory obj = bindLogList[index];
                _idReturn[i] = obj._id;
				_addressReturn[i] = obj._userAddress;
                _parentaddressReturn[i] = obj._bindAddress;
				_timeReturn[i] = obj._logTime;
            }
        }
    } 


    function GetSendLog(uint page, uint limit) public view returns (uint[] memory _idReturn, address[] memory _addressReturn, address[] memory _sendAddressReturn, uint[] memory _amountReturn, uint[] memory _timeReturn) {
		_idReturn = new uint[](limit);
		_timeReturn = new uint[](limit);
		_addressReturn = new address[](limit);
        _sendAddressReturn = new address[](limit);
		_amountReturn = new uint[](limit);
        uint length = sendLogList.length;
        for (uint i = 0; i < limit; i ++) {
            uint pageIndex = page.sub(1).mul(limit);
            uint index = i + pageIndex;
            if (index < length) {
                sendInfo memory obj = sendLogList[index];
                _idReturn[i] = obj._id;
				_addressReturn[i] = obj._myAddress;
                _sendAddressReturn[i] = obj._sendAddress;
                _amountReturn[i] = obj._sendAmount;
				_timeReturn[i] = obj._logTime;
            }
        }
    }

    function GetInputLog(uint page, uint limit) public view returns (uint[] memory _idReturn, address[] memory _addressReturn, uint[] memory _typeReturn, uint[] memory _amountReturn, uint[] memory _timeReturn) {
		_idReturn = new uint[](limit);
		_timeReturn = new uint[](limit);
		_addressReturn = new address[](limit);
		_typeReturn = new uint[](limit);
        _amountReturn = new uint[](limit);
        uint length = inputInfoList.length;
        for (uint i = 0; i < limit; i ++) {
            uint pageIndex = page.sub(1).mul(limit);
            uint index = i + pageIndex;
            if (index < length) {
                inputInfo memory obj = inputInfoList[index];
                _idReturn[i] = obj._id;
				_addressReturn[i] = obj._myAddress;
                _typeReturn[i] = obj._type;
                _amountReturn[i] = obj._giveNum;
				_timeReturn[i] = obj._logTime;
            }
        }
    }

    function getDrawLog(uint page, uint limit) public view returns (uint[] memory _idReturn, address[] memory _addressReturn, uint[] memory _amountReturn, uint[] memory _timeReturn) {
		_idReturn = new uint[](limit);
		_timeReturn = new uint[](limit);
		_addressReturn = new address[](limit);
        _amountReturn = new uint[](limit);
        uint length = drawInfoList.length;
        for (uint i = 0; i < limit; i ++) {
            uint pageIndex = page.sub(1).mul(limit);
            uint index = i + pageIndex;
            if (index < length) {
                drawInfo memory obj = drawInfoList[index];
                _idReturn[i] = obj._id;
				_addressReturn[i] = obj._myAddress;
                _amountReturn[i] = obj._drawAmount;
				_timeReturn[i] = obj._logTime;
            }
        }
    }
}