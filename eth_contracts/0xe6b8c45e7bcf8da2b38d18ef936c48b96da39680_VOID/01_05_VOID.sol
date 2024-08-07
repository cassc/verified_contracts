// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MxVoid
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ################################################################################    //
//    ================================================================================    //
//    --------------------------------------------------------------------------------    //
//    ................................................................................    //
//                                                                                        //
//                                                                                        //
//            ...        ......            ......     ....            ...        ...      //
//           `;;.       .;;;'              `;;;.     .;'             `''       ';;;       //
//           [[[b     d'[[[  .,,,    ,,.   `[[[.   .['    .,,,,,.  ,,,,   .,,,,[[[        //
//          $ Y$$. .$  $$$   `$$b..$P'     `$$$. .$'    d$$' `$$b `$$$  d$$' `$$$         //
//         $  `$$$'   $$$     Y$$$'        `$$$.$'     $$$   $$$  $$$  $$$   $$$          //
//        8    Y     888   .o8"'88b        `888'      888   888  888  888   888           //
//      o8o        o888o o88'   888o       `8'       `Y8bod8P' o888o `Y8bod88P"           //
//                                                                                        //
//                                                                                        //
//                                                                                        //
//    ................................................................................    //
//    --------------------------------------------------------------------------------    //
//    ================================================================================    //
//    ################################################################################    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract VOID is ERC721Creator {
    constructor() ERC721Creator("MxVoid", "VOID") {}
}