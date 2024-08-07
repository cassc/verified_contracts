// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: If An Artist Paints in the Forest...
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                   //
//                                                                                                                                                   //
//                                                                                                                                                   //
//       ___                       __  ___    __  ___     __              ___  __               ___       ___     ___  __   __   ___  __  ___        //
//    | |__      /\  |\ |     /\  |__)  |  | /__`  |     |__)  /\  | |\ |  |  /__`    | |\ |     |  |__| |__     |__  /  \ |__) |__  /__`  |         //
//    | |       /~~\ | \|    /~~\ |  \  |  | .__/  |     |    /~~\ | | \|  |  .__/    | | \|     |  |  | |___    |    \__/ |  \ |___ .__/  |  ...    //
//                                                                                                                                                   //
//                                                                                                                                                   //
//                                                                                                                                                   //
//                                                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TREE is ERC721Creator {
    constructor() ERC721Creator("If An Artist Paints in the Forest...", "TREE") {}
}