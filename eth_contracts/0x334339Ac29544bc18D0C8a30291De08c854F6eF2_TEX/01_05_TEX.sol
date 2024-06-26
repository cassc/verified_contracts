// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Airdrops by Textrnr
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////
//                                                      //
//                                                      //
//    //////////////////////////////////////////////    //
//    //                                          //    //
//    //                                          //    //
//    //     ___  ___     ___  __        __       //    //
//    //      |  |__  \_/  |  |__) |\ | |__)      //    //
//    //      |  |___ / \  |  |  \ | \| |  \      //    //
//    //                                          //    //
//    //    __________________________________    //    //
//    //                                          //    //
//    //    * MANIFOLD SMART CONTRACT             //    //
//    //    * ERC1155                             //    //
//    //    * TEXTRNR / TEX                       //    //
//    //    __________________________________    //    //
//    //                                          //    //
//    //                                          //    //
//    //////////////////////////////////////////////    //
//                                                      //
//                                                      //
//////////////////////////////////////////////////////////


contract TEX is ERC1155Creator {
    constructor() ERC1155Creator("Airdrops by Textrnr", "TEX") {}
}