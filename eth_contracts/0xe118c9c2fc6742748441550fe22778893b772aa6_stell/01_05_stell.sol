// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Stellabelle
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
//     _______ _________ _______  _        _        _______  ______   _______  _        _        _______     //
//    (  ____ \\__   __/(  ____ \( \      ( \      (  ___  )(  ___ \ (  ____ \( \      ( \      (  ____ \    //
//    | (    \/   ) (   | (    \/| (      | (      | (   ) || (   ) )| (    \/| (      | (      | (    \/    //
//    | (_____    | |   | (__    | |      | |      | (___) || (__/ / | (__    | |      | |      | (__        //
//    (_____  )   | |   |  __)   | |      | |      |  ___  ||  __ (  |  __)   | |      | |      |  __)       //
//          ) |   | |   | (      | |      | |      | (   ) || (  \ \ | (      | |      | |      | (          //
//    /\____) |   | |   | (____/\| (____/\| (____/\| )   ( || )___) )| (____/\| (____/\| (____/\| (____/\    //
//    \_______)   )_(   (_______/(_______/(_______/|/     \||/ \___/ (_______/(_______/(_______/(_______/    //
//                                                                                                           //
//                                                                                                           //
//    sǝdɐɔsǝ ǝuo ou ssǝuᴉddɐɥ ǝɥʇ ⅎo sǝdɐɥs ɔᴉƃɐɯ ǝɥʇ pǝɥɔɹɐǝsǝɹ ǝʌɐɥ ᴉ                                     //
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract stell is ERC721Creator {
    constructor() ERC721Creator("Stellabelle", "stell") {}
}