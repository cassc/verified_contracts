// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.14;

// TODO: need a correct interface here
interface IWrapped {
  function deposit() external payable;

  function withdraw(uint256 amount) external;
}