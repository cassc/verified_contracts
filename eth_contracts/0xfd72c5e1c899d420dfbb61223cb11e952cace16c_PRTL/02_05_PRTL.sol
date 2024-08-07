// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: THE PORTAL
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//                                                                         //
//     ________  ________  ________  _________  ________  ___              //
//    |\   __  \|\   __  \|\   __  \|\___   ___\\   __  \|\  \             //
//    \ \  \|\  \ \  \|\  \ \  \|\  \|___ \  \_\ \  \|\  \ \  \            //
//     \ \   ____\ \  \\\  \ \   _  _\   \ \  \ \ \   __  \ \  \           //
//      \ \  \___|\ \  \\\  \ \  \\  \|   \ \  \ \ \  \ \  \ \  \____      //
//       \ \__\    \ \_______\ \__\\ _\    \ \__\ \ \__\ \__\ \_______\    //
//        \|__|     \|_______|\|__|\|__|    \|__|  \|__|\|__|\|_______|    //
//                                                                         //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////


contract PRTL is ERC1155Creator {
    constructor() ERC1155Creator() {}
}