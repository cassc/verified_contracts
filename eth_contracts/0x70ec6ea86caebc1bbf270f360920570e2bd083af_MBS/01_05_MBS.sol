// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MomentsBySoomre
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                        //
//                                                                                                        //
//                                                                                                        //
//            _  _ ____ _  _ ____ _  _ ___ ____    ___  _   _    ____ ____ ____ _  _ ____ ____            //
//            |\/| |  | |\/| |___ |\ |  |  [__     |__]  \_/     [__  |  | |  | |\/| |__/ |___            //
//            |  | |__| |  | |___ | \|  |  ___]    |__]   |      ___] |__| |__| |  | |  \ |___            //
//                                                                                                        //
//    ___  _ ____ _ ___ ____ _       ____ ____ ___    ____ ____ _    _    ____ ____ ___ _ ____ _  _       //
//    |  \ | | __ |  |  |__| |       |__| |__/  |     |    |  | |    |    |___ |     |  | |  | |\ |       //
//    |__/ | |__] |  |  |  | |___    |  | |  \  |     |___ |__| |___ |___ |___ |___  |  | |__| | \|       //
//                                                                                                        //
//                                                                                                        //
//                     Digital Art Collection /// www.soomre.com /// Photo & Golf Moments                 //
//                                                                                                        //
//                                               MomentsBySoomre                                          //
//                                                                                                        //
//                                                                                                        //
//                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MBS is ERC721Creator {
    constructor() ERC721Creator("MomentsBySoomre", "MBS") {}
}