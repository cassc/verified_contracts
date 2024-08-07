// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: IsayevArt
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//    /////////////////////////////////////////////////////////////////////////////////    //
//    //                                                                             //    //
//    //                                                                             //    //
//    //      _____  _____     __     __________      __           _____ _______     //    //
//    //     |_   _|/ ____|  /\\ \   / /  ____\ \    / /     /\   |  __ \__   __|    //    //
//    //       | | | (___   /  \\ \_/ /| |__   \ \  / /     /  \  | |__) | | |       //    //
//    //       | |  \___ \ / /\ \\   / |  __|   \ \/ /     / /\ \ |  _  /  | |       //    //
//    //      _| |_ ____) / ____ \| |  | |____   \  /     / ____ \| | \ \  | |       //    //
//    //     |_____|_____/_/    \_\_|  |______|   \/     /_/    \_\_|  \_\ |_|       //    //
//    //                                                                             //    //
//    //                                                                             //    //
//    //                                                                             //    //
//    //                                                                             //    //
//    /////////////////////////////////////////////////////////////////////////////////    //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract ISYV is ERC721Creator {
    constructor() ERC721Creator("IsayevArt", "ISYV") {}
}