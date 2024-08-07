// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BEAN: CHECK
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    This bean may or may not be notable.                                                //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//              ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                             ▓▓▓▓▓▓▓▓▓▓▓▓                //
//           ▓▓▓▓               ▓▓▓▓▓                    ▓▓▓▓▓▓          ▓▓▓▓▓            //
//         ▓▓▓                      ▓▓▓▓▓            ▓▓▓▓▓                   ▓▓▓▓         //
//        ▓▓                            ▓▓▓▓▓▓▓▓▓▓▓▓▓▓                          ▓▓        //
//       ▓▓                                      ▓▓                              ▓▓▓      //
//      ▓▓                               ▓▓▓▓▓▓▓▓▓▓              ▓▓▓▓▓▓▓▓▒        ▓▓▓     //
//     ▓▓                                                       ▓▓▓▓▓▓▓▓▓▓▓        ▓▓     //
//     ▓▓                                                       ▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓    //
//     ▓▓                                                        ▓▓▓▓▓▓▓▓▓▓         ▓▓    //
//     ▓▓                                                          ▓▓▓▓▓▓           ▓▓    //
//     ▓▓                                                                           ▓▓    //
//     ▓▓    ▓                                                                      ▓▓    //
//      ▓▓   ▓▓▓   ▓░                                                               ▓▓    //
//      ▓▓▓   ▓▓▓   ▓▓                                                             ▓▓     //
//       ▓▓▓    ▓▓▓   ▓▓                                                          ▓▓▓     //
//         ▓▓▓    ▓▓▓   ▓▓▓                                                      ▓▓▓      //
//           ▓▓▓    ░▓▓▓    ▓▓▓▓                                               ▓▓▓        //
//             ▓▓▓      ▓▓▓▓     ▓▓▓▓▓▓                                      ▓▓▓          //
//               ▓▓▓▓       ▓▓▓▓▓                                         ▓▓▓▓            //
//                  ▓▓▓▓▓          ▓▓                                 ▓▓▓▓▓               //
//                       ▓▓▓▓▓▓▓                                ▓▓▓▓▓▓▓                   //
//                             ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                         //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract BEAN is ERC1155Creator {
    constructor() ERC1155Creator("BEAN: CHECK", "BEAN") {}
}