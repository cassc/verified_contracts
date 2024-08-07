// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: SOPHI
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////
//                                                //
//                                                //
//    .------..------..------..------..------.    //
//    |S.--. ||O.--. ||P.--. ||H.--. ||I.--. |    //
//    | :/\: || :/\: || :/\: || :/\: || (\/) |    //
//    | :\/: || :\/: || (__) || (__) || :\/: |    //
//    | '--'S|| '--'O|| '--'P|| '--'H|| '--'I|    //
//    `------'`------'`------'`------'`------'    //
//                                                //
//                                                //
////////////////////////////////////////////////////


contract SOPHI is ERC721Creator {
    constructor() ERC721Creator("SOPHI", "SOPHI") {}
}