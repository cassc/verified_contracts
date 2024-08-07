// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Magic Mork
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //
//                                                                                  //
//     ███▄ ▄███▓▄▄▄       ▄████ ██▓▄████▄      ███▄ ▄███▓▒█████  ██▀███  ██ ▄█▀    //
//    ▓██▒▀█▀ ██▒████▄    ██▒ ▀█▓██▒██▀ ▀█     ▓██▒▀█▀ ██▒██▒  ██▓██ ▒ ██▒██▄█▒     //
//    ▓██    ▓██▒██  ▀█▄ ▒██░▄▄▄▒██▒▓█    ▄    ▓██    ▓██▒██░  ██▓██ ░▄█ ▓███▄░     //
//    ▒██    ▒██░██▄▄▄▄██░▓█  ██░██▒▓▓▄ ▄██▒   ▒██    ▒██▒██   ██▒██▀▀█▄ ▓██ █▄     //
//    ▒██▒   ░██▒▓█   ▓██░▒▓███▀░██▒ ▓███▀ ░   ▒██▒   ░██░ ████▓▒░██▓ ▒██▒██▒ █▄    //
//    ░ ▒░   ░  ░▒▒   ▓▒█░░▒   ▒░▓ ░ ░▒ ▒  ░   ░ ▒░   ░  ░ ▒░▒░▒░░ ▒▓ ░▒▓▒ ▒▒ ▓▒    //
//    ░  ░      ░ ▒   ▒▒ ░ ░   ░ ▒ ░ ░  ▒      ░  ░      ░ ░ ▒ ▒░  ░▒ ░ ▒░ ░▒ ▒░    //
//    ░      ░    ░   ▒  ░ ░   ░ ▒ ░           ░      ░  ░ ░ ░ ▒   ░░   ░░ ░░ ░     //
//           ░        ░  ░     ░ ░ ░ ░                ░      ░ ░    ░    ░  ░       //
//                                 ░                                                //
//                                                                                  //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////


contract MM is ERC1155Creator {
    constructor() ERC1155Creator("Magic Mork", "MM") {}
}