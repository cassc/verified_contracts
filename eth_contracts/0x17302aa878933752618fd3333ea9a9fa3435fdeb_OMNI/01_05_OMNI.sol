// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Omnipotent Health and Fitness
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//                                                                          //
//                                                                          //
//              ▄▄▄▄▄██▄▄▄▄,                         ▄▄▄▄▄██▄▄▄▄▄           //
//          ,▄█████████████████▄,               ,▄█████████████████▄        //
//         █████████▀▀▀▀▀▀▀████████▄         ▄████████▀▀▀▀▀▀▀████████▄      //
//        ██████▀             ▀▀██████▄   ▄██████▀▀            `▀██████     //
//       ██████▌                  "▀█████████▀'                  ▐█████▌    //
//       ██████                     ,██████▄                     j██████    //
//       ▐██████                 ▄▄████▀▀▀████▄▄                 ██████▌    //
//        ▀██████▄,         ,▄▄██████▀     ▀██████▄▄,         ,▄██████▀     //
//         ▀█████████████████████▀▀           ▀▀█████████████████████▀      //
//           `▀██████████████▀▀-                  ▀▀██████████████▀`        //
//                 `▀▀▀▀"                               "▀▀▀▀`              //
//                                                                          //
//                                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////


contract OMNI is ERC721Creator {
    constructor() ERC721Creator("Omnipotent Health and Fitness", "OMNI") {}
}