// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mother of Madness
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//              ███████████▌    ██████████▀              ▀██████████     ███████████▌     //
//              ████████████   ▐█████████                  █████████▌   ▐███████████▌     //
//              ████████████   ▓████████▌        ▓█         █████████   ████████████▌     //
//              ████████████▌  █████████         ██▌        █████████   ████████████▌     //
//              █████████████  █████████        ▐██▌        █████████▌ ▐████████████▌     //
//              █████████████ ▐█████████        ▐██▌        ██████████ █████████████▌     //
//              ███████▌█████▌█████▌████        ▐██▌        ████▓█████ █████▐███████▌     //
//              ███████▌██████▐████ ████        ▐██▌        ████ █████▐█████▐███████▌     //
//              ███████▌▐█████ ████ ████        ▐██▌        ████ ████▌█████▌▐███████▌     //
//              ███████▌ █████▌███▌ ████        ▐██▌        ████ ▐███ █████ ▐███████▌     //
//              ███████▌ ██████▐██▌ ████        ▐██▌        ████  ███▐█████ ▐███████▌     //
//              ███████▌ ▐█████ ██  ████        ▐██▌        ████  ██▌▓████▌ ▐███████▌     //
//              ███████▌  █████▌██  ████        ▐██▌        ████  ▐█ █████▌ ▐███████▌     //
//              ███████▌  ██████▐▌  ████         ██         ████   █▐█████  ▐███████▌     //
//              ███████▌  ▐█████    █████                  █████   ▌▓█████  ▐███████▌     //
//              ███████▌   █████▌   ██████▄              ▄██████    █████▌  ▐███████▌     //
//                                                                                        //
//              ██ ▐█     ▐█ █                  █   ▐█▌ ██       ▐█                       //
//              ██ ██ ▓▌▀▌▐█ █▀█▌▐█▀█ █▀   ▓▌▀█ █   ▐██ ██ ▀▀█▌▓█▀█ █▀█▌▐█▀█▐█▀▀ █▀▀      //
//              █▐█▌█ █▌▐█▐█ █ ▐▌▐█▀▀ █    █▌▐█ █   ▐███▒█ █▀█▌▓▌ █ █ █▌██▀▀ ▄▀█ ▄▀█      //
//              ▀ ▀ ▀  ▀▀  ▀▀▀ ▐▀ ▀▀▀ ▀     ▀▀  ▀   ▐▀ ▀ ▀ ▀▀▀  ▀▀▀ ▀ ▀▀ ▀▀  ▀▀▀ ▀▀▀      //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract MOM is ERC1155Creator {
    constructor() ERC1155Creator("Mother of Madness", "MOM") {}
}