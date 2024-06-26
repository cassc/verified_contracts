// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: WANTED: Tolip the Rabbit
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                               //
//                                                                                                                               //
//             _        _          _             _                _            _            _              _          _          //
//            /\ \     /\ \       /\ \     _    /\ \             /\ \         /\ \         _\ \           /\ \       /\ \        //
//           /  \ \    \ \ \     /  \ \   /\_\ /  \ \____        \_\ \       /  \ \       /\__ \          \ \ \     /  \ \       //
//          / /\ \ \   /\ \_\   / /\ \ \_/ / // /\ \_____\       /\__ \     / /\ \ \     / /_ \_\         /\ \_\   / /\ \ \      //
//         / / /\ \_\ / /\/_/  / / /\ \___/ // / /\/___  /      / /_ \ \   / / /\ \ \   / / /\/_/        / /\/_/  / / /\ \_\     //
//        / /_/_ \/_// / /    / / /  \/____// / /   / / /      / / /\ \ \ / / /  \ \_\ / / /            / / /    / / /_/ / /     //
//       / /____/\  / / /    / / /    / / // / /   / / /      / / /  \/_// / /   / / // / /            / / /    / / /__\/ /      //
//      / /\____\/ / / /    / / /    / / // / /   / / /      / / /      / / /   / / // / / ____       / / /    / / /_____/       //
//     / / /   ___/ / /__  / / /    / / / \ \ \__/ / /      / / /      / / /___/ / // /_/_/ ___/\ ___/ / /__  / / /              //
//    / / /   /\__\/_/___\/ / /    / / /   \ \___\/ /      /_/ /      / / /____\/ //_______/\__\//\__\/_/___\/ / /               //
//    \/_/    \/_________/\/_/     \/_/     \/_____/       \_\/       \/_________/ \_______\/    \/_________/\/_/                //
//                                                                                                                               //
//                                                                                                                               //
//                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TOLIP is ERC1155Creator {
    constructor() ERC1155Creator("WANTED: Tolip the Rabbit", "TOLIP") {}
}