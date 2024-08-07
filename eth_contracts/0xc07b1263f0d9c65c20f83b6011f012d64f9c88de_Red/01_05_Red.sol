// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Red as a girl
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                          //
//                                                                                                                          //
//        _______  ________   _______      ________  ________      ________      ________   ________  ________  _______     //
//      //       \/        \_/       \    /        \/        \    /        \    /        \ /        \/        \/       \    //
//     //        /         /         /   /         /        _/   /         /   /       __/_/       //         /        /    //
//    /        _/        _/         /   /         /-        /   /         /   /       / //         /        _/        /     //
//    \____/___/\________/\________/    \___/____/\________/    \___/____/    \________/ \________/\____/___/\________/     //
//                                                                                                                          //
//                                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Red is ERC721Creator {
    constructor() ERC721Creator("Red as a girl", "Red") {}
}