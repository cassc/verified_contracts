// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LOVELY PIG
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                            //
//                                                                                                                            //
//                                                                                                                            //
//    .------..------..------..------.     .------..------..------..------..------..------..------..------..------.           //
//    |T.--. ||Y.--. ||P.--. ||E.--. |.-.  |S.--. ||O.--. ||M.--. ||E.--. ||T.--. ||H.--. ||I.--. ||N.--. ||G.--. |.-.        //
//    | :/\: || (\/) || :/\: || (\/) ((5)) | :/\: || :/\: || (\/) || (\/) || :/\: || :/\: || (\/) || :(): || :/\: ((5))       //
//    | (__) || :\/: || (__) || :\/: |'-.-.| :\/: || :\/: || :\/: || :\/: || (__) || (__) || :\/: || ()() || :\/: |'-.-.      //
//    | '--'T|| '--'Y|| '--'P|| '--'E| ((1)) '--'S|| '--'O|| '--'M|| '--'E|| '--'T|| '--'H|| '--'I|| '--'N|| '--'G| ((1))     //
//    `------'`------'`------'`------'  '-'`------'`------'`------'`------'`------'`------'`------'`------'`------'  '-'      //
//                                                                                                                            //
//                                                                                                                            //
//                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PIG is ERC721Creator {
    constructor() ERC721Creator("LOVELY PIG", "PIG") {}
}