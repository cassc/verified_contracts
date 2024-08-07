// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Oty Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//       ___  _           _____    _ _ _   _                                                  //
//      / _ \| |_ _   _  | ____|__| (_) |_(_) ___  _ __  ___                                  //
//     | | | | __| | | | |  _| / _` | | __| |/ _ \| '_ \/ __|                                 //
//     | |_| | |_| |_| | | |__| (_| | | |_| | (_) | | | \__ \                                 //
//      \___/ \__|\__, | |_____\__,_|_|\__|_|\___/|_| |_|___/                                 //
//                |___/                                                                       //
//                                                                                            //
//                                                                                            //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ██████████████████████████▀▀▀▀▀█████████████████████████████████████████████████    //
//        ███████████████████▒▒╢╢▓▓▓▓▓▓W╖,,    ▀▀█████████████████████████████████████████    //
//        ███████████████▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓@╖        ▀█████████████████████████████████████    //
//        ████████████╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╖.         ▀██████████████████████████████████    //
//        █████████▓▓▓█▓▓▓█▓████▓█▓▓▓▓▓▓▓▓▓▓▓╣@          ▀████████████████████████████████    //
//        ███████▓████▓▓▓███████▓██▓▓▓▓▓▓▓▓▓▓▓▓▓╦          ▀██████████████████████████████    //
//        ██████▓██████▓███████████▓▓▓▓▓▓█▓█▓▓▓▓╣@          ╙█████████████████████████████    //
//        ██████████▓███▓██████████▓▓▓▓▓▓████▓▓▓▓╣@, ,       '████████████████████████████    //
//        ████▓▓███▓▓▓▓███▓█▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░         ▐███████████████████████████    //
//        ███▓▓██████▓▓██▓▓▓▓▓▓▓▓▓▓▓▓█▓▓██▓▓▓▓▓██▓▓╣░          ███████████████████████████    //
//        ███▓████████▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▒`          ██████████████████████████    //
//        ██╢▓▓██████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣║▒           ██████████████████████████    //
//        ██▓▓▓███████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╢▓▓╣░           ██████████████████████████    //
//        ██▓▓▓▓███████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╢▓▓`           ██████████████████████████    //
//        ██▌▓▓▓▓█████████▓▓▓███▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓╬~           ██████████████████████████    //
//        ███▓▓▓▓▓▓████▓████▓█▓█▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓`          ███████████████████████████    //
//        ████▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓╣▓▓▓╣▒W         ╒███████████████████████████    //
//        █████▓▓▓▓▓▓▓▓▓████▓▓▓▓▓▓███▓▓▓▓╢╣▓▓▓▓▓╣╣▓µ─        ,████████████████████████████    //
//        ██████▓▓▓╢▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓╢╢╢╫╢╫╣╣╣▓▓▓▓▒        ▄█████████████████████████████    //
//        ███████▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╢╣╢╢╣╢╣▓╢╢╣╣╣        ███████████████████████████████    //
//        █████████▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓╣▓╢╢╢╢╣▓▓▓▓▓░      ▄████████████████████████████████    //
//        ████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣╢╣╢▓╫╣╣▓╣╣▒░   ,▄██████████████████████████████████    //
//        ███████████████╣▓▓▓▓▓▓▓▓▓▓▓▓╣╣╣╣╣╣╣╣╣▓╨  ▄▄█████████████████████████████████████    //
//        ███████████████████▓▒▓▓▓▓▓▓╣▓╣╢╣╢╢╢▒║▄▄█████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract OTYE is ERC1155Creator {
    constructor() ERC1155Creator() {}
}