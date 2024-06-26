// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TOXICOIN
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////
//                                                              //
//                                                              //
//                                                              //
//        __  ______  ____  __   __________ _  __ __________    //
//       / / / / __ \/ /\ \/ /  /_  __/ __ \ |/ //  _/ ____/    //
//      / /_/ / / / / /  \  /    / / / / / /   / / // /         //
//     / __  / /_/ / /___/ /    / / / /_/ /   |_/ // /___       //
//    /_/ /_/\____/_____/_/    /_/  \____/_/|_/___/\____/       //
//                                                              //
//                                                              //
//                                                              //
//                                                              //
//////////////////////////////////////////////////////////////////


contract TXCOIN is ERC1155Creator {
    constructor() ERC1155Creator("TOXICOIN", "TXCOIN") {}
}