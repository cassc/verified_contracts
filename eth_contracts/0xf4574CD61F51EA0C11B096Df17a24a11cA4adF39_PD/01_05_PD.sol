// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PixelDinos
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////
//                                                    //
//                                                    //
//                                                    //
//      _____ _          _   _____  _                 //
//     |  __ (_)        | | |  __ \(_)                //
//     | |__) |__  _____| | | |  | |_ _ __   ___      //
//     |  ___/ \ \/ / _ \ | | |  | | | '_ \ / _ \     //
//     | |   | |>  <  __/ | | |__| | | | | | (_) |    //
//     |_|   |_/_/\_\___|_| |_____/|_|_| |_|\___/     //
//                                                    //
//                                                    //
//                                                    //
//                                                    //
//                                                    //
////////////////////////////////////////////////////////


contract PD is ERC721Creator {
    constructor() ERC721Creator("PixelDinos", "PD") {}
}