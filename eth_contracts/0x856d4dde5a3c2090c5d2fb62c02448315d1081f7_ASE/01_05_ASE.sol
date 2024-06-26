// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Andy Schwetz Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                     ***                                                                                                                   //
//                                                   ******.                                                                                                                 //
//                                                   *******                                                                                                                 //
//                  *                               *********                              .,                                                                                //
//                  *****                           *********                           *****                                                                                //
//                  ********                        *********                        ********                                                                                //
//                  **********                      *********                     ,**********                                                                                //
//                  ************                    ********,                   ,************                                                                                //
//                  **************                  ********.                  **************                                                                                //
//                  ******  .******.                 *******                 *******.  ******                                                                                //
//                  ******    ******,                *******                *******    ******                                                                                //
//                  ******     ******,               *******               *******     ******                                                                                //
//                  ******      ******.              *******              ,******      ******                                                                                //
//                  ******       ******              *******              ******       ******                                                                                //
//                  ******       ,*****.             ******,             ,*****        ******                                                                                //
//                  ******        ******             ******.             ******        ******                                                                                //
//                  ******        ******             ******.             ******        ******                                                                                //
//                  ******        ******             ******.             ******        ******                                                                                //
//                  ******        .******            ******,            ******         ******                                                                                //
//                  ******         ******            *******            ******         ******                                                                                //
//                  ******         ******            *******            ******         ******                                                                                //
//                  ******         ,******          *********          ******          ******                                                                                //
//                  ******          ******         **********,         ******          ******                                                                                //
//                  ******        ********         ***********         ********        ******                                                                                //
//                  ******      **********.       *************       .**********      ******                                                                                //
//                  ******    *******.           ******* *******           .*******    ******                                                                                //
//                  ***************,            *******   *******            ****************                                                                                //
//                  ***************            *******     *******            ***************                                                                                //
//                  ****************          ******,       *******          ****************                                                                                //
//                  ******    ,*******.      ******          .******      ,*******.    ******                                                                                //
//                  ******      ******************             ******************      ******                                                                                //
//                  ******         *******************     *******************         ******                                                                                //
//                  ******               *******************************               ******                                                                                //
//                  ******              ******,    ***********    ,******              ******                                                                                //
//                  ******              ******       *******       ******              ******                                                                                //
//                  ******              ******       ******.       ******              ******                                                                                //
//                  *************************************************************************                                                                                //
//                  *************************************************************************                                                                                //
//                                      .******      ******.      ******                                                                                                     //
//                                       ******      ******.      ******                                                                                                     //
//                                        ******.    ******.    ,******                                                                                                      //
//                                         *******   ******.   *******                                                                                                       //
//                                          *******. ******. ,*******                                                                                                        //
//                                            *********************                                                                                                          //
//                                              *****************                                                                                                            //
//                                                ************,                                                                                                              //
//                                                   *******                                                                                                                 //
//                                                     .*                                                                                                                    //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//               .oooooo..o ooooo              .o.       oooooo     oooo ooooo                                                                                               //
//              d8P'    `Y8 `888'             .888.       `888.     .8'  `888'                                                                                               //
//              Y88bo.       888             .8"888.       `888.   .8'    888                                                                                                //
//               `"Y8888o.   888            .8' `888.       `888. .8'     888                                                                                                //
//                   `"Y88b  888           .88ooo8888.       `888.8'      888                                                                                                //
//              oo     .d8P  888       o  .8'     `888.       `888'       888                                                                                                //
//              8""88888P'  o888ooooood8 o88o     o8888o       `8'       o888o                                                                                               //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//    ooooo     ooo oooo    oooo ooooooooo.         .o.       ooooo ooooo      ooo oooooooooooo                                                                              //
//    `888'     `8' `888   .8P'  `888   `Y88.      .888.      `888' `888b.     `8' `888'     `8                                                                              //
//     888       8   888  d8'     888   .d88'     .8"888.      888   8 `88b.    8   888                                                                                      //
//     888       8   88888[       888ooo88P'     .8' `888.     888   8   `88b.  8   888oooo8                                                                                 //
//     888       8   888`88b.     888`88b.      .88ooo8888.    888   8     `88b.8   888    "                                                                                 //
//     `88.    .8'   888  `88b.   888  `88b.   .8'     `888.   888   8       `888   888       o                                                                              //
//       `YbodP'    o888o  o888o o888o  o888o o88o     o8888o o888o o8o        `8  o888ooooood8                                                                              //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
//                                                                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ASE is ERC1155Creator {
    constructor() ERC1155Creator() {}
}