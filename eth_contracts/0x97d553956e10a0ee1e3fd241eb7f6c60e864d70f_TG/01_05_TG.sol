// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Totochi Gift
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////
//                                                                          //
//                                                                          //
//     _______         _                 _      _    _____  _   __  _       //
//    |__   __|       | |               | |    (_)  / ____|(_) / _|| |      //
//       | |     ___  | |_   ___    ___ | |__   _  | |  __  _ | |_ | |_     //
//       | |    / _ \ | __| / _ \  / __|| '_ \ | | | | |_ || ||  _|| __|    //
//       | |   | (_) || |_ | (_) || (__ | | | || | | |__| || || |  | |_     //
//       |_|    \___/  \__| \___/  \___||_| |_||_|  \_____||_||_|   \__|    //
//                                                                          //
//                                                                          //
//                                                                          //
//                                                                          //
//                                                                          //
//////////////////////////////////////////////////////////////////////////////


contract TG is ERC1155Creator {
    constructor() ERC1155Creator("Totochi Gift", "TG") {}
}