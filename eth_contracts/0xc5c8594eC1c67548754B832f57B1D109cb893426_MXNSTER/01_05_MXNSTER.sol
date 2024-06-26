// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mxnsters
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//                                                                              //
//    ███    ███ ██   ██ ███    ██ ███████ ████████ ███████ ██████  ███████     //
//    ████  ████  ██ ██  ████   ██ ██         ██    ██      ██   ██ ██          //
//    ██ ████ ██   ███   ██ ██  ██ ███████    ██    █████   ██████  ███████     //
//    ██  ██  ██  ██ ██  ██  ██ ██      ██    ██    ██      ██   ██      ██     //
//    ██      ██ ██   ██ ██   ████ ███████    ██    ███████ ██   ██ ███████     //
//                                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract MXNSTER is ERC721Creator {
    constructor() ERC721Creator("Mxnsters", "MXNSTER") {}
}