// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: INKED
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////
//                                                            //
//                                                            //
//                                                            //
//       ________   _______  ____ ___   _______   ______      //
//      ╱        ╲╱╱   ╱   ╲╱    ╱   ╲╱╱       ╲_╱      ╲╲    //
//     _╱       ╱╱╱        ╱         ╱╱        ╱        ╱╱    //
//    ╱         ╱         ╱╱       _╱        _╱         ╱     //
//    ╲╲_______╱╲__╱_____╱╲╲___╱___╱╲________╱╲________╱      //
//                                                            //
//                                                            //
//                                                            //
////////////////////////////////////////////////////////////////


contract INK is ERC721Creator {
    constructor() ERC721Creator("INKED", "INK") {}
}