// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Death Of Didi
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                             //
//                                                                                                                             //
//     ________  _______   ________  _________  ___  ___          ________  ________      ________  ___  ________  ___         //
//    |\   ___ \|\  ___ \ |\   __  \|\___   ___\\  \|\  \        |\   __  \|\  _____\    |\   ___ \|\  \|\   ___ \|\  \        //
//    \ \  \_|\ \ \   __/|\ \  \|\  \|___ \  \_\ \  \\\  \       \ \  \|\  \ \  \__/     \ \  \_|\ \ \  \ \  \_|\ \ \  \       //
//     \ \  \ \\ \ \  \_|/_\ \   __  \   \ \  \ \ \   __  \       \ \  \\\  \ \   __\     \ \  \ \\ \ \  \ \  \ \\ \ \  \      //
//      \ \  \_\\ \ \  \_|\ \ \  \ \  \   \ \  \ \ \  \ \  \       \ \  \\\  \ \  \_|      \ \  \_\\ \ \  \ \  \_\\ \ \  \     //
//       \ \_______\ \_______\ \__\ \__\   \ \__\ \ \__\ \__\       \ \_______\ \__\        \ \_______\ \__\ \_______\ \__\    //
//        \|_______|\|_______|\|__|\|__|    \|__|  \|__|\|__|        \|_______|\|__|         \|_______|\|__|\|_______|\|__|    //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DOD is ERC721Creator {
    constructor() ERC721Creator("Death Of Didi", "DOD") {}
}