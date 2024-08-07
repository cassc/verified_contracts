// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Alpha: Infinite Curiosity
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//                                                                                             //
//    ██████╗  █████╗ ██╗██╗  ██╗   ██╗    ██████╗  █████╗ ██╗     ██████╗ ██╗  ██╗ █████╗     //
//    ██╔══██╗██╔══██╗██║██║  ╚██╗ ██╔╝    ██╔══██╗██╔══██╗██║     ██╔══██╗██║  ██║██╔══██╗    //
//    ██║  ██║███████║██║██║   ╚████╔╝     ██████╔╝███████║██║     ██████╔╝███████║███████║    //
//    ██║  ██║██╔══██║██║██║    ╚██╔╝      ██╔══██╗██╔══██║██║     ██╔═══╝ ██╔══██║██╔══██║    //
//    ██████╔╝██║  ██║██║███████╗██║       ██║  ██║██║  ██║███████╗██║     ██║  ██║██║  ██║    //
//    ╚═════╝ ╚═╝  ╚═╝╚═╝╚══════╝╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝    //
//                                                                                             //
//                                                                                             //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract ALPHA is ERC721Creator {
    constructor() ERC721Creator("Alpha: Infinite Curiosity", "ALPHA") {}
}