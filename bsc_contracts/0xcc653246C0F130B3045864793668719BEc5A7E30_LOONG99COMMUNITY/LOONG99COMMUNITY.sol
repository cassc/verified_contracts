/**
 *Submitted for verification at BscScan.com on 2022-09-21
*/

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;
interface IBEP20 {
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
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () { }

    function _msgSender() internal view returns (address) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
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
   * - The divisor cannot be zero.
   */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
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
   * - The divisor cannot be zero.
   */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
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
contract Ownable is Context {
    address private _owner;

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
     * @dev Returns the address of the current owner.
   */
    function changeOwner(address newOwner) public onlyOwner {
        _owner = newOwner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
   */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
    function renounceOwnership() public onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
   */
    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
interface IPancakeRouter {
    function factory() external pure returns (address);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract LOONG99COMMUNITY is Context, Ownable {
    using SafeMath for uint256;
    address private _dead = address(0x000000000000000000000000000000000000dEaD);
    address public _usdt=address(0x55d398326f99059fF775485246999027B3197955);//usdt
    address public _loong=address(0x6383851Aa1378e571Da44d585d70A5c54d0d602C);//神龙币
    address public _token=address(0x93aFBc2Da334b312DD09630109Dd2f4209556f35);//社区币
    address public _receiver=address(0x56c0Fb4a4935eCf17bfbeDbdD2BaD2f39023fa9c);//接收人
    bool public _isDead=true;
    IPancakeRouter private uniswapV2Router;
    uint public ratio=50;
    uint public ratio2=50;
    uint[3] public _receivers;
    address[3] public _addresses;
    uint public _minAmount=1*10**18;
    uint public _maxAmount=10000*10**18;
    constructor() {
        //绑定路由
        uniswapV2Router = IPancakeRouter(0x10ED43C718714eb63d5aA57B78B54704E256024E);//pancake main
        _receivers=[45,50,5];
        _addresses[0]=address(0x1F78B101d6982C0190d96EcE38bca5806DFDDEA1);
        _addresses[1]=address(0x48Db62D5f8EA6a0B432F135Db5EE512BCE8f1e1e);
        _addresses[2]=address(0x361e6A37eda252d0c673a040102ab0A919869e54);
    }
    function setParams(uint[3] calldata params,address[3] calldata addresses,uint minAmount,uint maxAmount) external onlyOwner{
        require(params[0].add(params[1]).add(params[2])==100,"error");
        delete _receivers;
        delete _addresses;
        _receivers=params;
        _addresses=addresses;
        _minAmount=minAmount;
        _maxAmount=maxAmount;
    }
    function setIsDead(bool isDead) external onlyOwner{
        _isDead=isDead;
    }
    function buy(uint amount,uint status) external {
        require(amount>0,"error");
        require(amount>=_minAmount,"error1");
        require(amount<=_maxAmount,"error2");
        if(status==0){
            //组合支付
            //usdt部分
            address[] memory path = new address[](2);//交易对
            path[0]=_usdt;
            if(_isDead==true){
                IBEP20(_usdt).transferFrom(_msgSender(),address(this),amount.mul(ratio).div(100));
                path[1]=_loong;
                uint loong=IBEP20(_loong).balanceOf(address(this));
                IBEP20(_usdt).approve(address(uniswapV2Router),2**256-1);
                uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount.mul(ratio).div(100), 0, path, address(this), block.timestamp);
                loong=IBEP20(_loong).balanceOf(address(this))-loong;
                IBEP20(_loong).transfer(_dead,loong);//销毁
            }else{
                IBEP20(_usdt).transferFrom(_msgSender(),address(this),amount.mul(ratio).div(100));
                IBEP20(_usdt).transfer(_receiver,amount.mul(ratio).div(100));
            }

            //社区币部分
            path[1]=_token;
            uint[] memory amounts=uniswapV2Router.getAmountsOut(amount.mul(100-ratio).div(100), path);
            IBEP20(_token).transferFrom(_msgSender(),address(this),amounts[1]);
            if(_receivers[0]>0){
                IBEP20(_token).transfer(_addresses[0],amounts[1].mul(_receivers[0]).div(100));
            }
            if(_receivers[1]>0){
                IBEP20(_token).transfer(_addresses[1],amounts[1].mul(_receivers[1]).div(100));
            }
            if(_receivers[2]>0){
                IBEP20(_token).transfer(_addresses[2],amounts[1].mul(_receivers[2]).div(100));
            }
        }else if(status==1){
            //单u支付
            IBEP20(_usdt).transferFrom(_msgSender(),address(this),amount);
            address[] memory path = new address[](2);//交易对
            path[0]=_usdt;
            if(_isDead==true){
                path[1]=_loong;
                uint loong=IBEP20(_loong).balanceOf(address(this));
                IBEP20(_usdt).approve(address(uniswapV2Router),2**256-1);
                uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount.mul(ratio2).div(100), 0, path, address(this), block.timestamp);
                loong=IBEP20(_loong).balanceOf(address(this))-loong;
                IBEP20(_loong).transfer(_dead,loong);//销毁
            }else{
                IBEP20(_usdt).transfer(_receiver,amount.mul(ratio2).div(100));
            }

            //社区币部分
            path[1]=_token;
            uint surplus=IBEP20(_token).balanceOf(address(this));
            IBEP20(_usdt).approve(address(uniswapV2Router),2**256-1);
            uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(amount.mul(100-ratio2).div(100), 0, path, address(this), block.timestamp);
            surplus=IBEP20(_token).balanceOf(address(this))-surplus;
            if(_receivers[0]>0){
                IBEP20(_token).transfer(_addresses[0],surplus.mul(_receivers[0]).div(100));
            }
            if(_receivers[1]>0){
                IBEP20(_token).transfer(_addresses[1],surplus.mul(_receivers[1]).div(100));
            }
            if(_receivers[2]>0){
                IBEP20(_token).transfer(_addresses[2],surplus.mul(_receivers[2]).div(100));
            }

        }else{
            revert("error3");
        }

    }
}