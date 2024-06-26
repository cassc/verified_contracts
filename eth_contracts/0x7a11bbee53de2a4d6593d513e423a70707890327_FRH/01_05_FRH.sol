// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: FAKERAREHEADLINES
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//     ▄▄▄        ▄████  ██▀███   ██▓ ███▄ ▄███▓ ▒█████   ███▄    █▓██   ██▓    //
//    ▒████▄     ██▒ ▀█▒▓██ ▒ ██▒▓██▒▓██▒▀█▀ ██▒▒██▒  ██▒ ██ ▀█   █ ▒██  ██▒    //
//    ▒██  ▀█▄  ▒██░▄▄▄░▓██ ░▄█ ▒▒██▒▓██    ▓██░▒██░  ██▒▓██  ▀█ ██▒ ▒██ ██░    //
//    ░██▄▄▄▄██ ░▓█  ██▓▒██▀▀█▄  ░██░▒██    ▒██ ▒██   ██░▓██▒  ▐▌██▒ ░ ▐██▓░    //
//     ▓█   ▓██▒░▒▓███▀▒░██▓ ▒██▒░██░▒██▒   ░██▒░ ████▓▒░▒██░   ▓██░ ░ ██▒▓░    //
//     ▒▒   ▓▒█░ ░▒   ▒ ░ ▒▓ ░▒▓░░▓  ░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒   ██▒▒▒     //
//      ▒   ▒▒ ░  ░   ░   ░▒ ░ ▒░ ▒ ░░  ░      ░  ░ ▒ ▒░ ░ ░░   ░ ▒░▓██ ░▒░     //
//      ░   ▒   ░ ░   ░   ░░   ░  ▒ ░░      ░   ░ ░ ░ ▒     ░   ░ ░ ▒ ▒ ░░      //
//          ░  ░      ░    ░      ░         ░       ░ ░           ░ ░ ░         //
//                                                                  ░ ░         //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract FRH is ERC721Creator {
    constructor() ERC721Creator("FAKERAREHEADLINES", "FRH") {}
}