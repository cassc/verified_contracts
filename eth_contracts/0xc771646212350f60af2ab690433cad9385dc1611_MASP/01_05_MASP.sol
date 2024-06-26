// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: M-ASpecialorder
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                     //
//                                                                                                                     //
//       _____   ____ ___________________    _______________________  .____    .______________ _______    _________    //
//      /     \ |    |   \__    ___/  _  \   \      \__    ___/  _  \ |    |   |   \_   _____/ \      \  /   _____/    //
//     /  \ /  \|    |   / |    | /  /_\  \  /   |   \|    | /  /_\  \|    |   |   ||    __)_  /   |   \ \_____  \     //
//    /    Y    \    |  /  |    |/    |    \/    |    \    |/    |    \    |___|   ||        \/    |    \/        \    //
//    \____|__  /______/   |____|\____|__  /\____|__  /____|\____|__  /_______ \___/_______  /\____|__  /_______  /    //
//            \/                         \/         \/              \/        \/           \/         \/        \/     //
//                                                                                                                     //
//                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MASP is ERC721Creator {
    constructor() ERC721Creator("M-ASpecialorder", "MASP") {}
}