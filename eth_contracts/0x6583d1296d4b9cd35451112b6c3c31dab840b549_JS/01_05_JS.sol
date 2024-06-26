// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jared Savino
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//                                                                               //
//       ___                        _   _____                _                   //
//      |_  |                      | | /  ___|              (_)                  //
//        | |  __ _  _ __  ___   __| | \ `--.   __ _ __   __ _  _ __    ___      //
//        | | / _` || '__|/ _ \ / _` |  `--. \ / _` |\ \ / /| || '_ \  / _ \     //
//    /\__/ /| (_| || |  |  __/| (_| | /\__/ /| (_| | \ V / | || | | || (_) |    //
//    \____/  \__,_||_|   \___| \__,_| \____/  \__,_|  \_/  |_||_| |_| \___/     //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract JS is ERC721Creator {
    constructor() ERC721Creator("Jared Savino", "JS") {}
}