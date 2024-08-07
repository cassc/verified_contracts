// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 1055pm
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////
//                                                        //
//                                                        //
//     ___________   .________.________                   //
//    /_   \   _  \  |   ____/|   ____/_____   _____      //
//     |   /  /_\  \ |____  \ |____  \\____ \ /     \     //
//     |   \  \_/   \/       \/       \  |_> >  Y Y  \    //
//     |___|\_____  /______  /______  /   __/|__|_|  /    //
//                \/       \/       \/|__|         \/     //
//                                                        //
//                                                        //
////////////////////////////////////////////////////////////


contract TFFPM is ERC1155Creator {
    constructor() ERC1155Creator("1055pm", "TFFPM") {}
}