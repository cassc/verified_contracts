// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Westward
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////
//                                                                      //
//                                                                      //
//     __      __                 __                            .___    //
//    /  \    /  \ ____   _______/  |___  _  _______ _______  __| _/    //
//    \   \/\/   // __ \ /  ___/\   __\ \/ \/ /\__  \\_  __ \/ __ |     //
//     \        /\  ___/ \___ \  |  |  \     /  / __ \|  | \/ /_/ |     //
//      \__/\  /  \___  >____  > |__|   \/\_/  (____  /__|  \____ |     //
//           \/       \/     \/                     \/           \/     //
//                                                                      //
//                                                                      //
//////////////////////////////////////////////////////////////////////////


contract WST is ERC721Creator {
    constructor() ERC721Creator("Westward", "WST") {}
}