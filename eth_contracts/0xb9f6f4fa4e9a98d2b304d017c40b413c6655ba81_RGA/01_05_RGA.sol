// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: RohanGanapathyArt
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                //
//                                                                                                                                                //
//                                                                                                                                                //
//    .#####....####...##..##...####...##..##...####....####...##..##...####...#####....####...######..##..##..##..##...####...#####...######.    //
//    .##..##..##..##..##..##..##..##..###.##..##......##..##..###.##..##..##..##..##..##..##....##....##..##...####...##..##..##..##....##...    //
//    .#####...##..##..######..######..##.###..##.###..######..##.###..######..#####...######....##....######....##....######..#####.....##...    //
//    .##..##..##..##..##..##..##..##..##..##..##..##..##..##..##..##..##..##..##......##..##....##....##..##....##....##..##..##..##....##...    //
//    .##..##...####...##..##..##..##..##..##...####...##..##..##..##..##..##..##......##..##....##....##..##....##....##..##..##..##....##...    //
//    ........................................................................................................................................    //
//                                                                                                                                                //
//                                                                                                                                                //
//                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract RGA is ERC1155Creator {
    constructor() ERC1155Creator("RohanGanapathyArt", "RGA") {}
}