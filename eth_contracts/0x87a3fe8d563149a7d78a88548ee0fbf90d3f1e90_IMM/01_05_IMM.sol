// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Immersion by Marina Núñez
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//         e    e                       ,e,                          888b    |                                          //
//        d8b  d8b       /~~~8e  888-~\  "  888-~88e   /~~~8e        |Y88b   | 888  888 888-~88e  e88~~8e   ~~~d88P     //
//       d888bdY88b          88b 888    888 888  888       88b       | Y88b  | 888  888 888  888 d888  88b    d88P      //
//      / Y88Y Y888b    e88~-888 888    888 888  888  e88~-888       |  Y88b | 888  888 888  888 8888__888   d88P       //
//     /   YY   Y888b  C888  888 888    888 888  888 C888  888       |   Y88b| 888  888 888  888 Y888    ,  d88P        //
//    /          Y888b  "88_-888 888    888 888  888  "88_-888       |    Y888 "88_-888 888  888  "88___/  d88P___      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract IMM is ERC721Creator {
    constructor() ERC721Creator(unicode"Immersion by Marina Núñez", "IMM") {}
}