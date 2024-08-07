// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Simple Joe
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////
//                                                                                   //
//                                                                                   //
//                                                                                   //
//      ██████  ██▓ ███▄ ▄███▓ ██▓███   ██▓    ▓█████     ▄▄▄██▀▀▀▒█████  ▓█████     //
//    ▒██    ▒ ▓██▒▓██▒▀█▀ ██▒▓██░  ██▒▓██▒    ▓█   ▀       ▒██  ▒██▒  ██▒▓█   ▀     //
//    ░ ▓██▄   ▒██▒▓██    ▓██░▓██░ ██▓▒▒██░    ▒███         ░██  ▒██░  ██▒▒███       //
//      ▒   ██▒░██░▒██    ▒██ ▒██▄█▓▒ ▒▒██░    ▒▓█  ▄    ▓██▄██▓ ▒██   ██░▒▓█  ▄     //
//    ▒██████▒▒░██░▒██▒   ░██▒▒██▒ ░  ░░██████▒░▒████▒    ▓███▒  ░ ████▓▒░░▒████▒    //
//    ▒ ▒▓▒ ▒ ░░▓  ░ ▒░   ░  ░▒▓▒░ ░  ░░ ▒░▓  ░░░ ▒░ ░    ▒▓▒▒░  ░ ▒░▒░▒░ ░░ ▒░ ░    //
//    ░ ░▒  ░ ░ ▒ ░░  ░      ░░▒ ░     ░ ░ ▒  ░ ░ ░  ░    ▒ ░▒░    ░ ▒ ▒░  ░ ░  ░    //
//    ░  ░  ░   ▒ ░░      ░   ░░         ░ ░      ░       ░ ░ ░  ░ ░ ░ ▒     ░       //
//          ░   ░         ░                ░  ░   ░  ░    ░   ░      ░ ░     ░  ░    //
//                                                                                   //
//                                                                                   //
//                                                                                   //
//                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////


contract SJ is ERC721Creator {
    constructor() ERC721Creator("Simple Joe", "SJ") {}
}