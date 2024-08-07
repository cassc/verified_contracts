// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: project1
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
//              _____                    _____                   _______                   _____                    _____                    _____                _____              //
//             /\    \                  /\    \                 /::\    \                 /\    \                  /\    \                  /\    \              /\    \             //
//            /::\    \                /::\    \               /::::\    \               /::\    \                /::\    \                /::\    \            /::\    \            //
//           /::::\    \              /::::\    \             /::::::\    \              \:::\    \              /::::\    \              /::::\    \           \:::\    \           //
//          /::::::\    \            /::::::\    \           /::::::::\    \              \:::\    \            /::::::\    \            /::::::\    \           \:::\    \          //
//         /:::/\:::\    \          /:::/\:::\    \         /:::/~~\:::\    \              \:::\    \          /:::/\:::\    \          /:::/\:::\    \           \:::\    \         //
//        /:::/__\:::\    \        /:::/__\:::\    \       /:::/    \:::\    \              \:::\    \        /:::/__\:::\    \        /:::/  \:::\    \           \:::\    \        //
//       /::::\   \:::\    \      /::::\   \:::\    \     /:::/    / \:::\    \             /::::\    \      /::::\   \:::\    \      /:::/    \:::\    \          /::::\    \       //
//      /::::::\   \:::\    \    /::::::\   \:::\    \   /:::/____/   \:::\____\   _____   /::::::\    \    /::::::\   \:::\    \    /:::/    / \:::\    \        /::::::\    \      //
//     /:::/\:::\   \:::\____\  /:::/\:::\   \:::\____\ |:::|    |     |:::|    | /\    \ /:::/\:::\    \  /:::/\:::\   \:::\    \  /:::/    /   \:::\    \      /:::/\:::\    \     //
//    /:::/  \:::\   \:::|    |/:::/  \:::\   \:::|    ||:::|____|     |:::|    |/::\    /:::/  \:::\____\/:::/__\:::\   \:::\____\/:::/____/     \:::\____\    /:::/  \:::\____\    //
//    \::/    \:::\  /:::|____|\::/   |::::\  /:::|____| \:::\    \   /:::/    / \:::\  /:::/    \::/    /\:::\   \:::\   \::/    /\:::\    \      \::/    /   /:::/    \::/    /    //
//     \/_____/\:::\/:::/    /  \/____|:::::\/:::/    /   \:::\    \ /:::/    /   \:::\/:::/    / \/____/  \:::\   \:::\   \/____/  \:::\    \      \/____/   /:::/    / \/____/     //
//              \::::::/    /         |:::::::::/    /     \:::\    /:::/    /     \::::::/    /            \:::\   \:::\    \       \:::\    \              /:::/    /              //
//               \::::/    /          |::|\::::/    /       \:::\__/:::/    /       \::::/    /              \:::\   \:::\____\       \:::\    \            /:::/    /               //
//                \::/____/           |::| \::/____/         \::::::::/    /         \::/    /                \:::\   \::/    /        \:::\    \           \::/    /                //
//                 ~~                 |::|  ~|                \::::::/    /           \/____/                  \:::\   \/____/          \:::\    \           \/____/                 //
//                                    |::|   |                 \::::/    /                                      \:::\    \               \:::\    \                                  //
//                                    \::|   |                  \::/____/                                        \:::\____\               \:::\____\                                 //
//                                     \:|   |                   ~~                                               \::/    /                \::/    /                                 //
//                                      \|___|                                                                     \/____/                  \/____/                                  //
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract p1 is ERC721Creator {
    constructor() ERC721Creator("project1", "p1") {}
}