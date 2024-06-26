// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: SLVNART Creations
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////
//                                                      //
//                                                      //
//                                                      //
//    .▄▄ · ▄▄▌   ▌ ▐· ▐ ▄  ▄▄▄· ▄▄▄  ▄▄▄▄▄             //
//    ▐█ ▀. ██•  ▪█·█▌•█▌▐█▐█ ▀█ ▀▄ █·•██               //
//    ▄▀▀▀█▄██▪  ▐█▐█•▐█▐▐▌▄█▀▀█ ▐▀▀▄  ▐█.▪             //
//    ▐█▄▪▐█▐█▌▐▌ ███ ██▐█▌▐█ ▪▐▌▐█•█▌ ▐█▌·             //
//     ▀▀▀▀ .▀▀▀ . ▀  ▀▀ █▪ ▀  ▀ .▀  ▀ ▀▀▀              //
//     ▄▄· ▄▄▄  ▄▄▄ . ▄▄▄· ▄▄▄▄▄▪         ▐ ▄ .▄▄ ·     //
//    ▐█ ▌▪▀▄ █·▀▄.▀·▐█ ▀█ •██  ██ ▪     •█▌▐█▐█ ▀.     //
//    ██ ▄▄▐▀▀▄ ▐▀▀▪▄▄█▀▀█  ▐█.▪▐█· ▄█▀▄ ▐█▐▐▌▄▀▀▀█▄    //
//    ▐███▌▐█•█▌▐█▄▄▌▐█ ▪▐▌ ▐█▌·▐█▌▐█▌.▐▌██▐█▌▐█▄▪▐█    //
//    ·▀▀▀ .▀  ▀ ▀▀▀  ▀  ▀  ▀▀▀ ▀▀▀ ▀█▄▀▪▀▀ █▪ ▀▀▀▀     //
//                                                      //
//                                                      //
//                                                      //
//////////////////////////////////////////////////////////


contract SLVNC is ERC721Creator {
    constructor() ERC721Creator("SLVNART Creations", "SLVNC") {}
}