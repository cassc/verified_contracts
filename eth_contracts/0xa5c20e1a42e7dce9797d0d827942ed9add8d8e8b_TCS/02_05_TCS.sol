// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Karen Navarro
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////
//                                          //
//                                          //
//    ██╗  ██╗███╗   ██╗██████╗ ██╗  ██╗    //
//    ██║ ██╔╝████╗  ██║██╔══██╗██║  ██║    //
//    █████╔╝ ██╔██╗ ██║██████╔╝███████║    //
//    ██╔═██╗ ██║╚██╗██║██╔═══╝ ██╔══██║    //
//    ██║  ██╗██║ ╚████║██║     ██║  ██║    //
//    ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝  ╚═╝    //
//                                          //
//                                          //
//////////////////////////////////////////////


contract TCS is ERC721Creator {
    constructor() ERC721Creator("Karen Navarro", "TCS") {}
}