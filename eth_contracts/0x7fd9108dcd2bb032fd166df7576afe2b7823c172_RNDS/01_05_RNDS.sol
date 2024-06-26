// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: RendShots
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//    __________                   .____________.__            __              //
//    \______   \ ____   ____    __| _/   _____/|  |__   _____/  |_  ______    //
//     |       _// __ \ /    \  / __ |\_____  \ |  |  \ /  _ \   __\/  ___/    //
//     |    |   \  ___/|   |  \/ /_/ |/        \|   Y  (  <_> )  |  \___ \     //
//     |____|_  /\___  >___|  /\____ /_______  /|___|  /\____/|__| /____  >    //
//            \/     \/     \/      \/       \/      \/                 \/     //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract RNDS is ERC1155Creator {
    constructor() ERC1155Creator("RendShots", "RNDS") {}
}