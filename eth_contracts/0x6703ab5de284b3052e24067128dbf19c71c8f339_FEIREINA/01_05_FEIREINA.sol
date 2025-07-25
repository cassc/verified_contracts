// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Feireina's Reverie
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////
//                                                            //
//                                                            //
//    ██████╗ ███████╗██╗   ██╗███████╗██████╗ ██╗███████╗    //
//    ██╔══██╗██╔════╝██║   ██║██╔════╝██╔══██╗██║██╔════╝    //
//    ██████╔╝█████╗  ██║   ██║█████╗  ██████╔╝██║█████╗      //
//    ██╔══██╗██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗██║██╔══╝      //
//    ██║  ██║███████╗ ╚████╔╝ ███████╗██║  ██║██║███████╗    //
//    ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝    //
//                                                            //
//                                                            //
//                                                            //
////////////////////////////////////////////////////////////////


contract FEIREINA is ERC721Creator {
    constructor() ERC721Creator("Feireina's Reverie", "FEIREINA") {}
}