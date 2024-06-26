// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sender by Dun
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                  ,╗╗╣╬╬╬╬╬╬╣           //
//                                                                 ╔╣╬╬╬╬╬╬╬╬╬╬▓          //
//                                                                 ║╬╬╬╬╬╬╬╬╬╬╬╬          //
//                                                                 ╬╬╬╬╬╬╬╬╬╬╬╬╬          //
//                                                                ╣╬╬╬╬╬╬╬╬╬╬╬╬▒          //
//                                                                ║╬╬╬╬╬╬╬╬╬╬╬╬▒          //
//                                                                 ║╬╬╬╬╬╬╬╬╬╬╬▒          //
//                                                                  ╠╬╬╬╬╣╝╝╙╙`           //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract SNDR is ERC721Creator {
    constructor() ERC721Creator("Sender by Dun", "SNDR") {}
}