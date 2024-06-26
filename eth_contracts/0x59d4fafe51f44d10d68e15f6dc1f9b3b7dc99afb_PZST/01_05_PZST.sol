// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Secret Thieves
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▀▄▓▀▓▀▌▐▄▌▐▌█▀▓█▌▄█▓▓▀█▀▓▀▌█▀▓▀▀▓▀▀▓▀▀▄▀▓▌▓████████████████    //
//        █████████████████▓╬▓▓▄▄▀ ▓▀ ▓▓▌▐▀▌▐▄▀▌▓▓▓▓ ▓ ▓ ─║ ▄▀ ▀▓ ▓▀▌▄▐▓▌▓████████████████    //
//        █████████████████▓╬▓▓▄▄██▄▓█▄▄█▓██▄▓█▌█▓▓▓▄▓▄▓▄▌█▄▓██▄▓▌▄▓▄▄█▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓▐▓▀▓▌▌▓▓▌▓▐▓▌▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓█████▓▓████████████████▓██████▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓█████████▓▓▓▓▓▓▓▓▓▓▓▓▓█████████▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╣▓▓▓▓▓█████████████████████████████████▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╣▓▓▓▓███████████████████████████████████▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓████████████████████████████████████▓▓▓▌▓████████████████    //
//        █████████████████▓╣▓▓▓▓▓████████████████▀▀███████████████▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓███████████░▒▒████████████▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓███████████▒▒▒███████████▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓██████▒▒▒▒▒▒▒▒▒▒▒▒▒▐█████▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓██▒▓▓▒▀██▒▒▒▒▒██▀▒╢▓▒██▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓██████▓╢╣╣▒╢╢╣▓██████▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓██▓▌▒█▓▓▓▓▓▌▒▒▒▒▓▓▓▓▓█▀▓▓██▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╣▓▓▓▓▓▓▓▓██▓█▓╬▓▒▒▒▒▒╫╨╣▒▒▒▒▒▓▓▓▓▓███▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓█▓▓█▌▒▒▒▒▒▀▓▀░▒▒▒▒╫██▓▓█▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓██████▒▒▒▀▀███▀▀▒▒▒▓█████▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▄▒▒░▀░▒▒▄▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▓▄▄▄▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▒░░▀▀░▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▓████████████████    //
//        █████████████████▓▒▓▀▓█▓▓▓▓▓▓▓▓▓▓█▀▓▓▄▄░░▒░▄▓▓█▓▓▓▓▓▓▓▓▓▓▓█▓▀▒▒╢████████████████    //
//        ████████████████▒╥╥░▓▓▓▒▒▀▀▀▀▀▀▒▒▒░░░░░█▀█▄██████▓▓▀▀▀▀▀▒▒▒▒▒▒░░║███████████████    //
//        ████████████████▓╦▓▒▒▒▒▒▒▒▒▒▒▒▒▒░░▄▄█▀▒▒░███████████▄░▒▒▒▒▒▒▒▒░▄▄███████████████    //
//        ████████████████▓▓╜▓▓▓▌▒▒▒▒▒░▄██████░░▒▒▀▀░░██████████▄░▄▄▓▓████████████████████    //
//        █████████████████▓▓▓▓▓▒░▄██████████▌▒▒▒▒▒▒▒░▄▄██████████████████████████████████    //
//        ██████████████████▓▓▓██████████████▌╣▒▒▒▒▒▒▒▒███████████████▒░░╠████████████████    //
//        ████████████████████████████████████▒▒▒▒▒▒▒▒╢███████████████▌▒▒▐████████████████    //
//        █████████████████████████████████████▒▒░░▒▒▒▒███████████████▌▒░╫████████████████    //
//        █████████████████▓▓▓╢███████████████▄███░▒▒▒▒▒██████████████▒░░▒████████████████    //
//        █████████████████▓╖╓▒▒███████████████▀░▒▒▒▒▒▒╢█████████████▒▒  ▒▀███████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract PZST is ERC721Creator {
    constructor() ERC721Creator("Secret Thieves", "PZST") {}
}