// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract SimpleToken is Ownable, ERC20 {
    uint256 private constant INITIAL_SUPPLY = 8040000000 * 10 ** 18;

    constructor() ERC20("Planet 74", "PLA74") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}