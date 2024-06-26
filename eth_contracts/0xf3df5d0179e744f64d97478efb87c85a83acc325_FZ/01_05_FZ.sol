// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Florian Zumbrunn 1/1s
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//    .---..                        .---.             .                           //
//    |    |         o                 /              |                           //
//    |--- | .-. .--..  .-.  .--.     /  .  . .--.--. |.-. .--..  . .--. .--.     //
//    |    |(   )|   | (   ) |  |    /   |  | |  |  | |   )|   |  | |  | |  |     //
//    '    `-`-' ' -' `-`-'`-'  `-  '---'`--`-'  '  `-'`-' '   `--`-'  `-'  `-    //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract FZ is ERC721Creator {
    constructor() ERC721Creator("Florian Zumbrunn 1/1s", "FZ") {}
}