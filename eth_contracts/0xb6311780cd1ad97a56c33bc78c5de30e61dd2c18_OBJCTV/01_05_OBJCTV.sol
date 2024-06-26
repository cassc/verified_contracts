// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: objective theory
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//    84 104  101 32 111 98  106 101 99 116  105 118 101 32  116  104  101    //
//    111 114  121 32 111 102 32  99 111 110  116 114 97 99 116 115 32 104    //
//    111 108 100 115 32  116 104 97  116 32 97 110  32 97 103 114 101 101    //
//    109  101 110 116 32 98 101 116 119 101 101 110 32 112 97 114 116 105    //
//    101 115 32  105 115 32 108 101 103 97  108 108 121 32 98 105 110 100    //
//    105 110 103 32 105 102 44 32 105  110 32 116 104 101  32 111 112 105    //
//    110  105  111 110 32  111 102 32 97 32 114 101 97 115  111 110 97 98    //
//    108 101 32 112 101 114 115 111 110  32 119 104 111 32 105 115 32 110    //
//    111 116 32 97 32 112 97 114 116 121 32 116 111  32 116 104 101 32 99    //
//    111 110 116 114 97 99 116 44 32 97 110 32 111 102 102 101 114 32 104    //
//    97 115 32 98 101 101 110 32 109 97 100 101 32 97 110 100 32 97 99 99    //
//    101 112 116 101 100 46                                                  //
//                                                                            //
//    objective theory                                                        //
//    1/1s by nicedayJules                                                    //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


contract OBJCTV is ERC721Creator {
    constructor() ERC721Creator("objective theory", "OBJCTV") {}
}