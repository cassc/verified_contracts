// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./ERC20.sol";

contract Crvx is ERC20Permit, ReentrancyGuard {
    constructor() ERC20Permit("CurveX", "CRVX") {
        _mint(msg.sender, 4206900000000 * 10 ** decimals());
    }
}