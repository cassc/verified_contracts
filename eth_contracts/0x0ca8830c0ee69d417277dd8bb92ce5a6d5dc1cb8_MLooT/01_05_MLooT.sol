// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Meme Loot
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////
//                                                              //
//                                                              //
//                                                              //
//      __  __ ___ __  __ ___   _    ___   ___ _____            //
//     |  \/  | __|  \/  | __| | |  / _ \ / _ \_   _|           //
//     | |\/| | _|| |\/| | _|  | |_| (_) | (_) || |             //
//     |_|  |_|___|_|  |_|___| |____\___/ \___/ |_|  by GLOW    //
//                                                              //
//        ~~~~:                                                 //
//              ~~~~.:::.                                       //
//            ~~   | _ _ |                                      //
//                 |  |  |                                      //
//                 |_____|                                      //
//              -+-__) (__-+-                                   //
//             {             }                                  //
//           :. |   .:      |                                   //
//           |  MEME |   |\LOOT/|                               //
//           |       |  /   xx  \                               //
//           |       | /   *)    )                              //
//           |       |/          \                              //
//           :       :            \                             //
//            \_____/     \___     \                            //
//                          / \  )  )                           //
//                          \  \___/                            //
//                           )                                  //
//                                                              //
//                                                              //
//////////////////////////////////////////////////////////////////


contract MLooT is ERC1155Creator {
    constructor() ERC1155Creator("Meme Loot", "MLooT") {}
}