// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DALL-E Monsters
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////
//                                          //
//                                          //
//    ─────────▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄─────────    //
//    ───────▄▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀▄───────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒███▒▒▒▒▒▒▒▒███▒▒▒▌──────    //
//    ▄▄────▐▒▒▒███▒▒▒▒▒▒▒▒███▒▒▒▌────▄▄    //
//    ▌▒▀▄──▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──▄▀▒▐    //
//    ▌▒▒▒▀▄█▒▒▒▄▀▄▄▀▀▄▄▀▀▄▄▀▄▒▒▒█▄▀▒▒▒▐    //
//    ▀▄▒▒▒▒▐▒▒▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▌▒▒▒▒▄▀    //
//    ──▀▄▒▒▐▒▒▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▌▒▒▄▀──    //
//    ────▀▄▐▒▒▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▒▌▄▀────    //
//    ──────█▒▒▐▄▀▄▀▀▄▄▀▀▄▄▀▀▄▌▒▒█──────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▌──────    //
//    ──────▐▒▒▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▓▓▄▀▀▄▓▓▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▌──▐▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▌──▐▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▌──▐▒▒▒▒▒▒▒▒▌──────    //
//    ──────▐▒▒▒▒▒▒▒▒▌──▐▒▒▒▒▒▒▒▒▌──────    //
//    ───────▀▀▀▀▀▀▀▀────▀▀▀▀▀▀▀▀───────    //
//                                          //
//                                          //
//////////////////////////////////////////////


contract DMON is ERC721Creator {
    constructor() ERC721Creator("DALL-E Monsters", "DMON") {}
}