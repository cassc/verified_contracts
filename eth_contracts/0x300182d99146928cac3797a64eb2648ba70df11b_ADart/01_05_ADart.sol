// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Aislandart
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
//                                               ▄▄                            //
//                                              ████▄                          //
//                                            ▄███▀███                         //
//                                           ███▀   ███▄                       //
//                                         ▄███      ▀███                      //
//                        █████████████████████████████████████████████████    //
//                        ▀▀▀▀▀▀▀▀▀▀▀▀▀▀████▀▀▀▀▀▀▀▀▀▀▀▀▀███▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀    //
//                                     ███▀               ███▀                 //
//                                   ▄███                  ▀███                //
//                                  ▄██▀                     ▀██▄              //
//                                 ███                        ▀███             //
//                               ▄██▀                           ▀██▄           //
//                              ███                               ███▄         //
//                            ▄██▀                                 ▀██▄        //
//                           ███▀                                    ███▄      //
//                         ▄███                                       ▀██▄     //
//                        █████████████████████████████████████████████████    //
//                        ▀███▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀████    //
//                         ▀███                                       ▄██▀     //
//                           ███▄                                   ▄███       //
//                            ▀███                                 ▄██▀        //
//                              ███▄                             ▄███          //
//                               ▀██▄                           ▄██▀           //
//                                 ███                         ███             //
//                                  ███▄                     ▄██▀              //
//                                   ▀███                   ███▀               //
//                                     ███▄               ▄██▀                 //
//                                      ▀██▄             ███▀                  //
//                                        ███          ▄███                    //
//                                         ▀██▄       ███▀                     //
//                                          ▀███    ▄███                       //
//                                            ███▄ ███▀                        //
//                                             ▀█████                          //
//                                               ██▀                           //
//                                                                             //
//                                                                             //
//    ---                                                                      //
//    aislandart                                                               //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract ADart is ERC721Creator {
    constructor() ERC721Creator("Aislandart", "ADart") {}
}