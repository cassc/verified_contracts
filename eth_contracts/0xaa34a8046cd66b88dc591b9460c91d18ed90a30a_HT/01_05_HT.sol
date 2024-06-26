// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HANAFUDA'S TIME
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                  .                                     //
//                                    *****       *****.                                  //
//                                  *********  .*********                                 //
//                                 ***********************                                //
//                                *************************                               //
//                               ,*************************,                              //
//                               ***************************                              //
//                               ***************************                              //
//             ,*********.       ***************************    *************,            //
//        .***********************************************************************        //
//          *********************************************************************         //
//           ******************************************************************,          //
//            *****************************************************************           //
//       ,**************************************************************************      //
//     *******************************************************************************    //
//      ,****************************************************************************     //
//         ***********************************************************************,       //
//           .*****************************************************************.          //
//               *********************************************************.               //
//                    ************************************************                    //
//                      ***********************************************                   //
//                    **************************************************,                 //
//                  ,****************************************************.                //
//                 *******************************************************                //
//                *********************************************************               //
//               .*********************************************************               //
//               ****************************  ****************************               //
//               **************************     .**************************               //
//                         *************,         ,***************                        //
//                         **********.               ************,                        //
//                         .*****,                      .********                         //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract HT is ERC721Creator {
    constructor() ERC721Creator("HANAFUDA'S TIME", "HT") {}
}