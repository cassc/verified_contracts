// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: testingtesting123
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                               //
//                                                                                                                               //
//      __                   __  .__                   __                   __  .__                  ____________  ________      //
//    _/  |_  ____   _______/  |_|__| ____    ____   _/  |_  ____   _______/  |_|__| ____    ____   /_   \_____  \ \_____  \     //
//    \   __\/ __ \ /  ___/\   __\  |/    \  / ___\  \   __\/ __ \ /  ___/\   __\  |/    \  / ___\   |   |/  ____/   _(__  <     //
//     |  | \  ___/ \___ \  |  | |  |   |  \/ /_/  >  |  | \  ___/ \___ \  |  | |  |   |  \/ /_/  >  |   /       \  /       \    //
//     |__|  \___  >____  > |__| |__|___|  /\___  /   |__|  \___  >____  > |__| |__|___|  /\___  /   |___\_______ \/______  /    //
//               \/     \/               \//_____/              \/     \/               \//_____/                \/       \/     //
//                                                                                                                               //
//                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract test123 is ERC721Creator {
    constructor() ERC721Creator("testingtesting123", "test123") {}
}