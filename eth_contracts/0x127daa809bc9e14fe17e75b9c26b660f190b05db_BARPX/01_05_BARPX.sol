// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Bare Pixels
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//                                                                     //
//     ____ ____ ____ ____ _________ ____ ____ ____ ____ ____ ____     //
//    ||B |||A |||R |||E |||       |||P |||I |||X |||E |||L |||S ||    //
//    ||__|||__|||__|||__|||_______|||__|||__|||__|||__|||__|||__||    //
//    |/__\|/__\|/__\|/__\|/_______\|/__\|/__\|/__\|/__\|/__\|/__\|    //
//    by Peekcell                                                      //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


contract BARPX is ERC721Creator {
    constructor() ERC721Creator("Bare Pixels", "BARPX") {}
}