// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Les Quatre Saisons
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//    '  ██╗     ███████╗███████╗                                   //
//    '  ██║     ██╔════╝██╔════╝                                   //
//    '  ██║     █████╗  ███████╗                                   //
//    '  ██║     ██╔══╝  ╚════██║                                   //
//    '  ███████╗███████╗███████║                                   //
//    '  ╚══════╝╚══════╝╚══════╝                                   //
//    '                                                             //
//    '   ██████╗ ██╗   ██╗ █████╗ ████████╗██████╗ ███████╗        //
//    '  ██╔═══██╗██║   ██║██╔══██╗╚══██╔══╝██╔══██╗██╔════╝        //
//    '  ██║   ██║██║   ██║███████║   ██║   ██████╔╝█████╗          //
//    '  ██║▄▄ ██║██║   ██║██╔══██║   ██║   ██╔══██╗██╔══╝          //
//    '  ╚██████╔╝╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗        //
//    '   ╚══▀▀═╝  ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝        //
//    '                                                             //
//    '  ███████╗ █████╗ ██╗███████╗ ██████╗ ███╗   ██╗███████╗     //
//    '  ██╔════╝██╔══██╗██║██╔════╝██╔═══██╗████╗  ██║██╔════╝     //
//    '  ███████╗███████║██║███████╗██║   ██║██╔██╗ ██║███████╗     //
//    '  ╚════██║██╔══██║██║╚════██║██║   ██║██║╚██╗██║╚════██║     //
//    '  ███████║██║  ██║██║███████║╚██████╔╝██║ ╚████║███████║     //
//    '  ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝     //
//    '                                                             //
//                                                                  //
//                                                                  //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract L4S is ERC721Creator {
    constructor() ERC721Creator("Les Quatre Saisons", "L4S") {}
}