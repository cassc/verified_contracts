// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: obras gavin gamboa
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                              //
//                                                                                                              //
//             __                                         _                                __                   //
//      ____  / /_  _________ ______   ____ _____ __   __(_)___     ____ _____ _____ ___  / /_  ____  ____ _    //
//     / __ \/ __ \/ ___/ __ `/ ___/  / __ `/ __ `/ | / / / __ \   / __ `/ __ `/ __ `__ \/ __ \/ __ \/ __ `/    //
//    / /_/ / /_/ / /  / /_/ (__  )  / /_/ / /_/ /| |/ / / / / /  / /_/ / /_/ / / / / / / /_/ / /_/ / /_/ /     //
//    \____/_.___/_/   \__,_/____/   \__, /\__,_/ |___/_/_/ /_/   \__, /\__,_/_/ /_/ /_/_.___/\____/\__,_/      //
//                                  /____/                       /____/                                         //
//    https://gavart.ist/                                                                                       //
//    @gavcloud                                                                                                 //
//                                                                                                              //
//                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract OGG is ERC721Creator {
    constructor() ERC721Creator("obras gavin gamboa", "OGG") {}
}