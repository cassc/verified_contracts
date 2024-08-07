// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Valérie Biet
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                                                                                         //
//    __/\\\________/\\\_________________/\\\\\\\\\\\\\________________________            //
//     _\/\\\_______\/\\\________________\/\\\/////////\\\______________________           //
//      _\//\\\______/\\\_________________\/\\\_______\/\\\__/\\\________________          //
//       __\//\\\____/\\\____/\\\\\\\\\____\/\\\\\\\\\\\\\\__\///______/\\\\\\\\__         //
//        ___\//\\\__/\\\____\////////\\\___\/\\\/////////\\\__/\\\___/\\\/////\\\_        //
//         ____\//\\\/\\\_______/\\\\\\\\\\__\/\\\_______\/\\\_\/\\\__/\\\\\\\\\\\__       //
//          _____\//\\\\\_______/\\\/////\\\__\/\\\_______\/\\\_\/\\\_\//\\///////___      //
//           ______\//\\\_______\//\\\\\\\\/\\_\/\\\\\\\\\\\\\/__\/\\\__\//\\\\\\\\\\_     //
//            _______\///_________\////////\//__\/////////////____\///____\//////////__    //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract VB is ERC721Creator {
    constructor() ERC721Creator(unicode"Valérie Biet", "VB") {}
}