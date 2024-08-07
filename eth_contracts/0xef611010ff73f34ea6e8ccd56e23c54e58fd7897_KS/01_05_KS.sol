// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Kill Strike
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////
//                                                                                   //
//                                                                                   //
//                                                                                   //
//     ██ ▄█▀ ██▓ ██▓     ██▓         ██████ ▄▄▄█████▓ ██▀███   ██▓ ██ ▄█▀▓█████     //
//     ██▄█▒ ▓██▒▓██▒    ▓██▒       ▒██    ▒ ▓  ██▒ ▓▒▓██ ▒ ██▒▓██▒ ██▄█▒ ▓█   ▀     //
//    ▓███▄░ ▒██▒▒██░    ▒██░       ░ ▓██▄   ▒ ▓██░ ▒░▓██ ░▄█ ▒▒██▒▓███▄░ ▒███       //
//    ▓██ █▄ ░██░▒██░    ▒██░         ▒   ██▒░ ▓██▓ ░ ▒██▀▀█▄  ░██░▓██ █▄ ▒▓█  ▄     //
//    ▒██▒ █▄░██░░██████▒░██████▒   ▒██████▒▒  ▒██▒ ░ ░██▓ ▒██▒░██░▒██▒ █▄░▒████▒    //
//    ▒ ▒▒ ▓▒░▓  ░ ▒░▓  ░░ ▒░▓  ░   ▒ ▒▓▒ ▒ ░  ▒ ░░   ░ ▒▓ ░▒▓░░▓  ▒ ▒▒ ▓▒░░ ▒░ ░    //
//    ░ ░▒ ▒░ ▒ ░░ ░ ▒  ░░ ░ ▒  ░   ░ ░▒  ░ ░    ░      ░▒ ░ ▒░ ▒ ░░ ░▒ ▒░ ░ ░  ░    //
//    ░ ░░ ░  ▒ ░  ░ ░     ░ ░      ░  ░  ░    ░        ░░   ░  ▒ ░░ ░░ ░    ░       //
//    ░  ░    ░      ░  ░    ░  ░         ░              ░      ░  ░  ░      ░  ░    //
//                                                                                   //
//                                                                                   //
//                                                                                   //
//                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////


contract KS is ERC721Creator {
    constructor() ERC721Creator("Kill Strike", "KS") {}
}