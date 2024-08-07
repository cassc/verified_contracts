// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Darkness Within (Editions)
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ..####...#####...######...####...##..##..##..##...........####....####...##..##.    //
//    .##..##..##..##....##....##..##..###.##..###.##..........##..##..##......##..##.    //
//    .######..#####.....##....######..##.###..##.###..........######...####...######.    //
//    .##..##..##..##....##....##..##..##..##..##..##..........##..##......##..##..##.    //
//    .##..##..##..##....##....##..##..##..##..##..##..######..##..##...####...##..##.    //
//    ................................................................................    //
//                                                                                        //
//    Creator artann_ash (Anna)                                                           //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract DWE is ERC1155Creator {
    constructor() ERC1155Creator("Darkness Within (Editions)", "DWE") {}
}