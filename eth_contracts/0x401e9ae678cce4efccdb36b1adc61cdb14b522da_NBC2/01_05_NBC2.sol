// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: $NIKITA Barcode S2
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ░░░░▒▒▒▒▓░▓███▒░███▓░▓████████▓░░░█░██▒░█░▒▓░░░░░█░░░▓█▓░▓▒░░░░░█▒░░██▓░░░░████▒░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░░░░█▒░░███░░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░░░░█▒░░███░░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░░░░█▒░░███░░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░░░░█▒░░███░░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░░▒▒▓▒▒▒▓▓▓▒░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░░█░██▓░█░▒█░░░░░█▒░░██▓░█▒░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒█░▓███▓░████░██████████░░▒█░██▓░█░▒█░░░░░█▒░░▓█▓░█▒░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒░█▒░░░▒█░▓██░█████████████░█░░▒█░█▓░█████░▓██░░▒█░░░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒░█▒░░░▒█░▓██░█████████████░█░░▒█░█▓░█████░▓██░░▒█░░░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒░█▒░░░▒█░▓██░█████████████░█░░▒█░█▓░█████░▓██░░▒█░░░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒░█▒░░░▒█░▓██░█████████████░█░░▒█░█▓░█████░▓██░░▒█░░░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒░█▒░░░▒█░▓██░█████████████░█░░▒█░█▓░█████░▓██░░▒█░░░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░▒▒▒▒▒░█▒░░░▒█░▓██░█████████████░█░░▒█░█▓░█████░▓██░░▒█░░░░▒██░▓██░░░█░░▒████▓░██▒░░░░█░    //
//    ░░░░░░░░░▒░░░░░▒░░▒▒░▒▒▒▓▓▒▓▓▒▒▓▒▒░▒░░░▒░▒░░▒▒▒▒▒░▒▒▒░░░▒░░░░░▒▒░░▒▒░░░▒░░░▒▒▒▒░░▒▒░░░░░▒░    //
//    ░░░▒▒▒▒▓▓░▒▓░░▒▓░░░░▒▓░░▒▓░▓▓░░▓▒░░░░░░░░░░▒▒▓░▓█░░▓▒░▒▓░░░░░░░░░░░░░░░░░░░█░▒▓█░▓▓░▒▓▒░░░    //
//    ░░░▒▓░░▒▒░▓▒░░▓▒░░░░░▓░▒█▒░▓▓▒▒▓▓░░░░░░░░░░░▒▒░▒▒░░▒░░▓▒░░░░░░░░░░░░░░░░░░░▒░░▒▒░▒▒░░▒▒░░░    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract NBC2 is ERC721Creator {
    constructor() ERC721Creator("$NIKITA Barcode S2", "NBC2") {}
}