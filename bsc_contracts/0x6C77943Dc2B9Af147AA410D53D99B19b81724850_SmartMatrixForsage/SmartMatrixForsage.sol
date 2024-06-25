/**
 *Submitted for verification at BscScan.com on 2023-01-04
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
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

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
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
        // This method relies in extcodesize, which returns 0 for contracts in
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
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
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
/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
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
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

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

/**
 * @dev This abstract contract provides a fallback function that delegates all calls to another contract using the EVM
 * instruction `delegatecall`. We refer to the second contract as the _implementation_ behind the proxy, and it has to
 * be specified by overriding the virtual {_implementation} function.
 * 
 * Additionally, delegation to the implementation can be triggered manually through the {_fallback} function, or to a
 * different contract through the {_delegate} function.
 * 
 * The success and return data of the delegated call will be returned back to the caller of the proxy.
 */
abstract contract Proxy {
    /**
     * @dev Delegates the current call to `implementation`.
     * 
     * This function does not return to its internall call site, it will return directly to the external caller.
     */
    function _delegate(address implementation) internal {
        // solhint-disable-next-line no-inline-assembly
        assembly {
            // Copy msg.data. We take full control of memory in this inline assembly
            // block because it will not return to Solidity code. We overwrite the
            // Solidity scratch pad at memory position 0.
            calldatacopy(0, 0, calldatasize())

            // Call the implementation.
            // out and outsize are 0 because we don't know the size yet.
            let result := delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)

            // Copy the returned data.
            returndatacopy(0, 0, returndatasize())

            switch result
            // delegatecall returns 0 on error.
            case 0 { revert(0, returndatasize()) }
            default { return(0, returndatasize()) }
        }
    }

    /**
     * @dev This is a virtual function that should be overriden so it returns the address to which the fallback function
     * and {_fallback} should delegate.
     */
    function _implementation() internal virtual view returns (address);

    /**
     * @dev Delegates the current call to the address returned by `_implementation()`.
     * 
     * This function does not return to its internall call site, it will return directly to the external caller.
     */
    function _fallback() internal {
        _beforeFallback();
        _delegate(_implementation());
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if no other
     * function in the contract matches the call data.
     */
    fallback () payable external {
        _fallback();
    }

    /**
     * @dev Fallback function that delegates calls to the address returned by `_implementation()`. Will run if call data
     * is empty.
     */
    receive () payable external {
        _fallback();
    }

    /**
     * @dev Hook that is called before falling back to the implementation. Can happen as part of a manual `_fallback`
     * call, or as part of the Solidity `fallback` or `receive` functions.
     * 
     * If overriden should call `super._beforeFallback()`.
     */
    function _beforeFallback() internal virtual {
    }
}
library SafeERC20 {
    using SafeMath for uint256;
    using Address for address;

    function safeTransfer(IERC20 token, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(IERC20 token, address spender, uint256 value) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        // solhint-disable-next-line max-line-length
        require((value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).add(value);
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
        uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
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
        if (returndata.length > 0) { // Return data is optional
            // solhint-disable-next-line max-line-length
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


contract Forsage2 is Proxy {
    
    address public impl;
    address public contractOwner;

    modifier onlyContractOwner() { 
        require(msg.sender == contractOwner); 
        _; 
    }

    constructor(address _impl) public {
        impl = _impl;
        contractOwner = msg.sender;
    }
    
    function update(address newImpl) public onlyContractOwner {
        impl = newImpl;
    }

    function removeOwnership() public onlyContractOwner {
        contractOwner = address(0);
    }
    
    function _implementation() internal override view returns (address) {
        return impl;
    }
}
contract SmartMatrixForsageBasic  {

     
    address public impl;
    address public contractOwner;

    using SafeMath for uint;
    IERC20 public depositToken;
     

    struct User {
        uint id;
        address referrer;
        uint directs;
        address[] referrals;

        uint8 activeX2Levels;
        uint8 activeX3Levels;
        uint8 activeX4Levels;        
        
        mapping(uint8 => X2) x2Matrix;
        mapping(uint8 => X3) x3Matrix;
        mapping(uint8 => X4) x4Matrix;
    }

    struct X2 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }

    struct X3 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }

    struct X4 {
        address currentReferrer;
        address[] referrals;
        bool blocked;
        uint reinvestCount;
    }

    struct Income {
        uint total;
        uint m1;
        uint m2;
        uint m3;
        uint level;
    }

    mapping(address => Income) public income;
    mapping(address => User) public users;
    mapping(uint => address) public idToAddress;

    uint public BASIC_PRICE;
    uint public SLOT_PRICE;
    uint public FEE_PRICE;

    uint public m1Users;
    uint public m2Users;
    uint public m3Users;
    

    struct pool{
        uint id;
        uint parent;
        address u_address;
    }
    mapping(uint => pool) public m1x2;    
    mapping(uint => pool) public m2x3;     
    mapping(uint => pool) public m3x4;

    uint public total_user;
    mapping(address => bool) public isUserExists;
    
 
     
}

contract SmartMatrixForsage is SmartMatrixForsageBasic {
    using SafeERC20 for IERC20;
    modifier onlyOwner() { 
        require(msg.sender == contractOwner); 
        _; 
    }

    function init(address addr,IERC20 _depositToken) public onlyOwner() {
        
        total_user++;

        BASIC_PRICE = 40e18;
        SLOT_PRICE = 30e18;
        FEE_PRICE = 10e18;

        idToAddress[total_user]=addr;
        users[addr].id=total_user;
        users[addr].referrer=address(this);         

        m1Users++;
        m1x2[m1Users].id=m1Users;
        m1x2[m1Users].parent=0;
        m1x2[m1Users].u_address=addr;
        
        m2Users++;
        m2x3[m2Users].id=m1Users;
        m2x3[m2Users].parent=0;
        m2x3[m2Users].u_address=addr;
        
        m3Users++;
        m3x4[m3Users].id=m1Users;
        m3x4[m3Users].parent=0;
        m3x4[m3Users].u_address=addr;
        
        users[msg.sender].activeX2Levels++;
        users[msg.sender].activeX3Levels++;
        users[msg.sender].activeX4Levels++;
        
        depositToken = IERC20(_depositToken);

    }

    function calparent(uint mtrix)public view returns(uint){
        uint dr;
        if(mtrix==3){
            dr = (uint(m3Users).sub(1)).div(4);             
        }else if(mtrix==2){
            dr = (uint(m2Users).sub(1)).div(3);             
        }else {
            dr = (uint(m1Users).sub(1)).div(2);            
        } 
        
        return dr.add(1);
    }

    function activeMatrix(address usr, uint matrix)internal returns(uint){
        uint prt = calparent(matrix);
        uint rt;
        if(matrix == 3){
            m3Users++;
            m3x4[m3Users].id=m3Users;
            m3x4[m3Users].parent=prt;
            m3x4[m3Users].u_address=usr;
            rt = m3Users;
        }else if(matrix == 2){
            m2Users++;
            m2x3[m2Users].id=m2Users;
            m2x3[m2Users].parent=prt;
            m2x3[m2Users].u_address=usr;
            rt = m2Users;
        }else{
            m1Users++;
            m1x2[m1Users].id=m1Users;
            m1x2[m1Users].parent=prt;
            m1x2[m1Users].u_address=usr;
            rt = m1Users;
        }
        return rt;
    }

    function registration(address _referrer) public returns(bool){
        require(isUserExists[msg.sender]==false,"Already Exists.");
        total_user++;

        depositToken.safeTransferFrom(msg.sender,address(this),BASIC_PRICE);
        depositToken.safeTransferFrom(msg.sender,contractOwner,FEE_PRICE);

        idToAddress[total_user]=msg.sender;
        users[msg.sender].id=total_user;
        users[msg.sender].referrer=_referrer;
        users[_referrer].directs++;
        users[_referrer].referrals.push(msg.sender);
        isUserExists[msg.sender]=true;
        updateX2(msg.sender);       

        return true;
    }

    
    function updateX2(address useraddress) internal returns(bool) {
        
        if(users[useraddress].activeX2Levels==0){
            users[useraddress].activeX2Levels++;
        }
        uint p = activeMatrix(useraddress,1);
        uint parent1 = m1x2[p].parent;
        address parent = m1x2[parent1].u_address;
         
       
        users[parent].x2Matrix[users[parent].activeX2Levels].referrals.push(useraddress);
        if(users[parent].x2Matrix[users[parent].activeX2Levels].referrals.length>=2){
            users[parent].activeX2Levels++;
            income[parent].total += 20e18;
            income[parent].m1 += 20e18;
            depositToken.transfer(parent,20e18);
            distributeGen(parent);
            updateX3(parent);
        }
        return true;
    }

    function updateX3(address useraddress) internal returns(bool) {
        if(users[useraddress].activeX3Levels==0){
            users[useraddress].activeX3Levels++;
        }
        uint p = activeMatrix(useraddress,2);

        uint parent1 = m2x3[p].parent;
        address parent = m2x3[parent1].u_address;

        users[parent].x3Matrix[users[parent].activeX3Levels].referrals.push(useraddress);
        if(users[parent].x3Matrix[users[parent].activeX3Levels].referrals.length>=3){
            users[parent].activeX3Levels++;
            income[parent].total += 30e18;
            income[parent].m2 += 30e18;
            depositToken.transfer(parent,30e18);
            //distributeGen(parent);
            updateX2(parent);
            updateX4(parent);
        }
        return true;
    }

    function updateX4(address useraddress) internal returns(bool) {
        if(users[useraddress].activeX4Levels==0){
            users[useraddress].activeX4Levels++;
        }
        uint p = activeMatrix(useraddress,3);
        uint parent1 = m3x4[p].parent;
        address parent = m3x4[parent1].u_address;

        users[parent].x4Matrix[users[parent].activeX4Levels].referrals.push(useraddress);
        if(users[parent].x4Matrix[users[parent].activeX4Levels].referrals.length>=4){
            users[parent].activeX4Levels++;
            income[parent].total += 60e18;
            income[parent].m3 += 60e18;
            depositToken.transfer(parent,60e18);
            //distributeGen(parent);
            updateX2(parent);
            updateX4(parent);
        } 

        return true;
    }

    address private x;
    function distributeGen(address spo)internal {
        x = users[spo].referrer;

        for(uint i = 0 ; i < 10 ; i++ ){
            if(x != address(0)){
                    income[x].total += 1e18;
                    income[x].level += 1e18;
                    depositToken.transfer(x,1e18);                                    
                    x = users[x].referrer;
            }else{
                break;
            }            
        }
    }

    function usersX2Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool, uint) {
        return (users[userAddress].x2Matrix[level].currentReferrer,
                users[userAddress].x2Matrix[level].referrals,
                users[userAddress].x2Matrix[level].blocked,
                users[userAddress].x2Matrix[level].reinvestCount);
    }
    function usersX3Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool, uint) {
        return (users[userAddress].x3Matrix[level].currentReferrer,
                users[userAddress].x3Matrix[level].referrals,
                users[userAddress].x3Matrix[level].blocked,
                users[userAddress].x3Matrix[level].reinvestCount);
    }
    function usersX4Matrix(address userAddress, uint8 level) public view returns(address, address[] memory, bool, uint) {
        return (users[userAddress].x4Matrix[level].currentReferrer,
                users[userAddress].x4Matrix[level].referrals,
                users[userAddress].x4Matrix[level].blocked,
                users[userAddress].x4Matrix[level].reinvestCount);
    }
    function getDirect(address u_address,uint cnt) public view returns(address){
        return users[u_address].referrals[cnt];
    }
    function withdrawLostTokens(address tokenAddress,address rcv) public onlyOwner {
        require(tokenAddress != address(depositToken), "cannot withdraw deposit token");
        if (tokenAddress == address(0)) {
            address(uint160(rcv)).transfer(address(this).balance);
        } else {
            IERC20(tokenAddress).transfer(rcv, IERC20(tokenAddress).balanceOf(address(this)));
        }
    }

}