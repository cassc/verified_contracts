// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: chaze 1/1's
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//     ▄████▄   ██░ ██  ▄▄▄      ▒███████▒▓█████     //
//    ▒██▀ ▀█  ▓██░ ██▒▒████▄    ▒ ▒ ▒ ▄▀░▓█   ▀     //
//    ▒▓█    ▄ ▒██▀▀██░▒██  ▀█▄  ░ ▒ ▄▀▒░ ▒███       //
//    ▒▓▓▄ ▄██▒░▓█ ░██ ░██▄▄▄▄██   ▄▀▒   ░▒▓█  ▄     //
//    ▒ ▓███▀ ░░▓█▒░██▓ ▓█   ▓██▒▒███████▒░▒████▒    //
//    ░ ░▒ ▒  ░ ▒ ░░▒░▒ ▒▒   ▓▒█░░▒▒ ▓░▒░▒░░ ▒░ ░    //
//      ░  ▒    ▒ ░▒░ ░  ▒   ▒▒ ░░░▒ ▒ ░ ▒ ░ ░  ░    //
//    ░         ░  ░░ ░  ░   ▒   ░ ░ ░ ░ ░   ░       //
//    ░ ░       ░  ░  ░      ░  ░  ░ ░       ░  ░    //
//    ░                          ░                   //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract chaze is ERC721Creator {
    constructor() ERC721Creator("chaze 1/1's", "chaze") {}
}