// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mochima, The Ghost Donkey
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//    ___  ___           _     _                                                            //
//    |  \/  |          | |   (_)                                                           //
//    | .  . | ___   ___| |__  _ _ __ ___   __ _                                            //
//    | |\/| |/ _ \ / __| '_ \| | '_ ` _ \ / _` |                                           //
//    | |  | | (_) | (__| | | | | | | | | | (_| |                                           //
//    \_|  |_/\___/ \___|_| |_|_|_| |_| |_|\__,_|                                           //
//                                                                                          //
//                                                                                          //
//     _____ _            _____ _               _    ______            _                    //
//    |_   _| |          |  __ \ |             | |   |  _  \          | |                   //
//      | | | |__   ___  | |  \/ |__   ___  ___| |_  | | | |___  _ __ | | _____ _   _       //
//      | | | '_ \ / _ \ | | __| '_ \ / _ \/ __| __| | | | / _ \| '_ \| |/ / _ \ | | |      //
//      | | | | | |  __/ | |_\ \ | | | (_) \__ \ |_  | |/ / (_) | | | |   <  __/ |_| |      //
//      \_/ |_| |_|\___|  \____/_| |_|\___/|___/\__| |___/ \___/|_| |_|_|\_\___|\__, |      //
//                                                                               __/ |      //
//                                                                              |___/       //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract MGD is ERC721Creator {
    constructor() ERC721Creator("Mochima, The Ghost Donkey", "MGD") {}
}