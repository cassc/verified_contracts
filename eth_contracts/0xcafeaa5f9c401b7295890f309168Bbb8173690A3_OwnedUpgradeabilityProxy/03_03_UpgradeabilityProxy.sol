// SPDX-License-Identifier: GPL-3.0-only

pragma solidity ^0.8.18;

import "./Proxy.sol";

/**
 * @title UpgradeabilityProxy
 * @dev This contract represents a proxy where the implementation address to which it will delegate can be upgraded
 */
contract UpgradeabilityProxy is Proxy {
  /**
  * @dev This event will be emitted every time the implementation gets upgraded
  * @param implementation representing the address of the upgraded implementation
  */
  event Upgraded(address indexed implementation);

  // Storage position of the address of the current implementation
  bytes32 private constant IMPLEMENTATION_POSITION = keccak256("org.govblocks.proxy.implementation");

  /**
  * @dev Constructor function
  */
  // solhint-disable-next-line no-empty-blocks
  constructor() {}

  /**
  * @dev Tells the address of the current implementation
  * @return impl - address of the current implementation
  */
  function implementation() public override view returns (address impl) {
    bytes32 position = IMPLEMENTATION_POSITION;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      impl := sload(position)
    }
  }

  /**
  * @dev Sets the address of the current implementation
  * @param _newImplementation address representing the new implementation to be set
  */
  function _setImplementation(address _newImplementation) internal {
    bytes32 position = IMPLEMENTATION_POSITION;
    // solhint-disable-next-line no-inline-assembly
    assembly {
      sstore(position, _newImplementation)
    }
  }

  /**
  * @dev Upgrades the implementation address
  * @param _newImplementation representing the address of the new implementation to be set
  */
  function _upgradeTo(address _newImplementation) internal {
    address currentImplementation = implementation();
    require(currentImplementation != _newImplementation);
    _setImplementation(_newImplementation);
    emit Upgraded(_newImplementation);
  }
}