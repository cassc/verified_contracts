// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Sims
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////
//                                                      //
//                                                      //
//                                                      //
//      _______ _             _____ _                   //
//     |__   __| |           / ____(_)                  //
//        | |  | |__   ___  | (___  _ _ __ ___  ___     //
//        | |  | '_ \ / _ \  \___ \| | '_ ` _ \/ __|    //
//        | |  | | | |  __/  ____) | | | | | | \__ \    //
//        |_|  |_| |_|\___| |_____/|_|_| |_| |_|___/    //
//                                                      //
//                                                      //
//                                                      //
//                                                      //
//                                                      //
//////////////////////////////////////////////////////////


contract SIMS is ERC721Creator {
    constructor() ERC721Creator("The Sims", "SIMS") {}
}