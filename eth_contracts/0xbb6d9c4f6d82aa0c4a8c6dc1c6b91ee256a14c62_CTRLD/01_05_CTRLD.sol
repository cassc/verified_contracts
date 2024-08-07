// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Central District
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                               //
//                                                                                                                               //
//                                                                                                                               //
//     ██████╗███████╗███╗   ██╗████████╗██████╗  █████╗ ██╗         ██████╗ ██╗███████╗████████╗██████╗ ██╗ ██████╗████████╗    //
//    ██╔════╝██╔════╝████╗  ██║╚══██╔══╝██╔══██╗██╔══██╗██║         ██╔══██╗██║██╔════╝╚══██╔══╝██╔══██╗██║██╔════╝╚══██╔══╝    //
//    ██║     █████╗  ██╔██╗ ██║   ██║   ██████╔╝███████║██║         ██║  ██║██║███████╗   ██║   ██████╔╝██║██║        ██║       //
//    ██║     ██╔══╝  ██║╚██╗██║   ██║   ██╔══██╗██╔══██║██║         ██║  ██║██║╚════██║   ██║   ██╔══██╗██║██║        ██║       //
//    ╚██████╗███████╗██║ ╚████║   ██║   ██║  ██║██║  ██║███████╗    ██████╔╝██║███████║   ██║   ██║  ██║██║╚██████╗   ██║       //
//     ╚═════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝    ╚═════╝ ╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝ ╚═════╝   ╚═╝       //
//                                                                                                                               //
//                                                                                                                               //
//                                                                                                                               //
//                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CTRLD is ERC721Creator {
    constructor() ERC721Creator("Central District", "CTRLD") {}
}