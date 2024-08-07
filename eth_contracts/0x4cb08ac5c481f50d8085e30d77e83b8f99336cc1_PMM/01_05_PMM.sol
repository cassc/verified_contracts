// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Physical Minimalist Mood
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                       //
//                                                                                                                                       //
//                                                                                                                                       //
//     /$$$$$$$  /$$                 /$$      /$$ /$$ /$$      /$$                           /$$                                         //
//    | $$__  $$| $$                | $$$    /$$$|__/| $$$    /$$$                          | $$                                         //
//    | $$  \ $$| $$$$$$$  /$$   /$$| $$$$  /$$$$ /$$| $$$$  /$$$$  /$$$$$$   /$$$$$$   /$$$$$$$                                         //
//    | $$$$$$$/| $$__  $$| $$  | $$| $$ $$/$$ $$| $$| $$ $$/$$ $$ /$$__  $$ /$$__  $$ /$$__  $$                                         //
//    | $$____/ | $$  \ $$| $$  | $$| $$  $$$| $$| $$| $$  $$$| $$| $$  \ $$| $$  \ $$| $$  | $$                                         //
//    | $$      | $$  | $$| $$  | $$| $$\  $ | $$| $$| $$\  $ | $$| $$  | $$| $$  | $$| $$  | $$                                         //
//    | $$      | $$  | $$|  $$$$$$$| $$ \/  | $$| $$| $$ \/  | $$|  $$$$$$/|  $$$$$$/|  $$$$$$$                                         //
//    |__/      |__/  |__/ \____  $$|__/     |__/|__/|__/     |__/ \______/  \______/  \_______/                                         //
//                         /$$  | $$                                                                                                     //
//                        |  $$$$$$/                                                                                                     //
//                         \______/                                                                                                      //
//        /$$$$$                       /$$               /$$$$$$$                                                                        //
//       |__  $$                      | $$              | $$__  $$                                                                       //
//          | $$ /$$   /$$  /$$$$$$$ /$$$$$$    /$$$$$$ | $$  \ $$ /$$$$$$   /$$$$$$   /$$$$$$                                           //
//          | $$| $$  | $$ /$$_____/|_  $$_/   |____  $$| $$$$$$$//$$__  $$ /$$__  $$ /$$__  $$                                          //
//     /$$  | $$| $$  | $$|  $$$$$$   | $$      /$$$$$$$| $$____/| $$$$$$$$| $$  \ $$| $$$$$$$$                                          //
//    | $$  | $$| $$  | $$ \____  $$  | $$ /$$ /$$__  $$| $$     | $$_____/| $$  | $$| $$_____/                                          //
//    |  $$$$$$/|  $$$$$$/ /$$$$$$$/  |  $$$$/|  $$$$$$$| $$     |  $$$$$$$| $$$$$$$/|  $$$$$$$                                          //
//     \______/  \______/ |_______/    \___/   \_______/|__/      \_______/| $$____/  \_______/                                          //
//                                                                         | $$                                                          //
//                                                                         | $$                                                          //
//                                                                         |__/                                                          //
//      /$$$$$$  /$$ /$$                 /$$      /$$                                                   /$$$$$$$$ /$$$$$$$$ /$$   /$$    //
//     /$$__  $$|__/| $$                | $$$    /$$$                                                  | $$_____/|__  $$__/| $$  | $$    //
//    | $$  \__/ /$$| $$$$$$$   /$$$$$$ | $$$$  /$$$$  /$$$$$$  /$$   /$$  /$$$$$$  /$$   /$$  /$$$$$$ | $$         | $$   | $$  | $$    //
//    | $$ /$$$$| $$| $$__  $$ /$$__  $$| $$ $$/$$ $$ /$$__  $$| $$  | $$ /$$__  $$| $$  | $$ /$$__  $$| $$$$$      | $$   | $$$$$$$$    //
//    | $$|_  $$| $$| $$  \ $$| $$$$$$$$| $$  $$$| $$| $$$$$$$$| $$  | $$| $$  \ $$| $$  | $$| $$  \__/| $$__/      | $$   | $$__  $$    //
//    | $$  \ $$| $$| $$  | $$| $$_____/| $$\  $ | $$| $$_____/| $$  | $$| $$  | $$| $$  | $$| $$      | $$         | $$   | $$  | $$    //
//    |  $$$$$$/| $$| $$$$$$$/|  $$$$$$$| $$ \/  | $$|  $$$$$$$|  $$$$$$$|  $$$$$$/|  $$$$$$/| $$      | $$$$$$$$   | $$   | $$  | $$    //
//     \______/ |__/|_______/  \_______/|__/     |__/ \_______/ \____  $$ \______/  \______/ |__/      |________/   |__/   |__/  |__/    //
//                                                              /$$  | $$                                                                //
//                                                             |  $$$$$$/                                                                //
//                                                              \______/                                                                 //
//                                                                                                                                       //
//                                                                                                                                       //
//                                                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PMM is ERC721Creator {
    constructor() ERC721Creator("Physical Minimalist Mood", "PMM") {}
}