// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ascent
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////
//                                                  //
//                                                  //
//       #                                          //
//      # #    ####   ####  ###### #    # #####     //
//     #   #  #      #    # #      ##   #   #       //
//    #     #  ####  #      #####  # #  #   #       //
//    #######      # #      #      #  # #   #       //
//    #     # #    # #    # #      #   ##   #       //
//    #     #  ####   ####  ###### #    #   #       //
//                                                  //
//                                                  //
//////////////////////////////////////////////////////


contract Ascent is ERC1155Creator {
    constructor() ERC1155Creator("Ascent", "Ascent") {}
}