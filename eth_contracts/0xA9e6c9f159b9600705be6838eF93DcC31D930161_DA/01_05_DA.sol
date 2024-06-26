// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Delawer Art
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//                                                                            //
//    ########  ######## ##          ###    ##      ## ######## ########      //
//    ##     ## ##       ##         ## ##   ##  ##  ## ##       ##     ##     //
//    ##     ## ##       ##        ##   ##  ##  ##  ## ##       ##     ##     //
//    ##     ## ######   ##       ##     ## ##  ##  ## ######   ########      //
//    ##     ## ##       ##       ######### ##  ##  ## ##       ##   ##       //
//    ##     ## ##       ##       ##     ## ##  ##  ## ##       ##    ##      //
//    ########  ######## ######## ##     ##  ###  ###  ######## ##     ##     //
//                         ###    ########  ########                          //
//                        ## ##   ##     ##    ##                             //
//                       ##   ##  ##     ##    ##                             //
//                      ##     ## ########     ##                             //
//                      ######### ##   ##      ##                             //
//                      ##     ## ##    ##     ##                             //
//                      ##     ## ##     ##    ##                             //
//                                                                            //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


contract DA is ERC721Creator {
    constructor() ERC721Creator("Delawer Art", "DA") {}
}