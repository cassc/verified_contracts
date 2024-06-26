// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: the_cult_verse
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                      //
//                                                                                                                                                                      //
//     _____ ______    ________   ________   ________   ___  ___   _______    ________          ________   ___      ___    ___  _______    ___        ________          //
//    |\   _ \  _   \ |\   __  \ |\   __  \ |\   ____\ |\  \|\  \ |\  ___ \  |\   __  \        |\   __  \ |\  \    |\  \  /  /||\  ___ \  |\  \      |\   ____\         //
//    \ \  \\\__\ \  \\ \  \|\  \\ \  \|\  \\ \  \___|_\ \  \\\  \\ \   __/| \ \  \|\  \       \ \  \|\  \\ \  \   \ \  \/  / /\ \   __/| \ \  \     \ \  \___|_        //
//     \ \  \\|__| \  \\ \  \\\  \\ \  \\\  \\ \_____  \\ \   __  \\ \  \_|/__\ \   _  _\       \ \   ____\\ \  \   \ \    / /  \ \  \_|/__\ \  \     \ \_____  \       //
//      \ \  \    \ \  \\ \  \\\  \\ \  \\\  \\|____|\  \\ \  \ \  \\ \  \_|\ \\ \  \\  \|       \ \  \___| \ \  \   /     \/    \ \  \_|\ \\ \  \____ \|____|\  \      //
//       \ \__\    \ \__\\ \_______\\ \_______\ ____\_\  \\ \__\ \__\\ \_______\\ \__\\ _\        \ \__\     \ \__\ /  /\   \     \ \_______\\ \_______\ ____\_\  \     //
//        \|__|     \|__| \|_______| \|_______||\_________\\|__|\|__| \|_______| \|__|\|__|        \|__|      \|__|/__/ /\ __\     \|_______| \|_______||\_________\    //
//                                             \|_________|                                                        |__|/ \|__|                          \|_________|    //
//                                                                                                                                                                      //
//                                                                                                                                                                      //
//                                                                                                                                                                      //
//                                                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CULTVERSE is ERC1155Creator {
    constructor() ERC1155Creator("the_cult_verse", "CULTVERSE") {}
}