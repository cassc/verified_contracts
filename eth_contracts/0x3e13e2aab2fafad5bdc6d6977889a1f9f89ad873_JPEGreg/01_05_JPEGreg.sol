// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ネオンの夢 BANNER 001
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////
//                                                                                 //
//                                                                                 //
//       __     ______   ______     ______     ______     ______     ______        //
//      /\ \   /\  == \ /\  ___\   /\  ___\   /\  == \   /\  ___\   /\  ___\       //
//     _\_\ \  \ \  _-/ \ \  __\   \ \ \__ \  \ \  __<   \ \  __\   \ \ \__ \      //
//    /\_____\  \ \_\    \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\     //
//    \/_____/   \/_/     \/_____/   \/_____/   \/_/ /_/   \/_____/   \/_____/     //
//                                                                                 //
//                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////


contract JPEGreg is ERC1155Creator {
    constructor() ERC1155Creator(unicode"ネオンの夢 BANNER 001", "JPEGreg") {}
}