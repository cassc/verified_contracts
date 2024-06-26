// SPDX-License-Identifier: ISC

pragma solidity 0.7.5;

interface IwstETH {
    function wrap(uint256 _stETHAmount) external returns (uint256);

    function unwrap(uint256 _wstETHAmount) external returns (uint256);
}