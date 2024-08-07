// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dragon Breeder Card
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
//      _____                                ____                    _              _____              _     //
//     |  __ \                              |  _ \                  | |            / ____|            | |    //
//     | |  | |_ __ __ _  __ _  ___  _ __   | |_) |_ __ ___  ___  __| | ___ _ __  | |     __ _ _ __ __| |    //
//     | |  | | '__/ _` |/ _` |/ _ \| '_ \  |  _ <| '__/ _ \/ _ \/ _` |/ _ \ '__| | |    / _` | '__/ _` |    //
//     | |__| | | | (_| | (_| | (_) | | | | | |_) | | |  __/  __/ (_| |  __/ |    | |___| (_| | | | (_| |    //
//     |_____/|_|  \__,_|\__, |\___/|_| |_| |____/|_|  \___|\___|\__,_|\___|_|     \_____\__,_|_|  \__,_|    //
//                        __/ |                                                                              //
//                       |___/                                                                               //
//                                                                                                           //
//                                                                                                           //
//                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DBCARD is ERC721Creator {
    constructor() ERC721Creator("Dragon Breeder Card", "DBCARD") {}
}