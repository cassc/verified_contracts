// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Genesia Collector Badges
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//     _______  _______  __    _  _______  _______  ___   _______    _______  _______  ___      ___      _______  _______  _______  _______  ______      _______  _______  ______   _______  _______  _______     //
//    |       ||       ||  |  | ||       ||       ||   | |   _   |  |       ||       ||   |    |   |    |       ||       ||       ||       ||    _ |    |  _    ||   _   ||      | |       ||       ||       |    //
//    |    ___||    ___||   |_| ||    ___||  _____||   | |  |_|  |  |       ||   _   ||   |    |   |    |    ___||       ||_     _||   _   ||   | ||    | |_|   ||  |_|  ||  _    ||    ___||    ___||  _____|    //
//    |   | __ |   |___ |       ||   |___ | |_____ |   | |       |  |       ||  | |  ||   |    |   |    |   |___ |       |  |   |  |  | |  ||   |_||_   |       ||       || | |   ||   | __ |   |___ | |_____     //
//    |   ||  ||    ___||  _    ||    ___||_____  ||   | |       |  |      _||  |_|  ||   |___ |   |___ |    ___||      _|  |   |  |  |_|  ||    __  |  |  _   | |       || |_|   ||   ||  ||    ___||_____  |    //
//    |   |_| ||   |___ | | |   ||   |___  _____| ||   | |   _   |  |     |_ |       ||       ||       ||   |___ |     |_   |   |  |       ||   |  | |  | |_|   ||   _   ||       ||   |_| ||   |___  _____| |    //
//    |_______||_______||_|  |__||_______||_______||___| |__| |__|  |_______||_______||_______||_______||_______||_______|  |___|  |_______||___|  |_|  |_______||__| |__||______| |_______||_______||_______|    //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract GNSB is ERC721Creator {
    constructor() ERC721Creator("Genesia Collector Badges", "GNSB") {}
}