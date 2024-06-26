// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Nvrndr Editions
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//          ___                        ___           ___          _____          ___         //
//         /__/\          ___         /  /\         /__/\        /  /::\        /  /\        //
//         \  \:\        /__/\       /  /::\        \  \:\      /  /:/\:\      /  /::\       //
//          \  \:\       \  \:\     /  /:/\:\        \  \:\    /  /:/  \:\    /  /:/\:\      //
//      _____\__\:\       \  \:\   /  /:/~/:/    _____\__\:\  /__/:/ \__\:|  /  /:/~/:/      //
//     /__/::::::::\  ___  \__\:\ /__/:/ /:/___ /__/::::::::\ \  \:\ /  /:/ /__/:/ /:/___    //
//     \  \:\~~\~~\/ /__/\ |  |:| \  \:\/:::::/ \  \:\~~\~~\/  \  \:\  /:/  \  \:\/:::::/    //
//      \  \:\  ~~~  \  \:\|  |:|  \  \::/~~~~   \  \:\  ~~~    \  \:\/:/    \  \::/~~~~     //
//       \  \:\       \  \:\__|:|   \  \:\        \  \:\         \  \::/      \  \:\         //
//        \  \:\       \__\::::/     \  \:\        \  \:\         \__\/        \  \:\        //
//         \__\/           ~~~~       \__\/         \__\/                       \__\/        //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract NVRNDR is ERC721Creator {
    constructor() ERC721Creator("Nvrndr Editions", "NVRNDR") {}
}