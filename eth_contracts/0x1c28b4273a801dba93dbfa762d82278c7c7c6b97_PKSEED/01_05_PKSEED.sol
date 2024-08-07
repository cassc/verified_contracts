// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Punkinz Seeds
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//     _______  __   __  __    _  ___   _  ___   __    _  _______     //
//    |       ||  | |  ||  |  | ||   | | ||   | |  |  | ||       |    //
//    |    _  ||  | |  ||   |_| ||   |_| ||   | |   |_| ||____   |    //
//    |   |_| ||  |_|  ||       ||      _||   | |       | ____|  |    //
//    |    ___||       ||  _    ||     |_ |   | |  _    || ______|    //
//    |   |    |       || | |   ||    _  ||   | | | |   || |_____     //
//    |___|    |_______||_|  |__||___| |_||___| |_|  |__||_______|    //
//     _______  _______  _______  ______   _______                    //
//    |       ||       ||       ||      | |       |                   //
//    |  _____||    ___||    ___||  _    ||  _____|                   //
//    | |_____ |   |___ |   |___ | | |   || |_____                    //
//    |_____  ||    ___||    ___|| |_|   ||_____  |                   //
//     _____| ||   |___ |   |___ |       | _____| |                   //
//    |_______||_______||_______||______| |_______|                   //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract PKSEED is ERC1155Creator {
    constructor() ERC1155Creator("Punkinz Seeds", "PKSEED") {}
}