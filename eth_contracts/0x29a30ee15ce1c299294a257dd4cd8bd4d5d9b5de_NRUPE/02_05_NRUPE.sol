// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NATIRUPE
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////
//                                                  //
//                                                  //
//                                                  //
//      _   _       _   _                           //
//     | \ | |     | | (_)                          //
//     |  \| | __ _| |_ _ _ __ _   _ _ __   ___     //
//     | . ` |/ _` | __| | '__| | | | '_ \ / _ \    //
//     | |\  | (_| | |_| | |  | |_| | |_) |  __/    //
//     |_| \_|\__,_|\__|_|_|   \__,_| .__/ \___|    //
//                                  | |             //
//                                  |_|             //
//                                                  //
//                                                  //
//                                                  //
//////////////////////////////////////////////////////


contract NRUPE is ERC721Creator {
    constructor() ERC721Creator("NATIRUPE", "NRUPE") {}
}