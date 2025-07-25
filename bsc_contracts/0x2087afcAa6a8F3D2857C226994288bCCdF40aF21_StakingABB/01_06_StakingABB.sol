// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.4;

import "ReentrancyGuard.sol";
import "ERC20.sol";

contract StakingABB is ReentrancyGuard {
    ERC20 public ABB;
    uint256 public totalStakedAmount;
    struct StakedAmount {
        uint256 depositTimestamp;
        uint256 amount;
        uint256 lockUpPeriod;
        string solanaAddress;
        uint256 nextIndex;
    }
    struct StakeDetail {
        uint256 collectedRewards; 
        StakedAmount[] stakedAmounts;
        uint256 startIndex;
    }
    event Stake(
        address indexed account,
        uint256 amount,
        uint256 lockUpPeriod,
        string solanaAddress,
        uint256 currentTime,
        uint256 unlockTime
    );
    event Withdraw(address indexed account, uint256 amount);
    mapping(address => StakeDetail) public stakeDetailPerUser;
    mapping(uint256 => uint256) public lockupDaysToAPY;

    /************************************************
     *  CONSTRUCTOR
     ***********************************************/

    constructor(ERC20 token) {
        ABB = token;
        lockupDaysToAPY[30] = 500;
        lockupDaysToAPY[60] = 1000;
        lockupDaysToAPY[90] = 1500;
    }

    /************************************************
     *  READ FUNCTIONS
     ***********************************************/

    /**
     * @notice Base formula for reward calculations as per the corresponding APY.Reward returned with a factor of 1e18 (ABB token decimals)
     */
    function _calculateReward(
        uint256 amount,
        uint256 lockUpDays,
        uint256 currentDayCount
    ) internal view returns (uint256 reward) {
        currentDayCount = currentDayCount > lockUpDays
            ? lockUpDays
            : currentDayCount;
        reward =
            (lockupDaysToAPY[lockUpDays] * amount * currentDayCount) /
            (365 * 1e4);
    }

    /**
     * @notice Used for getting the list of staking details of a user
     */
    function getUserStakedAmounts(address account)
        external
        view
        returns (StakedAmount[] memory stakedAmounts)
    {
        stakedAmounts = stakeDetailPerUser[account].stakedAmounts;
    }

    /**
     * @notice Used for getting the expected reward as per the input parameters
     */
    function calculateReward(uint256 amount, uint256 lockUpDays)
        external
        view
        returns (uint256 reward)
    {
        reward = _calculateReward(amount, lockUpDays, lockUpDays);
    }

    /**
     * @notice Used for getting accrued reward for a user
     */
    function calculateUserReward(address account)
        external
        view
        returns (uint256 reward)
    {
        StakeDetail memory userStakingDetails = stakeDetailPerUser[account];
        uint256 startIndex = userStakingDetails.startIndex;
        uint256 n = startIndex;
        reward = userStakingDetails.collectedRewards;
        uint256 dayCount;

        while (n < userStakingDetails.stakedAmounts.length) {
            StakedAmount memory currentStakeBlock = userStakingDetails
                .stakedAmounts[n];
            dayCount =
                (block.timestamp - currentStakeBlock.depositTimestamp) /
                1 days;
            reward += _calculateReward(
                currentStakeBlock.amount,
                currentStakeBlock.lockUpPeriod,
                dayCount
            );
            n = currentStakeBlock.nextIndex;
        }
    }

    /**
     * @notice Used for getting the tokens that have completed their staking period and are available to withdraw.
     */
    function claimableTokens(address account)
        external
        view
        returns (uint256 amountToWithdraw)
    {
        StakeDetail memory userStakingDetails = stakeDetailPerUser[account];
        uint256 startIndex = userStakingDetails.startIndex;
        uint256 n = startIndex;

        while (n < userStakingDetails.stakedAmounts.length) {
            StakedAmount memory currentStakeBlock = userStakingDetails
                .stakedAmounts[n];
            if (
                currentStakeBlock.depositTimestamp +
                    (currentStakeBlock.lockUpPeriod * 1 days) <=
                block.timestamp
            ) {
                amountToWithdraw += currentStakeBlock.amount;
            }
            n = currentStakeBlock.nextIndex;
        }
    }

    /************************************************
     *  WRITE FUNCTIONS
     ***********************************************/

    /**
     * @notice Used for staking tokens for 30, 60, or 90 days. LockupPeriod is in days.
     */
    function stake(
        uint256 amount,
        uint256 lockUpPeriod,
        string memory solanaAddress
    ) external nonReentrant {
        address account = msg.sender;
        uint256 currentTime = block.timestamp;
        StakedAmount memory amountStaked = StakedAmount(
            currentTime,
            amount,
            lockUpPeriod,
            solanaAddress,
            stakeDetailPerUser[account].stakedAmounts.length + 1
        );
        stakeDetailPerUser[account].stakedAmounts.push(amountStaked);
        totalStakedAmount += amount;

        bool success = ABB.transferFrom(account, address(this), amount);
        require(success, "Staking didn't go through");
        emit Stake(
            account,
            amount,
            lockUpPeriod,
            solanaAddress,
            currentTime,
            currentTime + lockUpPeriod * 1 days
        );
    }

    /**
     * @notice Used for withdrawing tokens which have completed their staking period 
     */
    function withdraw() external nonReentrant {
        StakeDetail memory userStakingDetails = stakeDetailPerUser[msg.sender];
        uint256 startIndex = userStakingDetails.startIndex;
        uint256 n = startIndex;
        uint256 formerIndex;
        uint256 amountToWithdraw;
        uint256 collectedRewards;

        while (n < userStakingDetails.stakedAmounts.length) {
            StakedAmount memory currentStakeBlock = userStakingDetails
                .stakedAmounts[n];
            if (
                currentStakeBlock.depositTimestamp +
                    (currentStakeBlock.lockUpPeriod * 1 days) <=
                block.timestamp
            ) {
                amountToWithdraw += currentStakeBlock.amount;
                collectedRewards += _calculateReward(
                    currentStakeBlock.amount,
                    currentStakeBlock.lockUpPeriod,
                    currentStakeBlock.lockUpPeriod
                );

                if (n == startIndex) {
                    startIndex = currentStakeBlock.nextIndex;
                } else {
                    stakeDetailPerUser[msg.sender]
                        .stakedAmounts[formerIndex]
                        .nextIndex = currentStakeBlock.nextIndex;
                }
            } else {
                formerIndex = n;
            }
            n = currentStakeBlock.nextIndex;
        }

        stakeDetailPerUser[msg.sender].startIndex = startIndex;
        stakeDetailPerUser[msg.sender].collectedRewards += collectedRewards;
        totalStakedAmount -= amountToWithdraw;

        if (amountToWithdraw > 0) {
            bool success = ABB.transfer(msg.sender, amountToWithdraw);
            require(success, "The Withdrawal didn't go through");
            emit Withdraw(msg.sender, amountToWithdraw);
        }
    }
}