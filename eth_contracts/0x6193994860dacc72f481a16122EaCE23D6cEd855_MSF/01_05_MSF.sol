// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mic_Seb and Friends
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//    .___  ___.  __    ______            _______. _______ .______           ___      .__   __.  _______      _______ .______       __   _______ .__   __.  _______       _______.    //
//    |   \/   | |  |  /      |          /       ||   ____||   _  \         /   \     |  \ |  | |       \    |   ____||   _  \     |  | |   ____||  \ |  | |       \     /       |    //
//    |  \  /  | |  | |  ,----'         |   (----`|  |__   |  |_)  |       /  ^  \    |   \|  | |  .--.  |   |  |__   |  |_)  |    |  | |  |__   |   \|  | |  .--.  |   |   (----`    //
//    |  |\/|  | |  | |  |               \   \    |   __|  |   _  <       /  /_\  \   |  . `  | |  |  |  |   |   __|  |      /     |  | |   __|  |  . `  | |  |  |  |    \   \        //
//    |  |  |  | |  | |  `----.      .----)   |   |  |____ |  |_)  |     /  _____  \  |  |\   | |  '--'  |   |  |     |  |\  \----.|  | |  |____ |  |\   | |  '--'  |.----)   |       //
//    |__|  |__| |__|  \______| _____|_______/    |_______||______/     /__/     \__\ |__| \__| |_______/    |__|     | _| `._____||__| |_______||__| \__| |_______/ |_______/        //
//                             |______|                                                                                                                                               //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MSF is ERC721Creator {
    constructor() ERC721Creator("Mic_Seb and Friends", "MSF") {}
}