// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMasterChimpyV2 {
    function deposit(uint256 _pid, uint256 _amount) external;

    function withdraw(uint256 _pid, uint256 _amount) external;

    function pendingCake(uint256 _pid, address _user) external view returns (uint256);

    function userInfo(uint256 _pid, address _user) external view returns (uint256, uint256);

    function emergencyWithdraw(uint256 _pid) external;

    function getBoostMultiplier(address _user, uint256 _pid) external view returns (uint256);

    function poolLength() external view returns (uint256 pools);

    function lpToken(uint256 _pid) external view returns (address);

    function updateBoostMultiplier(
        address _user,
        uint256 _pid,
        uint256 _newMultiplier
    ) external;
}