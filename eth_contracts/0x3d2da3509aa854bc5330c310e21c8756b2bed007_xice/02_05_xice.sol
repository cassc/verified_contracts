// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ice
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//     ______                     __                                                   //
//    |      \                   |  \                                                  //
//     \$$$$$$ _______   ______  | $$____    ______    ______    ______   __    __     //
//      | $$  /       \ /      \ | $$    \  /      \  /      \  /      \ |  \  |  \    //
//      | $$ |  $$$$$$$|  $$$$$$\| $$$$$$$\|  $$$$$$\|  $$$$$$\|  $$$$$$\| $$  | $$    //
//      | $$ | $$      | $$    $$| $$  | $$| $$    $$| $$   \$$| $$  | $$| $$  | $$    //
//     _| $$_| $$_____ | $$$$$$$$| $$__/ $$| $$$$$$$$| $$      | $$__| $$| $$__/ $$    //
//    |   $$ \\$$     \ \$$     \| $$    $$ \$$     \| $$       \$$    $$ \$$    $$    //
//     \$$$$$$ \$$$$$$$  \$$$$$$$ \$$$$$$$   \$$$$$$$ \$$       _\$$$$$$$ _\$$$$$$$    //
//                                                             |  \__| $$|  \__| $$    //
//                                                              \$$    $$ \$$    $$    //
//                                                               \$$$$$$   \$$$$$$     //
//            / \                                                                      //
//        __/    \_                                                                    //
//       /_  -  \  \                      ,:',:`,:'                                    //
//      / / /     \ \                  __||_||_||_||___                                //
//     |    |     / |             ____[""""""""""""""""]___                            //
//     /   /     \   \            \ " '''''''''''''''''''' \                           //
//     ~~^~^~HZ~~^~^~^~~^~^~^~~jgs~^~^~^^~^~^~^~^~^~^~^~~^~^~^~^~~^~^                  //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract xice is ERC721Creator {
    constructor() ERC721Creator("ice", "xice") {}
}