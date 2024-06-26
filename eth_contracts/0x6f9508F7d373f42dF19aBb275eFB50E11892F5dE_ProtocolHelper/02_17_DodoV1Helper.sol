// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;
pragma abicoder v1;

import "../interfaces/DodoV1.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@1inch/solidity-utils/contracts/libraries/SafeERC20.sol";

/**
 * @title DodoV1Helper
 * @notice Helper that performs onchain calculation required to call a Dodo v1 contract and returns corresponding caller and data
 */
abstract contract DodoV1Helper {
    using SafeERC20 for IERC20;

    function swapQuoteTokenDodoV1(
        uint256 sellAmount,
        IDODO pool,
        IDODOHelper helper
    ) external view returns (address target, address sourceTokenInteractionTarget, uint256 valueLimit, bytes memory data) {
        uint256 boughtAmount = helper.querySellQuoteToken(pool, sellAmount);
        bytes memory resultData = abi.encodeCall(pool.buyBaseToken, (boughtAmount, sellAmount, ""));
        return (address(pool), address(pool), sellAmount, resultData);
    }
}