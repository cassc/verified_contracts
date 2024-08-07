// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

import {IERC20} from "IERC20.sol";

interface IERC20WithDecimals is IERC20 {
    function decimals() external view returns (uint256);
}