// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ETHs - Infinity Edition
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//      _____        __ _       _ _           ______    _ _ _   _                 //
//     |_   _|      / _(_)     (_) |         |  ____|  | (_) | (_)                //
//       | |  _ __ | |_ _ _ __  _| |_ _   _  | |__   __| |_| |_ _  ___  _ __      //
//       | | | '_ \|  _| | '_ \| | __| | | | |  __| / _` | | __| |/ _ \| '_ \     //
//      _| |_| | | | | | | | | | | |_| |_| | | |___| (_| | | |_| | (_) | | | |    //
//     |_____|_| |_|_| |_|_| |_|_|\__|\__, | |______\__,_|_|\__|_|\___/|_| |_|    //
//                                     __/ |                                      //
//                                    |___/                                       //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract ETHs is ERC721Creator {
    constructor() ERC721Creator("ETHs - Infinity Edition", "ETHs") {}
}