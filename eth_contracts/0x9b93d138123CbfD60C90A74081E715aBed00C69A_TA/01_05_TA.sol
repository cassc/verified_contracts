// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Auction
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//     _______  __   __  _______    _______  __   __  _______  _______  ___   _______  __    _     //
//    |       ||  | |  ||       |  |   _   ||  | |  ||       ||       ||   | |       ||  |  | |    //
//    |_     _||  |_|  ||    ___|  |  |_|  ||  | |  ||       ||_     _||   | |   _   ||   |_| |    //
//      |   |  |       ||   |___   |       ||  |_|  ||       |  |   |  |   | |  | |  ||       |    //
//      |   |  |       ||    ___|  |       ||       ||      _|  |   |  |   | |  |_|  ||  _    |    //
//      |   |  |   _   ||   |___   |   _   ||       ||     |_   |   |  |   | |       || | |   |    //
//      |___|  |__| |__||_______|  |__| |__||_______||_______|  |___|  |___| |_______||_|  |__|    //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract TA is ERC721Creator {
    constructor() ERC721Creator("The Auction", "TA") {}
}