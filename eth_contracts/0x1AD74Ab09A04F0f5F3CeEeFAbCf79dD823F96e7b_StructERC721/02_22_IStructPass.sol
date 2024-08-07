// SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

interface IStructPass {
    function balanceOf(address owner) external view returns (uint256 balance);
}