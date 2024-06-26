// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Changes
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//                                                                  //
//    ░█████╗░██╗░░██╗░█████╗░███╗░░██╗░██████╗░███████╗░██████╗    //
//    ██╔══██╗██║░░██║██╔══██╗████╗░██║██╔════╝░██╔════╝██╔════╝    //
//    ██║░░╚═╝███████║███████║██╔██╗██║██║░░██╗░█████╗░░╚█████╗░    //
//    ██║░░██╗██╔══██║██╔══██║██║╚████║██║░░╚██╗██╔══╝░░░╚═══██╗    //
//    ╚█████╔╝██║░░██║██║░░██║██║░╚███║╚██████╔╝███████╗██████╔╝    //
//    ░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚══╝░╚═════╝░╚══════╝╚═════╝░    //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract CHANGES is ERC1155Creator {
    constructor() ERC1155Creator("Changes", "CHANGES") {}
}