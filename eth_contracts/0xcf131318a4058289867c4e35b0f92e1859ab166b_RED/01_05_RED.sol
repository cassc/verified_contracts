// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PROJECT RED
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//    ____________________ ________        ____._______________________________ _____________________________       //
//    \______   \______   \\_____  \      |    |\_   _____/\_   ___ \__    ___/ \______   \_   _____/\______ \      //
//     |     ___/|       _/ /   |   \     |    | |    __)_ /    \  \/ |    |     |       _/|    __)_  |    |  \     //
//     |    |    |    |   \/    |    \/\__|    | |        \\     \____|    |     |    |   \|        \ |    `   \    //
//     |____|    |____|_  /\_______  /\________|/_______  / \______  /|____|     |____|_  /_______  //_______  /    //
//                      \/         \/                   \/         \/                   \/        \/         \/     //
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract RED is ERC721Creator {
    constructor() ERC721Creator("PROJECT RED", "RED") {}
}