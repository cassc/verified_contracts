// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Water Seed
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
//                                                                                                        //
//     __      __  _____________________________________    _______________________________________       //
//    /  \    /  \/  _  \__    ___/\_   _____/\______   \  /   _____/\_   _____/\_   _____/\______ \      //
//    \   \/\/   /  /_\  \|    |    |    __)_  |       _/  \_____  \  |    __)_  |    __)_  |    |  \     //
//     \        /    |    \    |    |        \ |    |   \  /        \ |        \ |        \ |    `   \    //
//      \__/\  /\____|__  /____|   /_______  / |____|_  / /_______  //_______  //_______  //_______  /    //
//           \/         \/                 \/         \/          \/         \/         \/         \/     //
//                                                                                                        //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract WSEED is ERC721Creator {
    constructor() ERC721Creator("Water Seed", "WSEED") {}
}