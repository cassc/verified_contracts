// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import '@openzeppelin/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol';

contract GeckoGoldCoin is ERC20PresetMinterPauser {
    constructor() ERC20PresetMinterPauser("GeckoGoldCoin", "GGC") {}
}