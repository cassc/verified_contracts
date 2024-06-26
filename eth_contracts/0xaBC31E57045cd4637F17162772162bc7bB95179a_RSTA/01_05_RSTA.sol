// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: REECE SWANEPOEL TIMED ART
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////
//                                                //
//                                                //
//                                                //
//    ██████╗░███████╗███████╗░█████╗░███████╗    //
//    ██╔══██╗██╔════╝██╔════╝██╔══██╗██╔════╝    //
//    ██████╔╝█████╗░░█████╗░░██║░░╚═╝█████╗░░    //
//    ██╔══██╗██╔══╝░░██╔══╝░░██║░░██╗██╔══╝░░    //
//    ██║░░██║███████╗███████╗╚█████╔╝███████╗    //
//    ╚═╝░░╚═╝╚══════╝╚══════╝░╚════╝░╚══════╝    //
//                                                //
//    ░██████╗░██╗░░░░░░░██╗░█████╗░███╗░░██╗     //
//    ██╔════╝░██║░░██╗░░██║██╔══██╗████╗░██║     //
//    ╚█████╗░░╚██╗████╗██╔╝███████║██╔██╗██║     //
//    ░╚═══██╗░░████╔═████║░██╔══██║██║╚████║     //
//    ██████╔╝░░╚██╔╝░╚██╔╝░██║░░██║██║░╚███║     //
//    ╚═════╝░░░░╚═╝░░░╚═╝░░╚═╝░░╚═╝╚═╝░░╚══╝     //
//                                                //
//    ███████╗██████╗░░█████╗░███████╗██╗░░░░░    //
//    ██╔════╝██╔══██╗██╔══██╗██╔════╝██║░░░░░    //
//    █████╗░░██████╔╝██║░░██║█████╗░░██║░░░░░    //
//    ██╔══╝░░██╔═══╝░██║░░██║██╔══╝░░██║░░░░░    //
//    ███████╗██║░░░░░╚█████╔╝███████╗███████╗    //
//    ╚══════╝╚═╝░░░░░░╚════╝░╚══════╝╚══════╝    //
//                                                //
//    ████████╗██╗███╗░░░███╗███████╗██████╗░     //
//    ╚══██╔══╝██║████╗░████║██╔════╝██╔══██╗     //
//    ░░░██║░░░██║██╔████╔██║█████╗░░██║░░██║     //
//    ░░░██║░░░██║██║╚██╔╝██║██╔══╝░░██║░░██║     //
//    ░░░██║░░░██║██║░╚═╝░██║███████╗██████╔╝     //
//    ░░░╚═╝░░░╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░     //
//                                                //
//    ░█████╗░██████╗░████████╗                   //
//    ██╔══██╗██╔══██╗╚══██╔══╝                   //
//    ███████║██████╔╝░░░██║░░░                   //
//    ██╔══██║██╔══██╗░░░██║░░░                   //
//    ██║░░██║██║░░██║░░░██║░░░                   //
//    ╚═╝░░╚═╝╚═╝░░╚═╝░░░╚═╝░░░                   //
//                                                //
//                                                //
////////////////////////////////////////////////////


contract RSTA is ERC721Creator {
    constructor() ERC721Creator("REECE SWANEPOEL TIMED ART", "RSTA") {}
}