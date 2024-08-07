// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Tungsten Drops
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//    ___________                            __                ________      _____   ________       //
//    \__    ___/_ __  ____    ____  _______/  |_  ____   ____ \______ \    /  _  \  \_____  \      //
//      |    | |  |  \/    \  / ___\/  ___/\   __\/ __ \ /    \ |    |  \  /  /_\  \  /   |   \     //
//      |    | |  |  /   |  \/ /_/  >___ \  |  | \  ___/|   |  \|    `   \/    |    \/    |    \    //
//      |____| |____/|___|  /\___  /____  > |__|  \___  >___|  /_______  /\____|__  /\_______  /    //
//                        \//_____/     \/            \/     \/        \/         \/         \/     //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract TUNGSTEN is ERC1155Creator {
    constructor() ERC1155Creator("Tungsten Drops", "TUNGSTEN") {}
}