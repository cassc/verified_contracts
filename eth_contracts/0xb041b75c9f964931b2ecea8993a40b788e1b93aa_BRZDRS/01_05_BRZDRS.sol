// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BRZDRS
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//              _____                    _____                    _____                    _____                    _____                    _____              //
//             /\    \                  /\    \                  /\    \                  /\    \                  /\    \                  /\    \             //
//            /::\    \                /::\    \                /::\    \                /::\    \                /::\    \                /::\    \            //
//           /::::\    \              /::::\    \               \:::\    \              /::::\    \              /::::\    \              /::::\    \           //
//          /::::::\    \            /::::::\    \               \:::\    \            /::::::\    \            /::::::\    \            /::::::\    \          //
//         /:::/\:::\    \          /:::/\:::\    \               \:::\    \          /:::/\:::\    \          /:::/\:::\    \          /:::/\:::\    \         //
//        /:::/__\:::\    \        /:::/__\:::\    \               \:::\    \        /:::/  \:::\    \        /:::/__\:::\    \        /:::/__\:::\    \        //
//       /::::\   \:::\    \      /::::\   \:::\    \               \:::\    \      /:::/    \:::\    \      /::::\   \:::\    \       \:::\   \:::\    \       //
//      /::::::\   \:::\    \    /::::::\   \:::\    \               \:::\    \    /:::/    / \:::\    \    /::::::\   \:::\    \    ___\:::\   \:::\    \      //
//     /:::/\:::\   \:::\ ___\  /:::/\:::\   \:::\____\               \:::\    \  /:::/    /   \:::\ ___\  /:::/\:::\   \:::\____\  /\   \:::\   \:::\    \     //
//    /:::/__\:::\   \:::|    |/:::/  \:::\   \:::|    |_______________\:::\____\/:::/____/     \:::|    |/:::/  \:::\   \:::|    |/::\   \:::\   \:::\____\    //
//    \:::\   \:::\  /:::|____|\::/   |::::\  /:::|____|\::::::::::::::::::/    /\:::\    \     /:::|____|\::/   |::::\  /:::|____|\:::\   \:::\   \::/    /    //
//     \:::\   \:::\/:::/    /  \/____|:::::\/:::/    /  \::::::::::::::::/____/  \:::\    \   /:::/    /  \/____|:::::\/:::/    /  \:::\   \:::\   \/____/     //
//      \:::\   \::::::/    /         |:::::::::/    /    \:::\~~~~\~~~~~~         \:::\    \ /:::/    /         |:::::::::/    /    \:::\   \:::\    \         //
//       \:::\   \::::/    /          |::|\::::/    /      \:::\    \               \:::\    /:::/    /          |::|\::::/    /      \:::\   \:::\____\        //
//        \:::\  /:::/    /           |::| \::/____/        \:::\    \               \:::\  /:::/    /           |::| \::/____/        \:::\  /:::/    /        //
//         \:::\/:::/    /            |::|  ~|               \:::\    \               \:::\/:::/    /            |::|  ~|               \:::\/:::/    /         //
//          \::::::/    /             |::|   |                \:::\    \               \::::::/    /             |::|   |                \::::::/    /          //
//           \::::/    /              \::|   |                 \:::\____\               \::::/    /              \::|   |                 \::::/    /           //
//            \::/____/                \:|   |                  \::/    /                \::/____/                \:|   |                  \::/    /            //
//             ~~                       \|___|                   \/____/                  ~~                       \|___|                   \/____/             //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BRZDRS is ERC1155Creator {
    constructor() ERC1155Creator("BRZDRS", "BRZDRS") {}
}