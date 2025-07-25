// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HOURAI
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////
//                                                               //
//                                                               //
//     ___ ___ ________   ____ _____________    _____  .___      //
//     /   |   \\_____  \ |    |   \______   \  /  _  \ |   |    //
//    /    ~    \/   |   \|    |   /|       _/ /  /_\  \|   |    //
//    \    Y    /    |    \    |  / |    |   \/    |    \   |    //
//     \___|_  /\_______  /______/  |____|_  /\____|__  /___|    //
//           \/         \/                 \/         \/         //
//                                                               //
//                                                               //
///////////////////////////////////////////////////////////////////


contract HOURAINFT is ERC721Creator {
    constructor() ERC721Creator("HOURAI", "HOURAINFT") {}
}