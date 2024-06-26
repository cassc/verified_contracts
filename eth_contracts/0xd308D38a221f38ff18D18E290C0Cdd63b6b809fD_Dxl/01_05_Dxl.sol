// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dxl Editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////
//                                                          //
//                                                          //
//                                                          //
//    ──────────────────────────────────────────────────    //
//    ─████████████───████████──████████─██████─────────    //
//    ─██░░░░░░░░████─██░░░░██──██░░░░██─██░░██─────────    //
//    ─██░░████░░░░██─████░░██──██░░████─██░░██─────────    //
//    ─██░░██──██░░██───██░░░░██░░░░██───██░░██─────────    //
//    ─██░░██──██░░██───████░░░░░░████───██░░██─────────    //
//    ─██░░██──██░░██─────██░░░░░░██─────██░░██─────────    //
//    ─██░░██──██░░██───████░░░░░░████───██░░██─────────    //
//    ─██░░██──██░░██───██░░░░██░░░░██───██░░██─────────    //
//    ─██░░████░░░░██─████░░██──██░░████─██░░██████████─    //
//    ─██░░░░░░░░████─██░░░░██──██░░░░██─██░░░░░░░░░░██─    //
//    ─████████████───████████──████████─██████████████─    //
//    ──────────────────────────────────────────────────    //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////


contract Dxl is ERC1155Creator {
    constructor() ERC1155Creator("Dxl Editions", "Dxl") {}
}