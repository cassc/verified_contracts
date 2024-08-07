// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PURE_ART
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//    ██████  ██    ██ ██████  ███████          █████  ██████  ████████        //
//    ██   ██ ██    ██ ██   ██ ██              ██   ██ ██   ██    ██           //
//    ██████  ██    ██ ██████  █████           ███████ ██████     ██           //
//    ██      ██    ██ ██   ██ ██              ██   ██ ██   ██    ██           //
//    ██       ██████  ██   ██ ███████ ███████ ██   ██ ██   ██    ██           //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//    https://twitter.com/QBiosphere                                           //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract PART is ERC721Creator {
    constructor() ERC721Creator("PURE_ART", "PART") {}
}