// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Holly Herbert Bidders Editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ▀█████████▄   ▄█  ████████▄  ████████▄     ▄████████    ▄████████    ▄████████      //
//      ███    ███ ███  ███   ▀███ ███   ▀███   ███    ███   ███    ███   ███    ███      //
//      ███    ███ ███▌ ███    ███ ███    ███   ███    █▀    ███    ███   ███    █▀       //
//     ▄███▄▄▄██▀  ███▌ ███    ███ ███    ███  ▄███▄▄▄      ▄███▄▄▄▄██▀   ███             //
//    ▀▀███▀▀▀██▄  ███▌ ███    ███ ███    ███ ▀▀███▀▀▀     ▀▀███▀▀▀▀▀   ▀███████████      //
//      ███    ██▄ ███  ███    ███ ███    ███   ███    █▄  ▀███████████          ███      //
//      ███    ███ ███  ███   ▄███ ███   ▄███   ███    ███   ███    ███    ▄█    ███      //
//    ▄█████████▀  █▀   ████████▀  ████████▀    ██████████   ███    ███  ▄████████▀       //
//                                                           ███    ███                   //
//       ▄████████ ████████▄   ▄█      ███      ▄█   ▄██████▄  ███▄▄▄▄      ▄████████     //
//      ███    ███ ███   ▀███ ███  ▀█████████▄ ███  ███    ███ ███▀▀▀██▄   ███    ███     //
//      ███    █▀  ███    ███ ███▌    ▀███▀▀██ ███▌ ███    ███ ███   ███   ███    █▀      //
//     ▄███▄▄▄     ███    ███ ███▌     ███   ▀ ███▌ ███    ███ ███   ███   ███            //
//    ▀▀███▀▀▀     ███    ███ ███▌     ███     ███▌ ███    ███ ███   ███ ▀███████████     //
//      ███    █▄  ███    ███ ███      ███     ███  ███    ███ ███   ███          ███     //
//      ███    ███ ███   ▄███ ███      ███     ███  ███    ███ ███   ███    ▄█    ███     //
//      ██████████ ████████▀  █▀      ▄████▀   █▀    ▀██████▀   ▀█   █▀   ▄████████▀      //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract HHBE is ERC1155Creator {
    constructor() ERC1155Creator("Holly Herbert Bidders Editions", "HHBE") {}
}