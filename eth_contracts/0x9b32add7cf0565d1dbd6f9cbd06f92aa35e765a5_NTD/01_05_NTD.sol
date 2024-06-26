// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Natived
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//    __/\\\\\_____/\\\_________________________________________________________________________/\\\__            //
//     _\/\\\\\\___\/\\\________________________________________________________________________\/\\\__           //
//      _\/\\\/\\\__\/\\\____________________/\\\_______/\\\_____________________________________\/\\\__          //
//       _\/\\\//\\\_\/\\\__/\\\\\\\\\_____/\\\\\\\\\\\_\///___/\\\____/\\\_____/\\\\\\\\_________\/\\\__         //
//        _\/\\\\//\\\\/\\\_\////////\\\___\////\\\////___/\\\_\//\\\__/\\\____/\\\/////\\\___/\\\\\\\\\__        //
//         _\/\\\_\//\\\/\\\___/\\\\\\\\\\_____\/\\\______\/\\\__\//\\\/\\\____/\\\\\\\\\\\___/\\\////\\\__       //
//          _\/\\\__\//\\\\\\__/\\\/////\\\_____\/\\\_/\\__\/\\\___\//\\\\\____\//\\///////___\/\\\__\/\\\__      //
//           _\/\\\___\//\\\\\_\//\\\\\\\\/\\____\//\\\\\___\/\\\____\//\\\______\//\\\\\\\\\\_\//\\\\\\\/\\_     //
//            _\///_____\/////___\////////\//______\/////____\///______\///________\//////////___\///////\//__    //
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NTD is ERC1155Creator {
    constructor() ERC1155Creator("Natived", "NTD") {}
}