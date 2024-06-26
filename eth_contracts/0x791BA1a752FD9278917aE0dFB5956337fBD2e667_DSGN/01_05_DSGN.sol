// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DESIGNED IN CALIFORNIA
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
//                                                                                                        //
//    ▓▀▀▄ ▓▀▀▀ ▄▀▀▀▄ ▓ ▄▀▀▄ ▓▄  ▓ ▓▀▀▀ ▓▀▀▄   ▓ ▓▄  ▓   ▄▀▀▄ ▄▀▀▄ ▓    ▓ ▓▀▀▀ ▄▀▀▀▄ ▓▀▀▄ ▓▄  ▓ ▓ ▄▀▀▄    //
//    ▓  ▓ ▓▀▀▀ ▀▀▀▄▄ ▓ ▓ ▄▄ ▓ ▓ ▓ ▓▀▀▀ ▓  ▓   ▓ ▓ ▓ ▓   ▓    ▓▄▄▓ ▓    ▓ ▓▀▀  ▓   ▓ ▓▄▄▀ ▓ ▓ ▓ ▓ ▓▄▄▓    //
//    ▓▄▄▀ ▓▄▄▄ ▀▄▄▄▀ ▓ ▀▄▄▀ ▓  ▀▓ ▓▄▄▄ ▓▄▄▀   ▓ ▓  ▀▓   ▀▄▄▀ ▓  ▓ ▓▄▄▄ ▓ ▓    ▀▄▄▄▀ ▓  ▓ ▓  ▀▓ ▓ ▓  ▓    //
//                                                                                                        //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DSGN is ERC721Creator {
    constructor() ERC721Creator("DESIGNED IN CALIFORNIA", "DSGN") {}
}