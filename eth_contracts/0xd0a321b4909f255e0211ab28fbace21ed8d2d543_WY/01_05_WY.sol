// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: WANGYUN
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//     .----------------.  .----------------.  .-----------------. .----------------.     //
//    | .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | |  ___  ____   | || |     _____    | || | ____  _____  | || |    ______    | |    //
//    | | |_  ||_  _|  | || |    |_   _|   | || ||_   \|_   _| | || |  .' ___  |   | |    //
//    | |   | |_/ /    | || |      | |     | || |  |   \ | |   | || | / .'   \_|   | |    //
//    | |   |  __'.    | || |      | |     | || |  | |\ \| |   | || | | |    ____  | |    //
//    | |  _| |  \ \_  | || |     _| |_    | || | _| |_\   |_  | || | \ `.___]  _| | |    //
//    | | |____||____| | || |    |_____|   | || ||_____|\____| | || |  `._____.'   | |    //
//    | |              | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract WY is ERC721Creator {
    constructor() ERC721Creator("WANGYUN", "WY") {}
}