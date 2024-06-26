// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Hold On To Yourself
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////
//                                          //
//                                          //
//    ██╗      ██████╗ ██╗      █████╗      //
//    ██║     ██╔═══██╗██║     ██╔══██╗     //
//    ██║     ██║   ██║██║     ███████║     //
//    ██║     ██║   ██║██║     ██╔══██║     //
//    ███████╗╚██████╔╝███████╗██║  ██║     //
//    ╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝     //
//                                          //
//                                          //
//    ██████╗ ██╗  ██╗███████╗ █████╗       //
//    ██╔══██╗██║  ██║██╔════╝██╔══██╗      //
//    ██████╔╝███████║█████╗  ███████║      //
//    ██╔══██╗██╔══██║██╔══╝  ██╔══██║      //
//    ██║  ██║██║  ██║███████╗██║  ██║      //
//    ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝      //
//                                          //
//                                          //
//    ███████╗████████╗██╗   ██╗██╗  ██╗    //
//    ██╔════╝╚══██╔══╝╚██╗ ██╔╝╚██╗██╔╝    //
//    ███████╗   ██║    ╚████╔╝  ╚███╔╝     //
//    ╚════██║   ██║     ╚██╔╝   ██╔██╗     //
//    ███████║   ██║      ██║   ██╔╝ ██╗    //
//    ╚══════╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝    //
//                                          //
//                                          //
//                                          //
//                                          //
//                                          //
//////////////////////////////////////////////


contract HOTY is ERC721Creator {
    constructor() ERC721Creator("Hold On To Yourself", "HOTY") {}
}