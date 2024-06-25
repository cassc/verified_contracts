/**
 *Submitted for verification at BscScan.com on 2022-09-06
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

interface IERC20 
{

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
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

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

    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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


    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return a % b;
    }

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

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    
    constructor () {
      address msgSender = _msgSender();
      _owner = msgSender;
      emit OwnershipTransferred(address(0), msgSender);
    }

    
    function owner() public view returns (address) {
      return _owner;
    }

    
    modifier onlyOwner() {
      require(_owner == _msgSender(), "Ownable: caller is not the owner");
      _;
    }

    function renounceOwnership() public onlyOwner {
      emit OwnershipTransferred(_owner, address(0));
      _owner = address(0);
    }

    function transferOwnership(address newOwner) public onlyOwner {
      _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
      require(newOwner != address(0), "Ownable: new owner is the zero address");
      emit OwnershipTransferred(_owner, newOwner);
      _owner = newOwner;
    }
}

abstract contract ReentrancyGuard {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }
}

contract OpenFunds_POWER is Context, Ownable , ReentrancyGuard {
    using SafeMath for uint256;
    IERC20 private BusdInterface;
    address public dev = 0x2F50275208CF3e4355972f1b1Db85537DE3d896E;
    uint256 public constant deposit_fee = 6;
    uint256 public constant withdraw_fee = 3;
    address public tokenAdress;
    struct DepositStruct {
        address investor;
        uint256 depositAmount;
        uint256 depositAt; 
        uint256 claimedAmount; 
        bool state; 
        uint256 unlockedDate;
        uint256 rewardPerc;
    }

    struct PlanStruct {
        uint256 lockedDate;
        uint256 rewardPerc;
    }

    mapping(uint256 => PlanStruct) public planInfo;

    constructor() {
        tokenAdress = 0xe9e7CEA3DedcA5984780Bafc599bD69ADd087D56; 
        BusdInterface = IERC20(tokenAdress);
        planInfo[7] = PlanStruct(SafeMath.mul(7,86400),10);
        planInfo[14] = PlanStruct(SafeMath.mul(14,86400),15);
        planInfo[30] = PlanStruct(SafeMath.mul(30,86400),20);
        planInfo[60] = PlanStruct(SafeMath.mul(60,86400),35);
    }
    uint256 public _currentDepositID = 0;
    address[] public investors;
    
    mapping(uint256 => DepositStruct) public depositState;
    // mapping form investor to deposit IDs
    mapping(address => uint256[]) public ownedDeposits;
    
    mapping(address => bool) public investorExists;
    // invest function 
    function deposit(uint256 _lockedDate, uint256 _amount) public noReentrant  {
        require(_amount >0, "You need deposit more than 0 BUSD");
        require(planInfo[_lockedDate].lockedDate>0,"Do not allow other locked date!");
        uint256 _id = getNextDepositID();
        incrementDepositID();
        uint256 total_fee = depositFee(_amount);
        BusdInterface.transferFrom(msg.sender,dev,total_fee);
        uint256 total_contract = SafeMath.sub(_amount,total_fee);
        depositState[_id].investor = msg.sender;
        depositState[_id].depositAmount = _amount;
        depositState[_id].depositAt = block.timestamp;
        depositState[_id].state = true;
        depositState[_id].unlockedDate = block.timestamp + planInfo[_lockedDate].lockedDate;
        depositState[_id].rewardPerc = planInfo[_lockedDate].rewardPerc;
        ownedDeposits[msg.sender].push(_id);
        if(!investorExists[msg.sender]) {
            investors.push(msg.sender);
            investorExists[msg.sender] = true;
        }
        BusdInterface.transferFrom(msg.sender,address(this),total_contract);
        
    }

    // claim by ID
    function claimReward(uint256 id) public noReentrant {
        require(depositState[id].investor == msg.sender, "Start investing before you want to claim!");
        require(depositState[id].state, "You have already withdrawed the investment!");

        uint256 validReward = calculateRewardByID(id);

        require(validReward > 0, "Invalid reward");

        uint256 wFee = withdrawFee(validReward);

        BusdInterface.transfer(msg.sender,SafeMath.sub(validReward, wFee) );
        BusdInterface.transfer(dev,wFee);
        depositState[id].claimedAmount += validReward;
    }
    // claim by address
    function claimAllReward() public noReentrant {
        uint256 allRewards = 0;
        require(ownedDeposits[msg.sender].length > 0, "you can deposit once at least");

        for (uint256 i;i < ownedDeposits[msg.sender].length;i++) {
            uint256 validRewardID = calculateRewardByID(ownedDeposits[msg.sender][i]);
            allRewards += validRewardID;
            depositState[ownedDeposits[msg.sender][i]].claimedAmount += validRewardID;
        }

        uint256 wFee = withdrawFee(allRewards);

        BusdInterface.transfer(msg.sender,SafeMath.sub(allRewards, wFee) );
        BusdInterface.transfer(dev,wFee);
    }

    function unStake(uint256 id) public noReentrant {
        require(
            depositState[id].investor == msg.sender,
            "only investor of this id can claim reward"
        );
        require(
            (block.timestamp > depositState[id].unlockedDate),
            "withdraw lock time is not finished yet"
        );
        require(depositState[id].state, "you already withdrawed capital");

        uint256 avaiableReward = calculateRewardByID(id);

        uint256 totalReturnCapital = depositState[id].depositAmount + avaiableReward;

        require(
            totalReturnCapital <= getBalance(),
            "total fund is not enough"
        );

        BusdInterface.transfer(msg.sender,totalReturnCapital );
        depositState[id].state = false;
    }

    function getOwnedDeposits(address investor) public view returns (uint256[] memory) {
        return ownedDeposits[investor];
    }

    // other functions
    function calculateRewardByID(uint256 id) public view returns (uint256) {
        if(depositState[id].state == false) return 0;
        
        uint256 lastedClaim = block.timestamp - depositState[id].depositAt;

        uint256 dailyValue = SafeMath.div(SafeMath.mul(depositState[id].depositAmount,depositState[id].rewardPerc),1000);

        uint256 availableReward = SafeMath.div(SafeMath.mul(dailyValue,lastedClaim),1 days );

        require(
            availableReward >= depositState[id].claimedAmount,
            "Not right here!"
        );
        
        return SafeMath.sub(availableReward, depositState[id].claimedAmount);
    }

    function getAllValidReward(address investor) public view returns (uint256) {
        uint256 allValidReward;
        for(uint256 i = 0; i < ownedDeposits[investor].length; i ++) {
            allValidReward += calculateRewardByID(ownedDeposits[investor][i]);
        }

        return allValidReward;
    }

    // statistic Func
    function getTotalRewards() public view returns (uint256) {
        uint256 totalRewards;
        for(uint256 i = 0; i < _currentDepositID; i ++) {
            totalRewards += calculateRewardByID(i + 1);
        }
        return totalRewards;
    }

    function getTotalInvests() public view returns (uint256) {
        uint256 totalInvests;
        for(uint256 i = 0; i < _currentDepositID; i ++) {
            if(depositState[i + 1].state) totalInvests += depositState[i + 1].depositAmount;
        }
        return totalInvests;
    }

    function getTotalInvestor() public view returns (uint256) {
        return investors.length;
    }

    function DailyRoi(uint256 _amount, uint256 _roi) public pure returns(uint256) {
        return SafeMath.div(SafeMath.mul(_amount,_roi),1000);
    }

    function getNextDepositID() private view returns (uint256) {
        return _currentDepositID + 1;
    }

    function incrementDepositID() private {
        _currentDepositID++;
    }

    function depositFee(uint256 _amount) public pure returns(uint256){
     return SafeMath.div(SafeMath.mul(_amount,deposit_fee),100);
    }

    function withdrawFee(uint256 _amount) public pure returns(uint256) {
        return SafeMath.div(SafeMath.mul(_amount,withdraw_fee),100);
    }

    function getBalance() public view returns(uint256){
         return BusdInterface.balanceOf(address(this));
    }

    function getInvestors() public view returns (address[] memory) {
        return investors;
    }

}