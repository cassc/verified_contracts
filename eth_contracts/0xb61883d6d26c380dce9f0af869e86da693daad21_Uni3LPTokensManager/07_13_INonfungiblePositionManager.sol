// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.6;

interface INonfungiblePositionManager {
  function factory() external returns (address);

  function ownerOf(uint256 tokenId) external view returns (address);

  function positions(uint256 tokenId)
    external
    view
    returns (
      uint96 nonce,
      address operator,
      address token0,
      address token1,
      uint24 fee,
      int24 tickLower,
      int24 tickUpper,
      uint128 liquidity,
      uint256 feeGrowthInside0LastX128,
      uint256 feeGrowthInside1LastX128,
      uint128 tokensOwed0,
      uint128 tokensOwed1
    );

  struct MintParams {
    address token0;
    address token1;
    uint24 fee;
    int24 tickLower;
    int24 tickUpper;
    uint256 amount0Desired;
    uint256 amount1Desired;
    uint256 amount0Min;
    uint256 amount1Min;
    address recipient;
    uint256 deadline;
  }

  function mint(MintParams calldata params)
    external
    payable
    returns (
      uint256 tokenId,
      uint128 liquidity,
      uint256 amount0,
      uint256 amount1
    );

  struct IncreaseLiquidityParams {
    uint256 tokenId;
    uint256 amount0Desired;
    uint256 amount1Desired;
    uint256 amount0Min;
    uint256 amount1Min;
    uint256 deadline;
  }

  function increaseLiquidity(IncreaseLiquidityParams calldata params)
    external
    payable
    returns (
      uint128 liquidity,
      uint256 amount0,
      uint256 amount1
    );

  struct DecreaseLiquidityParams {
    uint256 tokenId;
    uint128 liquidity;
    uint256 amount0Min;
    uint256 amount1Min;
    uint256 deadline;
  }

  function decreaseLiquidity(DecreaseLiquidityParams calldata params)
    external
    payable
    returns (uint256 amount0, uint256 amount1);

  struct CollectParams {
    uint256 tokenId;
    address recipient;
    uint128 amount0Max;
    uint128 amount1Max;
  }

  function collect(CollectParams calldata params) external payable returns (uint256 amount0, uint256 amount1);

  function burn(uint256 tokenId) external payable;

  function approve(address to, uint256 tokenId) external;

  function safeTransferFrom(
    address from,
    address to,
    uint256 tokenId
  ) external;

  function name() external view returns (string memory);

  function createAndInitializePoolIfNecessary(
    address token0,
    address token1,
    uint24 fee,
    uint160 sqrtPriceX96
  ) external payable returns (address);
}