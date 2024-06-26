// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: THE MAGICAL WORLD
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                        //
//                                                                                                                                                        //
//                                                                                                                                                        //
//                                                                                                                                                        //
//    ,--------.,--.  ,--.,------.    ,--.   ,--.  ,---.   ,----.   ,--. ,-----.  ,---.  ,--.       ,--.   ,--. ,-----. ,------. ,--.   ,------.          //
//    '--.  .--'|  '--'  ||  .---'    |   `.'   | /  O  \ '  .-./   |  |'  .--./ /  O  \ |  |       |  |   |  |'  .-.  '|  .--. '|  |   |  .-.  \         //
//       |  |   |  .--.  ||  `--,     |  |'.'|  ||  .-.  ||  | .---.|  ||  |    |  .-.  ||  |       |  |.'.|  ||  | |  ||  '--'.'|  |   |  |  \  :        //
//       |  |   |  |  |  ||  `---.    |  |   |  ||  | |  |'  '--'  ||  |'  '--'\|  | |  ||  '--.    |   ,'.   |'  '-'  '|  |\  \ |  '--.|  '--'  /        //
//       `--'   `--'  `--'`------'    `--'   `--'`--' `--' `------' `--' `-----'`--' `--'`-----'    '--'   '--' `-----' `--' '--'`-----'`-------'         //
//                                                                                                                                                        //
//                                                                                                                                                        //
//                                                                                                                                                        //
//                                                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Lavender is ERC1155Creator {
    constructor() ERC1155Creator("THE MAGICAL WORLD", "Lavender") {}
}