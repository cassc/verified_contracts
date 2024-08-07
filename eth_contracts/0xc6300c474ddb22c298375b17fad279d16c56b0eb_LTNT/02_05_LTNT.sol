// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Latent
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                         //
//                                                                                                         //
//                    ▄█          ▄████████     ███        ▄████████ ███▄▄▄▄       ███                     //
//                   ███         ███    ███ ▀█████████▄   ███    ███ ███▀▀▀██▄ ▀█████████▄                 //
//                   ███         ███    ███    ▀███▀▀██   ███    █▀  ███   ███    ▀███▀▀██                 //
//                   ███         ███    ███     ███   ▀  ▄███▄▄▄     ███   ███     ███   ▀                 //
//                   ███       ▀███████████     ███     ▀▀███▀▀▀     ███   ███     ███                     //
//                   ███         ███    ███     ███       ███    █▄  ███   ███     ███                     //
//                   ███▌    ▄   ███    ███     ███       ███    ███ ███   ███     ███                     //
//                   █████▄▄██   ███    █▀     ▄████▀     ██████████  ▀█   █▀     ▄████▀                   //
//                   ▀                                                                                     //
//                                       ▀█████████▄  ▄██   ▄                                              //
//                                         ███    ███ ███   ██▄                                            //
//                                         ███    ███ ███▄▄▄███                                            //
//                                        ▄███▄▄▄██▀  ▀▀▀▀▀▀███                                            //
//                                       ▀▀███▀▀▀██▄  ▄██   ███                                            //
//                                         ███    ██▄ ███   ███                                            //
//                                         ███    ███ ███   ███                                            //
//                                       ▄█████████▀   ▀█████▀                                             //
//                                                                                                         //
//    ▄██   ▄      ▄████████   ▄▄▄▄███▄▄▄▄   ███    █▄  ████████▄     ▄████████  ▄███████▄  ███    █▄      //
//    ███   ██▄   ███    ███ ▄██▀▀▀███▀▀▀██▄ ███    ███ ███   ▀███   ███    ███ ██▀     ▄██ ███    ███     //
//    ███▄▄▄███   ███    ███ ███   ███   ███ ███    ███ ███    ███   ███    ███       ▄███▀ ███    ███     //
//    ▀▀▀▀▀▀███   ███    ███ ███   ███   ███ ███    ███ ███    ███   ███    ███     ▄███▀   ███    ███     //
//    ▄██   ███ ▀███████████ ███   ███   ███ ███    ███ ███    ███ ▀███████████   ▄███▀     ███    ███     //
//    ███   ███   ███    ███ ███   ███   ███ ███    ███ ███    ███   ███    ███ ▄███▀       ███    ███     //
//    ███   ███   ███    ███ ███   ███   ███ ███    ███ ███   ▄███   ███    ███ ███▄     ▄█ ███    ███     //
//     ▀█████▀    ███    █▀   ▀█   ███   █▀  ████████▀  ████████▀    ███    █▀   ▀████████▀ ████████▀      //
//                                                                                                         //
//                                                                                                         //
//                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LTNT is ERC721Creator {
    constructor() ERC721Creator("Latent", "LTNT") {}
}