// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: goldcat
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////
//                                                       //
//                                                       //
//                                                       //
//                   .__       .___             __       //
//       ____   ____ |  |    __| _/____ _____ _/  |_     //
//      / ___\ /  _ \|  |   / __ |/ ___\\__  \\   __\    //
//     / /_/  >  <_> )  |__/ /_/ \  \___ / __ \|  |      //
//     \___  / \____/|____/\____ |\___  >____  /__|      //
//    /_____/                   \/    \/     \/          //
//                                                       //
//                                                       //
//                                                       //
///////////////////////////////////////////////////////////


contract gc is ERC721Creator {
    constructor() ERC721Creator("goldcat", "gc") {}
}