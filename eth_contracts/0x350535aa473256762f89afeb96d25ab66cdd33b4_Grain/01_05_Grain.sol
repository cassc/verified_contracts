// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ingrained
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                                                                                         //
//    _________ _        _______  _______  _______ _________ _        _______  ______      //
//    \__   __/( (    /|(  ____ \(  ____ )(  ___  )\__   __/( (    /|(  ____ \(  __  \     //
//       ) (   |  \  ( || (    \/| (    )|| (   ) |   ) (   |  \  ( || (    \/| (  \  )    //
//       | |   |   \ | || |      | (____)|| (___) |   | |   |   \ | || (__    | |   ) |    //
//       | |   | (\ \) || | ____ |     __)|  ___  |   | |   | (\ \) ||  __)   | |   | |    //
//       | |   | | \   || | \_  )| (\ (   | (   ) |   | |   | | \   || (      | |   ) |    //
//    ___) (___| )  \  || (___) || ) \ \__| )   ( |___) (___| )  \  || (____/\| (__/  )    //
//    \_______/|/    )_)(_______)|/   \__/|/     \|\_______/|/    )_)(_______/(______/     //
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract Grain is ERC721Creator {
    constructor() ERC721Creator("Ingrained", "Grain") {}
}