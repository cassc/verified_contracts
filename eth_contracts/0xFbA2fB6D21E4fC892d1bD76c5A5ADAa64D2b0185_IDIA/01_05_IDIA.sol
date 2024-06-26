// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Interior design is art.
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////
//                                                                   //
//                                                                   //
//       ____    .-------.        .-''-.    ____..--'  ___    _      //
//     .'  __ `. |  _ _   \     .'_ _   \  |        |.'   |  | |     //
//    /   '  \  \| ( ' )  |    / ( ` )   ' |   .-'  '|   .'  | |     //
//    |___|  /  ||(_ o _) /   . (_ o _)  | |.-'.'   /.'  '_  | |     //
//       _.-`   || (_,_).' __ |  (_,_)___|    /   _/ '   ( \.-.|     //
//    .'   _    ||  |\ \  |  |'  \   .---.  .'._( )_ ' (`. _` /|     //
//    |  _( )_  ||  | \ `'   / \  `-'    /.'  (_'o._)| (_ (_) _)     //
//    \ (_ o _) /|  |  \    /   \       / |    (_,_)| \ /  . \ /     //
//     '.(_,_).' ''-'   `'-'     `'-..-'  |_________|  ``-'`-''      //
//                                                                   //
//                                                                   //
//                                                                   //
///////////////////////////////////////////////////////////////////////


contract IDIA is ERC721Creator {
    constructor() ERC721Creator("Interior design is art.", "IDIA") {}
}