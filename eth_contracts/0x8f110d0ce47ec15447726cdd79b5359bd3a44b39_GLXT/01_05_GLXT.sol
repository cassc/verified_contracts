// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GlitChess
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//     $$$$$$\  $$\ $$\   $$\      $$$$$$\  $$\                                         //
//    $$  __$$\ $$ |\__|  $$ |    $$  __$$\ $$ |                                        //
//    $$ /  \__|$$ |$$\ $$$$$$\   $$ /  \__|$$$$$$$\   $$$$$$\   $$$$$$$\  $$$$$$$\     //
//    $$ |$$$$\ $$ |$$ |\_$$  _|  $$ |      $$  __$$\ $$  __$$\ $$  _____|$$  _____|    //
//    $$ |\_$$ |$$ |$$ |  $$ |    $$ |      $$ |  $$ |$$$$$$$$ |\$$$$$$\  \$$$$$$\      //
//    $$ |  $$ |$$ |$$ |  $$ |$$\ $$ |  $$\ $$ |  $$ |$$   ____| \____$$\  \____$$\     //
//    \$$$$$$  |$$ |$$ |  \$$$$  |\$$$$$$  |$$ |  $$ |\$$$$$$$\ $$$$$$$  |$$$$$$$  |    //
//     \______/ \__|\__|   \____/  \______/ \__|  \__| \_______|\_______/ \_______/     //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract GLXT is ERC1155Creator {
    constructor() ERC1155Creator("GlitChess", "GLXT") {}
}