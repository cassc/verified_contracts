// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ndru_editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//      __                           ___          __           ___                         __      //
//     / /   ____  _/|  ____  ____  / _/ ___  ___/ /_____ __  /  / ____  ____  _/|  ____   \ \     //
//    < <   /___/ > _< /___/ /___/ / /  / _ \/ _  / __/ // /  / / /___/ /___/ > _< /___/    > >    //
//     \_\        |/              / /  /_//_/\_,_/ /  \_,_/ _/ /              |/           /_/     //
//                               /__/           /_/        /__/                                    //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                        [[[[[[[[[                              ]]]]]]]]]                         //
//                        [:::::::[                              ]:::::::]                         //
//                        [:::::::[                              ]:::::::]                         //
//                        [:::::[[[                              ]]]:::::]                         //
//                        [::::[        xxxxxxx      xxxxxxx        ]::::]                         //
//                        [::::[         x:::::x    x:::::x         ]::::]                         //
//                        [::::[          x:::::x  x:::::x          ]::::]                         //
//                        [::::[           x:::::xx:::::x           ]::::]                         //
//                        [::::[            x::::::::::x            ]::::]                         //
//                        [::::[             x::::::::x             ]::::]                         //
//                        [::::[             x::::::::x             ]::::]                         //
//                        [::::[            x::::::::::x            ]::::]                         //
//                        [:::::[[[        x:::::xx:::::x        ]]]:::::]                         //
//                        [:::::::[       x:::::x  x:::::x       ]:::::::]                         //
//                        [:::::::[      x:::::x    x:::::x      ]:::::::]                         //
//                        [[[[[[[[[     xxxxxxx      xxxxxxx     ]]]]]]]]]                         //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract NDRUx is ERC1155Creator {
    constructor() ERC1155Creator("ndru_editions", "NDRUx") {}
}