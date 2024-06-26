// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mooo Juice
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                           //
//                                                                                                                                                           //
//     ▄▀▀▀█▀▀▄  ▄▀▀▄ ▄▄   ▄▀▀█▀▄   ▄▀▀▀▀▄      ▄▀▀█▀▄   ▄▀▀▀▀▄            ▄█  ▄▀▀▄ ▄▀▀▄  ▄▀▀▀▀▄  ▄▀▀▀█▀▀▄      ▄▀▀▄ ▄▀▄  ▄▀▀█▄   ▄▀▀▀▀▄      ▄▀▀▄ █         //
//    █    █  ▐ █  █   ▄▀ █   █  █ █ █   ▐     █   █  █ █ █   ▐      ▄▀▀▀█▀ ▐ █   █    █ █ █   ▐ █    █  ▐     █  █ ▀  █ ▐ ▄▀ ▀▄ █    █      █  █ ▄▀         //
//    ▐   █     ▐  █▄▄▄█  ▐   █  ▐    ▀▄       ▐   █  ▐    ▀▄       █    █    ▐  █    █     ▀▄   ▐   █         ▐  █    █   █▄▄▄█ ▐    █      ▐  █▀▄          //
//       █         █   █      █    ▀▄   █          █    ▀▄   █      ▐    █      █    █   ▀▄   █     █            █    █   ▄▀   █     █         █   █         //
//     ▄▀         ▄▀  ▄▀   ▄▀▀▀▀▀▄  █▀▀▀        ▄▀▀▀▀▀▄  █▀▀▀         ▄   ▀▄     ▀▄▄▄▄▀   █▀▀▀    ▄▀           ▄▀   ▄▀   █   ▄▀    ▄▀▄▄▄▄▄▄▀ ▄▀   █          //
//    █          █   █    █       █ ▐          █       █ ▐             ▀▀▀▀               ▐      █             █    █    ▐   ▐     █         █    ▐          //
//    ▐          ▐   ▐    ▐       ▐            ▐       ▐                                         ▐             ▐    ▐              ▐         ▐               //
//                                                                                                                                                           //
//                                                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MOOJ is ERC1155Creator {
    constructor() ERC1155Creator("Mooo Juice", "MOOJ") {}
}