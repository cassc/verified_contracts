// SPDX-License-Identifier: reup.cash
pragma solidity ^0.8.17;

import "./Base/IBridgeUUPSERC20.sol";
import "./Base/ICanMint.sol";
import "./Base/IUpgradeableBase.sol";

interface IREUSD is IBridgeUUPSERC20, ICanMint, IUpgradeableBase
{
    function isREUSD() external view returns (bool);
    function url() external view returns (string memory);
}