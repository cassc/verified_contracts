// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Moments
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////
//                                                          //
//                                                          //
//                                            ##########    //
//                                                          //
//                                                          //
//                                            ##########    //
//                                                          //
//                                                          //
//                                            ##########    //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////


contract MOMNT is ERC721Creator {
    constructor() ERC721Creator("Moments", "MOMNT") {}
}