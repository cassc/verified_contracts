// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: IMPULSIVEDECISION
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////
//                                      //
//                                      //
//    ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣶⣶⣶⣶⣶⣶⣤⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀    //
//    ⠀⠀⠀⠀⠀⢀⣠⣾⣿⠿⠛⠋⠉⠀⣼⣇⠀⠉⠙⠛⠿⣿⣶⣄⠀⠀⠀⠀⠀⠀    //
//    ⠀⠀⠀⢀⣴⣿⠟⠉⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠙⠿⣿⣦⡀⠀⠀⠀    //
//    ⠀⠀⣠⣾⡟⠁⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⡄⠀⠀    //
//    ⠀⣰⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⣆⠀    //
//    ⢠⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡄    //
//    ⣾⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣧    //
//    ⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿    //
//    ⣿⡇⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀⠀⢸⣿    //
//    ⣿⣷⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⠿⠟⠻⠿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⣿⡟    //
//    ⠸⣿⣆⠀⢀⣴⣿⣿⡿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠉⠛⠻⢿⣿⣿⣦⡀⠀⣰⣿⠃    //
//    ⠀⢻⣿⣶⠿⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠛⠿⣶⣿⠏⠀    //
//    ⠀⠀⠹⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⠏⠀⠀    //
//    ⠀⠀⠀⠙⢿⣷⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣰⣿⡿⠁⠀⠀⠀    //
//    ⠀⠀⠀⠀⠀⠉⠻⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣶⣿⠟⠁⠀⠀⠀⠀⠀    //
//    ⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⡿⢿⣿⣶⣶⣿⡿⠿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀    //
//                                      //
//                                      //
//////////////////////////////////////////


contract IMPULSIVEDECISION is ERC1155Creator {
    constructor() ERC1155Creator("IMPULSIVEDECISION", "IMPULSIVEDECISION") {}
}