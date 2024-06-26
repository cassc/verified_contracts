// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Juicy Doll Box
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////
//                                                       //
//                                                       //
//      _______ _             _____ _        _           //
//     |__   __| |           / ____| |      (_)          //
//        | |  | |__   ___  | (___ | |_ _ __ _ _ __      //
//        | |  | '_ \ / _ \  \___ \| __| '__| | '_ \     //
//        | |  | | | |  __/  ____) | |_| |  | | |_) |    //
//        |_|  |_| |_|\___| |_____/ \__|_|  |_| .__/     //
//                                            | |        //
//                                            |_|        //
//                                                       //
//                                                       //
///////////////////////////////////////////////////////////


contract DOL is ERC1155Creator {
    constructor() ERC1155Creator("Juicy Doll Box", "DOL") {}
}