// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mistake Ann
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                                                                               //
//                                                                                               //
//    ███    ███ ██ ███████ ████████  █████  ██   ██ ███████      █████  ███    ██ ███    ██     //
//    ████  ████ ██ ██         ██    ██   ██ ██  ██  ██          ██   ██ ████   ██ ████   ██     //
//    ██ ████ ██ ██ ███████    ██    ███████ █████   █████       ███████ ██ ██  ██ ██ ██  ██     //
//    ██  ██  ██ ██      ██    ██    ██   ██ ██  ██  ██          ██   ██ ██  ██ ██ ██  ██ ██     //
//    ██      ██ ██ ███████    ██    ██   ██ ██   ██ ███████     ██   ██ ██   ████ ██   ████     //
//                                                                                               //
//                                                                                               //
//    Creator Anna (Mistake Ann)                                                                 //
//                                                                                               //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


contract MisAn is ERC721Creator {
    constructor() ERC721Creator("Mistake Ann", "MisAn") {}
}