// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 20/12/22
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//    ________ ________       /\  ____________       /\ ________ ________      //
//    \_____  \\_____  \     / / /_   \_____  \     / / \_____  \\_____  \     //
//     /  ____/ /  ____/    / /   |   |/  ____/    / /   /  ____/ /  ____/     //
//    /       \/       \   / /    |   /       \   / /   /       \/       \     //
//    \_______ \_______ \ / /     |___\_______ \ / /    \_______ \_______ \    //
//            \/       \/ \/                  \/ \/             \/       \/    //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract VIS20 is ERC721Creator {
    constructor() ERC721Creator("20/12/22", "VIS20") {}
}