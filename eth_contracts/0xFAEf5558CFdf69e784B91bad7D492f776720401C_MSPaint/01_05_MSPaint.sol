// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MS Paint & Me
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////
//                                                                 //
//                                                                 //
//       _____    _________ __________        .__        __        //
//      /     \  /   _____/ \______   \_____  |__| _____/  |_      //
//     /  \ /  \ \_____  \   |     ___/\__  \ |  |/    \   __\     //
//    /    Y    \/        \  |    |     / __ \|  |   |  \  |       //
//    \____|__  /_______  /  |____|    (____  /__|___|  /__|       //
//            \/        \/                  \/        \/           //
//                                                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////


contract MSPaint is ERC721Creator {
    constructor() ERC721Creator("MS Paint & Me", "MSPaint") {}
}