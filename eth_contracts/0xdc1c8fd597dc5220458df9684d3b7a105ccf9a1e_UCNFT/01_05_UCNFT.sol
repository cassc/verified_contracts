// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: University of Cincinnati - NFT Media Lan
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                 //
//                                                                                                                                 //
//    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//    //                                                                                                                     //    //
//    //                                                                                                                     //    //
//    //    #     #  #####     #     # ####### #######    #     # ####### ######  ###    #       #          #    ######      //    //
//    //    #     # #     #    ##    # #          #       ##   ## #       #     #  #    # #      #         # #   #     #     //    //
//    //    #     # #          # #   # #          #       # # # # #       #     #  #   #   #     #        #   #  #     #     //    //
//    //    #     # #          #  #  # #####      #       #  #  # #####   #     #  #  #     #    #       #     # ######      //    //
//    //    #     # #          #   # # #          #       #     # #       #     #  #  #######    #       ####### #     #     //    //
//    //    #     # #     #    #    ## #          #       #     # #       #     #  #  #     #    #       #     # #     #     //    //
//    //     #####   #####     #     # #          #       #     # ####### ######  ### #     #    ####### #     # ######      //    //
//    //                                                                                                                     //    //
//    //                                                                                                                     //    //
//    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//                                                                                                                                 //
//                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract UCNFT is ERC721Creator {
    constructor() ERC721Creator("University of Cincinnati - NFT Media Lan", "UCNFT") {}
}