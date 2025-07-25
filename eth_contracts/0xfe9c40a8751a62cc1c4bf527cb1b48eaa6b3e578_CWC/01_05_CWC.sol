// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Checkwork
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                         //
//                                                                                                         //
//    ________   ____ ______________ ____________________.___________    _______                           //
//    \_____  \ |    |   \_   _____//   _____/\__    ___/|   \_____  \   \      \                          //
//     /  / \  \|    |   /|    __)_ \_____  \   |    |   |   |/   |   \  /   |   \                         //
//    /   \_/.  \    |  / |        \/        \  |    |   |   /    |    \/    |    \                        //
//    \_____\ \_/______/ /_______  /_______  /  |____|   |___\_______  /\____|__  /                        //
//           \__>                \/        \/                        \/         \/                         //
//    _______________   ______________________________.___.______________ ___ .___ _______    ________     //
//    \_   _____/\   \ /   /\_   _____/\______   \__  |   |\__    ___/   |   \|   |\      \  /  _____/     //
//     |    __)_  \   Y   /  |    __)_  |       _//   |   |  |    | /    ~    \   |/   |   \/   \  ___     //
//     |        \  \     /   |        \ |    |   \\____   |  |    | \    Y    /   /    |    \    \_\  \    //
//    /_______  /   \___/   /_______  / |____|_  // ______|  |____|  \___|_  /|___\____|__  /\______  /    //
//            \/                    \/         \/ \/                       \/             \/        \/     //
//                                                                                                         //
//                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CWC is ERC721Creator {
    constructor() ERC721Creator("The Checkwork", "CWC") {}
}