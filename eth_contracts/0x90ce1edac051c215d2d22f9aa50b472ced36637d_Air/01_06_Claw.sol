// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/[email protected]/token/ERC20/ERC20.sol";
import "@openzeppelin/[email protected]/access/Ownable.sol";

contract Air is ERC20, Ownable {
    constructor() ERC20("claw", "CLAW") {
        _mint(msg.sender, 1000000000 * 10 ** decimals());
    }
}