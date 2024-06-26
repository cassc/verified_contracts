// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: KRISTA KIM: AIR
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    █████▒▒▒▒▒▒██████████████████████████▓▒▒▒▒▒▒▓██▓▒▒▒▒▒██████████████████████████▓▒▒▒▒▒▒▓███    //
//    █████░░░░░░▓███████████████████████▓░░░░░░░▒███░░░░░░▓████████████████████████░░░░░░░▒████    //
//    █████░░░░░░▓██████████████████████▒░░░░░░░▓████░░░░░░▓██████████████████████▓░░░░░░░▓█████    //
//    █████░░░░░░▓█████████████████████▒░░░░░░▒██████░░░░░░▓█████████████████████▒░░░░░░▒███████    //
//    █████░░░░░░████████████████████▒░░░░░░░▓███████░░░░░░▓███████████████████▓░░░░░░░▓████████    //
//    █████░░░░░░███████████████████▒░░░░░░▓█████████▒░░░░░▓██████████████████▒░░░░░░▒██████████    //
//    █████░░░░░░█████████████████▓░░░░░░▒███████████▒░░░░░▓████████████████▓░░░░░░▒▓███████████    //
//    █████░░░░░░████████████████▒▒▒▒▒▒▒▓████████████▒▒▒▒▒▒▓███████████████▒▒▒▒▒▒▒▓█████████████    //
//    █████▒▒▒▒▒▒██████████████▓▒▒▒▒▒▒▒██████████████▒▒▒▒▒▒██████████████▓▒▒▒▒▒▒▒███████████████    //
//    █████▒▒▒▒▒▒█████████████▒▒▒▒▒▒▒▓███████████████▒▒▒▒▒▒█████████████▒▒▒▒▒▒▒▓████████████████    //
//    █████▒▒▒▒▒▒███████████▓▒▒▒▒▒▒▓█████████████████▒▒▒▒▒▒███████████▓▒▒▒▒▒▒▒██████████████████    //
//    █████▒▒▒▒▒▒██████████▓▒▒▒▒▒▒▓██████████████████▓▒▒▒▒▒██████████▓▒▒▒▒▒▒▓███████████████████    //
//    █████▒▒▒▒▒▒████████▓▓▓▓▓▓▓▓████████████████████▓▓▓▓▓▓█████████▓▓▓▓▓▓▓█████████████████████    //
//    █████▒▒▒▓▓▓███████▓▓▓▓▓▓▓██████████████████████▓▓▓▓▓▓███████▓▓▓▓▓▓▓▓██████████████████████    //
//    █████▓▓▓▓▓▓█████▓▓▓▓▓▓▓▓███████████████████████▓▓▓▓▓▓██████▓▓▓▓▓▓▓████████████████████████    //
//    █████▓▓▓▓▓▓████▓▓▓▓▓▓▓█████████████████████████▓▓▓▓▓▓████▓▓▓▓▓▓▓██████████████████████████    //
//    █████▓▓▓▓▓▓███▓▓▓▓▓▓▓██████████████████████████▓▓▓▓▓▓███▓▓▓▓▓▓▓███████████████████████████    //
//    █████▓▓▓▓▓▓██▓▓▓▓▓▓▓███████████████████████████▓▓▓▓▓▓██▓▓▓▓▓▓▓████████████████████████████    //
//    █████▓▓▓▓▓▓███▓▓▓▓▓▓▓▓█████████████████████████▓▓▓▓▓▓███▓▓▓▓▓▓▓▓██████████████████████████    //
//    █████▓▓▓▓▓▓█████▓▓▓▓▓▓▓████████████████████████▓▓▓▓▓▓█████▓▓▓▓▓▓▓█████████████████████████    //
//    █████▒▒▒▒▓▓██████▓▓▓▓▓▓▓▓██████████████████████▓▓▓▓▓▓██████▓▓▓▓▓▓▓▓███████████████████████    //
//    █████▒▒▒▒▒▒████████▓▓▓▓▓▓▒█████████████████████▓▓▓▓▓▓████████▓▓▓▓▓▓▓██████████████████████    //
//    █████▒▒▒▒▒▒█████████▓▒▒▒▒▒▒▓███████████████████▓▒▒▒▒▒█████████▓▒▒▒▒▒▒▓████████████████████    //
//    █████▒▒▒▒▒▒███████████▒▒▒▒▒▒▒▓█████████████████▒▒▒▒▒▒███████████▒▒▒▒▒▒▒▓██████████████████    //
//    █████▒▒▒▒▒▒████████████▓▒▒▒▒▒▒▓████████████████▒▒▒▒▒▒████████████▓▒▒▒▒▒▒▒█████████████████    //
//    █████▒▒▒▒▒▒██████████████▒▒▒▒▒▒▒▓██████████████▒▒▒▒▒▒██████████████▒▒▒▒▒▒▒▓███████████████    //
//    █████░░░░░░███████████████▓▒▒▒▒▒▒▒█████████████▒▒▒▒▒▒▓██████████████▓▒▒▒▒▒▒▒██████████████    //
//    █████░░░░░░█████████████████▒░░░░░░▓███████████▒░░░░░▓████████████████▒░░░░░░▒████████████    //
//    █████░░░░░░██████████████████▒░░░░░░▒██████████▒░░░░░▓█████████████████▓░░░░░░░▓██████████    //
//    █████░░░░░░▓██████████████████▓░░░░░░░▓████████░░░░░░▓███████████████████▒░░░░░░▒█████████    //
//    █████░░░░░░▓████████████████████▒░░░░░░░███████░░░░░░▓████████████████████▒░░░░░░░▓███████    //
//    █████░░░░░░▓█████████████████████▓░░░░░░░▒█████░░░░░░▓██████████████████████░░░░░░░▒██████    //
//    █████░░░░░░▓███████████████████████▒░░░░░░░▓███░░░░░░▓███████████████████████▓░░░░░░░▓████    //
//    █████░░░░░░█████████████████████████▓░░░░░░░▒██░░░░░░▓█████████████████████████▒░░░░░░▒███    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract KK1155 is ERC1155Creator {
    constructor() ERC1155Creator("KRISTA KIM: AIR", "KK1155") {}
}