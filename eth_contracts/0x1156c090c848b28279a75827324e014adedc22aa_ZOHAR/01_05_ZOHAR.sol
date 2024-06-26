// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Hafftka - Zohar Works
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//                                                                  //
//     ██░ ██  ▄▄▄        █████▒ █████▒▄▄▄█████▓ ██ ▄█▀▄▄▄          //
//    ▓██░ ██▒▒████▄    ▓██   ▒▓██   ▒ ▓  ██▒ ▓▒ ██▄█▒▒████▄        //
//    ▒██▀▀██░▒██  ▀█▄  ▒████ ░▒████ ░ ▒ ▓██░ ▒░▓███▄░▒██  ▀█▄      //
//    ░▓█ ░██ ░██▄▄▄▄██ ░▓█▒  ░░▓█▒  ░ ░ ▓██▓ ░ ▓██ █▄░██▄▄▄▄██     //
//    ░▓█▒░██▓ ▓█   ▓██▒░▒█░   ░▒█░      ▒██▒ ░ ▒██▒ █▄▓█   ▓██▒    //
//     ▒ ░░▒░▒ ▒▒   ▓▒█░ ▒ ░    ▒ ░      ▒ ░░   ▒ ▒▒ ▓▒▒▒   ▓▒█░    //
//     ▒ ░▒░ ░  ▒   ▒▒ ░ ░      ░          ░    ░ ░▒ ▒░ ▒   ▒▒ ░    //
//     ░  ░░ ░  ░   ▒    ░ ░    ░ ░      ░      ░ ░░ ░  ░   ▒       //
//     ░  ░  ░      ░  ░                        ░  ░        ░  ░    //
//                                                                  //
//                                                                  //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract ZOHAR is ERC721Creator {
    constructor() ERC721Creator("Hafftka - Zohar Works", "ZOHAR") {}
}