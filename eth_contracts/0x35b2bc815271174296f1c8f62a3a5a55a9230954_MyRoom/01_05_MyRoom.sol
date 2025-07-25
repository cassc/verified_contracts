// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: My Room
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//     .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | | ____    ____ | || |  ____  ____  | || |  _______     | || |     ____     | || |     ____     | || | ____    ____ | |    //
//    | ||_   \  /   _|| || | |_  _||_  _| | || | |_   __ \    | || |   .'    `.   | || |   .'    `.   | || ||_   \  /   _|| |    //
//    | |  |   \/   |  | || |   \ \  / /   | || |   | |__) |   | || |  /  .--.  \  | || |  /  .--.  \  | || |  |   \/   |  | |    //
//    | |  | |\  /| |  | || |    \ \/ /    | || |   |  __ /    | || |  | |    | |  | || |  | |    | |  | || |  | |\  /| |  | |    //
//    | | _| |_\/_| |_ | || |    _|  |_    | || |  _| |  \ \_  | || |  \  `--'  /  | || |  \  `--'  /  | || | _| |_\/_| |_ | |    //
//    | ||_____||_____|| || |   |______|   | || | |____| |___| | || |   `.____.'   | || |   `.____.'   | || ||_____||_____|| |    //
//    | |              | || |              | || |              | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MyRoom is ERC1155Creator {
    constructor() ERC1155Creator("My Room", "MyRoom") {}
}