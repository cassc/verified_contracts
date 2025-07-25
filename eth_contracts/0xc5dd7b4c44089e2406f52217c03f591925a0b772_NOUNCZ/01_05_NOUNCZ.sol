// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NounCreepz
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//     /$$   /$$                                /$$$$$$                                                       //
//    | $$$ | $$                               /$$__  $$                                                      //
//    | $$$$| $$  /$$$$$$  /$$   /$$ /$$$$$$$ | $$  \__/  /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$$$    //
//    | $$ $$ $$ /$$__  $$| $$  | $$| $$__  $$| $$       /$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$|____ /$$/    //
//    | $$  $$$$| $$  \ $$| $$  | $$| $$  \ $$| $$      | $$  \__/| $$$$$$$$| $$$$$$$$| $$  \ $$   /$$$$/     //
//    | $$\  $$$| $$  | $$| $$  | $$| $$  | $$| $$    $$| $$      | $$_____/| $$_____/| $$  | $$  /$$__/      //
//    | $$ \  $$|  $$$$$$/|  $$$$$$/| $$  | $$|  $$$$$$/| $$      |  $$$$$$$|  $$$$$$$| $$$$$$$/ /$$$$$$$$    //
//    |__/  \__/ \______/  \______/ |__/  |__/ \______/ |__/       \_______/ \_______/| $$____/ |________/    //
//                                                                                    | $$                    //
//                                                                                    | $$                    //
//                                                                                    |__/                    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NOUNCZ is ERC721Creator {
    constructor() ERC721Creator("NounCreepz", "NOUNCZ") {}
}