// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.

    (c) Enzyme Council <[email protected]>

    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity 0.6.12;

/// @title IMapleV1MplRewards Interface
/// @author Enzyme Council <[email protected]>
interface IMapleV1MplRewards {
    function getReward() external;

    function rewardsToken() external view returns (address);
}