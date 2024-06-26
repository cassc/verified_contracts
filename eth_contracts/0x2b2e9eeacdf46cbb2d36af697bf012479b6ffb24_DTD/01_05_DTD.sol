// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Desaturated
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//                                                                                                //
//     ______  _______ _______ _______ _______ _     _  ______ _______ _______ _______ ______     //
//     |     \ |______ |______ |_____|    |    |     | |_____/ |_____|    |    |______ |     \    //
//     |_____/ |______ ______| |     |    |    |_____| |    \_ |     |    |    |______ |_____/    //
//                                                                                                //
//                                                                                                //
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////


contract DTD is ERC721Creator {
    constructor() ERC721Creator("Desaturated", "DTD") {}
}