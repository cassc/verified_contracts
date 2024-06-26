// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: manoMATE
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////
//                                                          //
//                                                          //
//     _____ ______   ________  ________   ________         //
//    |\   _ \  _   \|\   __  \|\   ___  \|\   __  \        //
//    \ \  \\\__\ \  \ \  \|\  \ \  \\ \  \ \  \|\  \       //
//     \ \  \\|__| \  \ \   __  \ \  \\ \  \ \  \\\  \      //
//      \ \  \    \ \  \ \  \ \  \ \  \\ \  \ \  \\\  \     //
//       \ \__\    \ \__\ \__\ \__\ \__\\ \__\ \_______\    //
//        \|__|     \|__|\|__|\|__|\|__| \|__|\|_______|    //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////


contract M2 is ERC1155Creator {
    constructor() ERC1155Creator("manoMATE", "M2") {}
}