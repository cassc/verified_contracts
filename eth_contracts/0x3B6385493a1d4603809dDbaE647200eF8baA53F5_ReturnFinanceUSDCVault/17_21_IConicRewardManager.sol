// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

interface IConicRewardManager {
    function claimEarnings() external returns (uint256, uint256, uint256);
}