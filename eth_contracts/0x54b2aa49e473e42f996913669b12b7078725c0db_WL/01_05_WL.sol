// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Women's Love
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    //
//                                                                                    //
//     __      __                          /\         .____                           //
//    /  \    /  \____   _____   ____   ___)/  ______ |    |    _______  __ ____      //
//    \   \/\/   /  _ \ /     \_/ __ \ /    \ /  ___/ |    |   /  _ \  \/ // __ \     //
//     \        (  <_> )  Y Y  \  ___/|   |  \\___ \  |    |__(  <_> )   /\  ___/     //
//      \__/\  / \____/|__|_|  /\___  >___|  /____  > |_______ \____/ \_/  \___  >    //
//           \/              \/     \/     \/     \/          \/               \/     //
//                                                                                    //
//                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////


contract WL is ERC1155Creator {
    constructor() ERC1155Creator("Women's Love", "WL") {}
}