// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Skribz
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//              _____                    _____                    _____                    _____                    _____                    _____              //
//             /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \             //
//            /::\    \                /::\____\                /::\    \                /::\    \                /::\    \                /::\    \            //
//           /::::\    \              /:::/    /               /::::\    \               \:::\    \              /::::\    \               \:::\    \           //
//          /::::::\    \            /:::/    /               /::::::\    \               \:::\    \            /::::::\    \               \:::\    \          //
//         /:::/\:::\    \          /:::/    /               /:::/\:::\    \               \:::\    \          /:::/\:::\    \               \:::\    \         //
//        /:::/__\:::\    \        /:::/____/               /:::/__\:::\    \               \:::\    \        /:::/__\:::\    \               \:::\    \        //
//        \:::\   \:::\    \      /::::\    \              /::::\   \:::\    \              /::::\    \      /::::\   \:::\    \               \:::\    \       //
//      ___\:::\   \:::\    \    /::::::\____\________    /::::::\   \:::\    \    ____    /::::::\    \    /::::::\   \:::\    \               \:::\    \      //
//     /\   \:::\   \:::\    \  /:::/\:::::::::::\    \  /:::/\:::\   \:::\____\  /\   \  /:::/\:::\    \  /:::/\:::\   \:::\ ___\               \:::\    \     //
//    /::\   \:::\   \:::\____\/:::/  |:::::::::::\____\/:::/  \:::\   \:::|    |/::\   \/:::/  \:::\____\/:::/__\:::\   \:::|    |_______________\:::\____\    //
//    \:::\   \:::\   \::/    /\::/   |::|~~~|~~~~~     \::/   |::::\  /:::|____|\:::\  /:::/    \::/    /\:::\   \:::\  /:::|____|\::::::::::::::::::/    /    //
//     \:::\   \:::\   \/____/  \/____|::|   |           \/____|:::::\/:::/    /  \:::\/:::/    / \/____/  \:::\   \:::\/:::/    /  \::::::::::::::::/____/     //
//      \:::\   \:::\    \            |::|   |                 |:::::::::/    /    \::::::/    /            \:::\   \::::::/    /    \:::\~~~~\~~~~~~           //
//       \:::\   \:::\____\           |::|   |                 |::|\::::/    /      \::::/____/              \:::\   \::::/    /      \:::\    \                //
//        \:::\  /:::/    /           |::|   |                 |::| \::/____/        \:::\    \               \:::\  /:::/    /        \:::\    \               //
//         \:::\/:::/    /            |::|   |                 |::|  ~|               \:::\    \               \:::\/:::/    /          \:::\    \              //
//          \::::::/    /             |::|   |                 |::|   |                \:::\    \               \::::::/    /            \:::\    \             //
//           \::::/    /              \::|   |                 \::|   |                 \:::\____\               \::::/    /              \:::\____\            //
//            \::/    /                \:|   |                  \:|   |                  \::/    /                \::/____/                \::/    /            //
//             \/____/                  \|___|                   \|___|                   \/____/                  ~~                       \/____/             //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Skbz is ERC1155Creator {
    constructor() ERC1155Creator("Skribz", "Skbz") {}
}