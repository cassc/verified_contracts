// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Check's Legacy
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*/(/*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@/(((((((((((((((((((((((((((((((((((((((((((((((((((((((,@@@@@@@@@@@    //
//    @@@@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((*@@@@@@@@@    //
//    @@@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((.    /(((((((((((@@@@@@@@    //
//    @@@@@@@((((((((((((((((((((((((((((((((((((((((((((((          (((((((((((@@@@@@    //
//    @@@@@@(((((((((((((((((((((((((((((((((((((((((((((              ((((((((((@@@@@    //
//    @@@@@(((((((((((((((((((((((((((((((((((((((((((                  ((((((((((@@@@    //
//    @@@@((((((((((((((((((((((((((((((((((((((((((                 ((((((((((((((@@@    //
//    @@@@(((((((((((((((((((((((((((((((((((((((                  ((((((((((((((((@@@    //
//    @@@((((((((((((((((((((((((((((((((((((((                 ((((((((((((((((((((@@    //
//    @@@((((((((((((((((((    (((((((((((((.                 ((((((((((((((((((((((@@    //
//    @@@(((((((((((((((/        (((((((((                  ((((((((((((((((((((((((@@    //
//    @@@(((((((((((((              ((((                 (((((((((((((((((((((((((((@@    //
//    @@@((((((((((((                                  (((((((((((((((((((((((((((((@@    //
//    @@@@(((((((((((((                             (((((((((((((((((((((((((((((((@@@    //
//    @@@@((((((((((((((((                        (((((((((((((((((((((((((((((((((@@@    //
//    @@@@@(((((((((((((((((                   (((((((((((((((((((((((((((((((((((@@@@    //
//    @@@@@@((((((((((((((((((               ((((((((((((((((((((((((((((((((((((@@@@@    //
//    @@@@@@@((((((((((((((((((((          (((((((((((((((((((((((((((((((((((((@@@@@@    //
//    @@@@@@@@@((((((((((((((((((((     ((((((((((((((((((((((((((((((((((((((@@@@@@@@    //
//    @@@@@@@@@@*(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@    //
//    @@@@@@@@@@@@,(((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract Checks is ERC1155Creator {
    constructor() ERC1155Creator("The Check's Legacy", "Checks") {}
}