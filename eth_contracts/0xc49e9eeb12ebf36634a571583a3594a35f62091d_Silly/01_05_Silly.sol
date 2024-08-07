// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Silly Clowns
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////
//                                                                     //
//                                                                     //
//                                                                     //
//           .__.__  .__                 .__                           //
//      _____|__|  | |  | ___.__.   ____ |  |   ______  _  ______      //
//     /  ___/  |  | |  |<   |  | _/ ___\|  |  /  _ \ \/ \/ /    \     //
//     \___ \|  |  |_|  |_\___  | \  \___|  |_(  <_> )     /   |  \    //
//    /____  >__|____/____/ ____|  \___  >____/\____/ \/\_/|___|  /    //
//         \/             \/           \/                       \/     //
//                                                                     //
//                                                                     //
//                                                                     //
/////////////////////////////////////////////////////////////////////////


contract Silly is ERC1155Creator {
    constructor() ERC1155Creator("Silly Clowns", "Silly") {}
}