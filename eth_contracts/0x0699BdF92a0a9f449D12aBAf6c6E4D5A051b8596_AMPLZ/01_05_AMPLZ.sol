// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 2AM Plaza
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//                                                                               //
//    ██████╗  █████╗ ███╗   ███╗    ██████╗ ██╗      █████╗ ███████╗ █████╗     //
//    ╚════██╗██╔══██╗████╗ ████║    ██╔══██╗██║     ██╔══██╗╚══███╔╝██╔══██╗    //
//     █████╔╝███████║██╔████╔██║    ██████╔╝██║     ███████║  ███╔╝ ███████║    //
//    ██╔═══╝ ██╔══██║██║╚██╔╝██║    ██╔═══╝ ██║     ██╔══██║ ███╔╝  ██╔══██║    //
//    ███████╗██║  ██║██║ ╚═╝ ██║    ██║     ███████╗██║  ██║███████╗██║  ██║    //
//    ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝    ╚═╝     ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝    //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract AMPLZ is ERC1155Creator {
    constructor() ERC1155Creator("2AM Plaza", "AMPLZ") {}
}