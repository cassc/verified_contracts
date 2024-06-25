// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IPancakePair.sol";
import "./IPancakeFactory.sol";
import "./PancakeLibrary.sol";
import "./Ownable.sol";

contract PairPrice is PancakeLibrary, Ownable {

    uint256 internal constant default_price_tolerance = 50; // 5%

    uint256 internal priceTolerance;

    constructor(address _auth) Ownable(_auth) {
        priceTolerance = default_price_tolerance;
    }

    function setPriceTolerance(uint256 tolerance) external onlyOwner {
        priceTolerance = tolerance;
    }

    function getPriceTolerance() external view returns (uint256 tolerance) {
        tolerance = priceTolerance;
    }

    function cumulateMUTAmountOut(uint256 USDTAmountIn) external view returns (uint256 res) {
        address pairAddress = IPancakeFactory(auth.getPancakeFactory()).getPair(auth.getUSDTToken(), auth.getFarmToken());
        (
            uint112 reserve0, 
            uint112 reserve1, 
        ) = IPancakePair(pairAddress).getReserves();
        res = getAmountOut(USDTAmountIn, reserve1, reserve0);
    }

    function cumulateUSDTAmountOut(uint256 MUTAmountIn) external view returns (uint256 res) {
        address pairAddress = IPancakeFactory(auth.getPancakeFactory()).getPair(auth.getUSDTToken(), auth.getFarmToken());
        (
            uint112 reserve0, 
            uint112 reserve1, 
        ) = IPancakePair(pairAddress).getReserves();
        res = getAmountOut(MUTAmountIn, reserve0, reserve1);
    }

    function cumulateUTOAmountIn(uint256 USDTAmountOut) external view returns (uint256 res) {
        address pairAddress = IPancakeFactory(auth.getPancakeFactory()).getPair(auth.getUSDTToken(), auth.getFarmToken());
        (
            uint112 reserve0, 
            uint112 reserve1, 
        ) = IPancakePair(pairAddress).getReserves();
        res = getAmountIn(USDTAmountOut, reserve0, reserve1);
    }

    function cumulateUSDTAmountIn(uint256 UTOAmountOut) external view returns (uint256 res) {
        address pairAddress = IPancakeFactory(auth.getPancakeFactory()).getPair(auth.getUSDTToken(), auth.getFarmToken());
        (
            uint112 reserve0, 
            uint112 reserve1, 
        ) = IPancakePair(pairAddress).getReserves();
        res = getAmountIn(UTOAmountOut, reserve1, reserve0);
    }
}