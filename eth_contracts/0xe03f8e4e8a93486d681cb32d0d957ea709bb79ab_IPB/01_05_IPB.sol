// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Irlpeepos Bulls
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//      _      _                                                          //
//     (_)    | |                                                         //
//      _ _ __| |_ __   ___  ___ _ __   ___                               //
//     | | '__| | '_ \ / _ \/ _ \ '_ \ / _ \                              //
//     | | |  | | |_) |  __/  __/ |_) | (_) |                             //
//     |_|_|  |_| .__/ \___|\___| .__/ \___/                              //
//          _   | | _           | | _     _       _               _       //
//         | |  |_|(_)          |_|| |   (_)     | |             | |      //
//       __| | ___  _ _ __   __ _  | |__  _ ___  | |__   ___  ___| |_     //
//      / _` |/ _ \| | '_ \ / _` | | '_ \| / __| | '_ \ / _ \/ __| __|    //
//     | (_| | (_) | | | | | (_| | | | | | \__ \ | |_) |  __/\__ \ |_     //
//      \__,_|\___/|_|_| |_|\__, | |_| |_|_|___/ |_.__/ \___||___/\__|    //
//       _____      _____    __/ |                                        //
//      / _ \ \ /\ / / _ \  |___/                                         //
//     | (_) \ V  V / (_) |                                               //
//      \___/ \_/\_/ \___/                                                //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract IPB is ERC721Creator {
    constructor() ERC721Creator("Irlpeepos Bulls", "IPB") {}
}