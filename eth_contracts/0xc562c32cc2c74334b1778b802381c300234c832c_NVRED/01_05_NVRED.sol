// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NEVERMXRE EDITIONS
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    █████████████████████████████████████████████████▓▓▓▓▓█████████████████████▒████████████████████████████████████████████    //
//    ███████████████████████████████████████████████████▓███████▓███▓███████▓██▒▓████████████████████████████████████████████    //
//    ████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▒▓░▒▒▓██████▓▒▒████▓██▓█████████████████████████████████████    //
//    █████████████████████████████████▓████▓███████▓▓▓▓▓▒▒▒▒▒▒▒▓▒▒▒▒▒▓▓██▓▓▓▓░░▓██▓▓▓█▓██████████████████████████████████████    //
//    █████████████████████████████████▓▓███▓▓██████▓▓▓▓▒░░░░▒░░▒▒▒░░▒▒▒▓▓▓▓▓░░▒███▒▓█▓████▓▓█████████████████████████████████    //
//    █████████████████████████████████▒███▓██████▓▓▓▓▓▓▒░░░░░░░░░▓▓▒░▒▒▓▓▓▓▓░░▒███▓███████▓██▓███████████████████████████████    //
//    ███████████████████████████████████▒█████▓▓██▓█▓▒▓▓▓▓▓▓▓▓▓▒░▒▓▓▓▓▓▓▒▒▒▒▒▒▓▓██████████████▓▓█████████████████████████████    //
//    █████████████████████████████████████████████████▓████▓████▓▓▓▓▓█████▓███████▓██▓███████████████████████████████████████    //
//    ████████████████████████████████████████████████████▓▓▒▓████▓▓███▓█████▓▓▓██▓██▓████████████████████████████████████████    //
//    ███████████████▒░▒░███▓░▓█▓░░▒▒▒▒▓▓░▓█████░░█░░░░▒░░▓▓░░▒░░░▒██▒░░░▓▓██▒░░░▓▓▒▒█████▓░▓█▒░▒▒▒░▒███░░▒▒▒▒▓███████████████    //
//    ███████████████▒░█░░██▓░▓█▓░▓██████░░████▒░▓▓░░▒▓█████░░███▓░▒█▒░▓░░█▓▓░░▒░▒▓▓▒░▒▓▓░░▓██▒░████░░██░▒████████████████████    //
//    ███████████████▒░██░▒█▓░▓█▓░░░░░░███░▒██▓░▒▓░░░░░░░░▓▓░░▒▒▒░░██▒░▓▒░▓▓▒░▒▒░▒▒▒▓█░░░▓████▒░▒▒▒░░▓██░░░░░░▓███████████████    //
//    ███████████████▒░██▓░▓▓░▓█▓░▓███████▒░▓█░░▓▓█░░███████░░▓▓▒░▓██▒░▓█░▒█░░█▓░▓▒▒░░░▒▒░▒███▒░██▓░▓███░▒████████████████████    //
//    ███████████████▒░███▓░▒░▓█▓░░▒▒▒▒▓███░░▒░▓▓▓█░░▒▒▒▒▒██░▒███▒░▒█▒░▓█▓░▒░▓█▓░▒░░░░▓▓█▓▒░▓█░░███▓░▒██░░▒▒▒▒▓███████████████    //
//    ███████████████████████████████████████▓▓▓▒▓█▓█▓▓████████████████████████▓▒▓░░▒▒▒▓██████████████████████████████████████    //
//    ███████████████████████████████████████▓▓▓███▒█▓▓█████████▓▓████████████▓▓▓▓▓▒▒▒▒▓██████████████████████████████████████    //
//    ███████████████████████████████████████▓▓████▓███████████▓░░▒▓███████████▓▓▓▓▓▓▓▒▓██████████████████████████████████████    //
//    ██████████████████████████████████████▓▒▒▓▓████████████▓▒░░░░░▓████████████▓▓▓▓▓▒▒▓▓████████████████████████████████████    //
//    ██████████████████████████████████████▓▓▓▒▒▒▓▓██████▓▒▒▒░░░░░░░▒▒▓▓▓█████▓▓▓▒▓▒▓▓▒▓▓████████████████████████████████████    //
//    ███████████████████████████████████████▒▓▒▒▒▒▓▓▓▓▓▒▒▒▒▒▒░▒▒▒▒▒░▒░▒▒▓▓▓▓███▓▓▒▒▒▓▓▒▓▓████████████████████████████████████    //
//    ███████████████████████████████████████▒▒▒▓▓▓█▓▒▒▒▒▒▒▓▓▒█████▓▓▒▒▓▓▓▓▓▒▒▓▓▓▓▒░░▓▓▒▓▓████████████████████████████████████    //
//    ███████████████████████████████████████▓▒▓▓▓▓█▓▓▒▒▓▓▓█▓█████████▓██▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓████████████████████████████████████    //
//    ████████████████████████████████████████▓██████▓▓▓███▓▓██████▓███████▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓████████████████████████████████████    //
//    ████████████████████████████████████████▓██████████▓▒░░▓█████▓▓▓██▓▓█████▓▓▓▓▓▓▓▓▓▒▓████████████████████████████████████    //
//    ██████████████████████████████████████████████████▓▒▒░░▒▓▓█████▓▓▓▓██████▓▓▓▓▓▒▒▒▒▒█████████████████████████████████████    //
//    █████████████████████████████████████████▓████████▓▓▒▓███████████▓▒▒▓▓█▓▓▓▓▓▓▒▒▒▓██▓████████████████████████████████████    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NVRED is ERC721Creator {
    constructor() ERC721Creator("NEVERMXRE EDITIONS", "NVRED") {}
}