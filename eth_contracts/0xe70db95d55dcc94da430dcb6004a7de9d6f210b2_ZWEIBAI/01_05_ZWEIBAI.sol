// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ZWEIB OPTIK AI ART
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                                                                           //
//      ___ ___    ___  ___ _____ ___ _  __    _   ___     _   ___ _____     //
//     |_  ) _ )  / _ \| _ \_   _|_ _| |/ /   /_\ |_ _|   /_\ | _ \_   _|    //
//      / /| _ \ | (_) |  _/ | |  | || ' <   / _ \ | |   / _ \|   / | |      //
//     /___|___/  \___/|_|   |_| |___|_|\_\ /_/ \_\___| /_/ \_\_|_\ |_|      //
//                                                                           //
//                                                                           //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


contract ZWEIBAI is ERC721Creator {
    constructor() ERC721Creator("ZWEIB OPTIK AI ART", "ZWEIBAI") {}
}