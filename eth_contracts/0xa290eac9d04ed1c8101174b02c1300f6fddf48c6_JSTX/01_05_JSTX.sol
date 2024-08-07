// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: John Stocks
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////
//                                                               //
//                                                               //
//                                                               //
//          _       _           ____  _             _            //
//         | | ___ | |__  _ __ / ___|| |_ ___   ___| | _____     //
//      _  | |/ _ \| '_ \| '_ \\___ \| __/ _ \ / __| |/ / __|    //
//     | |_| | (_) | | | | | | |___) | || (_) | (__|   <\__ \    //
//      \___/ \___/|_| |_|_| |_|____/ \__\___/ \___|_|\_\___/    //
//                                                               //
//                                                               //
//                                                               //
//                                                               //
///////////////////////////////////////////////////////////////////


contract JSTX is ERC721Creator {
    constructor() ERC721Creator("John Stocks", "JSTX") {}
}