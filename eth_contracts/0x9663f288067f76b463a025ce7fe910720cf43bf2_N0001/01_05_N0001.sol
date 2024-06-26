// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NoSleep-DRES13-MARGE
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                                               //
//                                                                                                                                                                                                                                                                                               //
//             _             _            _            _             _            _            _        _      _             _            _           _           _          _                   _                       _   _         _                   _           _              _          //
//            /\ \     _    /\ \         / /\         _\ \          /\ \         /\ \         /\ \    /_/\    /\ \          /\ \         /\ \        /\ \        / /\       / /\               /\ \                     /\_\/\_\ _    / /\                /\ \        /\ \           /\ \        //
//           /  \ \   /\_\ /  \ \       / /  \       /\__ \        /  \ \       /  \ \       /  \ \   \ \ \   \ \_\        /  \ \____   /  \ \      /  \ \      / /  \     / /  \             /  \ \                   / / / / //\_\ / /  \              /  \ \      /  \ \         /  \ \       //
//          / /\ \ \_/ / // /\ \ \     / / /\ \__   / /_ \_\      / /\ \ \     / /\ \ \     / /\ \ \   \ \ \__/ / /       / /\ \_____\ / /\ \ \    / /\ \ \    / / /\ \__ /_/ /\ \           / /\ \ \                 /\ \/ \ \/ / // / /\ \            / /\ \ \    / /\ \_\       / /\ \ \      //
//         / / /\ \___/ // / /\ \ \   / / /\ \___\ / / /\/_/     / / /\ \_\   / / /\ \_\   / / /\ \_\   \ \__ \/_/       / / /\/___  // / /\ \_\  / / /\ \_\  / / /\ \___\\_\/\ \ \         / / /\ \ \    ____       /  \____\__/ // / /\ \ \          / / /\ \_\  / / /\/_/      / / /\ \_\     //
//        / / /  \/____// / /  \ \_\  \ \ \ \/___// / /         / /_/_ \/_/  / /_/_ \/_/  / / /_/ / /    \/_/\__/\      / / /   / / // / /_/ / / / /_/_ \/_/  \ \ \ \/___/     \ \ \        \/_//_\ \ \ /\____/\    / /\/________// / /  \ \ \        / / /_/ / / / / / ______   / /_/_ \/_/     //
//       / / /    / / // / /   / / /   \ \ \     / / /         / /____/\    / /____/\    / / /__\/ /      _/\/__\ \    / / /   / / // / /__\/ / / /____/\      \ \ \            \ \ \         __\___ \ \\/____\/   / / /\/_// / // / /___/ /\ \      / / /__\/ / / / / /\_____\ / /____/\        //
//      / / /    / / // / /   / / /_    \ \ \   / / / ____    / /\____\/   / /\____\/   / / /_____/      / _/_/\ \ \  / / /   / / // / /_____/ / /\____\/  _    \ \ \            \ \ \       / /\   \ \ \         / / /    / / // / /_____/ /\ \    / / /_____/ / / /  \/____ // /\____\/        //
//     / / /    / / // / /___/ / //_/\__/ / /  / /_/_/ ___/\ / / /______  / / /______  / / /            / / /   \ \ \ \ \ \__/ / // / /\ \ \  / / /______ /_/\__/ / /           __\ \ \___  / /_/____\ \ \       / / /    / / // /_________/\ \ \  / / /\ \ \  / / /_____/ / // / /______        //
//    / / /    / / // / /____\/ / \ \/___/ /  /_______/\__\// / /_______\/ / /_______\/ / /            / / /    /_/ /  \ \___\/ // / /  \ \ \/ / /_______\\ \/___/ /           /___\_\/__/\/__________\ \ \      \/_/    / / // / /_       __\ \_\/ / /  \ \ \/ / /______\/ // / /_______\       //
//    \/_/     \/_/ \/_________/   \_____\/   \_______\/    \/__________/\/__________/\/_/             \/_/     \_\/    \/_____/ \/_/    \_\/\/__________/ \_____\/            \_________\/\_____________\/              \/_/ \_\___\     /____/_/\/_/    \_\/\/___________/ \/__________/       //
//                                                                                                                                                                                                                                                                                               //
//                                                                                                                                                                                                                                                                                               //
//                                                                                                                                                                                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract N0001 is ERC1155Creator {
    constructor() ERC1155Creator("NoSleep-DRES13-MARGE", "N0001") {}
}