// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: WEIRD-ONE
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//     /$$      /$$ /$$$$$$$$ /$$$$$$ /$$$$$$$  /$$$$$$$           /$$$$$$  /$$   /$$ /$$$$$$$$    //
//    | $$  /$ | $$| $$_____/|_  $$_/| $$__  $$| $$__  $$         /$$__  $$| $$$ | $$| $$_____/    //
//    | $$ /$$$| $$| $$        | $$  | $$  \ $$| $$  \ $$        | $$  \ $$| $$$$| $$| $$          //
//    | $$/$$ $$ $$| $$$$$     | $$  | $$$$$$$/| $$  | $$ /$$$$$$| $$  | $$| $$ $$ $$| $$$$$       //
//    | $$$$_  $$$$| $$__/     | $$  | $$__  $$| $$  | $$|______/| $$  | $$| $$  $$$$| $$__/       //
//    | $$$/ \  $$$| $$        | $$  | $$  \ $$| $$  | $$        | $$  | $$| $$\  $$$| $$          //
//    | $$/   \  $$| $$$$$$$$ /$$$$$$| $$  | $$| $$$$$$$/        |  $$$$$$/| $$ \  $$| $$$$$$$$    //
//    |__/     \__/|________/|______/|__/  |__/|_______/          \______/ |__/  \__/|________/    //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract WO is ERC1155Creator {
    constructor() ERC1155Creator("WEIRD-ONE", "WO") {}
}