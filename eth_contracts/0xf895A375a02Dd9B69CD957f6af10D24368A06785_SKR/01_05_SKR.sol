// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sekiro66
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //
//                                                                                  //
//    ______                                            ______    ______            //
//     /      \           /  |      /  |                     /      \  /      \     //
//    /$$$$$$  |  ______  $$ |   __ $$/   ______    ______  /$$$$$$  |/$$$$$$  |    //
//    $$ \__$$/  /      \ $$ |  /  |/  | /      \  /      \ $$ \__$$/ $$ \__$$/     //
//    $$      \ /$$$$$$  |$$ |_/$$/ $$ |/$$$$$$  |/$$$$$$  |$$      \ $$      \     //
//     $$$$$$  |$$    $$ |$$   $$<  $$ |$$ |  $$/ $$ |  $$ |$$$$$$$  |$$$$$$$  |    //
//    /  \__$$ |$$$$$$$$/ $$$$$$  \ $$ |$$ |      $$ \__$$ |$$ \__$$ |$$ \__$$ |    //
//    $$    $$/ $$       |$$ | $$  |$$ |$$ |      $$    $$/ $$    $$/ $$    $$/     //
//     $$$$$$/   $$$$$$$/ $$/   $$/ $$/ $$/        $$$$$$/   $$$$$$/   $$$$$$/      //
//                                                                                  //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////


contract SKR is ERC721Creator {
    constructor() ERC721Creator("Sekiro66", "SKR") {}
}