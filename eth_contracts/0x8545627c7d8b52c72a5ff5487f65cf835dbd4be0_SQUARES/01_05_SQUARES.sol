// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Squares by Godwits
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
//                                                                                    //
//     ________  ________  ___  ___  ________  ________  _______   ________           //
//    |\   ____\|\   __  \|\  \|\  \|\   __  \|\   __  \|\  ___ \ |\   ____\          //
//    \ \  \___|\ \  \|\  \ \  \\\  \ \  \|\  \ \  \|\  \ \   __/|\ \  \___|_         //
//     \ \_____  \ \  \\\  \ \  \\\  \ \   __  \ \   _  _\ \  \_|/_\ \_____  \        //
//      \|____|\  \ \  \\\  \ \  \\\  \ \  \ \  \ \  \\  \\ \  \_|\ \|____|\  \       //
//        ____\_\  \ \_____  \ \_______\ \__\ \__\ \__\\ _\\ \_______\____\_\  \      //
//       |\_________\|___| \__\|_______|\|__|\|__|\|__|\|__|\|_______|\_________\     //
//       \|_________|     \|__|                                      \|_________|     //
//                                                                                    //
//                                                                                    //
//     ________      ___    ___                                                       //
//    |\   __  \    |\  \  /  /|                                                      //
//    \ \  \|\ /_   \ \  \/  / /                                                      //
//     \ \   __  \   \ \    / /                                                       //
//      \ \  \|\  \   \/  /  /                                                        //
//       \ \_______\__/  / /                                                          //
//        \|_______|\___/ /                                                           //
//                 \|___|/                                                            //
//                                                                                    //
//                                                                                    //
//     ________  ________  ________  ___       __   ___  _________  ________          //
//    |\   ____\|\   __  \|\   ___ \|\  \     |\  \|\  \|\___   ___\\   ____\         //
//    \ \  \___|\ \  \|\  \ \  \_|\ \ \  \    \ \  \ \  \|___ \  \_\ \  \___|_        //
//     \ \  \  __\ \  \\\  \ \  \ \\ \ \  \  __\ \  \ \  \   \ \  \ \ \_____  \       //
//      \ \  \|\  \ \  \\\  \ \  \_\\ \ \  \|\__\_\  \ \  \   \ \  \ \|____|\  \      //
//       \ \_______\ \_______\ \_______\ \____________\ \__\   \ \__\  ____\_\  \     //
//        \|_______|\|_______|\|_______|\|____________|\|__|    \|__| |\_________\    //
//                                                                    \|_________|    //
//                                                                                    //
//                                                                                    //
//                                                                                    //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////


contract SQUARES is ERC721Creator {
    constructor() ERC721Creator("Squares by Godwits", "SQUARES") {}
}