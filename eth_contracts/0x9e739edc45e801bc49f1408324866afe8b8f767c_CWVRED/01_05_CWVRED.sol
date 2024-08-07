// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: VR Painting Editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//     ___  ___  ___  ___  _ _ _  _  _    _    ___  ___  ___  _ _  ___  _ _                    //
//    |  _>| . ||_ _|/ __>| | | || || |  | |  | __>| . ||_ _|| | || . || | |                   //
//    | <__|   | | | \__ \| | | || || |_ | |_ | _> |   | | | \   /| | || ' |                   //
//    `___/|_|_| |_| <___/|__/_/ |_||___||___||___>|_|_| |_|  |_| `___'`___'                   //
//                                                                                             //
//     _ _  ___   ___  ___  _  _ _  ___  _  _ _  ___    ___  ___  _  ___  _  ___  _ _  ___     //
//    | | || . \ | . \| . || || \ ||_ _|| || \ |/  _>  | __>| . \| ||_ _|| || . || \ |/ __>    //
//    | ' ||   / |  _/|   || ||   | | | | ||   || <_/\ | _> | | || | | | | || | ||   |\__ \    //
//    |__/ |_\_\ |_|  |_|_||_||_\_| |_| |_||_\_|`____/ |___>|___/|_| |_| |_|`___'|_\_|<___/    //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract CWVRED is ERC1155Creator {
    constructor() ERC1155Creator("VR Painting Editions", "CWVRED") {}
}