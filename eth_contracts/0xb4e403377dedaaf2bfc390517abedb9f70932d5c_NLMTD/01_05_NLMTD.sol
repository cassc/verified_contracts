// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: neurocolor Limited Editions
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    ░░░░░░▒▒▒▒█████▓▓██▓░░▒░░░░░░░░▒█▓░▓▓▓████▓███████▒▓▒██████▓▓▒▓███████████████████▒▓▓▒░░░░▓███████▒░░░░░░░░░░░░░░░░░░░░░    //
//    ░░░░░░░░░░░░▒███▓▓▓▒█▒░░░░░░░░▓▒░███████████████████████████████▒▓███████████████▓░░░░░░░░▒█████▓▓░▒░░░▓░░░░░░▒▓▓▒▓▓▒░░░    //
//    ░░░░░░░░░░░░▒▓▓▒░░▓██░░░▒░░▒▓▒░▒▒▓█████████▓█████▓██████████▒░░▓▓▓▒▒▒██▒▒▓████████▓▓▒█████▒▒▒▓░░░░░▒▒░░░░░░░░▒░░░░░░░░░▓    //
//    ███▓░░░░░░▒█▓██▒░▓███▒▒▓▒░░░░▒███▓█████████▓▒██▓██████████████▓▒▒▓███▓██▒░▓████████████▒▓▓▒▒░░░░░▒░░░░░░░▒░░▓▓░░░░░░░░░░    //
//    ░░██░░░▓▒▓█████▒▓███▓▓▒░░░░░░░░░░░░▓████████████▓▓███████████████████████████░▓██▓▓█▒░▒▒░░█░▒░░░█░▒▓▓▒░░▒█▒▓░░░▒▓▓▓▒▒░░░    //
//    ▒▒███▓▓████████████▓▒░░░░░░░░░░░░░░░██████░▒████████████████████████████████████████░▒█▓░░▒░░░░▒░░░░░░░░░▓▒░░░░▒▒░░░░░░░    //
//    ░▒▓░▒▓█████████▓▓▒░░░▓██░░░░░░░░░░░░░██████████████████████▓██▓███████▒█████▓▓██████▓░░░░▓▓░░▓████▓░░░░▒░░░░░░░░░░░▒░░░░    //
//    ░▒░░▒░░▒██████▓░░░░░░░▒█▓░░░░░░░░░░░▒▓▒▓████▒▒██████▓▓█████▓▒▓█░▒██▓███░██████████████▒▒░▓░░░▓█▓▒░░░░▒▒░░░░░░░▒▓█▓░░▒▓▒░    //
//    ▒░░░░░░░▓███▒██░░▒▒▒░░░░▓▓▓░░░▓▒░▒░░░▒▒░▒███████████████▓█████▓░░░▓██▓▓▒░▓█████████████▓██▓▓░░█▒░░░▓▓░░░░░▒▒▓████▒▓░░░░░    //
//    █▓▒░░░░░░▓███▓█▒▓██▓░░░░░░░░░░░▒▒░░░░▒▓█▒░▒████████▓▓▒▓██▓▓▓▓▓██▓░░██▓░░░░▓███▒█▓████▒███▓██░░█▒░░██░░░░███▓▒░░░░░▒░░░░▒    //
//    █▓██░░░▓▓▒▒█░░░▒▒░░░▒▓▒░░░░░░░░░░▒▓▒░░░▒▓█████████████████▓▓▒▓▒▒██░░░▓▒░░░░▒████████▓░████▒░░░▓▒░░█▓░░░░▒█▒░▒░░░░░░░▒▒▒▒    //
//    ███▒░▒███▓░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▓██████▓███████████████▓▒▓▓░░░██▒░░▓███████▓░▓██▓▒▒░▒▒▓░░█▒░░░░░░▒▓░▒░░░░░░▒▓█▒    //
//    ░▓▓▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░▒▒▓▒▓▓▒▒▒▒░██████████████████████████▒▓▓▒▒░░▓▒░░██▒████▓░▒███░░░░▒█░░█▓░░▒░░▒▒▓█▓▒░░░░█▓░░░    //
//    ░░░▒░░█▓▒░░░░░░░░░░▒▒░░░░░░░░░░░░░▒░░░▓█▒▒▒░░▒█████████▒▓████████████▒▒░░░▓▒░▓█▓▒████▒░▓██▒░▒░░▒█░▒█░░▒░█░░██▒░░░░░░░░░░    //
//    ░░▒░▒░░▒▒░░░░░░░░▓████▓░░░░░░░░░░░░░░░░░░░░▒██████████▓███▓▓▓▓███████▓▒░░░░▓░░████████░▒███▒▒░▒░█▓▒█▓░░▒█▓██░░░░░░░░░▒▓░    //
//    ░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░▒▒░▒█████▒░▓▒▓▓▓█▓▒▓▓██▒▒████▓░░░▒░▓██▓█████▒░▒███▓▓█▒░▒▒░█▒░░▓░▓█░░░░░░░▒░▓░░    //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░▒▒▒▒█▓▓███▓░░▓▓███████████▓███▒░░▒░░███▒██████▓░▓██████░▒░░░█▒░░░▒█░▓▒░░░░░▓▓░█    //
//    ▓▓▓░░░▓▓▓█░▒▓░░░░░░░▓▓▓▓▓▓▒░░░░░░░░░▒░░░░░░░▒▒▒▒▒█▓░░▓██████▓▓▓▒▓▓█▓▒███░░░▒▒████▒███████▓▒█▒███░░░░░░▓▒░░░▒░░░░░░░░▒░▓░    //
//    ░░▒▓▓▓██▓███▓▓░░▒▓█▓▒▒▓▓██▓░░░░░░░░░░▒░░░░▒▒▒██▓▒░░▒█▓▒▒▓▓█████████▓░░██▓░░▒░▒██▒▒▓███████▓█▓██▓▒▓░░░░░█▓░░░░░░░░░░░░▓░▒    //
//    ░░░▓▒░▒▒░▓▒▓░░░▓██▒█▓███▓▓▒▓█▓░░░▒▒▓█▒░░░░▒▒░░░░░▒▓▓▒▒█████████████▓░░████▒░▓▒▓██▓░███████▓███▓▓▒░▓░▒░░██▒░░░░░▒░░░░▒░██    //
//    ▓▓▓▒▓█▒░░░▓▓▒░░░░▒█▒▒█▒▒▒▓▓▒░▒█▓▒░░███▒░▒░░░░░░░░░░▒▓▓▓▓██████████░░░░███████░░▓██▓▒████████████▓░░░░░░▓███░░░░▒░░░░░▓▒░    //
//    ▒▓▒▓█▓░▒░░▒░░▒█▒░▒░░░▒▒▒▓▓███▓▓███░░▒▓█▓▓█▓▒░░░▒▒▓███████████▓░░▒▒░░░░▓█████░█▓███▓▓▓▓▒██████████▓░░░░░░███░░░░▒░░░▒░░░░    //
//    ░░░░██▒░▒▒▒▒░██▓▓░░▓▓▓███████████████▓▒█▒▓███▓▓▓▓▒▓███▓▒▒░▓████▓░░░░░░▒█▓███▓████████████▓░███████▒░░░░░▒█▓▒░░░░░░░░░░░░    //
//    ░░▓█▒░░▒▒▒█▓▒▓███▒███████████████████████████▓▓▒▒▓█▓▓▓████████▓░░░░░░░░█▒▒███▒█░░███▓▓█████████████▓░░░░░▓██░░░░░░░░░░░█    //
//    ▓▒▓▒░░░░▒█▓█████████████████████████████▓▓███░░░░▒▓█████████▓░░░░░░▒█▓███▒███▒█░░█░░░░▒██████▓███████▒░▒░░▓▒░░░░░░░░▒░▒▒    //
//    ██▒░░░░▒▓███▓█████████▒████▓▓██████████████████████████████▒░░░▒░░░░▓▓▓▒█████░▓░░▒█░▒░░▒█████▓▓████████▓░░░░░░░░░░▒▓░▒█▒    //
//    ██▓░░░░▓▒███████████▓▓███▓▒░░▒▒▒░░▒▓▓████████████████████▒░░░░░░░░░▒▓▓░▒████▒▒▓▓░░▒█▒▓█▓███░▓██████▒██▓▒░░▒░░░░░░▓▓░▒███    //
//    ██▓░░░▓▒▓██████████▓▓█▓▓░░░░░▒▒▒░░░░░░░░▓██████████████▓░░░░░▒████▓███▓██▓████░█░░▒███▓▓▓▓█▓█████▓░▓█▓░░░░░░░░░░░███████    //
//    ███▒▓▒███▓███████████▒▒▓░░░▓██████░░▓▓░░█████████████▓░░░░░░█████████████▓▓███████████▓█████████▓░▓██░░░░░░░░░░░▓██████▓    //
//    ██▒░▓▒▓█████████████▓░░░░░▒█████▓▒▒▒▓█▒░▓██████████▒░░░░░░░░█████████▓█▓▓▒░▓████████▓██▓███████▓░▓███▒░▓▒░░░░░░▒████████    //
//    ▒██▒░░▓█████░▓██▒█░█░▒░▒░░▓████▓░▒▓▓██░░░█████████▓░░░░░░░░▒▒████████████▓░▒██████████▓▓██████▓░░███▓░▒█░░▒░░▒▒█████████    //
//    ░▓██▒▒▓█████▓▒███▓▓▓▒▓░▒░░░░░██░░░░▒██░░░█████████▒▒░░░░░░░▒░██████████▒█▒░▓████████████▓▓▓████░▒███░░█▓▒░░░▒░██████████    //
//    ░░▓███████████████████░▓░░░░░▓▓░░░▒██▓░░▓█████████▓░░░░░░░▓▒░███▓▓████▒▓▓░▒███▓█▒▒████▒███▓████▒█▓▓░▒▓▒█▒░░░░████▓▓▒████    //
//    ░▒░██▓▒██████▓░█████████▒░░░░░░▒███▒░░░█▓████████▒░░░░░░░██▒░░▓███▒▒▓▒▒░░▓████▓░▒▓▒░░░█████████▓░░░▓▒░▒▒░░░░████▒▒▒█████    //
//    ░▓▒██▓███████▓▓█████████▒░░░░░█▓▒░░░░▓▓▒█████▓▓▒░░░░░░░░▒░▓█▒▓██████▓▓███▓▓▒▒▒▒▓▒▒░▒▓███▓███▓▒░░▓▒░░░░░░░░░████▓▒▓██████    //
//    ░░▒▓█████████████████████░░░▒░░░░▒▒▒█▓▓█████▓█░░░░▒░░░░░░░░▓█▓▒▒▒░▒░░░░░░░░░░░▒▒▓▓▓▒░░░▒█▓▒░░░▒▓░░░░░░░░░░██████████████    //
//    ░█▓██████████████████████▒░█▓░░▒▒▒███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓████████████▒▓    //
//    ▓████████▓███████████████▒░░▓░░▓████████████▒░░░░░▓░▒▒░░░░░░░░░░░░░░░░░░▒░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░▓███▓███████▓▒▒▓    //
//    █████████████████████▒░▓▓▓░░░░░▓████████████░░░░░░░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓████████████████    //
//    ███████████▓▒▓███████▒▒▓▒▒░░░░░█▒███████████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░░░▒▓░░▓████▓███████████    //
//    █████████▒░░░▓███▓▓██▓██░▒░▒░░░█▓███████████▒░░░▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▓▒░░░░▒▒░▓████████████████▓▓    //
//    ████████▒░░░░█████▒██████▒▒▒░░░███████████▒█▒░░░░░░░░▒▒▒░░░░░░▒▒▒▒▒░▒▒▒░░░░░░░░░░░░░░░░░░░░░░░▒▓▓▒▒▓████████████████████    //
//    ██████▓░▒█▓▒░▒████████████▓▒░░░░████████▓░▓██▓▒▒▒▒▒▒▓▓▓▒▒▒▒▒▒░▒▒▓▒▓▒▓▓▒▒░░░░░░░░░░░▒▒░░░░▒▓▓▓▒▒████▒░██████████████████▓    //
//    █████▓▒░░▓▒░░████▒▓████████▓░░░░░████████▓▒▓▓█▓▓▓▓███▓▓▓▓▒▒░░░░░░░░░░░░▒▒▒▓███████████▒░░░▒▒▒▓████▓▒█████████████████▒░░    //
//    ████▓▒▓▓░░▒░░████▒████▓█████▓▒░░░░▓███████████████▓▓▓▓▓▓███▓▓▓▓▓███▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓█████████████████████████████▓░▒░░    //
//    ████▒░░░░░▓████████████▓█████▓░░░░░▓█████▓▓█▓▒▒▓████████████▓▓▓▓▓▓██▓▓▓▒▓▓█▓▓▓████▓██████▓▒▓▓████████████████████▒░░██▓▒    //
//    ██▓░░░░▒▒▓█████████████▒░▒████▒░░░░░▒██████████████████████████████▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▓▓▓█████████████████████████▒▒▒░▒▓██░    //
//    ▓▓▓▓░░▒▓░░██▓███████████░░▓▓███░░░░░░▒▒▒▓▓██████████████████████▓▓▓███████████████████████████████████████████▒▓▓▓▓█████    //
//    ███▒░░░░░░█████████████▓▒▓▓░░░▒░░░░░░▒▓▓▓▒▒▓██████████████████████████▓▓█████▓▓██████████████████████████████▓░░▓██████▓    //
//    ██▒░░░░░░▓██████████▓▓██████░░░▒▓░░░▓███▓░▒▓█▓▒▒▓▓█████████████▓▓▓▒░░░░░░░░▒████████▓▓▓███████████▓█████▓▓▓░▒▓███████▒▓█    //
//    █▒░░░██████▓█████████▓███▒██▒█░▓█▓░▒▒█████▓░░▒▒▓█▓▒░░▒▒▓▓▓▒░▒░░░░░░░░▒▒░░░░▒▓▓▓███████▓▒▒▓█▓▓▓▓█▓▓▒▒▓▓▓███▓████████▒▒███    //
//    ██▓▒███████████████████▓▒▒██░▒▒███▓░█▒▓██████▓▒░░▒▓██▓▒░░░░░░░▒▒░░░░░░░░░░▒▓▒░░░░░░░░▒██▓▒▒▓█▓▒▓▓▒▒░░░▒▓▓▓████████▓▓███▓    //
//    ██████████████████████▓▒▒█░░░░░█▓▓█▓▒█▒▒▓░▓█████▒▒▒░▒▒██████▓▓▓██▓▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░████▓▒▒▓░▒▓██████▓▒██████▓    //
//    ███████████████████████▓▒█▓░░▒░░▒▒▓░░░▓▓▒▒▒▒█████▓░░░░░▒▓▓▓▓█▓▓▓▒▒░░░▒██████████████████▓░░▒░░▒▓██████████████▓▓█████▓▒▒    //
//    ████████████████████████████▒▓▒▓▒░░▓░░░░▒███▒▒▓▓▒▒▒░░░░░░░▒░░░░░░▒▒▓▒░░▓███████████▓▒▒▓▓▓▓▓▓▒▒░░▓▓▓▓▓▓▓▓██░▓██░████████░    //
//    █▓▒▓███▓▒▓█▓▓████████████████████▒░░▒░░░░░░█▓▓▒░░░░░░░░░░▒▒▓▓▓██▓▓░░░░░░░░▒▓██████████▓▒░░███▒▒▓▓████████▓▓██▓▓█████▓▓█▓    //
//    ░░░░░░░░░░░░░░▓██████████████████▒░░░░░░░▓░░▒███▒▓▓▓▒▒▒▓███░▓███░░░░░░░▒▒▓▓░░░▒▒▓▒▒▓█████▒████████████▓▒░░▓░░░░░▒▒▒░░▒▒▒    //
//    ░░░░░░░░░▒▒▒░░░░▓██▒░░████████████▓███▓▓▒░▓▒░▒█████▒▒█████▓█████▒░░░▒▓█████████▓░░░░▒▓▓▓█████▓▓▓▒▒▒▓▓▓▒▒░░░░░░░▒▒██▓████    //
//    ░▒▓▓░░▓████▓▒▒█▓░▓█▓▓▒███████████████▓█▓▓▓██▓▒▓█████▓█▓▒░░░░░░▒█▒▒▒▓█████▓▓▓▓▒▒▓█▓░░░░░░░▓▓█▓▒▒▒░░▓▓▓███░░░░░░▓█▓██▒▒▓██    //
//    ███▓░░░░▒░▒▒███░░░▒▓▓▓█▓▒▓▓████████░░░░▒▒▓▓▓▒▒▓▓███▒█▓▒░░░░░░░▒░▒█▒▒░░▒█▓░░░░░░░░░▒░░░░░░░▒░░▒▓▒░░▓██▒░▓░▒░░░░▓░░▒██▓▓░░    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NLMTD is ERC721Creator {
    constructor() ERC721Creator("neurocolor Limited Editions", "NLMTD") {}
}