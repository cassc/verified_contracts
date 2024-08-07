// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: makeitrad || brawhaus
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                          //
//                                                                                                                                          //
//                      _        _ _                 _                                                                                      //
//      _ __ ___   __ _| | _____(_) |_ _ __ __ _  __| |                                                                                     //
//     | '_ ` _ \ / _` | |/ / _ \ | __| '__/ _` |/ _` |                                                                                     //
//     | | | | | | (_| |   <  __/ | |_| | | (_| | (_| |                                                                                     //
//     |_| |_| |_|\__,_|_|\_\___|_|\__|_|  \__,_|\__,_|                                                                                     //
//     | |__  _ __ __ ___      _| |__   __ _ _   _ ___                                                                                      //
//     | '_ \| '__/ _` \ \ /\ / / '_ \ / _` | | | / __|                                                                                     //
//     | |_) | | | (_| |\ V  V /| | | | (_| | |_| \__ \                                                                                     //
//     |_.__/|_|  \__,_| \_/\_/ |_| |_|\__,_|\__,_|___/                                                                                     //
//                                                                                                                                          //
//     +++++++++++++++makeitrad+brawhaus+++++++++++++++                                                                                     //
//                                                                                                                                          //
//                                                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract radb is ERC721Creator {
    constructor() ERC721Creator("makeitrad || brawhaus", "radb") {}
}