// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: CameoVTS 1 of 1s
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//                                                                                      //
//      _____    _____    __    __    _____   _____     _     _   _______   ______      //
//     /\ __/\  /\___/\  /_/\  /\_\ /\_____\ ) ___ (   /_/\ /\_\/\_______)\/ ____/\     //
//     ) )__\/ / / _ \ \ ) ) \/ ( (( (_____// /\_/\ \  ) ) ) ( (\(___  __\/) ) __\/     //
//    / / /    \ \(_)/ //_/ \  / \_\\ \__\ / /_/ (_\ \/_/ / \ \_\ / / /     \ \ \       //
//    \ \ \_   / / _ \ \\ \ \\// / // /__/_\ \ )_/ / /\ \ \_/ / /( ( (      _\ \ \      //
//     ) )__/\( (_( )_) ))_) )( (_(( (_____\\ \/_\/ /  \ \   / /  \ \ \    )____) )     //
//     \/___\/ \/_/ \_\/ \_\/  \/_/ \/_____/ )_____(    \_\_/_/   /_/_/    \____\/      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract CAMEO is ERC721Creator {
    constructor() ERC721Creator("CameoVTS 1 of 1s", "CAMEO") {}
}