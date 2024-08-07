// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Printmaking by Godwits
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                            //
//                                                                                                                            //
//       ________  ________   ________  ________  ________  ________  ________  ____ ___   ________  ________  ________       //
//      ╱        ╲╱        ╲ ╱        ╲╱    ╱   ╲╱        ╲╱        ╲╱        ╲╱    ╱   ╲ ╱        ╲╱    ╱   ╲╱        ╲      //
//     ╱         ╱         ╱_╱       ╱╱         ╱        _╱         ╱         ╱         ╱_╱       ╱╱         ╱       __╱      //
//    ╱       __╱        _╱╱         ╱         ╱╱       ╱╱         ╱         ╱        _╱╱         ╱         ╱       ╱ ╱       //
//    ╲______╱  ╲____╱___╱ ╲________╱╲__╱_____╱ ╲______╱ ╲__╱__╱__╱╲___╱____╱╲____╱___╱ ╲________╱╲__╱_____╱╲________╱        //
//       ________  ________                                                                                                   //
//      ╱       ╱ ╱    ╱   ╲                                                                                                  //
//     ╱        ╲╱         ╱                                                                                                  //
//    ╱         ╱╲__      ╱                                                                                                   //
//    ╲________╱   ╲_____╱                                                                                                    //
//       ________  ________   _______  ________   ________  ________  ________            s                                   //
//      ╱        ╲╱        ╲_╱       ╲╱  ╱  ╱  ╲ ╱        ╲╱        ╲╱        ╲                                               //
//     ╱       __╱         ╱         ╱         ╱_╱       ╱╱        _╱        _╱                                               //
//    ╱       ╱ ╱         ╱         ╱         ╱╱         ╱╱       ╱╱-        ╱                                                //
//    ╲________╱╲________╱╲________╱╲________╱ ╲________╱ ╲______╱ ╲________╱                                                 //
//                                                                                                                            //
//                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PRNT is ERC721Creator {
    constructor() ERC721Creator("Printmaking by Godwits", "PRNT") {}
}