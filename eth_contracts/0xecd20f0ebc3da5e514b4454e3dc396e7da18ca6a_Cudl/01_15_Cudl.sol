pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol";

contract Cudl is ERC20PresetMinterPauser("CUDL", "CUDL") {}