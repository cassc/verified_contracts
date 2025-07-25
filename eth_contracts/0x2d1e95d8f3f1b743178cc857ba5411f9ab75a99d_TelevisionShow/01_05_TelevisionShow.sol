// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TelevisionShow
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
//                                                                                                    //
//    ___________    .__              .__       .__                _________.__                       //
//    \__    ___/___ |  |   _______  _|__| _____|__| ____   ____  /   _____/|  |__   ______  _  __    //
//      |    |_/ __ \|  | _/ __ \  \/ /  |/  ___/  |/  _ \ /    \ \_____  \ |  |  \ /  _ \ \/ \/ /    //
//      |    |\  ___/|  |_\  ___/\   /|  |\___ \|  (  <_> )   |  \/        \|   Y  (  <_> )     /     //
//      |____| \___  >____/\___  >\_/ |__/____  >__|\____/|___|  /_______  /|___|  /\____/ \/\_/      //
//                 \/          \/             \/               \/        \/      \/                   //
//                                                                                                    //
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TelevisionShow is ERC721Creator {
    constructor() ERC721Creator("TelevisionShow", "TelevisionShow") {}
}