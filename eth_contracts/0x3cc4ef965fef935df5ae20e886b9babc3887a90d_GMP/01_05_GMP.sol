// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PROVENANCE
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                         //
//                                                                                                                         //
//                                                                                                                         //
//                                                                                                    __      __           //
//                                                                                                   /  |    /  |          //
//       ______   _____  ____   _____  ____    ______   _______    ______   __    __       ______   _⟠⟠ |_   ⟠⟠ |____      //
//      /      \ /     \/    \ /     \/    \  /      \ /       \  /      \ /  |  /  |     /      \ / ⟠⟠   |  ⟠⟠      \     //
//     /gmgmgm  |gmgmgm gmgm  |$$$$$$ $$$$  |/$$$$$$  |$$$$$$$  |/$$$$$$  |$$ |  $$ |    /⟠⟠⟠⟠⟠⟠⟠ |⟠⟠⟠⟠⟠⟠/   ⟠⟠⟠⟠⟠⟠⟠⟠ |    //
//     gm |  gm |gm | gm | gm |$$ | $$ | $$ |$$ |  $$ |$$ |  $$ |$$    $$ |$$ |  $$ |    ⟠⟠    ⟠⟠ |  ⟠⟠ | __ ⟠⟠ |  ⟠⟠ |    //
//     gm \__gm |gm | gm | gm |$$ | $$ | $$ |$$ \__$$ |$$ |  $$ |$$$$$$$$/ $$ \__$$ | __ ethereum/   ⟠⟠ |/  |⟠⟠ |  ⟠⟠ |    //
//     gm    gm |gm | gm | gm |$$ | $$ | $$ |$$    $$/ $$ |  $$ |$$       |$$    $$ |/  |⟠⟠       |  ⟠⟠  ⟠⟠/ ⟠⟠ |  ⟠⟠ |    //
//      gmgmgm  |gm/  gm/  gm/ $$/  $$/  $$/  $$$$$$/  $$/   $$/  $$$$$$$/  $$$$$$$ |._/  ⟠⟠⟠⟠⟠⟠⟠/   ⟠⟠⟠⟠⟠/  ⟠⟠/   ⟠⟠/     //
//     /  \__gm |                                                          /  \__$$ |                                      //
//     gm    gm/                                                           $$    $$/                                       //
//      gmgmgm/                                                             $$$$$$/                                        //
//                                                                                                                         //
//                                                                                                                         //
//                                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract GMP is ERC721Creator {
    constructor() ERC721Creator("PROVENANCE", "GMP") {}
}