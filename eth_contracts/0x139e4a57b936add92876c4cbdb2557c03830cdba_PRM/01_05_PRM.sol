// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Praemium
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//                                          _                     _              ____    _        //
//      _ __   _ __  __ _   ___  _ __ ___  (_) _   _  _ __ ___   | |__   _   _  |  _ \  / \       //
//     | '_ \ | '__|/ _` | / _ \| '_ ` _ \ | || | | || '_ ` _ \  | '_ \ | | | | | |_) |/ _ \      //
//     | |_) || |  | (_| ||  __/| | | | | || || |_| || | | | | | | |_) || |_| | |  __// ___ \     //
//     | .__/ |_|   \__,_| \___||_| |_| |_||_| \__,_||_| |_| |_| |_.__/  \__, | |_|  /_/   \_\    //
//     |_|                                                               |___/                    //
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////


contract PRM is ERC1155Creator {
    constructor() ERC1155Creator("Praemium", "PRM") {}
}