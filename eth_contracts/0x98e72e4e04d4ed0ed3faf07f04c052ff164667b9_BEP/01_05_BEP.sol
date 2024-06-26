// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: beeple parody
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                 //
//                                                                                                                                                                                 //
//                                                                                                                                                                                 //
//               _               _            _            _          _             _            _          _                   _           _            _        _        _       //
//              / /\            /\ \         /\ \         /\ \       _\ \          /\ \         /\ \       / /\                /\ \        /\ \         /\ \     /\ \     /\_\     //
//             / /  \          /  \ \       /  \ \       /  \ \     /\__ \        /  \ \       /  \ \     / /  \              /  \ \      /  \ \       /  \ \____\ \ \   / / /     //
//            / / /\ \        / /\ \ \     / /\ \ \     / /\ \ \   / /_ \_\      / /\ \ \     / /\ \ \   / / /\ \            / /\ \ \    / /\ \ \     / /\ \_____\\ \ \_/ / /      //
//           / / /\ \ \      / / /\ \_\   / / /\ \_\   / / /\ \_\ / / /\/_/     / / /\ \_\   / / /\ \_\ / / /\ \ \          / / /\ \_\  / / /\ \ \   / / /\/___  / \ \___/ /       //
//          / / /\ \_\ \    / /_/_ \/_/  / /_/_ \/_/  / / /_/ / // / /         / /_/_ \/_/  / / /_/ / // / /  \ \ \        / / /_/ / / / / /  \ \_\ / / /   / / /   \ \ \_/        //
//         / / /\ \ \___\  / /____/\    / /____/\    / / /__\/ // / /         / /____/\    / / /__\/ // / /___/ /\ \      / / /__\/ / / / /   / / // / /   / / /     \ \ \         //
//        / / /  \ \ \__/ / /\____\/   / /\____\/   / / /_____// / / ____    / /\____\/   / / /_____// / /_____/ /\ \    / / /_____/ / / /   / / // / /   / / /       \ \ \        //
//       / / /____\_\ \  / / /______  / / /______  / / /      / /_/_/ ___/\ / / /______  / / /      / /_________/\ \ \  / / /\ \ \  / / /___/ / / \ \ \__/ / /         \ \ \       //
//      / / /__________\/ / /_______\/ / /_______\/ / /      /_______/\__\// / /_______\/ / /      / / /_       __\ \_\/ / /  \ \ \/ / /____\/ /   \ \___\/ /           \ \_\      //
//      \/_____________/\/__________/\/__________/\/_/       \_______\/    \/__________/\/_/       \_\___\     /____/_/\/_/    \_\/\/_________/     \/_____/             \/_/      //
//                                                                                                                                                                                 //
//                                                                                                                                                                                 //
//                                                                                                                                                                                 //
//                                                                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BEP is ERC1155Creator {
    constructor() ERC1155Creator("beeple parody", "BEP") {}
}