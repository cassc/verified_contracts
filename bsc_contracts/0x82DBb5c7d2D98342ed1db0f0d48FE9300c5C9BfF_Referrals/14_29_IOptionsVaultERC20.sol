// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity >=0.8.13;
import "./Interfaces.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IOptionsVaultERC20 {
  function DEFAULT_ADMIN_ROLE (  ) external view returns ( bytes32 );
  function VAULT_BUYERWHITELIST_ROLE (  ) external view returns ( bytes32 );
  function VAULT_LPWHITELIST_ROLE (  ) external view returns ( bytes32 );
  function VAULT_OPERATOR_ROLE (  ) external view returns ( bytes32 );
  function allowance ( address owner, address spender ) external view returns ( uint256 );
  function approve ( address spender, uint256 amount ) external returns ( bool );
  function balanceOf ( address account ) external view returns ( uint256 );
  function buyerWhitelistOnly (  ) external view returns ( IStructs.BoolState );
  function collateralReserves (  ) external view returns ( uint256 );
  function collateralToken (  ) external view returns ( IERC20 );
  function decimals (  ) external view returns ( IStructs.BoolState );
  function decreaseAllowance ( address spender, uint256 subtractedValue ) external returns ( bool );
  function factory (  ) external view returns ( address );
  function getRoleAdmin ( bytes32 role ) external view returns ( bytes32 );
  function grantRole ( bytes32 role, address account ) external;
  function hasRole ( bytes32 role, address account ) external view returns ( bool );
  function hasRoleVaultOwner ( address _account ) external view returns ( bool );
  function hasRoleVaultOwnerOrOperator ( address _account ) external view returns ( bool );
  function increaseAllowance ( address spender, uint256 addedValue ) external returns ( bool );
  function initialize ( address _owner, IOracle _oracle, IERC20 _collateralToken, IFeeCalcs _vaultFeeCalc, uint256 _vaultId ) external;
  function ipfsHash (  ) external view returns ( string memory );
  function isInTradingWindow (  ) external view returns ( bool );
  function isInTransferWindow (  ) external view returns ( bool );
  function isOptionValid ( address _buyer, uint256 _period, uint256 _optionSize, IOracle _oracle, uint256 collectedPremium ) external view returns ( bool );
  function lock ( uint256 _optionId, uint256 _optionSize, IStructs.OptionType _optionType ) external;
  function lockedCollateral ( uint256 ) external view returns ( bool );
  function lockedCollateralCall (  ) external view returns ( uint256 );
  function lockedCollateralPut (  ) external view returns ( uint256 );
  function lpOpenToPublic (  ) external view returns ( IStructs.BoolState );
  function maxInvest (  ) external view returns ( uint256 );
  function name (  ) external view returns ( string memory );
  function nextTransferWindowStartTime (  ) external view returns ( uint256 );
  function oracleEnabled ( address ) external view returns ( bool );
  function oracleEnabledLocked (  ) external view returns ( IStructs.BoolState );
  function provide ( uint256 _collateralIn ) external returns ( uint256 mintTokens );
  function provideAndMint ( uint256 _collateralIn, bool _mintVaultTokens, bool _collectedWithPremium ) external returns ( uint256 mintTokens );
  function readOnly (  ) external view returns ( bool );
  function renounceRole ( bytes32 role, address account ) external;
  function revokeRole ( bytes32 role, address account ) external;
  function send ( uint256 _optionId, address _to, uint256 _amount ) external;
  function setBuyerWhitelistOnly ( bool _value ) external;
  function setBuyerWhitelistOnlyImmutable (  ) external;
  function setIpfsHash ( string calldata _value ) external;
  function setLPOpenToPublicTrueImmutable (  ) external;
  function setMaxInvest ( uint256 _value ) external;
  function setOracleEnabled ( address _oracle, bool _value ) external;
  function setOracleEnabledLockedImmutable (  ) external;
  function setReadOnly ( bool _value ) external;
  function setVaultFee ( uint256 _value ) external;
  function setVaultFeeCalc ( address _value ) external;
  function setVaultFeeCalcLocked ( bool _value ) external;
  function setVaultFeeCalcLockedImmutable (  ) external;
  function setVaultFeeRecipient ( address _value ) external;
  function setWindowParams ( uint256 _tradingWindow, uint256 _transferWindow, uint256 _transferWindowStartTime ) external;
  function supportsInterface ( bytes4 interfaceId ) external view returns ( bool );
  function symbol (  ) external view returns ( string memory );
  function totalSupply (  ) external view returns ( uint256 );
  function tradingWindow (  ) external view returns ( uint256 );
  function transfer ( address to, uint256 amount ) external returns ( bool );
  function transferFrom ( address from, address to, uint256 amount ) external returns ( bool );
  function transferWindow (  ) external view returns ( uint256 );
  function transferWindowStartTime (  ) external view returns ( uint256 );
  function unlock ( uint256 _optionId ) external;
  function vaultCollateralAvailable (  ) external view returns ( uint256 );
  function vaultCollateralLocked (  ) external view returns ( uint256 );
  function vaultCollateralTotal (  ) external view returns ( uint256 );
  function vaultFee (  ) external view returns ( uint256 );
  function vaultFeeCalc (  ) external view returns ( IFeeCalcs );
  function vaultFeeCalcLocked (  ) external view returns ( IStructs.BoolState );
  function vaultFeeRecipient (  ) external view returns ( address );
  function vaultId (  ) external view returns ( uint256 );
  function vaultUtilization ( uint256 _includingOptionSize ) external view returns ( uint256 );
  function withdraw ( uint256 _tokensToBurn ) external returns ( uint256 collateralOut );
}