// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.16;

import "@openzeppelin/contracts/interfaces/IERC20.sol";


contract Lunaonestaking {

    event OwnershipTransferred(address owner, address newOwner);
    event FeeUpdated(uint256 previousFee, uint256 updatedFee);
    event StakeLimitUpdated(Stake);
    event Staking(address userAddress, uint256 level, uint256 amount);
    event Withdraw(address userAddress, uint256 withdrawAmount, uint256 rewardAmount);

    address public owner;
    IERC20 public token;
    uint256 public penaltyFeePermile;

    struct UserDetail {
        uint256 level;
        uint256 amount;
        uint256 initialTime;
        uint256 endTime;
        uint256 rewardAmount;
        uint256 withdrawAmount;
        bool status;
    }

    struct Stake {
        uint256 rewardPercent;
        uint256 stakeLimit;
    }

    mapping(address =>mapping(uint256 => UserDetail)) internal users;
    mapping(uint256 => Stake) internal stakingDetails;

    modifier onlyOwner() {
        require(owner == msg.sender,"Ownable: Caller is not owner");
        _;
    }

    constructor (IERC20 _token,uint256 _penaltyFeePermile) {
        token = _token;
        penaltyFeePermile = _penaltyFeePermile;
        stakingDetails[1] = Stake(15, 90 days);
        stakingDetails[2] = Stake(20, 180 days);
        stakingDetails[3] = Stake(30, 365 days);
        stakingDetails[4] = Stake(40, 730 days);
        owner = msg.sender;
    }


    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "ownable: invalid address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    function updatePenaltyFee(uint256 fee) external onlyOwner {
        emit FeeUpdated(penaltyFeePermile, fee);
        penaltyFeePermile = fee;
    }

    function recoverBNB(uint256 amount) external onlyOwner {
        payable(owner).transfer(amount);
    }

    function recoverToken(address tokenAddr,uint256 amount) external onlyOwner {
        IERC20(tokenAddr).transfer(owner, amount);
    }

    function stake(uint256 amount, uint256 level) external returns(bool) {
        require(level > 0 && level <= 4, "Invalid level");
        require(!(users[msg.sender][level].status),"user already exist");
        require( amount > 0, "invalid amount");
        users[msg.sender][level].amount = amount;
        users[msg.sender][level].level = level;
        users[msg.sender][level].endTime = block.timestamp + stakingDetails[level].stakeLimit;        
        users[msg.sender][level].initialTime = block.timestamp;
        users[msg.sender][level].status = true;
        token.transferFrom(msg.sender, address(this), amount);
        emit Staking(msg.sender, level, amount);
        return true;
    }


    function getRewards(address account, uint256 level) internal view returns(uint256) {
        if(users[account][level].endTime <= block.timestamp) {
            uint256 stakeAmount = users[account][level].amount;
            uint256 rewardRate = stakingDetails[level].rewardPercent;
            uint256 interval = block.timestamp - users[account][level].initialTime;
            uint256 rewardAmount = stakeAmount * interval * rewardRate / 365 days / 100;
            return rewardAmount;
        }
        else {
            return (0);
        }
    }

    function withdraw(uint256 level) external returns(bool) {
        require(level > 0 && level <= 4, "Invalid level");
        require(users[msg.sender][level].status, "user not exist");
        require(users[msg.sender][level].endTime <= block.timestamp, "staking end time is not reached ");
        uint256 rewardAmount = getRewards(msg.sender, level);
        uint256 amount = rewardAmount + users[msg.sender][level].amount;
        token.transfer(msg.sender, amount);
        uint256 rAmount = rewardAmount + users[msg.sender][level].rewardAmount;
        uint256 wAmount = amount + users[msg.sender][level].withdrawAmount;
        users[msg.sender][level] = UserDetail(0, 0, 0, 0, rAmount, wAmount, false);
        emit Withdraw(msg.sender, amount, rewardAmount);
        return true;
    }

    function emergencyWithdraw(uint256 level) external returns(uint256) {
        require(level > 0 && level <= 4, "Invalid level");
        require(users[msg.sender][level].status, "user not exist");
        uint256 stakedAmount = users[msg.sender][level].amount;
        uint256 penalty = stakedAmount * penaltyFeePermile / 100;
        token.transfer(msg.sender, stakedAmount - penalty);
        token.transfer(owner, penalty);
        uint256 rewardAmount = users[msg.sender][level].rewardAmount;
        uint256 withdrawAmount = users[msg.sender][level].withdrawAmount;
        users[msg.sender][level] = UserDetail(0, 0, 0, 0, rewardAmount, withdrawAmount, false);

        emit Withdraw(msg.sender, stakedAmount, 0);
        return stakedAmount;
    }

    function getUserDetails(address account, uint256 level) external view returns(UserDetail memory, uint256 rewardAmount) {
        uint256 reward = getRewards(account, level);
        return (users[account][level], reward);
    }

    function setStakeDetails(uint256 level, Stake memory _stakeDetails) external onlyOwner returns(bool) {
        require(level > 0 && level <= 4, "Invalid level");
        stakingDetails[level] = _stakeDetails;
        emit StakeLimitUpdated(stakingDetails[level]);
        return true;
    }
}