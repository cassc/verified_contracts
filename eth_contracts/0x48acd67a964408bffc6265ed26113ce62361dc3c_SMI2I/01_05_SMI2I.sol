// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sean Murphy I2I
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                             //
//                                                                                                                                                             //
//     ________  _______   ________  ________           _____ ______   ___  ___  ________  ________  ___  ___      ___    ___      ___    _______  ___         //
//    |\   ____\|\  ___ \ |\   __  \|\   ___  \        |\   _ \  _   \|\  \|\  \|\   __  \|\   __  \|\  \|\  \    |\  \  /  /|    |\  \  /  ___  \|\  \        //
//    \ \  \___|\ \   __/|\ \  \|\  \ \  \\ \  \       \ \  \\\__\ \  \ \  \\\  \ \  \|\  \ \  \|\  \ \  \\\  \   \ \  \/  / /    \ \  \/__/|_/  /\ \  \       //
//     \ \_____  \ \  \_|/_\ \   __  \ \  \\ \  \       \ \  \\|__| \  \ \  \\\  \ \   _  _\ \   ____\ \   __  \   \ \    / /      \ \  \__|//  / /\ \  \      //
//      \|____|\  \ \  \_|\ \ \  \ \  \ \  \\ \  \       \ \  \    \ \  \ \  \\\  \ \  \\  \\ \  \___|\ \  \ \  \   \/  /  /        \ \  \  /  /_/__\ \  \     //
//        ____\_\  \ \_______\ \__\ \__\ \__\\ \__\       \ \__\    \ \__\ \_______\ \__\\ _\\ \__\    \ \__\ \__\__/  / /           \ \__\|\________\ \__\    //
//       |\_________\|_______|\|__|\|__|\|__| \|__|        \|__|     \|__|\|_______|\|__|\|__|\|__|     \|__|\|__|\___/ /             \|__| \|_______|\|__|    //
//       \|_________|                                                                                            \|___|/                                       //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SMI2I is ERC721Creator {
    constructor() ERC721Creator("Sean Murphy I2I", "SMI2I") {}
}