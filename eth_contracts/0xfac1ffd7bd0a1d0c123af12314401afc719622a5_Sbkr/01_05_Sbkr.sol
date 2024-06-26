// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sonerbakir
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//       _____ __    __           ____  __          __                //
//      / ___// /_  / /_______   / __ \/ /_  ____  / /_____  _____    //
//      \__ \/ __ \/ //_/ ___/  / /_/ / __ \/ __ \/ __/ __ \/ ___/    //
//     ___/ / /_/ / ,< / /     / ____/ / / / /_/ / /_/ /_/ (__  )     //
//    /____/_.___/_/|_/_/     /_/   /_/ /_/\____/\__/\____/____/      //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract Sbkr is ERC1155Creator {
    constructor() ERC1155Creator("Sonerbakir", "Sbkr") {}
}