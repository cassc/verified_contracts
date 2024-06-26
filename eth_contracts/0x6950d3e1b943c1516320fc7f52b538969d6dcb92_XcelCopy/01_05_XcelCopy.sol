// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Xcel-Copy
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//                                                                                //
//    ██   ██  ██████ ███████ ██             ██████  ██████  ██████  ██    ██     //
//     ██ ██  ██      ██      ██            ██      ██    ██ ██   ██  ██  ██      //
//      ███   ██      █████   ██      █████ ██      ██    ██ ██████    ████       //
//     ██ ██  ██      ██      ██            ██      ██    ██ ██         ██        //
//    ██   ██  ██████ ███████ ███████        ██████  ██████  ██         ██        //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract XcelCopy is ERC1155Creator {
    constructor() ERC1155Creator("Xcel-Copy", "XcelCopy") {}
}