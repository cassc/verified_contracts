// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sleepy Checks by Goro
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                        //
//                                                                                                                                        //
//                                                                                                                                        //
//      /$$$$$$  /$$       /$$$$$$$$ /$$$$$$$$ /$$$$$$$  /$$     /$$        /$$$$$$  /$$   /$$ /$$$$$$$$  /$$$$$$  /$$   /$$  /$$$$$$     //
//     /$$__  $$| $$      | $$_____/| $$_____/| $$__  $$|  $$   /$$/       /$$__  $$| $$  | $$| $$_____/ /$$__  $$| $$  /$$/ /$$__  $$    //
//    | $$  \__/| $$      | $$      | $$      | $$  \ $$ \  $$ /$$/       | $$  \__/| $$  | $$| $$      | $$  \__/| $$ /$$/ | $$  \__/    //
//    |  $$$$$$ | $$      | $$$$$   | $$$$$   | $$$$$$$/  \  $$$$/        | $$      | $$$$$$$$| $$$$$   | $$      | $$$$$/  |  $$$$$$     //
//     \____  $$| $$      | $$__/   | $$__/   | $$____/    \  $$/         | $$      | $$__  $$| $$__/   | $$      | $$  $$   \____  $$    //
//     /$$  \ $$| $$      | $$      | $$      | $$          | $$          | $$    $$| $$  | $$| $$      | $$    $$| $$\  $$  /$$  \ $$    //
//    |  $$$$$$/| $$$$$$$$| $$$$$$$$| $$$$$$$$| $$          | $$          |  $$$$$$/| $$  | $$| $$$$$$$$|  $$$$$$/| $$ \  $$|  $$$$$$/    //
//     \______/ |________/|________/|________/|__/          |__/           \______/ |__/  |__/|________/ \______/ |__/  \__/ \______/     //
//                                                                                                                                        //
//                                                                                                                                        //
//                                                                                                                                        //
//                                                                                                                                        //
//                                                                                                                                        //
//                                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SLEEPC is ERC1155Creator {
    constructor() ERC1155Creator("Sleepy Checks by Goro", "SLEEPC") {}
}