// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./ITokenController.sol";

/// @title Controlled ERC20 Token
/// @notice ERC20 Tokens with a controller for minting & burning
interface IControlledToken is IERC20 {

  /// @notice Interface to the contract responsible for controlling mint/burn
  function controller() external view returns (ITokenController);

  /// @notice Allows the controller to mint tokens for a user account
  /// @dev May be overridden to provide more granular control over minting
  /// @param _user Address of the receiver of the minted tokens
  /// @param _amount Amount of tokens to mint
  function controllerMint(address _user, uint256 _amount) external;

  /// @notice Allows the controller to burn tokens from a user account
  /// @dev May be overridden to provide more granular control over burning
  /// @param _user Address of the holder account to burn tokens from
  /// @param _amount Amount of tokens to burn
  function controllerBurn(address _user, uint256 _amount) external;

  /// @notice Allows an operator via the controller to burn tokens on behalf of a user account
  /// @dev May be overridden to provide more granular control over operator-burning
  /// @param _operator Address of the operator performing the burn action via the controller contract
  /// @param _user Address of the holder account to burn tokens from
  /// @param _amount Amount of tokens to burn
  function controllerBurnFrom(address _operator, address _user, uint256 _amount) external;
}