// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Editions by Meowgress
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//                           @@(                                                 &@(                          //
//                           @@@@                                              ,@@@@                          //
//                           @@@@@@@                                         @@@@@@@                          //
//                          @@@@@@@@@@/                                   %@@@@@@@@@@                         //
//                          @@@@@@@@@@@@@                               @@@@@@@@@@@@@                         //
//                (@        @@@@@@@@@@@@@@@@                        [email protected]@@@@@@@@@@@@@@@        @                //
//                 @@       @@@@@@@@@@@@@@@@@@@                   @@@@@@@@@@@@@@@@@@@       @@                //
//                  @@@     @@@@@@@@@@@@@@@@@@@@@@             @@@@@@@@@@@@@@@@@@@@@@     @@@                 //
//             [email protected]      @@@  %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@* ,@@@      @             //
//               @@        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@              //
//                 @@@.       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@       /@@@                //
//                      @@@@@ (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@                     //
//                           *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                          //
//                            @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                           //
//                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                          //
//                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                          //
//                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                          //
//                          *@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                          //
//                           @ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @                          //
//                            (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                           //
//                              @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                             //
//                                %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#                               //
//                                   [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                   //
//                                      @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                                     //
//                                         @@@@@@@@@@@@@@@@@@@@@@@@@@@                                        //
//                                          @@@@@@@@@@@@@@@@@@@@@@@@@                                         //
//                                              @@@@@@@@@@@@@@@@/                                             //
//                                                   .%@@@@                                                   //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract EDITIONS is ERC1155Creator {
    constructor() ERC1155Creator("Editions by Meowgress", "EDITIONS") {}
}