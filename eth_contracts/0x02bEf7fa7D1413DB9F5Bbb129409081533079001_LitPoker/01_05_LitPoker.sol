// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LitPoker
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//                                                                    //
//    ██╗░░░░░██╗████████╗██████╗░░█████╗░██╗░░██╗███████╗██████╗░    //
//    ██║░░░░░██║╚══██╔══╝██╔══██╗██╔══██╗██║░██╔╝██╔════╝██╔══██╗    //
//    ██║░░░░░██║░░░██║░░░██████╔╝██║░░██║█████═╝░█████╗░░██████╔╝    //
//    ██║░░░░░██║░░░██║░░░██╔═══╝░██║░░██║██╔═██╗░██╔══╝░░██╔══██╗    //
//    ███████╗██║░░░██║░░░██║░░░░░╚█████╔╝██║░╚██╗███████╗██║░░██║    //
//    ╚══════╝╚═╝░░░╚═╝░░░╚═╝░░░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract LitPoker is ERC1155Creator {
    constructor() ERC1155Creator("LitPoker", "LitPoker") {}
}