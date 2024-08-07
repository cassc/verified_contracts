// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: FIGHT
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////
//                                                       //
//                                                       //
//    COLLAB RELEASE OF @BONGDOE AND @UNDERSCORE_XO      //
//                                                       //
//     ________ ___  ________  ___  ___  _________       //
//    |\  _____\\  \|\   ____\|\  \|\  \|\___   ___\     //
//    \ \  \__/\ \  \ \  \___|\ \  \\\  \|___ \  \_|     //
//     \ \   __\\ \  \ \  \  __\ \   __  \   \ \  \      //
//      \ \  \_| \ \  \ \  \|\  \ \  \ \  \   \ \  \     //
//       \ \__\   \ \__\ \_______\ \__\ \__\   \ \__\    //
//        \|__|    \|__|\|_______|\|__|\|__|    \|__|    //
//                                                       //
//                                                       //
///////////////////////////////////////////////////////////


contract FIGHT is ERC1155Creator {
    constructor() ERC1155Creator("FIGHT", "FIGHT") {}
}