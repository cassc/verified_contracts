// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sense Of Beauty
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                  //
//                                                                                                                                                                  //
//                                                                                                                                                                  //
//    ██████  ███████ ███████  █████      ███    ██ ██  █████      ██████  ██   ██  ██████  ████████  ██████   ██████  ██████   █████  ██████  ██   ██ ██    ██     //
//    ██   ██ ██         ███  ██   ██     ████   ██ ██ ██   ██     ██   ██ ██   ██ ██    ██    ██    ██    ██ ██       ██   ██ ██   ██ ██   ██ ██   ██  ██  ██      //
//    ██████  █████     ███   ███████     ██ ██  ██ ██ ███████     ██████  ███████ ██    ██    ██    ██    ██ ██   ███ ██████  ███████ ██████  ███████   ████       //
//    ██   ██ ██       ███    ██   ██     ██  ██ ██ ██ ██   ██     ██      ██   ██ ██    ██    ██    ██    ██ ██    ██ ██   ██ ██   ██ ██      ██   ██    ██        //
//    ██   ██ ███████ ███████ ██   ██     ██   ████ ██ ██   ██     ██      ██   ██  ██████     ██     ██████   ██████  ██   ██ ██   ██ ██      ██   ██    ██        //
//                                                                                                                                                                  //
//                                                                                                                                                                  //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    █████████████████████████████████████████▓████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████▓▒▒▒▒▓██████████████████████████████████████████████                                                                    //
//    █████████████████████████████████████▒▒▒░▒▒▓▓▓████████████████████████████████████████████                                                                    //
//    ███████████████████████████████████▓▒▒░░░░░░▒▓▓███████████████████████████████████████████                                                                    //
//    ██████████████████████████████████▒▒░░░░░░░░░▒▒▓▓█████████████████████████████████████████                                                                    //
//    ████████████████████████████████▓▒▒░░░░░░░░░░░░▒▓▓████████████████████████████████████████                                                                    //
//    ████████████████████████████████▒░░░░▒▓▓▓▓▓▓▓▒░░▒▓▓███████████████████████████████████████                                                                    //
//    ███████████████████████████████▒░░░░░▒▓▓▓▒▓█▓▒░░░▒▓▓██████████████████████████████████████                                                                    //
//    ██████████████████████████████▒░░░░░░░░░░░░░░░░░░░▒▓██████████████████████████████████████                                                                    //
//    █████████████████████████████▓▒░░░░░░░░░░▒▓░░░░░░░░▒▓█████████████████████████████████████                                                                    //
//    █████████████████████████████▒░░░░░░░░░░░░░░░░░░░░▒▒▓█████████████████████████████████████                                                                    //
//    █████████████████████████████▒░░░░░░░░░░░░░░░░░░░▒▒▒▒▓████████████████████████████████████                                                                    //
//    ██████████████████████████████▒░░░░░░▒▒▒▒▓▒▒▒▒░░▒▒▒▒▒▓████████████████████████████████████                                                                    //
//    ████████████████████████████████▒░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████████████████████████████████████                                                                    //
//    ██████████████████████████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓███████████████████████████████████████                                                                    //
//    ███████████████████████████████████▓▒▒▒▒▒▒▒▒▒▒▓███████████████████████████████████████████                                                                    //
//    █████████████████████████████████████▓▒▒▒▒▒▒▒▒████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████▓▒▒▒▒▒▒█████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████▓▓▒▒▒▒▒▒▒▓█▓▓▓██████████████████████████████████████████                                                                    //
//    █████████████████████████████████▓▓▓▓▓▓▓▒▒▓███████████████████████████████████████████████                                                                    //
//    ██████████████████████████████▓██▓▓███▓▓▓▒▓██▓████████████████████████████████████████████                                                                    //
//    █████████████████████████████▓▓█▓▓▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓████████████████████████████████████████                                                                    //
//    ██████████████████████████████▒▒▓▓▓▒▒▒▒▒▒▒▒▓▓▒▓▓▓█████████████████████████████████████████                                                                    //
//    ███████████████████████████████▓█▓▓▓▒▒▒▒▓▓▓█▓▓▓▓██████████████████████████████████████████                                                                    //
//    █████████████████████████████████▓▓▓▒▒▒▒▒▒▓▓▓▓▓███████████████████████████████████████████                                                                    //
//    ██████████████████████████████████▓▓▓▒▓▓▓▓▓█▓▓████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████▓▓▓▓▒▒▒▒▓▓▓▓████████████████████████████████████████████                                                                    //
//    ████████████████████████████████▓▓▓▒▓▓▓▓▓▓▓▓▓█████████████████████████████████████████████                                                                    //
//    █████████████████████████████▓▒▒▒▒▒▒▒▓▓▓████████▓▓████████████████████████████████████████                                                                    //
//    ███████████████████████████▓▒▒▒░▒▒▒▒▒▒▓▓▓█████▓██▓▓▓██████████████████████████████████████                                                                    //
//    █████████████████████████▓▒▒▒░░░░▒▒▒▒▓▓▓▓▓█████▓███▓▓██▓▓███▓▓████████████████████████████                                                                    //
//    ████████████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒░▒▒░▒▒▒▒▓▓▓█████▓▓▓▓▓▓▓▒▓▓▓▓▓▓▓▓▓███████████████████████████                                                                    //
//    ██████████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒░▒▒▒▒▒▒▓▓▓▓▓▓██▓▒▓▓▓▓▓▒▒▒▓▓▓▓▓▓█▓▓█████████████████████████                                                                    //
//    ████████████▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒░░░▒▒▒▒▓▓▓▓▓▓▓▓▒▒▓▓▓▒▒▒▒▒▓▓▓█▓▓▓▓▓████████████████████████                                                                    //
//    ████████████▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▓▒▒▓▓▒▒▓▓▓▓▒▒▓▒▒▒▒▒▒▒▓▓▓█▓▓█▓████████████████████████                                                                    //
//    ███████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒▒▒▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓█▓▓▓▓████████████████████████                                                                    //
//    ███████████▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓██▓▓▓████████████████████████                                                                    //
//    ██████████▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓██▓▓▓▓███████████████████████                                                                    //
//    ██████████▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▓▓█▓▓███████████████████████                                                                    //
//    ██████████▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████▓▒▒▒▒▒▒▒▒▒▓▓▓███▓███████████████████████                                                                    //
//    ██████████▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓█████▒▓▒▒▒▒▒▒▒▓▓▓▓███▓██████████████████████                                                                    //
//    ███████████▓█▓█▓▓▓▓▓▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓████▒▒▒▒▒▒▒▒▒▓▓▓▓███▓██████████████████████                                                                    //
//    ███████████▓███▓▓▓▓▓▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▓▒▒▒▒▒▒▒▒▓▓▓▓▓███▓█████████████████████                                                                    //
//    ███████████▓▓▓█▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▒▓▒▒▒▒▒▓▓▓▓█▓█▓█▓█████████████████████                                                                    //
//    ████████████▓▓█▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▓████▒▓▓▓▒▓▓▓▓▓██▓▓████████████████████████                                                                    //
//    █████████████▓██▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▒▒▓▒▒▒▒▒▒▒▓▒▒▒▓▓████▒▓▓▓▓▓▓▓▓▓███▓████████████████████████                                                                    //
//    █████████████▓██▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓▓▒▒▓▓▒▒▒▒▒▓▓▒▒▒▓▓███▓▒▓▓▓▓▓▓▓▓████▓█▓██████████████████████                                                                    //
//    ████████████████▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▓▒▓▓▓▓▓▓▓▓███▓▓▓▓▓▓▓▓▓▓█████████████████████████████                                                                    //
//    ████████████████▓▓▓▓▓▒▒▒▒▒▒▒▒▓▓▓▓▓▓▓▓▓▒▒▓▓▓▒▒▒▓▓███▓▓▓▓▓▓▓▓▓██████████████████████████████                                                                    //
//    █████████████████▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▒▒▒▒▒▒▒▒▒▒▓▓███▓▓▓▓▓▓▓▓▓██████████████████████████████                                                                    //
//    ██████████████████▓▓▓▒▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▓▓███▓▓▓▓▓▓▓▓███████████████████████████████                                                                    //
//    ███████████████████▓▓█████▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▓██▓▓▓▓▓▓▓▓████▓▓▓██▓██████████████████████                                                                    //
//    ████████████████████████▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▓▒▒▒▓█▓▓▓▒▒▓▓▓██▓▓▓▓▓▓▓▓▓▓████████████████████                                                                    //
//    █████████████████████▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▒▓▓▓▓██▓▓▓▓▓▓▓▓▓▓████████████████████                                                                    //
//    █████████████████████▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▒▒▒▒▒▒▒▒▒▓█▓▓▓▓▓█▓▓▓▒▒▓▓▓███████████                                                                    //
//    █████████████████████▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░▓▒▒▓▓▓▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▓████████                                                                    //
//    ████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒░░░▓▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▓▓▓▒▓▓█████████                                                                    //
//    ███████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒▒▓▓▓▓▓▓▓▓▒▒▒▓▓▓▓▓▓▓▓▓▓███████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ██████████████████████████████████████████████████████████████████████████████████████████                                                                    //
//    ████████████████████████████████████████▓▓▓██████████▓▓▓██████████████████████████████████                                                                    //
//                                                                                                                                                                  //
//                                                                                                                                                                  //
//                                                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SOB is ERC721Creator {
    constructor() ERC721Creator("Sense Of Beauty", "SOB") {}
}