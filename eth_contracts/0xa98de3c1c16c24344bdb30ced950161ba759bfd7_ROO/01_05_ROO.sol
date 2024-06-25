// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: RooRoo
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////
//                             //
//                             //
//    🌟 A joyful Artist 🌟    //
//                             //
//                             //
//                             //
//                             //
/////////////////////////////////


contract ROO is ERC1155Creator {
    constructor() ERC1155Creator("RooRoo", "ROO") {}
}