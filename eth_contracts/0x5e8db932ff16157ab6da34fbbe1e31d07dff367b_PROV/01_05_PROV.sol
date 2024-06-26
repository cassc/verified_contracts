// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Known Provenance
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
//     /$$   /$$                                                   /$$$$$$$                                                                                                                                                                                   //
//    | $$  /$$/                                                  | $$__  $$                                                                                                                                                                                  //
//    | $$ /$$/  /$$$$$$$   /$$$$$$  /$$  /$$  /$$ /$$$$$$$       | $$  \ $$ /$$$$$$   /$$$$$$  /$$    /$$ /$$$$$$  /$$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$  /$$$$$$                                                                                          //
//    | $$$$$/  | $$__  $$ /$$__  $$| $$ | $$ | $$| $$__  $$      | $$$$$$$//$$__  $$ /$$__  $$|  $$  /$$//$$__  $$| $$__  $$ |____  $$| $$__  $$ /$$_____/ /$$__  $$                                                                                         //
//    | $$  $$  | $$  \ $$| $$  \ $$| $$ | $$ | $$| $$  \ $$      | $$____/| $$  \__/| $$  \ $$ \  $$/$$/| $$$$$$$$| $$  \ $$  /$$$$$$$| $$  \ $$| $$      | $$$$$$$$                                                                                         //
//    | $$\  $$ | $$  | $$| $$  | $$| $$ | $$ | $$| $$  | $$      | $$     | $$      | $$  | $$  \  $$$/ | $$_____/| $$  | $$ /$$__  $$| $$  | $$| $$      | $$_____/                                                                                         //
//    | $$ \  $$| $$  | $$|  $$$$$$/|  $$$$$/$$$$/| $$  | $$      | $$     | $$      |  $$$$$$/   \  $/  |  $$$$$$$| $$  | $$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$                                                                                         //
//    |__/  \__/|__/  |__/ \______/  \_____/\___/ |__/  |__/      |__/     |__/       \______/     \_/    \_______/|__/  |__/ \_______/|__/  |__/ \_______/ \_______/                                                                                         //
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
//                                                                                                                                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PROV is ERC721Creator {
    constructor() ERC721Creator("Known Provenance", "PROV") {}
}