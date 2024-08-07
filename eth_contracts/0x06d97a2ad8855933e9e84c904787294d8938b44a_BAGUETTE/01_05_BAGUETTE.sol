// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BaguetteNFT
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                                                                           //
//       ______                             __     __) ________) ______)     //
//      (, /    )                          (, /|  /   (, /      (, /         //
//        /---(  _   _        _ _/__/_  _    / | /      /___,     /          //
//     ) / ____)(_(_(_/_(_(__(/_(__(___(/_) /  |/    ) /       ) /           //
//    (_/ (        .-/                   (_/   '    (_/       (_/            //
//                (_/                                                        //
//                                                                           //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


contract BAGUETTE is ERC721Creator {
    constructor() ERC721Creator("BaguetteNFT", "BAGUETTE") {}
}