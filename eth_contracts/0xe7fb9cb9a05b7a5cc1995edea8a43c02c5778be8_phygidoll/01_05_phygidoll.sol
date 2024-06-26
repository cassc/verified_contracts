// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: phygidoll
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//                                                                              //
//    ██████  ██   ██ ██    ██  ██████  ██ ██████   ██████  ██      ██          //
//    ██   ██ ██   ██  ██  ██  ██       ██ ██   ██ ██    ██ ██      ██          //
//    ██████  ███████   ████   ██   ███ ██ ██   ██ ██    ██ ██      ██          //
//    ██      ██   ██    ██    ██    ██ ██ ██   ██ ██    ██ ██      ██          //
//    ██      ██   ██    ██     ██████  ██ ██████   ██████  ███████ ███████     //
//                                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract phygidoll is ERC721Creator {
    constructor() ERC721Creator("phygidoll", "phygidoll") {}
}