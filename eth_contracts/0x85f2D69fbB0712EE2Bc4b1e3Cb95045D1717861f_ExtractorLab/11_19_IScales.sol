//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

import "./ISpendable.sol";

interface IScales is ISpendable {
	function deposit(uint256 amount) external;
}