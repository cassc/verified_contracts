// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
pragma experimental ABIEncoderV2;

interface IMasterApe {

    struct UserInfo {
        uint256 amount;
        uint256 rewardDebt;
    }

    struct PoolInfo {
        address lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accCakePerShare;
    }

    function cake() external view returns (address);
    function syrup() external view returns (address);

    function poolInfo(uint256 pid) external view returns (PoolInfo memory);
    function userInfo(uint256 arg1, address arg2) external view returns (UserInfo memory);
    
    function transferOwnership(address newOwner) external; // from Ownable.sol
    function updateMultiplier(uint256 multiplierNumber) external; // onlyOwner
    function add(uint256 _allocPoint, address _lpToken, bool _withUpdate) external; // onlyOwner
    function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) external; // onlyOwner
    function totalAllocPoint() external view returns (uint256);
    function BONUS_MULTIPLIER() external view returns (uint256);
    function cakePerBlock() external view returns (uint256);
    function poolLength() external view returns (uint256);
    function checkPoolDuplicate(address _lpToken) external view;
    function getMultiplier(uint256 _from, uint256 _to) external view returns (uint256);
    function pendingCake(uint256 _pid, address _user) external view returns (uint256);
    function massUpdatePools() external;
    function updatePool(uint256 _pid) external; // validatePool(_pid);
    function deposit(uint256 _pid, uint256 _amount) external; // validatePool(_pid);
    function withdraw(uint256 _pid, uint256 _amount) external; // validatePool(_pid);
    function enterStaking(uint256 _amount) external;
    function leaveStaking(uint256 _amount) external;
    function emergencyWithdraw(uint256 _pid) external;
    function getPoolInfo(uint256 _pid) external view returns(address lpToken, uint256 allocPoint, uint256 lastRewardBlock, uint256 accCakePerShare);
    function dev(address _devaddr) external;
    
}