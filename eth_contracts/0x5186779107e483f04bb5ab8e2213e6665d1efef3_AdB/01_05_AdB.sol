// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Space Between
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////
//                                                                 //
//                                                                 //
//    ╔═╗╔═╗╔═╗╔═╗╔═╗  ╔╗ ╔═╗╔╦╗╦ ╦╔═╗╔═╗╔╗╔                       //
//    ╚═╗╠═╝╠═╣║  ║╣   ╠╩╗║╣  ║ ║║║║╣ ║╣ ║║║                       //
//                                                                 //
//    ╚═╝╩  ╩ ╩╚═╝╚═╝  ╚═╝╚═╝ ╩ ╚╩╝╚═╝╚═╝╝╚╝                       //
//    ┌┐ ┬ ┬  ╔═╗┌┐┌┌┐┌┌─┐┌┬┐┌─┐┬─┐┬ ┬┌─┐  ┌┬┐┌─┐  ╔╗ ┌─┐┌─┐┬─┐    //
//    ├┴┐└┬┘  ╠═╣││││││├┤ │││├─┤├┬┘│ │├┤    ││├┤   ╠╩╗│ │├┤ ├┬┘    //
//    └─┘ ┴   ╩ ╩┘└┘┘└┘└─┘┴ ┴┴ ┴┴└─┴└┘└─┘  ─┴┘└─┘  ╚═╝└─┘└─┘┴└─    //
//                                                                 //
//                                                                 //
/////////////////////////////////////////////////////////////////////


contract AdB is ERC721Creator {
    constructor() ERC721Creator("Space Between", "AdB") {}
}