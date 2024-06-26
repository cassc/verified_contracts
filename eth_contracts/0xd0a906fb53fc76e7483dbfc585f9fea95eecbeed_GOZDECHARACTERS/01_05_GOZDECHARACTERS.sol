// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Gozde - Characters
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ████████████████████████████████████████████████████████████████████████████▓▓██    //
//        ████████████████████████████████████████▒▐▓███▒█▒▓▓█████████████████████████▓▓██    //
//        ███████████████████████████████████████▓▒▒▒▓██▒█▒▒▒▓▓██████████████████████▓▓███    //
//        ███████████████████████████████████████▒▒▒▒▒█▌▓█▒▒▒▒▓▓▓████████▓███████████▓▓███    //
//        ████████████████████████████████████▓███▓▒▒▒▓▌▌▓▒▒░▒▒▓▓▒▓█▒▒▒▌▓▒▓▓█████████▓▓███    //
//        ████████████████████████████████████████▓▓▒▒▒█▐▒░▒░▐▒▒▒▒░▓▒▒▒▒▐▒░▓████████▒▓▓███    //
//        ███████████████████████████████████████▓▓▓▓▒▒▀▒▒▒░░ ░▒▒▒░▐▌▒▒▒▒▒▒▒▓███████▓▓████    //
//        ██████████████████████████████████████████▓▒▒▒▓▒▒░░░ ▒▒▓▒░▓███▓▓▓▒▓███████▓▓████    //
//        ████████████████████████████████████████████▓▒▒▓▒▒  ░░▒▒▌▒▒▓█████▓▓██████▓▓█████    //
//        ██████████████████████████████████▓▒▒▒▒▒▓▓█████▓▓▓▒▄ ░░░▐▀▀▀▀▓████▒██████▓▓█████    //
//        ████████████████████████████████▓▓▒▒▒░░░▒░░░░░▀▒▀▒▒▒░          ▐██▒██████▓▓█████    //
//        █████████████████████████████████▓▓▒▒▒▒▒░░░░░░░▒▄▄▓▓▄▄▄▒▒▒▒░   ▐██▓█████▓▓██████    //
//        █████████████████████████████████████▓▒▒░░░░░░▒▓▓██████▀▒▒░░░░ █████████████████    //
//        ███████████████████████████████████████▒▒░░░░░░░▒▒▓▓█▒▓▀▀▄▒░  ░█████████████████    //
//        ███████████████████████████████████████▓▒░    ░▓███████▀▓█▓░░ ▐█████████████████    //
//        ███████████████████████████████████████▓▒░     ░▐█████▀ ░▒░   ▐█████████████████    //
//        ████████████████████████████████████████▒░     ░▀▓▓▓▓▒░░░     ▐█████████████████    //
//        ████████████████████████████████████████▒░       ░▒░░░        ██████████████████    //
//        ████████████████████████████████████████▒                    ▓██▓███████████████    //
//        ████████████████████████████████████████▒                   ▐███████████████████    //
//        ████████████████████████████████████████▒░░   ░░░          ▐███▓████████████████    //
//        ███████████████████████████████████████▓▒░    ░░░░░       ▄████▓████████████████    //
//        ███████████████████████████████████████▓▒░░░░░░ ░░░      ▐█████▓████████████████    //
//        ████████████████████████████████████████▓▒▒▀▀           ▐█████▓█████████████████    //
//        ██████████████████████████████████████▒▐█▒░            ▄██████▓▓████████████████    //
//        █████████████████████████████████████▓▄▒▒▒░      ░░   ▓█████████████████████████    //
//        ███████████████████████████████████████████▓▀▀▒░░░░░▐███████████████████████████    //
//        ██████████████████████████████████████▓▓▓▓▒▒▒▒▒░░░░█████████████████████████████    //
//        ██████████████████████████████████████████▓▀▀▒░░░███████████████████████████████    //
//        ███████████████████████████████████████▒▒▒░  ░░░▓███████████████████████████████    //
//        ██████████████████████████████████████████▒▒▒░ ▐████████████████████░   ░▀▀▀████    //
//        ███████████████████████████████████▀▀▒▒░     ░▐▓████████████████████          ▀█    //
//        █████████████████████████████████▓▒░░░░░░░░░░▒▓▒█████████████████▓██░               //
//        ██████████████████████████████▀▓▓▓▒░   ░░░▒▒▒░▒▒█████████████████▒▓█                //
//        ███████████████████████████▓▒▒░░░░▒░     ░░░▐░░▒▒███████████████▒▒▓█▌               //
//        ▒▓█████████████████████████▒▒░▒          ░░░░ ░░░▐▓█████████████▓▒▓█▌░              //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract GOZDECHARACTERS is ERC721Creator {
    constructor() ERC721Creator("Gozde - Characters", "GOZDECHARACTERS") {}
}