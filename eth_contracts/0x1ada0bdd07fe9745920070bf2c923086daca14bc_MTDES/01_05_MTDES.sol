// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MT Design
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//                                                                               //
//              _____                _____                    _____              //
//             /\    \              /\    \                  /\    \             //
//            /::\____\            /::\    \                /::\    \            //
//           /::::|   |            \:::\    \              /::::\    \           //
//          /:::::|   |             \:::\    \            /::::::\    \          //
//         /::::::|   |              \:::\    \          /:::/\:::\    \         //
//        /:::/|::|   |               \:::\    \        /:::/  \:::\    \        //
//       /:::/ |::|   |               /::::\    \      /:::/    \:::\    \       //
//      /:::/  |::|___|______        /::::::\    \    /:::/    / \:::\    \      //
//     /:::/   |::::::::\    \      /:::/\:::\    \  /:::/    /   \:::\ ___\     //
//    /:::/    |:::::::::\____\    /:::/  \:::\____\/:::/____/     \:::|    |    //
//    \::/    / ~~~~~/:::/    /   /:::/    \::/    /\:::\    \     /:::|____|    //
//     \/____/      /:::/    /   /:::/    / \/____/  \:::\    \   /:::/    /     //
//                 /:::/    /   /:::/    /            \:::\    \ /:::/    /      //
//                /:::/    /   /:::/    /              \:::\    /:::/    /       //
//               /:::/    /    \::/    /                \:::\  /:::/    /        //
//              /:::/    /      \/____/                  \:::\/:::/    /         //
//             /:::/    /                                 \::::::/    /          //
//            /:::/    /                                   \::::/    /           //
//            \::/    /                                     \::/____/            //
//             \/____/                                       ~~                  //
//                                                                               //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract MTDES is ERC1155Creator {
    constructor() ERC1155Creator("MT Design", "MTDES") {}
}