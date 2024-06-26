// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mastermind
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//                                                                  //
//     _  _   __   ____  ____  ____  ____  _  _  __  __ _  ____     //
//    ( \/ )// _\// ___)(_  _)(  __)(  _ \( \/ )(  )(  ( \(    \    //
//    / \/ \/    \\___ \  )(   ) _)  )   // \/ \ )( /    / ) D (    //
//    \_)(_/\_/\_/(____/ (__) (____)(__\_)\_)(_/(__)\_)__)(____/    //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract MSTR is ERC721Creator {
    constructor() ERC721Creator("Mastermind", "MSTR") {}
}