// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Skellies
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//     ________  ___  __    _______   ___       ___       ___  _______   ________          //
//    |\   ____\|\  \|\  \ |\  ___ \ |\  \     |\  \     |\  \|\  ___ \ |\   ____\         //
//    \ \  \___|\ \  \/  /|\ \   __/|\ \  \    \ \  \    \ \  \ \   __/|\ \  \___|_        //
//     \ \_____  \ \   ___  \ \  \_|/_\ \  \    \ \  \    \ \  \ \  \_|/_\ \_____  \       //
//      \|____|\  \ \  \\ \  \ \  \_|\ \ \  \____\ \  \____\ \  \ \  \_|\ \|____|\  \      //
//        ____\_\  \ \__\\ \__\ \_______\ \_______\ \_______\ \__\ \_______\____\_\  \     //
//       |\_________\|__| \|__|\|_______|\|_______|\|_______|\|__|\|_______|\_________\    //
//       \|_________|                                                      \|_________|    //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract SKL is ERC721Creator {
    constructor() ERC721Creator("Skellies", "SKL") {}
}