// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Kami's Editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////
//                                                  //
//                                                  //
//                                                  //
//    ██╗  ██╗ █████╗ ███╗   ███╗██╗    ███████╗    //
//    ██║ ██╔╝██╔══██╗████╗ ████║██║    ██╔════╝    //
//    █████╔╝ ███████║██╔████╔██║██║    █████╗      //
//    ██╔═██╗ ██╔══██║██║╚██╔╝██║██║    ██╔══╝      //
//    ██║  ██╗██║  ██║██║ ╚═╝ ██║██║    ███████╗    //
//    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚═╝    ╚══════╝    //
//                                                  //
//                                                  //
//                                                  //
//                                                  //
//////////////////////////////////////////////////////


contract KamiE is ERC1155Creator {
    constructor() ERC1155Creator("Kami's Editions", "KamiE") {}
}