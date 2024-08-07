// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: AyorArt
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                             //
//                                                                                                                             //
//              _____                _____                    _____                    _____                _____              //
//             /\    \              |\    \                  /\    \                  /\    \              /\    \             //
//            /::\    \             |:\____\                /::\    \                /::\    \            /::\    \            //
//           /::::\    \            |::|   |               /::::\    \              /::::\    \           \:::\    \           //
//          /::::::\    \           |::|   |              /::::::\    \            /::::::\    \           \:::\    \          //
//         /:::/\:::\    \          |::|   |             /:::/\:::\    \          /:::/\:::\    \           \:::\    \         //
//        /:::/__\:::\    \         |::|   |            /:::/__\:::\    \        /:::/__\:::\    \           \:::\    \        //
//       /::::\   \:::\    \        |::|   |           /::::\   \:::\    \      /::::\   \:::\    \          /::::\    \       //
//      /::::::\   \:::\    \       |::|___|______    /::::::\   \:::\    \    /::::::\   \:::\    \        /::::::\    \      //
//     /:::/\:::\   \:::\    \      /::::::::\    \  /:::/\:::\   \:::\    \  /:::/\:::\   \:::\____\      /:::/\:::\    \     //
//    /:::/  \:::\   \:::\____\    /::::::::::\____\/:::/  \:::\   \:::\____\/:::/  \:::\   \:::|    |    /:::/  \:::\____\    //
//    \::/    \:::\  /:::/    /   /:::/~~~~/~~      \::/    \:::\  /:::/    /\::/   |::::\  /:::|____|   /:::/    \::/    /    //
//     \/____/ \:::\/:::/    /   /:::/    /          \/____/ \:::\/:::/    /  \/____|:::::\/:::/    /   /:::/    / \/____/     //
//              \::::::/    /   /:::/    /                    \::::::/    /         |:::::::::/    /   /:::/    /              //
//               \::::/    /   /:::/    /                      \::::/    /          |::|\::::/    /   /:::/    /               //
//               /:::/    /    \::/    /                       /:::/    /           |::| \::/____/    \::/    /                //
//              /:::/    /      \/____/                       /:::/    /            |::|  ~|           \/____/                 //
//             /:::/    /                                    /:::/    /             |::|   |                                   //
//            /:::/    /                                    /:::/    /              \::|   |                                   //
//            \::/    /                                     \::/    /                \:|   |                                   //
//             \/____/                                       \/____/                  \|___|                                   //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AyArt is ERC721Creator {
    constructor() ERC721Creator("AyorArt", "AyArt") {}
}