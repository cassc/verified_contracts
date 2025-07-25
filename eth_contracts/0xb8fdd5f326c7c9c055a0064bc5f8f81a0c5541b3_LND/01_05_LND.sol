// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Late Night Degen
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                     //
//                                                                                                                                     //
//     /$$$$$$$$                           /$$$$$$$                  /$$       /$$           /$$    /$$                                //
//    |__  $$__/                          | $$__  $$                | $$      | $$          | $$   | $$                                //
//       | $$  /$$$$$$  /$$$$$$   /$$$$$$ | $$  \ $$  /$$$$$$   /$$$$$$$  /$$$$$$$ /$$   /$$| $$   | $$ /$$$$$$   /$$$$$$$ /$$$$$$$    //
//       | $$ /$$__  $$|____  $$ /$$__  $$| $$  | $$ |____  $$ /$$__  $$ /$$__  $$| $$  | $$|  $$ / $$//$$__  $$ /$$_____//$$_____/    //
//       | $$| $$  \__/ /$$$$$$$| $$  \ $$| $$  | $$  /$$$$$$$| $$  | $$| $$  | $$| $$  | $$ \  $$ $$/| $$  \ $$|  $$$$$$|  $$$$$$     //
//       | $$| $$      /$$__  $$| $$  | $$| $$  | $$ /$$__  $$| $$  | $$| $$  | $$| $$  | $$  \  $$$/ | $$  | $$ \____  $$\____  $$    //
//       | $$| $$     |  $$$$$$$| $$$$$$$/| $$$$$$$/|  $$$$$$$|  $$$$$$$|  $$$$$$$|  $$$$$$$   \  $/  |  $$$$$$/ /$$$$$$$//$$$$$$$/    //
//       |__/|__/      \_______/| $$____/ |_______/  \_______/ \_______/ \_______/ \____  $$    \_/    \______/ |_______/|_______/     //
//                              | $$                                               /$$  | $$                                           //
//                              | $$                                              |  $$$$$$/                                           //
//                              |__/                                               \______/                                            //
//                                                                                                                                     //
//                                                                                                                                     //
//                                                                                                                                     //
//                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LND is ERC721Creator {
    constructor() ERC721Creator("Late Night Degen", "LND") {}
}