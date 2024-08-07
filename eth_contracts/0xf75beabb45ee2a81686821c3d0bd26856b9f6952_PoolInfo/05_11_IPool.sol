/*
IPool

https://github.com/gysr-io/core

SPDX-License-Identifier: MIT
*/

pragma solidity 0.8.18;

/**
 * @title Pool interface
 *
 * @notice this defines the core Pool contract interface
 */
interface IPool {
    /**
     * @return staking tokens for Pool
     */
    function stakingTokens() external view returns (address[] memory);

    /**
     * @return reward tokens for Pool
     */
    function rewardTokens() external view returns (address[] memory);

    /**
     * @return staking balances for user
     */
    function stakingBalances(
        address user
    ) external view returns (uint256[] memory);

    /**
     * @return total staking balances for Pool
     */
    function stakingTotals() external view returns (uint256[] memory);

    /**
     * @return reward balances for Pool
     */
    function rewardBalances() external view returns (uint256[] memory);

    /**
     * @return GYSR usage ratio for Pool
     */
    function usage() external view returns (uint256);

    /**
     * @return address of staking module
     */
    function stakingModule() external view returns (address);

    /**
     * @return address of reward module
     */
    function rewardModule() external view returns (address);

    /**
     * @notice stake asset and begin earning rewards
     * @param amount number of tokens to stake
     * @param stakingdata data passed to staking module
     * @param rewarddata data passed to reward module
     */
    function stake(
        uint256 amount,
        bytes calldata stakingdata,
        bytes calldata rewarddata
    ) external;

    /**
     * @notice unstake asset and claim rewards
     * @param amount number of tokens to unstake
     * @param stakingdata data passed to staking module
     * @param rewarddata data passed to reward module
     */
    function unstake(
        uint256 amount,
        bytes calldata stakingdata,
        bytes calldata rewarddata
    ) external;

    /**
     * @notice claim rewards without unstaking
     * @param amount number of tokens to claim against
     * @param stakingdata data passed to staking module
     * @param rewarddata data passed to reward module
     */
    function claim(
        uint256 amount,
        bytes calldata stakingdata,
        bytes calldata rewarddata
    ) external;

    /**
     * @notice method called ad hoc to update user accounting
     * @param stakingdata data passed to staking module
     * @param rewarddata data passed to reward module
     */
    function update(
        bytes calldata stakingdata,
        bytes calldata rewarddata
    ) external;

    /**
     * @notice method called ad hoc to clean up and perform additional accounting
     * @param stakingdata data passed to staking module
     * @param rewarddata data passed to reward module
     */
    function clean(
        bytes calldata stakingdata,
        bytes calldata rewarddata
    ) external;

    /**
     * @return gysr balance available for withdrawal
     */
    function gysrBalance() external view returns (uint256);

    /**
     * @notice withdraw GYSR tokens applied during unstaking
     * @param amount number of GYSR to withdraw
     */
    function withdraw(uint256 amount) external;

    /**
     * @notice transfer control of the staking module to another account
     * @param newController address of new controller
     */
    function transferControlStakingModule(address newController) external;

    /**
     * @notice transfer control of the reward module to another account
     * @param newController address of new controller
     */
    function transferControlRewardModule(address newController) external;

    /**
     * @notice execute multiple operations in a single call
     * @param data array of encoded function data
     */
    function multicall(
        bytes[] calldata data
    ) external returns (bytes[] memory results);
}