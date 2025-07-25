// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Game of Lights & Shadows
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                         //
//                                                                                                                                         //
//     ___  _ _  ___  ___   ___  __ __  ___  ___  ___  _    _  ___   _ _  ___  ___  ___  _ _  ___  ___  _ _  ___  ___  ___  _ _ _  ___     //
//    |_ _|| | || __>/  _> | . ||  \  \| __>| . || __>| |  | |/  _> | | ||_ _|/ __>| . || \ || . \/ __>| | || . || . \| . || | | |/ __>    //
//     | | |   || _> | <_/\|   ||     || _> | | || _> | |_ | || <_/\|   | | | \__ \|   ||   || | |\__ \|   ||   || | || | || | | |\__ \    //
//     |_| |_|_||___>`____/|_|_||_|_|_||___>`___'|_|  |___||_|`____/|_|_| |_| <___/|_|_||_\_||___/<___/|_|_||_|_||___/`___'|__/_/ <___/    //
//                                                                                                                                         //
//                                                                                                                                         //
//                                                                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TGOLAS is ERC721Creator {
    constructor() ERC721Creator("The Game of Lights & Shadows", "TGOLAS") {}
}