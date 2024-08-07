// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Project X
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//                                                                  //
//    __________                   __               __ ____  ___    //
//    \______   \_______  ____    |__| ____   _____/  |\   \/  /    //
//     |     ___/\_  __ \/  _ \   |  |/ __ \_/ ___\   __\     /     //
//     |    |     |  | \(  <_> )  |  \  ___/\  \___|  | /     \     //
//     |____|     |__|   \____/\__|  |\___  >\___  >__|/___/\  \    //
//                            \______|    \/     \/          \_/    //
//                                                                  //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract PROJECTX is ERC1155Creator {
    constructor() ERC1155Creator("Project X", "PROJECTX") {}
}