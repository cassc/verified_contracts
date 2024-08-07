// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Trick Or Treat?
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//                                                                     //
//    ██   ██ ██ ██      ██      ██  █████  ███    ██                  //
//    ██  ██  ██ ██      ██      ██ ██   ██ ████   ██                  //
//    █████   ██ ██      ██      ██ ███████ ██ ██  ██                  //
//    ██  ██  ██ ██      ██      ██ ██   ██ ██  ██ ██                  //
//    ██   ██ ██ ███████ ███████ ██ ██   ██ ██   ████                  //
//                                                                     //
//                                                                     //
//    ███    ███  ██████   ██████  ██████  ███████                     //
//    ████  ████ ██    ██ ██    ██ ██   ██ ██                          //
//    ██ ████ ██ ██    ██ ██    ██ ██████  █████       █████           //
//    ██  ██  ██ ██    ██ ██    ██ ██   ██ ██                          //
//    ██      ██  ██████   ██████  ██   ██ ███████                     //
//                                                                     //
//                                                                     //
//    ████████ ██████  ██  ██████ ██   ██      ██████  ██████          //
//       ██    ██   ██ ██ ██      ██  ██      ██    ██ ██   ██         //
//       ██    ██████  ██ ██      █████       ██    ██ ██████          //
//       ██    ██   ██ ██ ██      ██  ██      ██    ██ ██   ██         //
//       ██    ██   ██ ██  ██████ ██   ██      ██████  ██   ██         //
//                                                                     //
//                                                                     //
//    ████████ ██████  ███████  █████  ████████                        //
//       ██    ██   ██ ██      ██   ██    ██                           //
//       ██    ██████  █████   ███████    ██                           //
//       ██    ██   ██ ██      ██   ██    ██                           //
//       ██    ██   ██ ███████ ██   ██    ██                           //
//                                                                     //
//                                                                     //
//                                                                     //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


contract TOT is ERC721Creator {
    constructor() ERC721Creator("Trick Or Treat?", "TOT") {}
}