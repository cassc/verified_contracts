// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Hendro Soetrisno
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//                                                          @@@@@@@@@@                                                            //
//                                                    @@@@@@@@      @@@@@@@@@                                                     //
//                                              @@@@      @@@@@@@@@@@@@@@@@     @@@@@                                             //
//                                          @@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@                                         //
//                                       @@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@                                      //
//                                    @@@  @@@@@@@@@@@@@                     @@@@@@@@@@@@@  @@@                                   //
//                                  @@   @@@@@@@@@@                               @@@@@@@@@@   @@                                 //
//                                @@  @@@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@   @@                               //
//                              @@   @@@@@@@@        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@   @@                             //
//                             @@  @@@@@@@@       @@@@@@@     @@@@@@@@@@@@    @@@@@@@@@@@ @@@@@@@@  @@                            //
//                            @@  @@@@@@@       @@@@@@@@      @@@@@@@@@@      @@@@@@@@@@@@@ @@@@@@@  @@                           //
//                           @@  @@@@@@@       @@@@@@@@       @@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@  @@                          //
//                          @@  @@@@@@@       @@@@@@@@@       @@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@  @@                         //
//                         @@  @@@@@@@       @@@@@@@@@@       @@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@  @@                        //
//                        @@  @@@@@@@       @@@@@@@@@@        @@@@@@@@@       @@@@@@@@@@@@@@@@@@@@@@@@@  @@                       //
//                        @@  @@@@@@@                         @@     @@                         @@@@@@@  @@                       //
//                        @@  @@@@@@@                         @       @                         @@@@@@@  @@                       //
//                        @@  @@@@@@@                         @@     @@                         @@@@@@@  @@                       //
//                        @@  @@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@       @@@@@@@@@@        @@@@@@@  @@                       //
//                         @@  @@@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@       @@@@@@@@@@       @@@@@@@  @@                        //
//                          @@  @@@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@       @@@@@@@@@       @@@@@@@  @@                         //
//                           @@  @@@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@       @@@@@@@@       @@@@@@@  @@                          //
//                            @@  @@@@@@@@@@@@@@@@@@@@@       @@@@@@@@@      @@@@@@@@       @@@@@@@  @@                           //
//                             @@  @@@@@@@%@@@@@@@@@@@@     @@@@@@@@@@@     @@@@@@@       @@@@@@@@  @@                            //
//                              @@  @@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        @@@@@@@@@  @@                             //
//                                @@  @@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@          @@@@@@@@@  @@                               //
//                                  @@  @@@@@@@@@@        @@@@@@@@@@@@@@@@         @@@@@@@@@@@  @@                                //
//                                    @@   @@@@@@@@@@@@                       @@@@@@@@@@@@   @@                                   //
//                                      @@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@                                     //
//                                          @@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@                                         //
//                                              @@@@     @@@@@@@@@@@@@@@@@@@     @@@@                                             //
//                                                   @@@@@@@             @@@@@@@                                                  //
//                                                        @@@@@@@@@@@@@@@@@                                                       //
//                                                              @@@@@                                                             //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//               @@   @@    @@@@@@    @@@  @@    @@@@@@     @@@@@       @@@@@           @@@@@@@   @@@@@@@    @@   @@              //
//               @@   @@    @@        @@@@ @@    @@  @@@    @@  @@     @@   @@          @@           @@      @@   @@              //
//               @@@@@@@    @@@@@@    @@@@@@@    @@   @@    @@@@@@    @@@   @@@         @@@@@@       @@      @@@@@@@              //
//               @@@@@@@    @@@@@@    @@ @@@@    @@   @@    @@@@@     @@@   @@@         @@@@@@       @@      @@@@@@@              //
//               @@   @@    @@        @@  @@@    @@  @@@    @@  @@     @@   @@    @@    @@           @@      @@   @@              //
//               @@   @@    @@@@@@    @@   @@    @@@@@@     @@  @@@     @@@@@     @@    @@@@@@@      @@      @@   @@              //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract hendro is ERC721Creator {
    constructor() ERC721Creator("Hendro Soetrisno", "hendro") {}
}