// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: McDosed
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                     //
//                                                                                                                                     //
//                                                                                                                                     //
//              _____                   _______                   _____                    _____                    _____              //
//             /\    \                 /::\    \                 /\    \                  /\    \                  /\    \             //
//            /::\    \               /::::\    \               /::\    \                /::\    \                /::\    \            //
//           /::::\    \             /::::::\    \             /::::\    \              /::::\    \              /::::\    \           //
//          /::::::\    \           /::::::::\    \           /::::::\    \            /::::::\    \            /::::::\    \          //
//         /:::/\:::\    \         /:::/~~\:::\    \         /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \         //
//        /:::/  \:::\    \       /:::/    \:::\    \       /:::/__\:::\    \        /:::/__\:::\    \        /:::/  \:::\    \        //
//       /:::/    \:::\    \     /:::/    / \:::\    \      \:::\   \:::\    \      /::::\   \:::\    \      /:::/    \:::\    \       //
//      /:::/    / \:::\    \   /:::/____/   \:::\____\   ___\:::\   \:::\    \    /::::::\   \:::\    \    /:::/    / \:::\    \      //
//     /:::/    /   \:::\ ___\ |:::|    |     |:::|    | /\   \:::\   \:::\    \  /:::/\:::\   \:::\    \  /:::/    /   \:::\ ___\     //
//    /:::/____/     \:::|    ||:::|____|     |:::|    |/::\   \:::\   \:::\____\/:::/__\:::\   \:::\____\/:::/____/     \:::|    |    //
//    \:::\    \     /:::|____| \:::\    \   /:::/    / \:::\   \:::\   \::/    /\:::\   \:::\   \::/    /\:::\    \     /:::|____|    //
//     \:::\    \   /:::/    /   \:::\    \ /:::/    /   \:::\   \:::\   \/____/  \:::\   \:::\   \/____/  \:::\    \   /:::/    /     //
//      \:::\    \ /:::/    /     \:::\    /:::/    /     \:::\   \:::\    \       \:::\   \:::\    \       \:::\    \ /:::/    /      //
//       \:::\    /:::/    /       \:::\__/:::/    /       \:::\   \:::\____\       \:::\   \:::\____\       \:::\    /:::/    /       //
//        \:::\  /:::/    /         \::::::::/    /         \:::\  /:::/    /        \:::\   \::/    /        \:::\  /:::/    /        //
//         \:::\/:::/    /           \::::::/    /           \:::\/:::/    /          \:::\   \/____/          \:::\/:::/    /         //
//          \::::::/    /             \::::/    /             \::::::/    /            \:::\    \               \::::::/    /          //
//           \::::/    /               \::/____/               \::::/    /              \:::\____\               \::::/    /           //
//            \::/____/                 ~~                      \::/    /                \::/    /                \::/____/            //
//             ~~                                                \/____/                  \/____/                  ~~                  //
//                                                                                                                                     //
//                                                                                                                                     //
//                                                                                                                                     //
//                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DOSED is ERC721Creator {
    constructor() ERC721Creator("McDosed", "DOSED") {}
}