// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: COGCORP.ETH
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                           ██████████U                                      //
//                                           ██████████U                                      //
//                  ╒▄▄▄▄▄▄▄▄          j▄▄▄▄▄███████████▄▄▄▄▄          ▄▄▄▄▄▄▄▄▄              //
//                  ▐████████          ▐████████████████████▌          ████████▌              //
//             ,,,,,▐████████▄,,,,,,,,,▐████████████████████▌,,,,,,,,,,█████████,,,,,         //
//             ██████████████████████████████████████████████████████████████████████         //
//             ██████████████████████████████████████████████████████████████████████         //
//             ██████████████████████████████████████████████████████████████████████         //
//             ▀████████████████████████████████████████████████████████████████████▀         //
//                  ▐██████████████████████████████████████████████████████████▌              //
//                  ▐██████████████████████████████████████████████████████████▌              //
//                  ▐██████████████████████████████████████████████████████████▌              //
//                  ▐████████████████████▌                 ████████████████████▌              //
//             ▄▄▄▄▄█████████████████████▌                 █████████████████████▄▄▄▄▄         //
//             █████████████████████▀````                  `````█████████████████████         //
//        ,,,,,█████████████████████                            █████████████████████,,,,,    //
//        ██████████████████████████            THE             ██████████████████████████    //
//        ██████████████████████████            COG             ██████████████████████████    //
//        ██████████████████████████        CORPORATION         ██████████████████████████    //
//        ██████████████████████████                            ██████████████████████████    //
//        ▀▀▀▀▀█████████████████████                            █████████████████████▀▀▀▀▀    //
//             █████████████████████                            █████████████████████         //
//             ██████████████████████████h                 ██████████████████████████         //
//                  ▐████████████████████▌                 ████████████████████▌              //
//                  ▐████████████████████▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄████████████████████▌              //
//                  ▐██████████████████████████████████████████████████████████▌              //
//                  ▐██████████████████████████████████████████████████████████▌              //
//             ,▄▄▄▄▐███████████████████████████████████████████████████████████▄▄▄▄▄         //
//             ██████████████████████████████████████████████████████████████████████         //
//             ██████████████████████████████████████████████████████████████████████         //
//             ██████████████████████████████████████████████████████████████████████         //
//             ▀▀▀▀▀█████████▀▀▀▀▀▀▀▀▀▀██████████████████████▀▀▀▀▀▀▀▀▀▀█████████▀▀▀▀▀         //
//                  ▐████████          ▐████████████████████▌          ████████▌              //
//                  ▐████████          ▐████████████████████▌          ████████▌              //
//                                           ██████████U                                      //
//                                           ██████████U                                      //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract COGCORP is ERC721Creator {
    constructor() ERC721Creator("COGCORP.ETH", "COGCORP") {}
}