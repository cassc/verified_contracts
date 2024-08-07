// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MushroomAnimals
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                                                                           //
//                                                                           //
//       ('-.     .-. .-')      ('-.                   ('-.   ) (`-.         //
//      ( OO ).-. \  ( OO )    ( OO ).-.             _(  OO)   ( OO ).       //
//      / . --. / ,--. ,--.    / . --. /  ,--.      (,------. (_/.  \_)-.    //
//      | \-.  \  |  .'   /    | \-.  \   |  |.-')   |  .---'  \  `.'  /     //
//    .-'-'  |  | |      /,  .-'-'  |  |  |  | OO )  |  |       \     /\     //
//     \| |_.'  | |     ' _)  \| |_.'  |  |  |`-' | (|  '--.     \   \ |     //
//      |  .-.  | |  .   \     |  .-.  | (|  '---.'  |  .--'    .'    \_)    //
//      |  | |  | |  |\   \    |  | |  |  |      |   |  `---.  /  .'.  \     //
//      `--' `--' `--' '--'    `--' `--'  `------'   `------' '--'   '--'    //
//                                                                           //
//                                                                           //
//                                                                           //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


contract AKMA is ERC1155Creator {
    constructor() ERC1155Creator("MushroomAnimals", "AKMA") {}
}