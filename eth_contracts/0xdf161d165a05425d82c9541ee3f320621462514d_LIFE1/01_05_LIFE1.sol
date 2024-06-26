// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LIFE
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//    ██╗     ██╗███████╗███████╗                                                                             //
//    ██║     ██║██╔════╝██╔════╝        shu kinouchi                                                         //
//    ██║     ██║█████╗  █████╗          1992                                                                 //
//    ██║     ██║██╔══╝  ██╔══╝          dancer                                                               //
//    ███████╗██║██║     ███████╗        japan                                                                //
//    ╚══════╝╚═╝╚═╝     ╚══════╝                                                                             //
//    ███████╗██╗  ██╗██╗   ██╗    ██╗  ██╗██╗███╗   ██╗ ██████╗ ██╗   ██╗ ██████╗██╗  ██╗██╗                 //
//    ██╔════╝██║  ██║██║   ██║    ██║ ██╔╝██║████╗  ██║██╔═══██╗██║   ██║██╔════╝██║  ██║██║                 //
//    ███████╗███████║██║   ██║    █████╔╝ ██║██╔██╗ ██║██║   ██║██║   ██║██║     ███████║██║                 //
//    ╚════██║██╔══██║██║   ██║    ██╔═██╗ ██║██║╚██╗██║██║   ██║██║   ██║██║     ██╔══██║██║                 //
//    ███████║██║  ██║╚██████╔╝    ██║  ██╗██║██║ ╚████║╚██████╔╝╚██████╔╝╚██████╗██║  ██║██║                 //
//    ╚══════╝╚═╝  ╚═╝ ╚═════╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝ ╚═════╝  ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝                 //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LIFE1 is ERC721Creator {
    constructor() ERC721Creator("LIFE", "LIFE1") {}
}