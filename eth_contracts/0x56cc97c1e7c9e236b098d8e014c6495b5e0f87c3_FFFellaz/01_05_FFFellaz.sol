// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Front Facing Fellaz
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@                                   @@@@@                                   @@    //
//    @@                                   @@@@@                                   @@    //
//    @@                                   @@@@@                                   @@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@                               %@@@@@@@@                                @@@@@    //
//    @@                               %@@@@@@@@                                @@@@@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@             @@@@@@@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@          @@           @@    @@@@@@@@    @@@@@@@@@@@     ,@@@@@            @@    //
//    @@   (@@@@@@@@    @@@@@@@@@    @@@@@@@@    @@@@@@@@@@   *    @@@@@@@@@@    @@@@    //
//    @@         &@@          @@@    @@@@@@@@    @@@@@@@@@   /@@    @@@@@@&    @@@@@@    //
//    @@   (@@@@@@@@    @@@@@@@@@    @@@@@@@@    @@@@@@@@            @@@(    @@@@@@@@    //
//    @@   (@@@@@@@@           @@          @@          @   *@@@@@@    @            @@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract FFFellaz is ERC721Creator {
    constructor() ERC721Creator("Front Facing Fellaz", "FFFellaz") {}
}