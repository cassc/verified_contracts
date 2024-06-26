// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Anomalies
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////
//                                                                                 //
//                                                                                 //
//                                                                                 //
//     █████╗ ███╗   ██╗ ██████╗ ███╗   ███╗ █████╗ ██╗     ██╗███████╗███████╗    //
//    ██╔══██╗████╗  ██║██╔═══██╗████╗ ████║██╔══██╗██║     ██║██╔════╝██╔════╝    //
//    ███████║██╔██╗ ██║██║   ██║██╔████╔██║███████║██║     ██║█████╗  ███████╗    //
//    ██╔══██║██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██║██║     ██║██╔══╝  ╚════██║    //
//    ██║  ██║██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██║  ██║███████╗██║███████╗███████║    //
//    ╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚══════╝    //
//                                                                                 //
//                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////


contract ANMLY is ERC721Creator {
    constructor() ERC721Creator("Anomalies", "ANMLY") {}
}