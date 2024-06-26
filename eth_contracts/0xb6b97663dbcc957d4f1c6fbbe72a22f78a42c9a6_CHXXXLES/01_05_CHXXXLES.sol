// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Checkles or Choggles?
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                                                                               //
//    _________   ___ _______________________  ____  __.____     ___________ _________           //
//    \_   ___ \ /   |   \_   _____/\_   ___ \|    |/ _|    |    \_   _____//   _____/           //
//    /    \  \//    ~    \    __)_ /    \  \/|      < |    |     |    __)_ \_____  \            //
//    \     \___\    Y    /        \\     \___|    |  \|    |___  |        \/        \           //
//     \______  /\___|_  /_______  / \______  /____|__ \_______ \/_______  /_______  /           //
//            \/       \/        \/         \/        \/       \/        \/        \/            //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//    _________   ___ ___ ________    ________  ________.____     ___________ _________          //
//    \_   ___ \ /   |   \\_____  \  /  _____/ /  _____/|    |    \_   _____//   _____/          //
//    /    \  \//    ~    \/   |   \/   \  ___/   \  ___|    |     |    __)_ \_____  \           //
//    \     \___\    Y    /    |    \    \_\  \    \_\  \    |___  |        \/        \          //
//     \______  /\___|_  /\_______  /\______  /\______  /_______ \/_______  /_______  /          //
//            \/       \/         \/        \/        \/        \/        \/        \/           //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//                                                                                               //
//    _____.___.________   ____ ___  ________  ____________________ .___________  ___________    //
//    \__  |   |\_____  \ |    |   \ \______ \ \_   _____/\_   ___ \|   \______ \ \_   _____/    //
//     /   |   | /   |   \|    |   /  |    |  \ |    __)_ /    \  \/|   ||    |  \ |    __)_     //
//     \____   |/    |    \    |  /   |    `   \|        \\     \___|   ||    `   \|        \    //
//     / ______|\_______  /______/   /_______  /_______  / \______  /___/_______  /_______  /    //
//     \/               \/                   \/        \/         \/            \/        \/     //
//                                                                                               //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


contract CHXXXLES is ERC1155Creator {
    constructor() ERC1155Creator("Checkles or Choggles?", "CHXXXLES") {}
}