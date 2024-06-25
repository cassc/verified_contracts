// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "../../libraries/external/GPv2Order.sol";
import "../vaults/IVault.sol";
import "../../strategies/LStrategy.sol";
import "../vaults/IUniV3Vault.sol";
import "../external/univ3/INonfungiblePositionManager.sol";

interface ILStrategyHelper {
    function checkOrder(
        GPv2Order.Data memory order,
        bytes calldata uuid,
        address erc20Vault,
        uint256 fee
    ) external;

    function getPreOrder(uint256[] memory tvl, uint256 minAmountOut) external view returns (LStrategy.PreOrder memory);

    function tickFromPriceX96(uint256 priceX96) external pure returns (int24);

    function calculateTokenAmounts(IUniV3Vault lowerVault, IUniV3Vault upperVault, IVault erc20Vault, uint256 amount0, uint256 amount1, INonfungiblePositionManager positionManager, bool isDeposit) external view returns (uint256[] memory lowerAmounts, uint256[] memory upperAmounts);
}