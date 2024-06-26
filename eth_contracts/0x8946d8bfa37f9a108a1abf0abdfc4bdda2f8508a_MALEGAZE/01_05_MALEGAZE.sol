// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Male Gaze
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//    ███╗   ███╗ █████╗ ██╗     ███████╗ ██████╗  █████╗ ███████╗███████╗    //
//    ████╗ ████║██╔══██╗██║     ██╔════╝██╔════╝ ██╔══██╗╚══███╔╝██╔════╝    //
//    ██╔████╔██║███████║██║     █████╗  ██║  ███╗███████║  ███╔╝ █████╗      //
//    ██║╚██╔╝██║██╔══██║██║     ██╔══╝  ██║   ██║██╔══██║ ███╔╝  ██╔══╝      //
//    ██║ ╚═╝ ██║██║  ██║███████╗███████╗╚██████╔╝██║  ██║███████╗███████╗    //
//    ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝    //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


contract MALEGAZE is ERC1155Creator {
    constructor() ERC1155Creator("The Male Gaze", "MALEGAZE") {}
}