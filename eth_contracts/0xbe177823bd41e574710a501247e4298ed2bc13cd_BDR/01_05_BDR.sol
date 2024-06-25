// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: A body, a dream, a regret
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                           //
//                                                                                                                                           //
//                                                        𝚊 𝚋𝚘𝚍𝚢                                                                        //
//                                                              𝚊 𝚍𝚛𝚎𝚊𝚖                                                                //
//                                                                     𝚊 𝚛𝚎𝚐𝚛𝚎𝚝                                                       //
//                                                                                                                                           //
//                                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BDR is ERC721Creator {
    constructor() ERC721Creator("A body, a dream, a regret", "BDR") {}
}