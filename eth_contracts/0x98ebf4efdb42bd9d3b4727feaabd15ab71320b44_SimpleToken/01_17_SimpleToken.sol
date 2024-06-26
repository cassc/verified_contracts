// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity 0.8.11;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract SimpleToken is ERC20, Ownable {
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _supply
    ) ERC20(_name, _symbol) {
        _mint(msg.sender, _supply);
    }
}