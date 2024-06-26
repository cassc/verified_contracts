// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import { ISafeOwnable } from './ISafeOwnable.sol';
import { IERC165 } from './IERC165.sol';
import { IDiamondBase } from './IDiamondBase.sol';
import { IDiamondReadable } from './IDiamondReadable.sol';
import { IDiamondWritable } from './IDiamondWritable.sol';

interface ISolidStateDiamond is
    IDiamondBase,
    IDiamondReadable,
    IDiamondWritable,
    ISafeOwnable,
    IERC165
{
    receive() external payable;

    /**
     * @notice get the address of the fallback contract
     * @return fallback address
     */
    function getFallbackAddress() external view returns (address);

    /**
     * @notice set the address of the fallback contract
     * @param fallbackAddress fallback address
     */
    function setFallbackAddress(address fallbackAddress) external;
}
