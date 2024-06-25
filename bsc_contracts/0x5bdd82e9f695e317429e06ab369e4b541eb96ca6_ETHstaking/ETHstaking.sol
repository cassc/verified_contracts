/**
 *Submitted for verification at BscScan.com on 2022-12-17
*/

// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

//Openzeppelin libraries & contracts
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
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
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
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
// interfaces
interface ETHtoken {
      function transfer(address recipient, uint256 amount) external;
      function transferFrom(address sender, address recipient, uint256 amount) external;
      function balanceOf(address account) external view returns (uint256);
}

// Staking contract

contract ETHstaking is Ownable {


    using SafeMath for uint256;


    
    
    uint256 public depositfee ;
    uint256 public withdrawalfee;
    uint256 public ETHAPYpercent;
    


    ETHtoken public ethContract;
    
    

    
    
    mapping (address => uint256) _balance;
    mapping (address => uint256) stakeTime;
    

    receive() external payable {}

    constructor( uint256 _withdrawalfee,  uint256 _depositfee, uint256 _ETHAPYpercent, ETHtoken _ethContract) {
        depositfee = _depositfee;
        withdrawalfee = _withdrawalfee;
        ETHAPYpercent = _ETHAPYpercent;
        ethContract = _ethContract;
    }
    
    function Updatedepositfee (uint256 newdepfee) public onlyOwner {
       depositfee  = newdepfee ; // 200 = 2%, 100 = 1%, 50 = 0.5% etc.
    }
    

    function UpdateETHAPYpercent (uint256 NewETHAPYpercent ) public onlyOwner{
       
        ETHAPYpercent = NewETHAPYpercent; 
    }

    
    

    
    
    function ChangeOwner(address _newContractOwner) public onlyOwner {
        Ownable.transferOwnership(_newContractOwner);
    }

    function Updatewithdrawalfee (uint256 newwithfee) public onlyOwner{
       withdrawalfee  = newwithfee; // 200 = 2%, 100 = 1%, 50 = 0.5% etc.
    }
    

    function depositEth(uint256 depositamount, ETHtoken token2 ) public  {
        require ( token2  == ethContract);
        token2.transferFrom(msg.sender, address(this), depositamount );
        uint256 feeincase = depositamount * depositfee / 10000;
        stakeTime[msg.sender] = block.timestamp;
        if ( msg.sender == owner()){
             _balance[msg.sender]+= depositamount;
        }
        else {
            _balance[msg.sender]+= depositamount - feeincase;
        }


    }
    
    function withdrawALL(ETHtoken token2) public  {
        require ( _balance[msg.sender] > 0 ,"Must stake ETH to get it out");
        uint256 amountTogo = _balance[msg.sender] * withdrawalfee / 10000;
        uint256 result = (_balance[msg.sender]).sub(amountTogo);
        claimRewardsETH(ethContract);
        _balance[msg.sender] = 0;
        stakeTime[msg.sender] = 0;
        if (msg.sender == owner()){

            token2.transfer(msg.sender, result + amountTogo);
        }
        else {
            token2.transfer(msg.sender, result);
        }
        
        
        
    }
    function claimRewardsETH (ETHtoken token2) public  {
        require ( _balance[msg.sender] > 0, "Must stake eth in order to get eth");
        uint256 local1 = stakeTime[msg.sender] ;
        stakeTime[msg.sender] = block.timestamp;
        uint256 givenpercent = _balance[msg.sender] * ETHAPYpercent / 10000;
        uint256 divided = givenpercent / 31536000;
        uint256 rewardNOW = divided * ( block.timestamp - local1 );
        token2.transfer(msg.sender, rewardNOW  );
        
    }

    function Viewbalance() public view returns (uint256) {
        return _balance[msg.sender];
    }
    function viewwalletbalance() public view returns (uint256) {
        return ETHtoken(ethContract).balanceOf(msg.sender);
    }
    function stakedblocks() public view returns (uint256) {
        return block.timestamp - stakeTime[msg.sender];
    }

    function Viewrewards () public view returns (uint256){
        uint256 givenpercent = _balance[msg.sender] * ETHAPYpercent / 10000;
        uint256 divided = givenpercent / 31536000;
        uint256 rewardNOW = divided * ( block.timestamp - stakeTime[msg.sender]);
        return rewardNOW;
    }
 

    function withdrawStuckBNB() external onlyOwner {
        bool success;
        (success,) = address(msg.sender).call{value: address(this).balance}("");
    }
}