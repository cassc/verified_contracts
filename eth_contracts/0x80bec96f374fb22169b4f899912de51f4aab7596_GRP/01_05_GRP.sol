// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Romain GANDRÉ
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                            //
//                                                                                                                            //
//                                                                                                                            //
//      ▄████  ██▀███      ██▓███   ██░ ██  ▒█████  ▄▄▄█████▓ ▒█████    ▄████  ██▀███   ▄▄▄       ██▓███   ██░ ██▓██   ██▓    //
//     ██▒ ▀█▒▓██ ▒ ██▒   ▓██░  ██▒▓██░ ██▒▒██▒  ██▒▓  ██▒ ▓▒▒██▒  ██▒ ██▒ ▀█▒▓██ ▒ ██▒▒████▄    ▓██░  ██▒▓██░ ██▒▒██  ██▒    //
//    ▒██░▄▄▄░▓██ ░▄█ ▒   ▓██░ ██▓▒▒██▀▀██░▒██░  ██▒▒ ▓██░ ▒░▒██░  ██▒▒██░▄▄▄░▓██ ░▄█ ▒▒██  ▀█▄  ▓██░ ██▓▒▒██▀▀██░ ▒██ ██░    //
//    ░▓█  ██▓▒██▀▀█▄     ▒██▄█▓▒ ▒░▓█ ░██ ▒██   ██░░ ▓██▓ ░ ▒██   ██░░▓█  ██▓▒██▀▀█▄  ░██▄▄▄▄██ ▒██▄█▓▒ ▒░▓█ ░██  ░ ▐██▓░    //
//    ░▒▓███▀▒░██▓ ▒██▒   ▒██▒ ░  ░░▓█▒░██▓░ ████▓▒░  ▒██▒ ░ ░ ████▓▒░░▒▓███▀▒░██▓ ▒██▒ ▓█   ▓██▒▒██▒ ░  ░░▓█▒░██▓ ░ ██▒▓░    //
//     ░▒   ▒ ░ ▒▓ ░▒▓░   ▒▓▒░ ░  ░ ▒ ░░▒░▒░ ▒░▒░▒░   ▒ ░░   ░ ▒░▒░▒░  ░▒   ▒ ░ ▒▓ ░▒▓░ ▒▒   ▓▒█░▒▓▒░ ░  ░ ▒ ░░▒░▒  ██▒▒▒     //
//      ░   ░   ░▒ ░ ▒░   ░▒ ░      ▒ ░▒░ ░  ░ ▒ ▒░     ░      ░ ▒ ▒░   ░   ░   ░▒ ░ ▒░  ▒   ▒▒ ░░▒ ░      ▒ ░▒░ ░▓██ ░▒░     //
//    ░ ░   ░   ░░   ░    ░░        ░  ░░ ░░ ░ ░ ▒    ░      ░ ░ ░ ▒  ░ ░   ░   ░░   ░   ░   ▒   ░░        ░  ░░ ░▒ ▒ ░░      //
//          ░    ░                  ░  ░  ░    ░ ░               ░ ░        ░    ░           ░  ░          ░  ░  ░░ ░         //
//                                                                                                                ░ ░         //
//                                                                                                                            //
//                                                                                                                            //
//                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract GRP is ERC721Creator {
    constructor() ERC721Creator(unicode"Romain GANDRÉ", "GRP") {}
}