// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.
    (c) Enzyme Council <[email protected]>
    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity 0.6.12;

/// @title IConvexBaseRewardPool Interface
/// @author Enzyme Council <[email protected]>
interface IConvexBaseRewardPool {
    function extraRewards(uint256) external view returns (address);

    function extraRewardsLength() external view returns (uint256);

    function getReward() external returns (bool);

    function withdrawAndUnwrap(uint256, bool) external returns (bool);
}