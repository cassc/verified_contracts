// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ASCiiBIRBS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                 _____   _____  _  _  ____  _____  _____   ____    _____     //
//         /\     / ____| / ____|(_)(_)|  _ \|_   _||  __ \ |  _ \  / ____|    //
//        /  \   | (___  | |      _  _ | |_) | | |  | |__) || |_) || (___      //
//       / /\ \   \___ \ | |     | || ||  _ <  | |  |  _  / |  _ <  \___ \     //
//      / ____ \  ____) || |____ | || || |_) |_| |_ | | \ \ | |_) | ____) |    //
//     /_/    \_\|_____/  \_____||_||_||____/|_____||_|  \_\|____/ |_____/     //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract ASCiiB is ERC721Creator {
    constructor() ERC721Creator("ASCiiBIRBS", "ASCiiB") {}
}