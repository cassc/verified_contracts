//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface ILibertiPriceFeed {
    function getPrice(address token) external view returns (uint256);
}