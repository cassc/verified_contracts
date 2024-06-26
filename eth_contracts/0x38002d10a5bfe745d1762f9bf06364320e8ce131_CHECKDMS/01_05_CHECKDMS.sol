// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Check DMs
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//       ,--.                                   ,--.            ,--.                               //
//     ,-|  | ,--,--.,--,--,  ,---.,--. ,--.    |  ,---.  ,---. |  | ,---.     ,--.,--. ,---.      //
//    ' .-. |' ,-.  ||      \| .-. |\  '  /     |  .-.  || .-. :|  || .-. |    |  ||  |(  .-'      //
//    \ `-' |\ '-'  ||  ||  |' '-' ' \   '      |  | |  |\   --.|  || '-' '    '  ''  '.-'  `)     //
//     `---'  `--`--'`--''--'.`-  /.-'  /       `--' `--' `----'`--'|  |-'      `----' `----'      //
//                           `---' `---'                            `--'                           //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract CHECKDMS is ERC721Creator {
    constructor() ERC721Creator("Check DMs", "CHECKDMS") {}
}