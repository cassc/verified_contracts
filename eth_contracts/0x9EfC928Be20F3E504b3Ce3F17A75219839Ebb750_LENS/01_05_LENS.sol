// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Pure Shutter
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////
//                                                       //
//                                                       //
//                                                       //
//      ▄▄^▄███▄                                         //
//    ▄▀▀▀▀░▄▄▄░▀▀▀▀▄                                    //
//    █▒▒▒▒█░░░█▒▒▒▒█                                    //
//    █▒▒▒▒▀▄▄▄▀▒▒▒▒█                                    //
//    ▀▄▄▄▄▄▄▄▄▄▄▄▄▄▀                                    //
//       ____        __                                  //
//      / __/__  ___/ /__ ____                           //
//     / _// _ \/ _  / -_) __/                           //
//    /___/_//_/\_,_/\__/_/                    __        //
//     / ___/__  ______ _  ___ ___  ___  ___ _/ /_ __    //
//    / (_ / _ \/ __/  ' \/ -_) _ \/ _ \/ _ `/ / // /    //
//    \___/\___/\__/_/_/_/\__/_//_/\___/\_, /_/\_,_/     //
//        / __/_  __/ // /             /___/             //
//     _ / _/  / / / _  /                                //
//    (_)___/ /_/ /_//_/                                 //
//                                                       //
//                                                       //
//                                                       //
///////////////////////////////////////////////////////////


contract LENS is ERC721Creator {
    constructor() ERC721Creator("Pure Shutter", "LENS") {}
}