// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 6529 MEMEmorabilia
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                        ████████████████████████████████████████████████    //
//                        ███▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀    //
//                        ███                                                 //
//                        ████████████████████████████████████████████████    //
//                        ███                                          ███    //
//                        ███▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄███    //
//                        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀    //
//                                                                            //
//                        ████████████████████████████████████████████████    //
//                        ███└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└└███    //
//                        ███▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ┌▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄███    //
//                        ██████████████████████▌  ▐██████████████████████    //
//                                            ██▌  ▐██⌐                       //
//                        ██████████████████████▌  ▐██████████████████████    //
//                        ╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙└  └╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙    //
//                        ╓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄    //
//                        ████████████████████████████████████████████████    //
//                        ███                                          ███    //
//                        ████████████████████████████████████████████████    //
//                        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀███    //
//                                                                     ███    //
//                        ████████████████████████████████████████████████    //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//                                                                            //
//        ╬╬                                                                  //
//                                                                            //
//    ---                                                                     //
//    6529 MEMEmorabilia                                                      //
//                                                                            //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


contract MEMEm is ERC1155Creator {
    constructor() ERC1155Creator("6529 MEMEmorabilia", "MEMEm") {}
}