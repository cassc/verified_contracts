// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Flora Mortis
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//     ,__   .                                               .                //
//     /  `  |     __.  .___    ___  , _ , _     __.  .___  _/_   `   ____    //
//     |__   |   .'   \ /   \  /   ` |' `|' `. .'   \ /   \  |    |  (        //
//     |     |   |    | |   ' |    | |   |   | |    | |   '  |    |  `--.     //
//     |    /\__  `._.' /     `.__/| /   '   /  `._.' /      \__/ / \___.'    //
//     /                                                                      //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


contract FLM is ERC721Creator {
    constructor() ERC721Creator("Flora Mortis", "FLM") {}
}