// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LIGHTS
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//                                    ◎◎◎        ◎◎◎                                    //
//                                  ◎◎◎◎◎◎◎    ◎◎◎◎◎◎◎                                  //
//                                  ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎                                  //
//                                  ◎○○○○○◎◎◎◎◎◎○○○○○◎                                  //
//                                  ○○○○○○○◎◎◎◎○○○○○○○                                  //
//                                 ○○○○○○○○◎◎◎◎○○○○○○○○                                 //
//                                 ○○○○○○○○◎◎◎◎○○○○○○○○                                 //
//                                 ○○○○○○○○◎◎◎◎○○○○○○○○                                 //
//                                 ○○○○○○○○◎◎◎◎○○○○○○○○                                 //
//                                ○○○○○○○○○◎◎◎◎○○○○○○○○○                                //
//                                ○○○○○○○○○◎◎◎◎○○○○○○○○○                                //
//                                ○○○○○○○○○◎◎◎◎○○○○○○○○○                                //
//                                ○○○○○○○○○◎◎◎◎○○○○○○○○○                                //
//                               ○○○○○○○○○○◎◎◎◎○○○○○○○○○○                               //
//                               ○○○○○○○○○○◎◎◎◎○○○○○○○○○○                               //
//                              ○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○                              //
//                             ○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○                             //
//                             ○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○                             //
//                            ○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○                            //
//                            ○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○                            //
//                            ○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○                            //
//                          ○○○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○○○                          //
//             ◎◎◎◎◎◎◎    ○○○○○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○○○○○    ◎◎◎◎◎◎◎             //
//          ◎◎◎◎◎◎◎●●●●○○○○○○○○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○○○○○○○○●●●●◎◎◎◎◎◎◎          //
//       ◎◎◎◎◎◎◎◎◎●●●○○○○○○○○○○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○○○○○○○○○○●●●◎◎◎◎◎◎◎◎◎       //
//     ◎◎◎◎◎◎◎◎◎◎◎●○○○○○○○○○○○○○○○○○○○○○○○○◎◎◎◎○○○○○○○○○○○○○○○○○○○○○○○○●◎◎◎◎◎◎◎◎◎◎◎     //
//    ◎◎◎◎◎◎◎◎◎◎◎◎●○○○○○○○○○○○○○○○○○○○○○○○○○◎◎○○○○○○○○○○○○○○○○○○○○○○○○○●◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎●○○○○○○○○○○○○○○○○○○○○○○○    ○○○○○○○○○○○○○○○○○○○○○○○●◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎●○○○○○○○○○○○○○○○○○○○○        ○○○○○○○○○○○○○○○○○○○○●◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎●●○○○○○○○○○○○○○○                ○○○○○○○○○○○○○○●●◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎●○○○○○○○○○                        ○○○○○○○○○●◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎●○○○○●●◎                        ◎●●○○○○●◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎●●●●●●◎◎                      ◎◎●●●●●●◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎●●●◎◎◎                      ◎◎◎●●●◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎                        ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//    ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎                          ◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎◎    //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract LIGHTS is ERC1155Creator {
    constructor() ERC1155Creator("LIGHTS", "LIGHTS") {}
}