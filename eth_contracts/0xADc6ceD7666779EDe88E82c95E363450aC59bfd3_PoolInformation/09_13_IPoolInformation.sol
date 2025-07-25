// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import {IPool} from "@maverickprotocol/maverick-v1-interfaces/contracts/interfaces/IPool.sol";

interface IPoolInformation {
    /// @notice Bin information
    /// @param id of the bin that changed
    /// @param kind one of the 4 Kinds (0=static, 1=right, 2=left, 3=both)
    /// @param lowerTick is the lower price tick of the bin in its current state
    /// @param reserveA amount of A token in bin
    /// @param reserveB amount of B token in bin
    /// @param mergeId Id of the bin that this bin has merged into.  0 for a
    //bin that is not merged.
    struct BinInfo {
        uint128 id;
        uint8 kind;
        int32 lowerTick;
        uint128 reserveA;
        uint128 reserveB;
        uint128 mergeId;
    }

    /// @notice calculate swap tokens
    /// @param pool to swap against
    /// @param amount amount of token that is either the input if exactOutput
    //is false or the output if exactOutput is true
    /// @param tokenAIn bool indicating whether tokenA is the input
    /// @param exactOutput bool indicating whether the amount specified is the
    //exact output amount (true)
    /// @param sqrtPriceLimit limiting sqrt price of the swap.  A value of 0
    //indicates no limit.  Limit is only engaged for exactOutput=false.  If the
    //limit is reached only part of the input amount will be swapped and the
    //callback will only require that amount of the swap to be paid.
    function calculateSwap(IPool pool, uint128 amount, bool tokenAIn, bool exactOutput, uint256 sqrtPriceLimit) external returns (uint256 returnAmount);

    /// @notice get list of bins that are active (ie have not been merged)
    /// @param pool to query
    /// @param startBinIndex index of the starting bin.  may need to paginate if the pool has many bins
    /// @param endBinIndex index of the ending bin
    function getActiveBins(IPool pool, uint128 startBinIndex, uint128 endBinIndex) external view returns (BinInfo[] memory bins);

    /// @notice merge depth of a given merged bin
    function getBinDepth(IPool pool, uint128 binId) external view returns (uint256 depth);

    /// @notice get sqrtPrice of the pool in D18 scale
    function getSqrtPrice(IPool pool) external view returns (uint256 sqrtPrice);

    /// @notice get list of bins that are at the active tick
    function getBinsAtTick(IPool pool, int32 tick) external view returns (IPool.BinState[] memory bins);

    /// @notice get liquidity information about the active tick
    function activeTickLiquidity(IPool pool) external view returns (uint256 sqrtPrice, uint256 liquidity, uint256 reserveA, uint256 reserveB);

    /// @notice get liquidity information about a given tick
    function tickLiquidity(IPool pool, int32 tick) external view returns (uint256 sqrtPrice, uint256 liquidity, uint256 reserveA, uint256 reserveB);
}