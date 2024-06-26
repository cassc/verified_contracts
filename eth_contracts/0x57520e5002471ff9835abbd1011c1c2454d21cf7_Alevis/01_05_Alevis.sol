// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Alevi’s editions
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                                   //
//                                                                                                                                                                                                                                                                                   //
//              _____                    _____            _____                    _____                    _____                    _____                            _____                   _______                   _____                    _____            _____              //
//             /\    \                  /\    \          /\    \                  /\    \                  /\    \                  /\    \                          /\    \                 /::\    \                 /\    \                  /\    \          /\    \             //
//            /::\    \                /::\____\        /::\    \                /::\____\                /::\    \                /::\    \                        /::\____\               /::::\    \               /::\    \                /::\____\        /::\    \            //
//           /::::\    \              /:::/    /       /::::\    \              /:::/    /                \:::\    \              /::::\    \                      /:::/    /              /::::::\    \             /::::\    \              /:::/    /       /::::\    \           //
//          /::::::\    \            /:::/    /       /::::::\    \            /:::/    /                  \:::\    \            /::::::\    \                    /:::/   _/___           /::::::::\    \           /::::::\    \            /:::/    /       /::::::\    \          //
//         /:::/\:::\    \          /:::/    /       /:::/\:::\    \          /:::/    /                    \:::\    \          /:::/\:::\    \                  /:::/   /\    \         /:::/~~\:::\    \         /:::/\:::\    \          /:::/    /       /:::/\:::\    \         //
//        /:::/__\:::\    \        /:::/    /       /:::/__\:::\    \        /:::/____/                      \:::\    \        /:::/__\:::\    \                /:::/   /::\____\       /:::/    \:::\    \       /:::/__\:::\    \        /:::/    /       /:::/  \:::\    \        //
//       /::::\   \:::\    \      /:::/    /       /::::\   \:::\    \       |::|    |                       /::::\    \       \:::\   \:::\    \              /:::/   /:::/    /      /:::/    / \:::\    \     /::::\   \:::\    \      /:::/    /       /:::/    \:::\    \       //
//      /::::::\   \:::\    \    /:::/    /       /::::::\   \:::\    \      |::|    |     _____    ____    /::::::\    \    ___\:::\   \:::\    \            /:::/   /:::/   _/___   /:::/____/   \:::\____\   /::::::\   \:::\    \    /:::/    /       /:::/    / \:::\    \      //
//     /:::/\:::\   \:::\    \  /:::/    /       /:::/\:::\   \:::\    \     |::|    |    /\    \  /\   \  /:::/\:::\    \  /\   \:::\   \:::\    \          /:::/___/:::/   /\    \ |:::|    |     |:::|    | /:::/\:::\   \:::\____\  /:::/    /       /:::/    /   \:::\ ___\     //
//    /:::/  \:::\   \:::\____\/:::/____/       /:::/__\:::\   \:::\____\    |::|    |   /::\____\/::\   \/:::/  \:::\____\/::\   \:::\   \:::\____\        |:::|   /:::/   /::\____\|:::|____|     |:::|    |/:::/  \:::\   \:::|    |/:::/____/       /:::/____/     \:::|    |    //
//    \::/    \:::\  /:::/    /\:::\    \       \:::\   \:::\   \::/    /    |::|    |  /:::/    /\:::\  /:::/    \::/    /\:::\   \:::\   \::/    /        |:::|__/:::/   /:::/    / \:::\    \   /:::/    / \::/   |::::\  /:::|____|\:::\    \       \:::\    \     /:::|____|    //
//     \/____/ \:::\/:::/    /  \:::\    \       \:::\   \:::\   \/____/     |::|    | /:::/    /  \:::\/:::/    / \/____/  \:::\   \:::\   \/____/          \:::\/:::/   /:::/    /   \:::\    \ /:::/    /   \/____|:::::\/:::/    /  \:::\    \       \:::\    \   /:::/    /     //
//              \::::::/    /    \:::\    \       \:::\   \:::\    \         |::|____|/:::/    /    \::::::/    /            \:::\   \:::\    \               \::::::/   /:::/    /     \:::\    /:::/    /          |:::::::::/    /    \:::\    \       \:::\    \ /:::/    /      //
//               \::::/    /      \:::\    \       \:::\   \:::\____\        |:::::::::::/    /      \::::/____/              \:::\   \:::\____\               \::::/___/:::/    /       \:::\__/:::/    /           |::|\::::/    /      \:::\    \       \:::\    /:::/    /       //
//               /:::/    /        \:::\    \       \:::\   \::/    /        \::::::::::/____/        \:::\    \               \:::\  /:::/    /                \:::\__/:::/    /         \::::::::/    /            |::| \::/____/        \:::\    \       \:::\  /:::/    /        //
//              /:::/    /          \:::\    \       \:::\   \/____/          ~~~~~~~~~~               \:::\    \               \:::\/:::/    /                  \::::::::/    /           \::::::/    /             |::|  ~|               \:::\    \       \:::\/:::/    /         //
//             /:::/    /            \:::\    \       \:::\    \                                        \:::\    \               \::::::/    /                    \::::::/    /             \::::/    /              |::|   |                \:::\    \       \::::::/    /          //
//            /:::/    /              \:::\____\       \:::\____\                                        \:::\____\               \::::/    /                      \::::/    /               \::/____/               \::|   |                 \:::\____\       \::::/    /           //
//            \::/    /                \::/    /        \::/    /                                         \::/    /                \::/    /                        \::/____/                 ~~                      \:|   |                  \::/    /        \::/____/            //
//             \/____/                  \/____/          \/____/                                           \/____/                  \/____/                          ~~                                                \|___|                   \/____/          ~~                  //
//                                                                                                                                                                                                                                                                                   //
//                                                                                                                                                                                                                                                                                   //
//                                                                                                                                                                                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Alevis is ERC721Creator {
    constructor() ERC721Creator(unicode"Alevi’s editions", "Alevis") {}
}