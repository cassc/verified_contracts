// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: pepenati-test
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////
//                                                           //
//                                                           //
//                                               __  .__     //
//    ______   ____ ______   ____   ____ _____ _/  |_|__|    //
//    \____ \_/ __ \\____ \_/ __ \ /    \\__  \\   __\  |    //
//    |  |_> >  ___/|  |_> >  ___/|   |  \/ __ \|  | |  |    //
//    |   __/ \___  >   __/ \___  >___|  (____  /__| |__|    //
//    |__|        \/|__|        \/     \/     \/             //
//                                                           //
//                                                           //
///////////////////////////////////////////////////////////////


contract pepet is ERC1155Creator {
    constructor() ERC1155Creator("pepenati-test", "pepet") {}
}