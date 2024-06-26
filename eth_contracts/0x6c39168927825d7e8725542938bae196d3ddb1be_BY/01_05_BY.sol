// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Bai yi
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//      _______   ________    ________      __  __   ________         //
//    /_______/\ /_______/\  /_______/\    /_/\/_/\ /_______/\        //
//    \::: _  \ \\::: _  \ \ \__.::._\/    \ \ \ \ \\__.::._\/        //
//     \::(_)  \/_\::(_)  \ \   \::\ \      \:\_\ \ \  \::\ \         //
//      \::  _  \ \\:: __  \ \  _\::\ \__    \::::_\/  _\::\ \__      //
//       \::(_)  \ \\:.\ \  \ \/__\::\__/\     \::\ \ /__\::\__/\     //
//        \_______\/ \__\/\__\/\________\/      \__\/ \________\/     //
//                                                                    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract BY is ERC721Creator {
    constructor() ERC721Creator("Bai yi", "BY") {}
}