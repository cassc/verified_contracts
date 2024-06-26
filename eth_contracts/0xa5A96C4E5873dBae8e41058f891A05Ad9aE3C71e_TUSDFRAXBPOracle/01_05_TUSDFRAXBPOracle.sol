// SPDX-License-Identifier: AGPL-3.0-only
// Using the same Copyleft License as in the original Repository
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import './interfaces/IOracle.sol';
import '../interfaces/IChainlinkAggregator.sol';
import '../interfaces/ICurvePool.sol';
import {Math} from '../dependencies/openzeppelin/contracts/Math.sol';

/**
 * @dev Oracle contract for TUSDFRAXBP LP Token
 */
contract TUSDFRAXBPOracle is IOracle {
  ICurvePool private constant TUSDFRAXBP = ICurvePool(0x33baeDa08b8afACc4d3d07cf31d49FC1F1f3E893);

  IChainlinkAggregator private constant TUSD =
    IChainlinkAggregator(0x3886BA987236181D98F2401c507Fb8BeA7871dF2);
  IChainlinkAggregator private constant FRAXUSDC =
    IChainlinkAggregator(0xfE3b8248f5bFDE88233c87eE17D49143849f9f28);

  /**
   * @dev Get LP Token Price
   */
  function _get() internal view returns (uint256) {
    (, int256 tusdPrice, , , ) = TUSD.latestRoundData();
    int256 fraxusdcPrice = FRAXUSDC.latestAnswer();
    uint256 minValue = Math.min(uint256(fraxusdcPrice), uint256(tusdPrice));

    return (TUSDFRAXBP.get_virtual_price() * minValue) / 1e18;
  }

  // Get the latest exchange rate, if no valid (recent) rate is available, return false
  /// @inheritdoc IOracle
  function get() public view override returns (bool, uint256) {
    return (true, _get());
  }

  // Check the last exchange rate without any state changes
  /// @inheritdoc IOracle
  function peek() public view override returns (bool, int256) {
    return (true, int256(_get()));
  }

  // Check the current spot exchange rate without any state changes
  /// @inheritdoc IOracle
  function latestAnswer() external view override returns (int256 rate) {
    return int256(_get());
  }
}