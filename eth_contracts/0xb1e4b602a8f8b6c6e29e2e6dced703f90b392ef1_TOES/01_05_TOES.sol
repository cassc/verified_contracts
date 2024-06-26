// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: //thompson: OpenEditions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ░███████░░░░░░░░░▒▒▒▒▓▓▓▓▓██████████████████████████████████████████████████████    //
//    ▒████████▓██████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████    //
//    ███████▒░▒▒▒▒▒▒▒░▒▒▒░░▒▒░▒░░░░▒░▒░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓█████    //
//    ██████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████    //
//    ██████▒░░░░░░░░░░▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒░░░░░░░░░░░██████    //
//    ██████▒░░░░░░▒▓█████████▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓█████████▒░░░░░░░░░██████    //
//    ██████▒░░░░░▒██████████████▓▒░░░░░░░░░░░░░░░░▒▒▒▒▓███████████████░░░░░░░░░██████    //
//    ██████░░░░░░▓████████████████▓░░░░░░░░░░░▒▓▓████████████████████▒░░░░░░░░░██████    //
//    ██████░░░░░▓███████████████████▓░░░░░░░░████████████████████▓▓▒░░░░░░░░░░░▓█████    //
//    █████▓░░░░░██████████████████████▒░░░░░░███████████████▓▓▒░░░░░░░░░░░░░░░░▓█████    //
//    █████▒░░░░▒██████▒▒███████████████░░░░░░░▒▓██▓▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░██████    //
//    ████▓░░░░░▓██████░░░░▓█████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████    //
//    ███▓░░░░░░██████▒░░░░░▒█████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████    //
//    ███▒░░░░░▒██████░░░░░░░░████████████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██████    //
//    ███▒░░░░░▓██████░░░░░░░░▒███████████▓░░░░░░░░░░░░░░▒▒▒▒▓▓█████▓░░░░░░░░░░▒██████    //
//    ███░░░░░▒██████▓░░░░░░░░░▓███████████▒░░░░░░░▒▓████████████████▒░░░░░░░░░▓██████    //
//    ███▒░░░░▓██████▓░░░░░░░░░░███████████▓░░░░░░█████████████████▓▒░░░░░░░░░░▓██████    //
//    ███▒░░░░▓██████▒░░░░░░░░░░███████████▓░░░░░▒████████████▓▓▒░░░░░░░░░░░░░░███████    //
//    ███▓░░░░███████▒░░░░░░░░░░███████████▒░░░░░░▓██▓▓▒▓▒▒░░░░░░░░░░░░░░░░░░░▓███████    //
//    ███▓░░░▓███████▒░░░░░░░░░░███████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓███████    //
//    ████░░░▓███████▓░░░░░░░░░░███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████    //
//    ████░░░▓████████░░░░░░░░░▒██████████▓░░░░░░░░░░░░░░░░░░░▒▒▓██████▓▓▓▒░░▓███████▓    //
//    ████▒░░▒████████▒░░░░░░░░▓██████████░░░░░░░░░░░░░░░░▒████████████████░░████████▓    //
//    ████▓░░▒█████████░░░░░░░▒██████████▓░░░░░░░░░▒▒▓▓▓███████████████████▒░████████▒    //
//    ████▓░░▒█████████▓░░░░░▒██████████▓░░░░░░░▒▓█████████████████████████▒▒████████▒    //
//    █████░░░▒█████████▓░░░░███████████░░░░░░▓██████████████████████████▒░░▒████████▓    //
//    █████░░░░▓█████████▓░░▓██████████▒░░░░▒█████████████████████▓█▓▒░░░░░░▓████████▓    //
//    █████░░░░▒██████████████████████▓░░░░░░▓█████████████▓▓▒▒░░░░░░░░░░░░░▒████████▓    //
//    █████▒░░░░░████████████████████▓░░░░░░░░▒▓▓██▓▓▒▒▒░░░░░░░░░░░░░░░░░░░░▒████████▓    //
//    █████▒░░░░░░▓█████████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████▓    //
//    █████▓░░░░░░░░▓█████████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████▓    //
//    █████▓░░░░░░░░░░▒▓▓███▓▓▓▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░████████▓    //
//    ▓████████▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░▒▓█████████░    //
//    ▓█████████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▓███████████████▓░    //
//    ▒██████████▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▓█▓██████████████████████░░    //
//    ░███████████▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓████████████████████████████████▓░░░    //
//    ░▒███████████▓▓▒░▒░░▒▒▒▒▒▒▓▓▓███████████████████████████████████████████▓▓▒░░░░░    //
//    ░░▒█████████████████████████████████████████████████████████▓▓▓▓▒▒▒░▒░░░░░░░░░░░    //
//    ░░░▓████████████████████████████████████████████████▓▓▒▒░░░░░░░░░░░░░░░░░░░░░░░░    //
//                           thompsonART.eth |  @thompsonnft                              //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract TOES is ERC721Creator {
    constructor() ERC721Creator("//thompson: OpenEditions", "TOES") {}
}