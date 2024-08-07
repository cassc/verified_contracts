// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Portraits of Life
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//    |    \  /   \ |    \ |      ||    \  /    ||    ||      | / ___/     /   \ |     |    | |    |    ||     | /  _]    //
//    |  o  )|     ||  D  )|      ||  D  )|  o  | |  | |      |(   \_     |     ||   __|    | |     |  | |   __|/  [_     //
//    |   _/ |  O  ||    / |_|  |_||    / |     | |  | |_|  |_| \__  |    |  O  ||  |_      | |___  |  | |  |_ |    _]    //
//    |  |   |     ||    \   |  |  |    \ |  _  | |  |   |  |   /  \ |    |     ||   _]     |     | |  | |   _]|   [_     //
//    |  |   |     ||  .  \  |  |  |  .  \|  |  | |  |   |  |   \    |    |     ||  |       |     | |  | |  |  |     |    //
//    |__|    \___/ |__|\_|  |__|  |__|\_||__|__||____|  |__|    \___|     \___/ |__|       |_____||____||__|  |_____|    //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract POL is ERC721Creator {
    constructor() ERC721Creator("Portraits of Life", "POL") {}
}