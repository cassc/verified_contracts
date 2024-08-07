// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Born 2 Live (Born 2 Die Derivative)
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                       //
//                                                                                                       //
//                       ____   ____  _____  _   _ ___  _      _______      ________                     //
//       _     _     _  |  _ \ / __ \|  __ \| \ | |__ \| |    |_   _\ \    / /  ____|_     _     _       //
//     _| |_ _| |_ _| |_| |_) | |  | | |__) |  \| |  ) | |      | |  \ \  / /| |__ _| |_ _| |_ _| |_     //
//    |_   _|_   _|_   _|  _ <| |  | |  _  /| . ` | / /| |      | |   \ \/ / |  __|_   _|_   _|_   _|    //
//      |_|   |_|   |_| | |_) | |__| | | \ \| |\  |/ /_| |____ _| |_   \  /  | |____|_|   |_|   |_|      //
//                      |____/ \____/|_|  \_\_| \_|____|______|_____|   \/   |______|                    //
//                                                                                                       //
//                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////


contract B2L is ERC1155Creator {
    constructor() ERC1155Creator("Born 2 Live (Born 2 Die Derivative)", "B2L") {}
}