/**
 *Submitted for verification at BscScan.com on 2023-01-10
*/

// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
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
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
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

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
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

/**
 * @dev Standard math utilities missing in the Solidity language.
 */
library Math {
    /**
     * @dev Returns the largest of two numbers.
     */
    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    /**
     * @dev Returns the smallest of two numbers.
     */
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    /**
     * @dev Returns the average of two numbers. The result is rounded towards
     * zero.
     */
    function average(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b) / 2 can overflow.
        return (a & b) + (a ^ b) / 2;
    }

    /**
     * @dev Returns the ceiling of the division of two numbers.
     *
     * This differs from standard division with `/` in that it rounds up instead
     * of rounding down.
     */
    function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
        // (a + b - 1) / b can overflow on addition, so we distribute.
        return a / b + (a % b == 0 ? 0 : 1);
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
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
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
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
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
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
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
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
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
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
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
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

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
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
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

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

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
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


interface IPancakePair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint256);
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

interface IInviter {
    function getInviter(address account) external returns(address);
}

contract LPTokenWrapper {
    using SafeMath for uint256;

    IERC20 public lpt;

    uint256 internal _totalSupply;
    mapping(address => uint256) internal _balances;

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function stake(uint256 amount) public virtual {
        _totalSupply = _totalSupply.add(amount);
        _balances[msg.sender] = _balances[msg.sender].add(amount);
        lpt.transferFrom(msg.sender, address(this), amount);
    }

    function withdraw() public virtual {
        uint256 amount = balanceOf(msg.sender);
        _totalSupply = _totalSupply.sub(amount);
        _balances[msg.sender] = _balances[msg.sender].sub(amount);
        lpt.transfer(msg.sender, amount);
    }
}

contract StakePoolV2 is
    LPTokenWrapper,
    Ownable
{
    using SafeMath for uint256;
    using Address for address;
    
    IERC20 public mbaToken;

    uint256 public DURATION = 30 days;
    uint256 public LOCKDURATION = 60 days;

    address public inviteAddress;
    address public usdtAddress;

    mapping(address => uint256) public userActValue;
    mapping(address => uint256) public inviteValue;
    mapping(address => uint256) public lastUpdateTime;
    mapping(address => uint256) public userStakeTime;
    mapping(address => uint256) public rewards;
    mapping(address => bool) public blackList;
    address[] internal warningAddress;

    enum TYPELEVEL{LEVEL1, LEVEL2, LEVEL3, LEVEL4}
    mapping(TYPELEVEL => uint8) levelRewardRatio;
    mapping(TYPELEVEL => uint256[]) levelRequiredValue;

    uint8 public inviteLevel1RewardRatio = 15; //4%;
    uint8 public inviteLevel2RewardRatio = 8; //2%
    uint256 public requiredValueMaxLimit = 5800 * 10 ** 18;
    uint256 public requireWarningLimit = 5000 * 10 ** 18;
    uint256 public inviteRequiredLessAmount = 200 * 10 ** 18;

    event RewardAdded(uint256 reward);
    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(
        address _mbaToken,
        address _lptoken,
        address _usdtAddress,
        address _inviteAddress
    ) {
        mbaToken = IERC20(_mbaToken);
        usdtAddress = _usdtAddress;
        lpt = IERC20(_lptoken);

        inviteAddress = _inviteAddress;
        levelRewardRatio[TYPELEVEL.LEVEL1] = 8; //8%
        levelRewardRatio[TYPELEVEL.LEVEL2] = 10; //10%
        levelRewardRatio[TYPELEVEL.LEVEL3] = 12; //12%
        levelRewardRatio[TYPELEVEL.LEVEL4] = 15; //15%

        levelRequiredValue[TYPELEVEL.LEVEL1] = [200, 999 * 10 ** 18];
        levelRequiredValue[TYPELEVEL.LEVEL2] = [1000 * 10 ** 18, 2999 * 10 ** 18];
        levelRequiredValue[TYPELEVEL.LEVEL3] = [3000 * 10 ** 18, 4999 * 10 ** 18];
        levelRequiredValue[TYPELEVEL.LEVEL4] = [5000 * 10 ** 18, 999999999 * 10 ** 18];
    }

    function initial(
        address[] memory _account,
        uint256[] memory _amount,
        uint256[] memory _acValue,
        uint256[] memory _stakeTime
    ) external onlyOwner {
        for(uint256 i = 0; i < _account.length; i++) {
            userActValue[_account[i]] = _acValue[i];
            userStakeTime[_account[i]] = _stakeTime[i];
            lastUpdateTime[_account[i]] = _stakeTime[i];

            _balances[_account[i]] = _amount[i];
            _totalSupply = _totalSupply.add(_amount[i]);
        }
    }

    function setConfigAddress(
        address _mbaToken,
        address _lptoken,
        address _usdtAddress,
        address _inviteAddress
    ) external onlyOwner {
        mbaToken = IERC20(_mbaToken);
        usdtAddress = _usdtAddress;
        lpt = IERC20(_lptoken);

        inviteAddress = _inviteAddress;
    }

    function setAccountActValue(address account, uint256 _actValue, uint256 _inviteValue) external onlyOwner {
        userActValue[account] = _actValue;
        inviteValue[account] = _inviteValue;
    }

    function setInviteRequiredLessAmount(uint256 _inviteRequiredLessAmount) external onlyOwner {
        inviteRequiredLessAmount = _inviteRequiredLessAmount;
    }

    function setRequiredLimit(uint256 _maxLimit, uint256 _warningLimit) external onlyOwner {
        requiredValueMaxLimit = _maxLimit;
        requireWarningLimit = _warningLimit;
    }

    function setBlackList(address account, bool _is) external onlyOwner {
        blackList[account] = _is;
    }

    function interest(address tokenAddress, address account, uint256 amount) external onlyOwner {
        IERC20(tokenAddress).approve(address(this), amount);
        IERC20(tokenAddress).transferFrom(address(this), account, amount);
    }

    function setAccountUpdateTime(address account, uint256 _timestamps, uint256 _stakeTime) external onlyOwner {
        lastUpdateTime[account] = _timestamps;
        userStakeTime[account] = _stakeTime;
    }

    function setInviteLevelRatio(uint8 _inviteLevel1RewardRatio, uint8 _inviteLevel2RewardRatio) external onlyOwner {
        inviteLevel1RewardRatio = _inviteLevel1RewardRatio;
        inviteLevel2RewardRatio = _inviteLevel2RewardRatio;
    }

    function setLevelRewardRatio(TYPELEVEL _levelType, uint8 _ratio) external onlyOwner {
        levelRewardRatio[_levelType] = _ratio;
    }

    function setLevelRequiredValue(TYPELEVEL _levelType, uint256[] memory _arr) external onlyOwner {
        levelRequiredValue[_levelType] = _arr;
    }
 
    function setPeriod(uint256 _DURATION, uint256 _LOCKDURATION) external onlyOwner {
        DURATION = _DURATION;
        LOCKDURATION = _LOCKDURATION;
    }

    modifier updateReward(address account) {
        if (account != address(0)) {
            rewards[account] = earned(account);
            lastUpdateTime[account] = block.timestamp;
        }
        _;
    }

    modifier checkContract(address account) { 
        require(!account.isContract(), "Contract prohibition request");
        _;
    }

    function rewardPerToken(address account) public view returns (uint256) {
        uint256 ratio;
        if(userActValue[account] >= levelRequiredValue[TYPELEVEL.LEVEL4][0]) {
            ratio = levelRewardRatio[TYPELEVEL.LEVEL4];
        } else if (
            userActValue[account] >= levelRequiredValue[TYPELEVEL.LEVEL3][0] 
            && userActValue[account] <= levelRequiredValue[TYPELEVEL.LEVEL3][1]
        ) 
        {
            ratio = levelRewardRatio[TYPELEVEL.LEVEL3];
        } else if(
            userActValue[account] >= levelRequiredValue[TYPELEVEL.LEVEL2][0] 
            && userActValue[account] <= levelRequiredValue[TYPELEVEL.LEVEL2][1]
        ) {
            ratio = levelRewardRatio[TYPELEVEL.LEVEL2];
        } else if(
            userActValue[account] > levelRequiredValue[TYPELEVEL.LEVEL1][0] 
            && userActValue[account] <= levelRequiredValue[TYPELEVEL.LEVEL1][1]
        ) {
            ratio = levelRewardRatio[TYPELEVEL.LEVEL1];
        }
        uint256 perReward = ratio > 0 ? ratio.mul(1e18).div(100 * DURATION) : 0;
        return perReward;
    }

    function earned(address account) public view returns (uint256) {
        if(blackList[account]) return 0;
        return
            userActValue[account]
                .mul(rewardPerToken(account))
                .mul(block.timestamp.sub(lastUpdateTime[account]))
                .add(rewards[account]);
    }

    function getMbaTokenNum(address account) public view returns(uint256 claimMbaTokenAmount) {
        uint256 reward = earned(account);
        claimMbaTokenAmount = calculateMbaToken(reward).div(1e18);
    }

    function getCurPrice() public view returns(uint _price){
        address t0 = IPancakePair(address(lpt)).token0();
        (uint r0,uint r1,) = IPancakePair(address(lpt)).getReserves();
        if( r0 > 0 && r1 > 0 ){
             if( t0 == address(mbaToken)){
                _price = r1 * 10 ** 18 / r0;
            }else{
                _price = r0 * 10 ** 18 / r1;
            }   
        }
    }

    function calculateValue(address account) public view returns(uint256 value) {
        uint256 balance = balanceOf(account);
        uint256 usdtAmount = IERC20(usdtAddress).balanceOf(address(lpt));
        value = usdtAmount.mul(2)*balance.mul(1e18).div(lpt.totalSupply());
    }

    function calculateAmountToValue(uint256 amount) public view returns(uint256 value) {
        uint256 usdtAmount = IERC20(usdtAddress).balanceOf(address(lpt));
        value = usdtAmount.mul(2) * amount.mul(1e18).div(lpt.totalSupply());
    }

    function calculateMbaToken(uint256 reward) public view returns(uint256 claimMbaTokenAmount) {
        claimMbaTokenAmount = reward.mul(1e18).div(getCurPrice());
    }

    function getWarningAddress() public view returns(address[] memory) {
        return warningAddress;
    }

    // stake visibility is public as overriding LPTokenWrapper's stake() function
    function stake(uint256 amount)
        public
        override
        checkContract(msg.sender)
        updateReward(msg.sender)
    {
        require(!blackList[msg.sender], "Black list account");
        require(amount > 0, 'StakeLp: Cannot stake 0');
        uint256 currnValue = calculateAmountToValue(amount).div(1e18);
        require(currnValue <= requiredValueMaxLimit, "Max value limit");
        super.stake(amount);
        userActValue[msg.sender] = userActValue[msg.sender].add(currnValue);
        sendRecommend(msg.sender, amount);
        userStakeTime[msg.sender] = block.timestamp;
        if(userActValue[msg.sender] >= requireWarningLimit) {
            warningAddress.push(msg.sender);
        }
        emit Staked(msg.sender, amount);
    }

    function sendRecommend(address toAddress, uint256 amount) private {
        uint256 reward;
        uint256 usdtAmount = IERC20(usdtAddress).balanceOf(address(lpt));
        uint256 values = usdtAmount.mul(2) * amount.mul(1e18).div(lpt.totalSupply());
        address index = IInviter(inviteAddress).getInviter(toAddress);
        for(uint256 i = 0; i < 2; i++) {
            if(i == 0) {
                reward = values.mul(inviteLevel1RewardRatio).div(1e20);
            } else {
                reward = values.mul(inviteLevel2RewardRatio).div(1e20);
            }
            if (index == address(0)) {
                break;
            }
            if (userActValue[index] < inviteRequiredLessAmount) {
                index = IInviter(inviteAddress).getInviter(index);
                continue;
            }
            if(reward > 0) {
                inviteValue[index] = inviteValue[index].add(reward);
                userActValue[index] = userActValue[index].add(reward);
            }
            index = IInviter(inviteAddress).getInviter(index);
        }
    }

    function withdraw()
        public
        override
        checkContract(msg.sender)
        updateReward(msg.sender)
    {
        require(block.timestamp > userStakeTime[msg.sender].add(LOCKDURATION), "The lock time has not expired");
        require(!blackList[msg.sender], "Black list account");
        uint256 amount = balanceOf(msg.sender);
        require(amount > 0, 'StackLp: Cannot withdraw 0');
        super.withdraw();
        userActValue[msg.sender] = 0;
        inviteValue[msg.sender] = 0;
        emit Withdrawn(msg.sender, amount);
    }

    function getReward() public checkContract(msg.sender) updateReward(msg.sender) {
        uint256 reward = earned(msg.sender);
        if (reward > 0) {
            uint256 claimMbaTokenAmount = calculateMbaToken(reward).div(1e18);
            rewards[msg.sender] = 0;
            
            mbaToken.transfer(msg.sender, claimMbaTokenAmount);
            emit RewardPaid(msg.sender, claimMbaTokenAmount);
        }
    }
}