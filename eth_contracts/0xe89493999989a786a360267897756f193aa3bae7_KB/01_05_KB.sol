// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Art of Kenneth Burris
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//    .______  .______  _____._     ._______  ._______     .____/\ ._______.______  .______  .____________._.___.__       ._______ .____     .______  .______  .___ .________         //
//    :      \ : __   \ \__ _:|     : .___  \ :_ ____/     :   /  \: .____/:      \ :      \ : .____/\__ _:|:   |  \      : __   / |    |___ : __   \ : __   \ : __||    ___/         //
//    |   .   ||  \____|  |  :|     | :   |  ||   _/       |.  ___/| : _/\ |       ||       || : _/\   |  :||   :   |     |  |>  \ |    |   ||  \____||  \____|| : ||___    \         //
//    |   :   ||   :  \   |   |     |     :  ||   |        |     \ |   /  \|   |   ||   |   ||   /  \  |   ||   .   |     |  |>   \|    :   ||   :  \ |   :  \ |   ||       /         //
//    |___|   ||   |___\  |   |      \_. ___/ |_. |        |      \|_.: __/|___|   ||___|   ||_.: __/  |   ||___|   |     |_______/|        ||   |___\|   |___\|   ||__:___/          //
//        |___||___|      |___|        :/       :/         |___\  /   :/       |___|    |___|   :/     |___|    |___|              |. _____/ |___|    |___|    |___|   :              //
//                                     :        :               \/                                                                  :/                                                //
//                                                                                                                                  :                                                 //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
//                                                                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract KB is ERC721Creator {
    constructor() ERC721Creator("Art of Kenneth Burris", "KB") {}
}