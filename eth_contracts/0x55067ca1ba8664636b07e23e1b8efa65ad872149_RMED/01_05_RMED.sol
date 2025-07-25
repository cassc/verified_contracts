// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ruído morto editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ░░░░░░░░░░░░░░░░░░▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████████▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓███████████▓▓▓████▓▓▓▓▓▓▓    //
//    ▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓███▓▓▒▓██▓▓▓▓▓▓█▓▓▓▓▓▓▓███▓▓█████████████████████████    //
//    ▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓█████████▓█▓██▓▓▓▓▓▓██▓▓▓▓▓▓███████████████████████    //
//    ▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓██▓▓▒▓▓██▓██████████▓▓▓▓█████████████████████    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓███████▓▓▓▓▓▒▒▒▒▓▓▓▓██▓▓██▓▓▓▓▓▓▓▓▓▓█████████████████    //
//    ▓██████▓▓▓▓▓▓▓▓▓▓▓██████████████████████████▓▒▒▓▓▓▓▓▒░░▒▓▓▓█▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓██████████████    //
//    ▓█████████████████████████████████████▓▒▒▓▓██▓▒▓▓▒▒▒▓▓▓██▓▒▒▒▒▒▒░▒▓▓▓▓▓▓▓▓▓▓▓▓▓███████████    //
//    ██████████████████████████████████████▓▓▓█▓██████████████▓▒▒▒░░░░▒▓▓▓███▓▓▓▓▓▓▓▓▓▓████████    //
//    ███████████████████████████████████████▓▓▓█████████████████████▓▓██▓▒▒▓██▓▓▓███▓▓▓▓▓▓█████    //
//    ████████████████████████████████████▓███████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████▓▒▒▓▒▒███████▓▓█████████    //
//    ██████████████████████████████████▓██████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓████▓▒▒▒▒▓█████████████████    //
//    ███████████████████████████████▓▓██████▓▒▒▒▒▒▒░░░░░▒▒▒▒▒▒▓▓▓▓▓▓▓▓█████▓▒░▒▓███████████████    //
//    ██████████████████████████▓▓▓██▒░▒████▓▒░░░░░▒░░░░░░░░░▒▓▒▒▒▒▒▒▓▓███████▓░░▓██████████████    //
//    █████████████████████████▓▓▓█▓█▓▓▓▓▓█▓▒░░░░░░░░░░░░░░░▒░░▒▒▒▒▒▒▓▓███████▓▒░░▒█████████████    //
//    ████████████████████████▓▓▓█▓▓▓▓▓▒░▒▓▒▒░░░░░░░░░░░░░░▒░░░░▓▒▒▒▒▓▒▒▓██████▓▒░░▒████████████    //
//    ██████████████████████▓▒▓██▓▒░▓█▓▒░▒▒▓▒░░░░░░░░░░░░░░░░░░░▒▒▒▒▓▓▒░░▒▓████▓▓▒░░▒▓▓▓▓▓▓▓█▓▓▓    //
//    █████████████████████▓▒▓██▓▒░▓█▓▒░░▓▓▓▒░░░░░░░░░░▒▓▓░░░░░░░▓▒▒▓▓▓▓▓▒░░▒▓██▓▓▒░░▓▓▓▒▓▓▓▓▓▓▓    //
//    ███████████████████▓▒▒▓██▓░░▓██▓░░▒███▓▒░░░░░░░░█░░░░░▒░░░░▒▓▓▓▓████▓▒░░▒▒█▓░░▒▓▒▒▒▒▒▒▒▒▓▓    //
//    ▓█████████████████▓▒▓██▓▓░░▓██▓▒░░▓███▓▒▒▒▒▒▓▓▒▓▒░░░░░▒░░░░░▒▓▓▓▓█████▓░░▒▓▓░░▒▒░░▒▒▒▒▒▒▒▓    //
//    ██████████████▓▓▓▓▓▒▒██▓░░▓██▓▒░░▒█████▓▒▒▒▓▒░░░░░░░░░░▒░░░░░▓▓▓███████▓░░▓▓░▒▒▒░░▒▒▒▒▒▒▒▒    //
//    ██████▓▓▓▓▓▒▓▓▓▓▓▓▓█▒▒▓▓░░▒██▓▒░░▒█████▓▓▓▓▓▓▓▓▒▒░░░░░░░▒░▓▓▓▒▓████████▓░░▒▓▓▓▓░░░░░░▒▒▒▒▒    //
//    ▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓▒▒▓▒▒▓▒░▒▓█▓░░░▒███████▓▓▒▒▒▒▒▒▒▒▒░░░░▒▓▓▒▒▓▓████████▓▒░░▓▓▓▒░░░░░░▒▒░░░    //
//    ▓▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▓▓▓▓░▒▓█▓▒░░▒██████▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▓▓▓▓███████▓▒░░▒█▓▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓████▓▓▒▒██▒░░▒▓█████▓▒░▒▒▒▒▒▒▒▓▒▒▒▒▒▓▓▓▓▓▓▒▓███████▓▒░░▒▓▓▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ░░░▒░░░░░▒▒▒▒▒▓▓█████████▓▒▒▓█▒░░░▒▓█████▓▓▓▓▓▓▒▒▒▓▒▒▒▒▓▓▓▓▓▓▓▓▓███████▓░░▒▓█▓▒▒░▒▒▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒░▒▒▒▓▓▓▓▓████████████▒▓▓█▒░░░▒▓▒▒▓█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████████▓▓▒░░▒▓▓▒░░░░▒▒░░░▒▒▒    //
//    ▒▒▒▒▒▓▓▒▒▒▒▒▒▒▓▓██████████████▓░░░▒░░░▒▓▓█████▓▓▓▓▓▓▓▓▓█████████████▓▒░░░▒▓▓▒░░░░░░░░░░░░▒    //
//    ▒▒▓▓▓▓▓▓▓▓▒▒▒▒▒▒▓▓██████████████▓▒░░░░░░▓▓▓▓▓██████▓███████████████▓▒░░░░▓▓▒░░░░░░░░░░░░░░    //
//    ▓▓▓▓▓▓▓▓▓▓▒▒▓▓▓▓▓▓████████████████▓▒▒░░░▒▒▒▓▒▓███████████████████▓▒▒▒░░░▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓█████████████████▓▒▒▒▒▒▒▒▒▒▓▓███████████▓▓▓▓██▓▒░░░░▒▓████▓▓▓▓▓▓▓▓▓████    //
//    ▓▓▓▓▓▓▓▓▓▒▒░░░░░▒▒▓▓██████████████████▓▓▒▒▓▓▓▒▒▓▓▓████████▓▒░░▒██▓▒░░░░▒▓▓█████▓▓▓▓▓▓▓████    //
//    ▓██████▓▓▒▒░░░░░░░▒▓▓███████████████████▓▓▒▒▒░░▒▒▓▓████████▓▒░░▒▓▓▒░░░░░▒▓██████▓▓▓▓▓▓████    //
//    ███████▓▓▒▒░░░░░░░░▒▒▓████████████████████▓▒░░░░░▒▒▓▓████████▓▒▒▒▓░░░░░░▒▒▓██████▓▓▓██████    //
//    ████████▓▓▒▒░░░░░░░░░▒▓███████████████████▓░░░░░░▒▓▓▓█████████▓▓▓▓▒░░░░░░░▒▓██████▓▓▓▓▓██▓    //
//    █████████▓▒▒░░░░░░░░░░▒▓██████████████████▓░░░░░░▒▓█████████████▓█▓▒░░░░░░▒▒▓██████▓▒▒▓▓██    //
//    ██████████▓▒▒░░░░░░░░░▒▒▓▓████████████████▓▒▒▒░░░▒▓███████████████▓▓▒░░░░░░░▒▓██████▓▒▒▓▓▓    //
//    ███████████▓▒▒░░░░░░░░░░▒▒▓████████████████▓▒░░░░▒▓████████████████▓▓▒▒░░░░░░▒▓▓██████▓▓▓▓    //
//    ███████████▓▓▒▒░░░░░░░░░▒▒▒▓▓██████████████▓▒░░░░░▒▓████████████████▓▓▓▒▒░░░░▒▒▒▓██████▓▓▓    //
//    ███████████▓▓▒▒▒░░░░░░░░░▒▒▒▓▓█████████████▓▒░░░░░▒███████████████████▓▓▓▒░░░░▒▒▒▓▓████▓▓▒    //
//    █████████▓▓▓▓▓▓▒▒░░░░░░░░░░▒▒▓▓████████████▓▒░░░░░▒▓█████████████████████▓▒░░░░▒▒▒▒▓████▓▓    //
//    ▓▓▓▓██▓▓▓██▓▓▓▓▓▓▒▒▒░░░░░░▒▒▒▒▓▓▓████████▓▓▓▒░▒░░▒▒▓██████████████████████▓▒░░░▒▒▒▒▓▓█████    //
//    ▒▓▓▓▓▓▓▓████████▓▓▓▒▒▒▒▓▓▓▓▓▓▒▓▓▓▓██████▓▓▓▓▒▒▒▒▒▒▒▓███████████████████████▓▓▓▓▒▓▓▓▒▒▒▓▓▓▓    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract RMED is ERC1155Creator {
    constructor() ERC1155Creator(unicode"ruído morto editions", "RMED") {}
}