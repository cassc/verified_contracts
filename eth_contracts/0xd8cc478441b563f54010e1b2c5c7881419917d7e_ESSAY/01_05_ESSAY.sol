// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Crypto Essay
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//     #####                                      #######                                //
//    #     # #####  #   # #####  #####  ####     #        ####   ####    ##   #   #     //
//    #       #    #  # #  #    #   #   #    #    #       #      #       #  #   # #      //
//    #       #    #   #   #    #   #   #    #    #####    ####   ####  #    #   #       //
//    #       #####    #   #####    #   #    #    #            #      # ######   #       //
//    #     # #   #    #   #        #   #    #    #       #    # #    # #    #   #       //
//     #####  #    #   #   #        #    ####     #######  ####   ####  #    #   #       //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract ESSAY is ERC1155Creator {
    constructor() ERC1155Creator("Crypto Essay", "ESSAY") {}
}