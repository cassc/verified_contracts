// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: WINTER IS COMING
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////
//                                                                           //
//                                                                           //
//           __           __         .__    .__  .__       .__     __        //
//      _____|  | __ _____/  |_  ____ |  |__ |  | |__| ____ |  |___/  |_     //
//     /  ___/  |/ // __ \   __\/ ___\|  |  \|  | |  |/ ___\|  |  \   __\    //
//     \___ \|    <\  ___/|  | \  \___|   Y  \  |_|  / /_/  >   Y  \  |      //
//    /____  >__|_ \\___  >__|  \___  >___|  /____/__\___  /|___|  /__|      //
//         \/     \/    \/          \/     \/       /_____/      \/          //
//                                                                           //
//                                                                           //
///////////////////////////////////////////////////////////////////////////////


contract WIC is ERC721Creator {
    constructor() ERC721Creator("WINTER IS COMING", "WIC") {}
}