// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: WAW x Amber Vittoria
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                             //
//                                                                                                                                             //
//     ___       __   ________  ___       __      ___    ___ ___      ___ ___  _________  _________  ________  ________  ___  ________         //
//    |\  \     |\  \|\   __  \|\  \     |\  \   |\  \  /  /|\  \    /  /|\  \|\___   ___\\___   ___\\   __  \|\   __  \|\  \|\   __  \        //
//    \ \  \    \ \  \ \  \|\  \ \  \    \ \  \  \ \  \/  / | \  \  /  / | \  \|___ \  \_\|___ \  \_\ \  \|\  \ \  \|\  \ \  \ \  \|\  \       //
//     \ \  \  __\ \  \ \   __  \ \  \  __\ \  \  \ \    / / \ \  \/  / / \ \  \   \ \  \     \ \  \ \ \  \\\  \ \   _  _\ \  \ \   __  \      //
//      \ \  \|\__\_\  \ \  \ \  \ \  \|\__\_\  \  /     \/   \ \    / /   \ \  \   \ \  \     \ \  \ \ \  \\\  \ \  \\  \\ \  \ \  \ \  \     //
//       \ \____________\ \__\ \__\ \____________\/  /\   \    \ \__/ /     \ \__\   \ \__\     \ \__\ \ \_______\ \__\\ _\\ \__\ \__\ \__\    //
//        \|____________|\|__|\|__|\|____________/__/ /\ __\    \|__|/       \|__|    \|__|      \|__|  \|_______|\|__|\|__|\|__|\|__|\|__|    //
//                                               |__|/ \|__|                                                                                   //
//                                                                                                                                             //
//                                                                                                                                             //
//                                                                                                                                             //
//                                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract WAWxAV is ERC1155Creator {
    constructor() ERC1155Creator("WAW x Amber Vittoria", "WAWxAV") {}
}