// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';


/// @notice Library to help safely transfer tokens and handle ETH wrapping and unwrapping of WETH
library TransferHelper {
  using SafeERC20 for IERC20;

  /// @notice Internal function used for standard ERC20 transferFrom method
  /// @notice it contains a pre and post balance check
  /// @notice as well as a check on the msg.senders balance
  /// @param token is the address of the ERC20 being transferred
  /// @param from is the remitting address
  /// @param to is the location where they are being delivered
  function transferTokens(
    address token,
    address from,
    address to,
    uint256 amount
  ) internal {
    uint256 priorBalance = IERC20(token).balanceOf(address(to));
    require(IERC20(token).balanceOf(from) >= amount, 'THL01');
    SafeERC20.safeTransferFrom(IERC20(token), from, to, amount);
    uint256 postBalance = IERC20(token).balanceOf(address(to));
    require(postBalance - priorBalance == amount, 'THL02');
  }

  /// @notice Internal function is used with standard ERC20 transfer method
  /// @notice this function ensures that the amount received is the amount sent with pre and post balance checking
  /// @param token is the ERC20 contract address that is being transferred
  /// @param to is the address of the recipient
  /// @param amount is the amount of tokens that are being transferred
  function withdrawTokens(
    address token,
    address to,
    uint256 amount
  ) internal {
    uint256 priorBalance = IERC20(token).balanceOf(address(to));
    SafeERC20.safeTransfer(IERC20(token), to, amount);
    uint256 postBalance = IERC20(token).balanceOf(address(to));
    require(postBalance - priorBalance == amount, 'THL02');
  }

}