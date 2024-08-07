// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: XMARKS
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//                                                                         //
//       _  __                 __           ___        _         __        //
//      | |/_/ __ _  ___ _____/ /__ _______/ _ \___   (_)__ ____/ /____    //
//     _>  <  /  ' \/ _ `/ __/  '_/(_-<___/ , _/ -_) / / -_) __/ __(_-<    //
//    /_/|_| /_/_/_/\_,_/_/ /_/\_\/___/  /_/|_|\__/_/ /\__/\__/\__/___/    //
//                                               |___/                     //
//                                                                         //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////


contract XMARKS is ERC1155Creator {
    constructor() ERC1155Creator("XMARKS", "XMARKS") {}
}