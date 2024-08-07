// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Hazel Griffiths Live
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//              _____                    _____                    _____                    _____                    _____      //
//             /\    \                  /\    \                  /\    \                  /\    \                  /\    \     //
//            /::\____\                /::\    \                /::\    \                /::\    \                /::\____\    //
//           /:::/    /               /::::\    \               \:::\    \              /::::\    \              /:::/    /    //
//          /:::/    /               /::::::\    \               \:::\    \            /::::::\    \            /:::/    /     //
//         /:::/    /               /:::/\:::\    \               \:::\    \          /:::/\:::\    \          /:::/    /      //
//        /:::/____/               /:::/__\:::\    \               \:::\    \        /:::/__\:::\    \        /:::/    /       //
//       /::::\    \              /::::\   \:::\    \               \:::\    \      /::::\   \:::\    \      /:::/    /        //
//      /::::::\    \   _____    /::::::\   \:::\    \               \:::\    \    /::::::\   \:::\    \    /:::/    /         //
//     /:::/\:::\    \ /\    \  /:::/\:::\   \:::\    \               \:::\    \  /:::/\:::\   \:::\    \  /:::/    /          //
//    /:::/  \:::\    /::\____\/:::/  \:::\   \:::\____\_______________\:::\____\/:::/__\:::\   \:::\____\/:::/____/           //
//    \::/    \:::\  /:::/    /\::/    \:::\  /:::/    /\::::::::::::::::::/    /\:::\   \:::\   \::/    /\:::\    \           //
//     \/____/ \:::\/:::/    /  \/____/ \:::\/:::/    /  \::::::::::::::::/____/  \:::\   \:::\   \/____/  \:::\    \          //
//              \::::::/    /            \::::::/    /    \:::\~~~~\~~~~~~         \:::\   \:::\    \       \:::\    \         //
//               \::::/    /              \::::/    /      \:::\    \               \:::\   \:::\____\       \:::\    \        //
//               /:::/    /               /:::/    /        \:::\    \               \:::\   \::/    /        \:::\    \       //
//              /:::/    /               /:::/    /          \:::\    \               \:::\   \/____/          \:::\    \      //
//             /:::/    /               /:::/    /            \:::\    \               \:::\    \               \:::\    \     //
//            /:::/    /               /:::/    /              \:::\____\               \:::\____\               \:::\____\    //
//            \::/    /                \::/    /                \::/    /                \::/    /                \::/    /    //
//             \/____/                  \/____/                  \/____/                  \/____/                  \/____/     //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Hazel is ERC1155Creator {
    constructor() ERC1155Creator("Hazel Griffiths Live", "Hazel") {}
}