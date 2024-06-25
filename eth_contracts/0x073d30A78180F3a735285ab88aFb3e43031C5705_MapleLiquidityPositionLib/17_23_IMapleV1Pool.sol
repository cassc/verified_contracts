// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.

    (c) Enzyme Council <[email protected]>

    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

pragma solidity 0.6.12;

/// @title IMapleV1Pool Interface
/// @author Enzyme Council <[email protected]>
interface IMapleV1Pool {
    function liquidityAsset() external view returns (address);

    function recognizableLossesOf(address) external returns (uint256);

    function withdrawableFundsOf(address) external returns (uint256);
}