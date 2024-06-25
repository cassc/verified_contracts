// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/[email protected]/token/ERC20/ERC20.sol";

contract EinsteinCrypto is ERC20 {
    constructor() ERC20("EinsteinCrypto", "E=MC2") {
        _mint(msg.sender, 100000000000 * 10 ** decimals());
    }
}