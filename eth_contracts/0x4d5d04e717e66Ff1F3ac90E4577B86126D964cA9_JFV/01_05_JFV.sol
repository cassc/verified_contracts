// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: J FRIENDS VAULT
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                              //
//                                                                                              //
//        ___          ________ ________  ___  _______   ________   ________  ________          //
//       |\  \        |\  _____\\   __  \|\  \|\  ___ \ |\   ___  \|\   ___ \|\   ____\         //
//       \ \  \       \ \  \__/\ \  \|\  \ \  \ \   __/|\ \  \\ \  \ \  \_|\ \ \  \___|_        //
//     __ \ \  \       \ \   __\\ \   _  _\ \  \ \  \_|/_\ \  \\ \  \ \  \ \\ \ \_____  \       //
//    |\  \\_\  \       \ \  \_| \ \  \\  \\ \  \ \  \_|\ \ \  \\ \  \ \  \_\\ \|____|\  \      //
//    \ \________\       \ \__\   \ \__\\ _\\ \__\ \_______\ \__\\ \__\ \_______\____\_\  \     //
//     \|________|        \|__|    \|__|\|__|\|__|\|_______|\|__| \|__|\|_______|\_________\    //
//                                                                              \|_________|    //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////


contract JFV is ERC1155Creator {
    constructor() ERC1155Creator("J FRIENDS VAULT", "JFV") {}
}