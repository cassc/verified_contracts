// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Builders
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//     _______   ____  ____   __    ___       ________    _______   _______    ________      //
//    |   _  "\ ("  _||_ " | |" \  |"  |     |"      "\  /"     "| /"      \  /"       )     //
//    (. |_)  :)|   (  ) : | ||  | ||  |     (.  ___  :)(: ______)|:        |(:   \___/      //
//    |:     \/ (:  |  | . ) |:  | |:  |     |: \   ) || \/    |  |_____/   ) \___  \        //
//    (|  _  \\  \\ \__/ //  |.  |  \  |___  (| (___\ || // ___)_  //      /   __/  \\       //
//    |: |_)  :) /\\ __ //\  /\  |\( \_|:  \ |:       :)(:      "||:  __   \  /" \   :)      //
//    (_______/ (__________)(__\_|_)\_______)(________/  \_______)|__|  \___)(_______/       //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract BLDRS is ERC721Creator {
    constructor() ERC721Creator("Builders", "BLDRS") {}
}