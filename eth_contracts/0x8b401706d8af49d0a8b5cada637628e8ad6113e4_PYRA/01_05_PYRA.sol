// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Pyramid Brain
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//     /$$$$$$$ /$$     /$$/$$$$$$$  /$$$$$$ /$$      /$$/$$$$$$/$$$$$$$        /$$$$$$$ /$$$$$$$  /$$$$$$ /$$$$$$/$$   /$$    //
//    | $$__  $|  $$   /$$| $$__  $$/$$__  $| $$$    /$$|_  $$_| $$__  $$      | $$__  $| $$__  $$/$$__  $|_  $$_| $$$ | $$    //
//    | $$  \ $$\  $$ /$$/| $$  \ $| $$  \ $| $$$$  /$$$$ | $$ | $$  \ $$      | $$  \ $| $$  \ $| $$  \ $$ | $$ | $$$$| $$    //
//    | $$$$$$$/ \  $$$$/ | $$$$$$$| $$$$$$$| $$ $$/$$ $$ | $$ | $$  | $$      | $$$$$$$| $$$$$$$| $$$$$$$$ | $$ | $$ $$ $$    //
//    | $$____/   \  $$/  | $$__  $| $$__  $| $$  $$$| $$ | $$ | $$  | $$      | $$__  $| $$__  $| $$__  $$ | $$ | $$  $$$$    //
//    | $$         | $$   | $$  \ $| $$  | $| $$\  $ | $$ | $$ | $$  | $$      | $$  \ $| $$  \ $| $$  | $$ | $$ | $$\  $$$    //
//    | $$         | $$   | $$  | $| $$  | $| $$ \/  | $$/$$$$$| $$$$$$$/      | $$$$$$$| $$  | $| $$  | $$/$$$$$| $$ \  $$    //
//    |__/         |__/   |__/  |__|__/  |__|__/     |__|______|_______/       |_______/|__/  |__|__/  |__|______|__/  \__/    //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PYRA is ERC721Creator {
    constructor() ERC721Creator("Pyramid Brain", "PYRA") {}
}