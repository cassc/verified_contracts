// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: True Face
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//                                                                              //
//    ████████╗██████╗ ██╗   ██╗███████╗    ███████╗ █████╗  ██████╗███████╗    //
//    ╚══██╔══╝██╔══██╗██║   ██║██╔════╝    ██╔════╝██╔══██╗██╔════╝██╔════╝    //
//       ██║   ██████╔╝██║   ██║█████╗      █████╗  ███████║██║     █████╗      //
//       ██║   ██╔══██╗██║   ██║██╔══╝      ██╔══╝  ██╔══██║██║     ██╔══╝      //
//       ██║   ██║  ██║╚██████╔╝███████╗    ██║     ██║  ██║╚██████╗███████╗    //
//       ╚═╝   ╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚══════╝    //
//                                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract TF is ERC721Creator {
    constructor() ERC721Creator("True Face", "TF") {}
}