// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 15 Merrimac
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//                                                                                //
//     ____ .________    _____                      .__                           //
//    /_   ||   ____/   /     \   __________________|__| _____ _____    ____      //
//     |   ||____  \   /  \ /  \_/ __ \_  __ \_  __ \  |/     \\__  \ _/ ___\     //
//     |   |/       \ /    Y    \  ___/|  | \/|  | \/  |  Y Y  \/ __ \\  \___     //
//     |___/______  / \____|__  /\___  >__|   |__|  |__|__|_|  (____  /\___  >    //
//                \/          \/     \/                      \/     \/     \/     //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract MMAC is ERC721Creator {
    constructor() ERC721Creator("15 Merrimac", "MMAC") {}
}