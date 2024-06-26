// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Al Tierra | The World of Dreams
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                           //
//                                                                                           //
//    .______  .___         _____._.___ ._______.______  .______  .______                    //
//    :      \ |   |        \__ _:|: __|: .____/: __   \ : __   \ :      \                   //
//    |   .   ||   |          |  :|| : || : _/\ |  \____||  \____||   .   |                  //
//    |   :   ||   |/\        |   ||   ||   /  \|   :  \ |   :  \ |   :   |                  //
//    |___|   ||   /  \       |   ||   ||_.: __/|   |___\|   |___\|___|   |                  //
//        |___||______/       |___||___|   :/   |___|    |___|        |___|                  //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//    _____._.___.__  ._______              ___ ._______  .______  .___    .______           //
//    \__ _:|:   |  \ : .____/     .___    |   |: .___  \ : __   \ |   |   :_ _   \          //
//      |  :||   :   || : _/\      :   | /\|   || :   |  ||  \____||   |   |   |   |         //
//      |   ||   .   ||   /  \     |   |/  :   ||     :  ||   :  \ |   |/\ | . |   |         //
//      |   ||___|   ||_.: __/     |   /       | \_. ___/ |   |___\|   /  \|. ____/          //
//      |___|    |___|   :/        |______/|___|   :/     |___|    |______/ :/               //
//                                         :       :                        :                //
//                                         :                                                 //
//                                                                                           //
//    ._______  ._______     .______  .______  ._______.______  ._____.___ .________         //
//    : .___  \ :_ ____/     :_ _   \ : __   \ : .____/:      \ :         ||    ___/         //
//    | :   |  ||   _/       |   |   ||  \____|| : _/\ |   .   ||   \  /  ||___    \         //
//    |     :  ||   |        | . |   ||   :  \ |   /  \|   :   ||   |\/   ||       /         //
//     \_. ___/ |_. |        |. ____/ |   |___\|_.: __/|___|   ||___| |   ||__:___/          //
//       :/       :/          :/      |___|       :/       |___|      |___|   :              //
//       :        :           :                                                              //
//                                                                                           //
//                                                                                           //
//                                                                                           //
//                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////


contract Dreamer is ERC721Creator {
    constructor() ERC721Creator("Al Tierra | The World of Dreams", "Dreamer") {}
}