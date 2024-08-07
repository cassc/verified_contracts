// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Vessels ASH
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////
//                                          //
//                                          //
//                                          //
//                                          //
//                                          //
//                                          //
//                                          //
//                                          //
//                                          //
//    __      __                _           //
//     \ \    / /               | |         //
//      \ \  / /__  ___ ___  ___| |___      //
//       \ \/ / _ \/ __/ __|/ _ \ / __|     //
//        \  /  __/\__ \__ \  __/ \__ \     //
//         \/ \___||___/___/\___|_|___/     //
//                 /\    / ____| |  | |     //
//                /  \  | (___ | |__| |     //
//               / /\ \  \___ \|  __  |     //
//              / ____ \ ____) | |  | |     //
//             /_/    \_\_____/|_|  |_|     //
//                                          //
//                                          //
//                                          //
//////////////////////////////////////////////


contract Ves is ERC721Creator {
    constructor() ERC721Creator("Vessels ASH", "Ves") {}
}