/**
 *Submitted for verification at BscScan.com on 2023-05-08
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
//使用http://remix.ethereum.org/部署合约，部署时，使用solidity语言，编译版本选择^0.8.10
/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 *从Solidity 0.8开始，通常不需要SafeMath`，因为编译器现在内置了溢出检查。
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
     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
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
        if (a == 0) {
            return 0;
        }
        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");
        return c;
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
        return div(a, b, "SafeMath: division by zero");
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
        require(b > 0, errorMessage);
        uint256 c = a / b;
        return c;
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
        return mod(a, b, "SafeMath: modulo by zero");
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
        require(b != 0, errorMessage);
        return a % b;
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 *本合同仅适用于中级、类库合同。
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
 *此模块通过继承使用。它将使修改器可用“onlyOwner”，它可以应用于您的函数，以将其使用限制为所有者。
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
     * @dev Transfers ownership of the contract to a new account (`newOwner`).将合同所有权转移到新帐户（`newOwner`）。
     * Can only be called by the current owner.只能由当前所有者调用。
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
// helper methods for interacting with ERC20 tokens and sending ETH that do not consistently return true/false
//用于与ERC20令牌交互并发送不一致返回true/false的ETH的助手方法
library TransferHelper {
    function safeTransferETH(address to, uint value) internal {
        (bool success,) = to.call{value:value}(new bytes(0));
        require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
    }
}
//上段代码代表安全传输ETH及侧链

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    //上段代码表示连接标准IERC20

    function name() external view returns (string memory);
    //代币名称
    
    function symbol() external view returns (string memory);
    //标志缩写

    function decimals() external view returns (uint8);
    //代币精度

    function totalSupply() external view returns (uint);
    //代币总量

    function balanceOf(address owner) external view returns (uint);
    //代币余额

    function allowance(address owner, address spender) external view returns (uint);
    //限额

    function approve(address spender, uint value) external returns (bool);
    //核准

    function transfer(address to, uint value) external returns (bool);
    //转账

    function transferFrom(address from, address to, uint value) external returns (bool);
    //转自

}
interface IWETH {
    //接口IWETH
    function deposit() external payable;
    //沉淀
    function transfer(address to, uint value) external returns (bool);
    //转账
    function withdraw(uint) external;
    //提币
    function balanceOf(address account) external view returns (uint256);
    //余额
}
contract BabMine is Ownable {
    //BabMine是可拥有的
    using SafeMath for uint256;
    mapping (address => uint256) private withdrawRate;
    //通过地址，获取提现比例

    struct MineConfig {
        uint256 id;
        uint256 amount;
        uint256  rate;
        uint256 status;
    }
    mapping(uint256 => MineConfig) private MineDetail;
    //挖矿详情

    event BuyMine(address indexed _user,uint256 mine_id, uint256 _value);

    function buyMine(uint256 id)  external payable{
        withdrawRate[msg.sender]=id;
        emit BuyMine(msg.sender,id,msg.value);
    }
    //上段代码，调用msg.sender关于买入的矿机id、对应的最高提现比例、用户id、地址

     function setMine(uint256 id,uint256 value,uint256 rate,uint256 status) external onlyOwner {
        MineDetail[id]=MineConfig(id,value,rate,status);
    }

    function getWithdrawRate(address _address) external view returns(uint256)  {
       return withdrawRate[_address];
    }



    mapping (address => mapping (address => uint256)) private tokenAmount;

    struct Config {
        uint256 fee;
        uint256 minAmount;
        uint256 maxAmount;
        uint256 status;
    }
    mapping (address => Config) private configMap;
    //配置映射

    mapping (address => uint256) private claimFrozen;
    //奖金已冻结

    address public WETH=0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    //默认地址不用修改

    event Claim(address indexed currency,address indexed _user, uint256 _value,uint256 _reserve, uint256 fee);
    event ClaimAll(address indexed _user, uint256 _value);
    event AddUserAmount(address indexed currency,address indexed _user,uint256 _value);
    event Burn(address indexed currency,uint256 _value,string destroyType);
    //奖金：币种地址、用户地址、数量、可用、手续费
    //所有奖金：用户地址、数量
    //添加用户的奖金数量：币种地址、用户地址、数量
    //燃烧手续费：币种地址、数量、销毁类型

    function changeConfig(address currency,uint256 _fee,uint256 _minAmount,uint256 _maxAmount,uint256 _status) public onlyOwner {
        configMap[currency]=Config(_fee,_minAmount,_maxAmount,_status);
    }
    //更改配置：币种地址、手续费、最小数量、最大数量、状态->所有者

    function getConfig(address currency) external view returns(uint256 _fee,uint256 _minAmount,uint256 _maxAmount,uint256 _status)  {
       return (configMap[currency].fee,configMap[currency].minAmount,configMap[currency].maxAmount,configMap[currency].status);
    }
    //获取配置：币种地址/（外部预览返回）/手续费、最小数量、最大数量、状态
    function getUserTokenAmount(address currency,address _userAddress) external view returns(uint256)  {
       return tokenAmount[currency][_userAddress];
    }
    //获取用户代币数量：币种地址、用户地址/（返回）/代币数量【币种】【用户地址】

    function addUserAmount(address currency,address _userAddress,  uint256 _amount) public onlyOwner{
        require(_amount > 0, "_amount > 0");
        tokenAmount[currency][_userAddress]=tokenAmount[currency][_userAddress].add(_amount);
        emit AddUserAmount(currency,_userAddress, _amount);
    }
    //添加用户数量：添加用户的奖金数量：币种地址、用户地址、数量

    function claim(address currency,uint256 _amount) public { 
        require(tokenAmount[currency][msg.sender] >= _amount, "Claim: not balance");
        require(claimFrozen[msg.sender] ==0, "Claim: userAmount must > 0");     
        Config memory config  =configMap[currency];
        require(config.minAmount <= _amount&&config.maxAmount >= _amount, "Claim: _amount error!");
        require(config.status==0, "Claim: status is error!");
        uint256 fee=0;
        uint256 reserveAmount=0;
        if(currency==WETH){
            reserveAmount= SafeMath.div(SafeMath.mul(_amount,MineDetail[withdrawRate[msg.sender]].rate),100);
            uint256 amount=SafeMath.sub(_amount,reserveAmount);
            fee =SafeMath.div(SafeMath.mul(amount,config.fee),100);
            uint256 realamount=SafeMath.sub(amount,fee);
            safeTransferETH(msg.sender, realamount);
        }else{
            fee =SafeMath.div(SafeMath.mul(_amount,config.fee),100);
            uint256 realamount=SafeMath.sub(_amount,fee);
            safeTransferToken(currency,address(msg.sender), realamount);
        }
        tokenAmount[currency][msg.sender] = tokenAmount[currency][msg.sender].sub(_amount);
        emit Claim(currency,msg.sender, _amount,reserveAmount,fee);
    }
    //奖金：币种地址、用户地址、数量、可用、手续费

    function safeTransferETH(address _to, uint256 _amount) internal {
        uint256 tokenBal =  address(this).balance;
        require(tokenBal >0 && tokenBal >= _amount , "AwardPool: pool not balance"); 
        TransferHelper.safeTransferETH(_to, _amount);
    }
    //安全传输ETH及侧链

    function safeTransferToken(address currency,address _to, uint256 _amount) internal {
        uint256 tokenBal = IERC20(currency).balanceOf(address(this));
        require(tokenBal >0 && tokenBal >= _amount, "AwardPool: pool not balance"); 
        IERC20(currency).transfer(_to, _amount);    
    }
    //安全传输代币

    function setFrozen(address _address,uint256 _status) public onlyOwner{
        claimFrozen[_address]=_status;
    }
    //设置冻结
    
}