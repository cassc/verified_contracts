// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Editions by Nathanael Billings
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                    _____    _ _ _   _                                                   //
//                   | ____|__| (_) |_(_) ___  _ __  ___                                   //
//                   |  _| / _` | | __| |/ _ \| '_ \/ __|                                  //
//                   | |__| (_| | | |_| | (_) | | | \__ \                                  //
//                   |_____\__,_|_|\__|_|\___/|_| |_|___/                                  //
//                               | |__  _   _                                              //
//                               | '_ \| | | |                                             //
//                               | |_) | |_| |                                             //
//      _   _       _   _        |_.__/ \__, |       _   ____  _ _ _ _                     //
//     | \ | | __ _| |_| |__   __ _ _ __|___/ _  ___| | | __ )(_) | (_)_ __   __ _ ___     //
//     |  \| |/ _` | __| '_ \ / _` | '_ \ / _` |/ _ \ | |  _ \| | | | | '_ \ / _` / __|    //
//     | |\  | (_| | |_| | | | (_| | | | | (_| |  __/ | | |_) | | | | | | | | (_| \__ \    //
//     |_| \_|\__,_|\__|_| |_|\__,_|_| |_|\__,_|\___|_| |____/|_|_|_|_|_| |_|\__, |___/    //
//                                                                           |___/         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract ENB is ERC721Creator {
    constructor() ERC721Creator("Editions by Nathanael Billings", "ENB") {}
}