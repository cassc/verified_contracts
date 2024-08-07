// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ARTWOLF
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////
//                                              //
//                                              //
//                                              //
//    ░██╗░░░░░░░██╗░█████╗░██╗░░░░░███████╗    //
//    ░██║░░██╗░░██║██╔══██╗██║░░░░░██╔════╝    //
//    ░╚██╗████╗██╔╝██║░░██║██║░░░░░█████╗░░    //
//    ░░████╔═████║░██║░░██║██║░░░░░██╔══╝░░    //
//    ░░╚██╔╝░╚██╔╝░╚█████╔╝███████╗██║░░░░░    //
//    ░░░╚═╝░░░╚═╝░░░╚════╝░╚══════╝╚═╝░░░░░    //
//                                              //
//                                              //
//////////////////////////////////////////////////


contract WOLF is ERC721Creator {
    constructor() ERC721Creator("ARTWOLF", "WOLF") {}
}