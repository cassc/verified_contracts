// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Pixels
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////
//                                      //
//                                      //
//                                      //
//    ▓▒▒▓▒▒▒▒▓▒▓▓▓▓▓▒▒▒▓▓▒▓▓▒▓▒▓▒▓▒    //
//    ▒▒▓▓▓▓▒▓▓▓▓▒▒▒▓▒▓▒▒▓▓▒▒▒▓▒▒▓▒▓    //
//    ▓▒▓▒▓▓▓▒▒▓▓▒▓▒▓▓▒▒▒▓▒▓▓▒▓▒▒▓▒▒    //
//    ▒▓▒▒▒▒▓▓▒▒▓▓▓▓▒▓▒▓▒▒▒▓▒▓▒▓▒▓▒▒    //
//    ▒▓▓▓▓▓▒▒▒▒▓▓▓▓▓▒▒▒▓▒▒▓▒▒▒▓▒▒▓▓    //
//    ▓▒▒▒▓▓▒▓▒▒▓▓▓▒▒▓▒▓▓▒▓▓▒▓▒▓▓▒▓▒    //
//    ▓▒▓▓▒▓▓▒▒▓   PIXELS   ▓▒▒▓▓▓▒▓    //
//    ▓▒▓▒Where Digital Art Began▓▒▒    //
//    ▒▒▒▒                       ▓▒▒    //
//    ▓▓▓▒▒▓▒▒▒▒▒▓▒▒▓▓▓▓▒▓▓▒▒▒▓▒▒▓▓▓    //
//    ▒▓▒▓▒▒▓▓▒▒▒▒▓▒▒▓▒▒▓▒▒▓▒▒▓▒▓▓▒▒    //
//    ▒▓▒▒▒▓▒▓▓▒▓▒▒▒▒▓▒▓▓▒▒▓▒▒▓▒▓▒▓▓    //
//    ▓▓▒▓▒▒▓▒▒▒▒▓▓▓▓▒▒▒▓▒▓▓▓▓▒▓▓▓▒▓    //
//    ▓▒▒▓▒▒▒▒▓▓▓▓▓▓▒▒▓▓▒▒▓▒▓▒▒▒▓▓▒▓    //
//    ▒▓▓▒▓▓▒▒▒▓▓▓▓▒▒▓▓▒▒▓▓▒▓▓▓▒▓▓▓▓    //
//                                      //
//                                      //
//////////////////////////////////////////


contract PIXEL is ERC721Creator {
    constructor() ERC721Creator("Pixels", "PIXEL") {}
}