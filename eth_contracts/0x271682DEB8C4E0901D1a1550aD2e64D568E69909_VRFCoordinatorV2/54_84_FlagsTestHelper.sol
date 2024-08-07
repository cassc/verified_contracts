// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../Flags.sol";

contract FlagsTestHelper {
  Flags public flags;

  constructor(address flagsContract) {
    flags = Flags(flagsContract);
  }

  function getFlag(address subject) external view returns (bool) {
    return flags.getFlag(subject);
  }

  function getFlags(address[] calldata subjects) external view returns (bool[] memory) {
    return flags.getFlags(subjects);
  }
}