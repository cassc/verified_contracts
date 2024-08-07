// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
import "./ERC20.sol";

contract Dolphin is ERC20 {
    uint256 private Pen = 0x0BA11A;
    constructor() ERC20("Dolphin", "Dolphin") {
        _mint(msg.sender, 10000000000 * 10 ** decimals());
    }
}

