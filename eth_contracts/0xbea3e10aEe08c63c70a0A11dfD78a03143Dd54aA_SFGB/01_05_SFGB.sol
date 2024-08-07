// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Semifungible
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//     ______     ______     __    __     __         //
//    /\  ___\   /\  ___\   /\ "-./  \   /\ \        //
//    \ \___  \  \ \  __\   \ \ \-./\ \  \ \ \       //
//     \/\_____\  \ \_____\  \ \_\ \ \_\  \ \_\      //
//      \/_____/   \/_____/   \/_/  \/_/   \/_/      //
//                                                   //
//     ______   __  __     __   __     ______        //
//    /\  ___\ /\ \/\ \   /\ "-.\ \   /\  ___\       //
//    \ \  __\ \ \ \_\ \  \ \ \-.  \  \ \ \__ \      //
//     \ \_\    \ \_____\  \ \_\\"\_\  \ \_____\     //
//      \/_/     \/_____/   \/_/ \/_/   \/_____/     //
//                                                   //
//     __     ______     __         ______           //
//    /\ \   /\  == \   /\ \       /\  ___\          //
//    \ \ \  \ \  __<   \ \ \____  \ \  __\          //
//     \ \_\  \ \_____\  \ \_____\  \ \_____\        //
//      \/_/   \/_____/   \/_____/   \/_____/        //
//                                                   //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract SFGB is ERC1155Creator {
    constructor() ERC1155Creator("Semifungible", "SFGB") {}
}