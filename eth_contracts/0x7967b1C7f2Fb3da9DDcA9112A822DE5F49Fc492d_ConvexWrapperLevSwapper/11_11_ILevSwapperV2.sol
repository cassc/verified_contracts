// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface ILevSwapperV2 {
    function swap(
        address recipient,
        uint256 shareToMin,
        uint256 shareFrom,
        bytes calldata data
    ) external returns (uint256 extraShare, uint256 shareReturned);
}