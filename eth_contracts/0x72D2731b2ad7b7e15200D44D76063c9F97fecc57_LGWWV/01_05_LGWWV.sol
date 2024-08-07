// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Little Girl Warriors World View
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//    ,---.    ,---.    .-''-.    .-_'''-.     ___    _ ,---.    ,---..-./`) ,---.   .--.     //
//    |    \  /    |  .'_ _   \  '_( )_   \  .'   |  | ||    \  /    |\ .-.')|    \  |  |     //
//    |  ,  \/  ,  | / ( ` )   '|(_ o _)|  ' |   .'  | ||  ,  \/  ,  |/ `-' \|  ,  \ |  |     //
//    |  |\_   /|  |. (_ o _)  |. (_,_)/___| .'  '_  | ||  |\_   /|  | `-'`"`|  |\_ \|  |     //
//    |  _( )_/ |  ||  (_,_)___||  |  .-----.'   ( \.-.||  _( )_/ |  | .---. |  _( )_\  |     //
//    | (_ o _) |  |'  \   .---.'  \  '-   .'' (`. _` /|| (_ o _) |  | |   | | (_ o _)  |     //
//    |  (_,_)  |  | \  `-'    / \  `-'`   | | (_ (_) _)|  (_,_)  |  | |   | |  (_,_)\  |     //
//    |  |      |  |  \       /   \        /  \ /  . \ /|  |      |  | |   | |  |    |  |     //
//    '--'      '--'   `'-..-'     `'-...-'    ``-'`-'' '--'      '--' '---' '--'    '--'     //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract LGWWV is ERC721Creator {
    constructor() ERC721Creator("Little Girl Warriors World View", "LGWWV") {}
}