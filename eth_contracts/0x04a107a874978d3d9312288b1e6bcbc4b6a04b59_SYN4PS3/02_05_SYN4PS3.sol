// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Project:SYN-4PS3
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                              ▄██▄           ▀        //
//                                                                             ▀▀█▀▀          █   ▄▐    //
//                                                                            ▄▄█            ▄██▄▀      //
//               ████████ ▀██   ███ ███   ▐██           ▄██    ████████  ████████  ████████▄██▀         //
//               ██  ▐██  ▐██  ██▀ ▐███   ██           ██▀    ▐███  ███ ▐██   ██▀ ███   ███▀            //
//             ▐███   ▀   ▐██▄██▀  ████▌ ██▌         ▄██▀    ▄██▌  ▐██  ███   ▀▀      ▄███        ▄▀    //
//              ▐███▄     ▐████   ▐██▀██▐██         ▄██ ▐██ ▐███▄ ▄██▌   ████       ███▌    ▄▄█▀  ▄     //
//                ▀███     ██▀    ▐█▌▐████▌ █████  ██▀  ██   ███████▀     ▀███▌      ▀███▄██▀ ▀▀▀       //
//            ██   ███    ██▀    ▄██  ████        █████████ ███▌      ██▌  ▐██  ██▌  ▐████              //
//           ███▄▄▄██    ▐██     ██   ███             ▐██  ▐██▌      ▐██▄▄▄██▌ ▐██▄▄▄██▌                //
//           ▀▀▀▀▀▀▀▀    ▀▀▀    ▀▀▀   ▀▀▀             ▀▀▀  ▀▀▀       ▀▀▀▀▀▀▀▀  ▀█▀▀▀█▀▀                 //
//                                                                                     ▀▄               //
//                                                                                                      //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SYN4PS3 is ERC721Creator {
    constructor() ERC721Creator("Project:SYN-4PS3", "SYN4PS3") {}
}