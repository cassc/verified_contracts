// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: U_U
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////
//                                                          //
//                                                          //
//      _   _   _____   _   _                               //
//     | | | | /  _  \ | | | |                              //
//     | |_| | | | | | | |_| |                              //
//     \___  | | |/| | \___  |                              //
//         | | | |_| |     | |                              //
//         |_| \_____/     |_|                              //
//                                                          //
//      _____   _   _   _____   _____   _   _    _____      //
//     /  ___| | | | | | ____| /  ___| | | / /  /  ___/     //
//     | |     | |_| | | |__   | |     | |/ /   | |___      //
//     | |     |  _  | |  __|  | |     | |\ \   \___  \     //
//     | |___  | | | | | |___  | |___  | | \ \   ___| |     //
//     \_____| |_| |_| |_____| \_____| |_|  \_\ /_____/     //
//                                                          //
//      _____   _____    _____    _____   _____             //
//     | ____| |  _  \  |  _  \  /  _  \ |  _  \            //
//     | |__   | |_| |  | |_| |  | | | | | |_| |            //
//     |  __|  |  _  /  |  _  /  | | | | |  _  /            //
//     | |___  | | \ \  | | \ \  | |_| | | | \ \            //
//     |_____| |_|  \_\ |_|  \_\ \_____/ |_|  \_\           //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////


contract ChecksError is ERC1155Creator {
    constructor() ERC1155Creator("U_U", "ChecksError") {}
}