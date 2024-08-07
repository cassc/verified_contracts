// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Businessneeds
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//      _ )            _)                                              |                |    |          //
//      _ \  |  | (_-<  |    \    -_) (_-< (_-<    \    -_)   -_)   _` | (_-<      -_)   _|    \        //
//     ___/ \_,_| ___/ _| _| _| \___| ___/ ___/ _| _| \___| \___| \__,_| ___/ _) \___| \__| _| _|       //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Businessneeds is ERC721Creator {
    constructor() ERC721Creator("Businessneeds", "Businessneeds") {}
}