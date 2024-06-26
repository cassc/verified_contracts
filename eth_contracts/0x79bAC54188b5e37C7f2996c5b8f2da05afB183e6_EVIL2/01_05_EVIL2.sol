// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Evil In Colour Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    █████████████████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░▒▒▒▒▒▒▓▓▓███████████████████████    //
//    ███████████████▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░▒▒▒▒▒▒▓▓▓▓▓██████████████████████    //
//    ███████████████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓████████████████████████    //
//    ███████████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓█████████████████████████    //
//    ███████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓█████████████████████████    //
//    ███████████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓█████████████████████████    //
//    ██████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓███████▓▓▓▓▓▓▓▓▓█████    //
//    ██████████████████████▓▓▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██████▓▓▒▒▒▒▒▒▓▓▓████    //
//    ███████████████████████▓▒▒▒▒▒▒░░░▒▒▓▓████████████████▓▓▒▒░░░░░▒▒▒▒▒▒▓████████▓▒▒▒▒▓▓▓▓████    //
//    ████████████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓█████████▓▓▓▓▓▓▓██████████▓▓▒░░▒▒▒▒▒▓▓▓▓▓▓▓███████████████    //
//    ███████████████▓▓▒▒▒▒▒▒▒▒▒▒▓▓████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓█████████████    //
//    █████████████▓▓▒▒▒▒▒▒▓▒▒▒▓████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████▓▒▓▒▒▒▒▒▒▒▒▓▓████████████    //
//    ███▓▓███████▓▓▒▒▒▒▒░▒█▓▓▒░▒▒▓███▓▓▓▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓▓▓▓▓▓▓██████▓▒▒▓█▒░░░░░▒▒▓▓▓███████████    //
//    ▓▓▓▓▓▓███████▓▒▒▒▒▒▒▓███▓▓▓▓▓██▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓███▓▒░▒▓███▒░░░░▒▓▓█████████████    //
//    ▒▒▒▒▓▓▓█████▓▓▒▒▒▒▒▓███████▓██▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓██▓▒▓▓█████▒░░░▒▒▓█████████████    //
//    ▒▒▒▒▒▓▓▓▓▓█▓▓▒▒▒▒▒███████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓███████████▒▒▒▒▒▒▓████████████    //
//    ▒▒▒▒▒▓▓▓▓▓▓▓▒▒▒▒░▓██████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓███████████▓░▒▒▒▒▒▓▓▓█████████    //
//    ▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒▒███████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓████████████▒░▒▒▒▒▒▒▓▓████████    //
//    ░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒░▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓████████████▒░▒▒▒▒▒▒▓▓████████    //
//    ░░░░░▒▒▒▒▒▒▒▒▒▒░▓████████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓████████████▒▒▒▒▒▒▒▒▒▓████████    //
//    ░░▒▒▒▒▒▒▒▒▒▒▒▒░░▓███████▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓█████████████▓▒▒▒▒▒▒▒▓▓████████    //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▓█████████▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓██████████████▓▒▒▒▒▓▓▓▓█████████    //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▓█████████████▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓█████████████▓▒▒▒▓████████▓▓▓██    //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▓█████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████████████████▒▒▒▓███▓▓▓▓▓▒▓▓▓█    //
//    ▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒█████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██████████████▓▓██████▒▓▓▓▒▒▒▒▒▒▒▒▒▓▓    //
//    ▒▒▒▒▒▓▒▒▓▒▒▒▒▒▓██████████▓▓▓▓▓▓▓▓▓█████▓▓▓▓▓▓█▓▓▓▓▓█████▓▓▓▓▒▒▒▓▓████▓█████▒▒▒▒▒▒▓▓▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒▒██▓▓▓▓▒▒▓█████████▓▒▒▒▒▒░░░░░░▒▓███▓▓▓█▓▒▒▒█████▓▓▒▒▒▒▒▒▒░▒▒▓████████▒▒▒▒███▓▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒▒▒████▓▓▓▓████████▓▒▒▒▒▒▒░░░░░░░░▒███▓▓▓▓▒▒████▓▒▒▒▒░░▒▒▒▒▒░▒▒███▓████▒▒▓███▓▒░░░░▒▒▒    //
//    ▒▒▒▒▒▒▒▓█████▓▓████████▒▒▒▒▒▒▒░░░░░░░░░▒████████████▒▒▒▒░░░▒▒▒▒▒▒▒▒███▓████▓█████▓░░░░░▒▒▒    //
//    ▒▒▒▒▒▒▒▒▓██████████████▓▒░░▒▒▒▒▒▒▒▒░░░░░▓██████████▓▒▒▒▒▒▒▒▒▒▒░░░░▒███▓█████████▓░░░░░▒▒▒▒    //
//    ▒▒▒▒▒▒▒▒▒███████████▓███▒▒░░▒▒▒▒▒▒▒▒░░▒▒█▓██████████▓▒▒▒▒░░░░░░░░░▓██▓██████████▓▒▒▒▒▒▒▒▒▒    //
//    ▒▒▒▒▒▒▒▒▒▓███████████▓███▓▒▒▒▒▒▒▒▒▒▒▒▒▓█████▓▓▓██████▓▓▒▒▒░░░░░▒▓███▓███████████▒▒▒▒▒▒▒▒▒▒    //
//    ░▒▒▒░░░░░▒▓████████████████▓▓▓▓▓▓▓▓▓▓███████▓▓▓████████▓▓▓▓▓▓▓███████▓░▒███████▓▒▒▒▒▒▒▒▒▓▓    //
//    ▒▒▒▒▒▒░░░░▒▓████████████████████████████████▒▒▒▓██████████████▓▓▓▓▓▓▓▒░▓█████▓▓▒▒▒▒▒▒▒▒▓▓█    //
//    ▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████▓▓▒▒▒▓▓███████████████▒▒▒▓▓▓█████████▓▒▒▒▒▒▓▓▓▓▒░████▓▓▒▒▒▒▒▓▓▓▓▓▓██    //
//    ▓▒▒▒▒▓▓▒▒▒▒▒▒▒▓█████████▓▓▓▓▓███████▓▓▒▒███████████▓▓▓▓████▓▒▒▒▒▓▓▓▓▓▒▓██▓▒▓▒▒▒▒▒▒▓███████    //
//    █▓▓▓███▓▒▒▒▒▒▒▒▒▓█████████████████▓▒▒▒▒▒▒▓▓▓████▓▓▓▒░▒▒▒▓▓██▓▓▓▓▓▓▓█▓▒█▓▓▓▒▒▒▒▒▓▓▓████████    //
//    ████████▓▓▓▓▒▒▒▒▒▓▓█████████████▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓░░░░░░░▒▒▒▒▓▓██████▓▒▒▒▓▓▒▒░░▒▒▒▓██████████    //
//    ████████████▓▓▒▒▒▒▒▒▒▒██████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▓▓▓███▓▓▓▒▒░░░░░░░░▒▒▒▓▓████████    //
//    ██████████████▓▓▒▒▒▒▒▒▒█████████▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓██▓▓▓▓▒░░░░░░░░▒▒▒▒▓█████████    //
//    █████████████▓▒▒▒▒▒▒▒▒░▓█████████▓▓▓▓▒▒▒▓▓█████████▓▓▒▒▒▓▓▓▓▓▓▓▓▓█▓▒░░░▒▒▒▒▒▒▓▓▓██████████    //
//    █████████████▒▒▒▒▒▒▒▒▒░░▓██████████▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓██▓▒░░▒▒▒▒▒▒▓██████████████    //
//    █████████████▓▒▒▒▒▒▒▒▒▒░░▓████████████████████████████▓▓▓▓▓▓████▓▒░░░▒▒▒▒▒▓▓██████████████    //
//    ██████████████▓▓▓▒▒▒▒▒▒░░░▒▓█████████████████▓▓▓███████████████▒░░░░░▒▒▒▒▒▒▒▓█████████████    //
//    █████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒░░░░░▓████████████▓▒▒▒▒▒▒▒▓▓█████████▒░░░░░░░▒▒▒▒▒▒▒▓▓████████████    //
//    ███████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒░░░░▓████████████▓▓▒▒▒▒▒▓▓██████████░░░░▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓██████████    //
//    ██████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒███████████████████████████████░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████████    //
//    ████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░███████████████████████████████░░░▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▓███████    //
//    ████▓▒▒░░░░░▒▒▒▒▒▒▒▒░░░░░░▒░▒░███████████████████████████████░░▒▒▒▒▒▒▒▒▒▒▒░░░░░▒▒▒▓███████    //
//    ████▒▒▒▒░░░░░░░░░░░░░░░░░▒▓██▒███████████████████████████████░▓█▓▒█▒▒▒▒▒▒▒░░░░░▒▒▓████████    //
//    ████▓▓▒▒▒░░░░░░░░░░░░░▒▒▓▓███████████████████████████████████████▓██▓▓▒▒▒▒▒░░░▒▒▒▓███▓▓▓▓█    //
//    ███████▓▒▒▒░░░▒▒▒░░░▒▓████████████████████████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▒▓▓▓    //
//    ▓▓▓█▓▓▓▓▒▒▒░▒▓██████████████████████████████████████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒    //
//    ▒▒▒▓▒▒▒▒▒▒░▒▒███████████████████████████████████████████████████████████████████▒▒▒▒▒▒▒▒▒▒    //
//    ▒░░▒▒▓▓▓▓█████████████████████████████████████████████████████████████████████████▓▒▒▒▒▒▒▒    //
//    ░░▒▓█████████████████████████████████████████████████████████████████████████████████▓▓▒▒▒    //
//    ▓███████████████████████████████████████████████████████████████████████████████████████▓▓    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████████████████████████████████████████████████████    //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract EVIL2 is ERC1155Creator {
    constructor() ERC1155Creator() {}
}