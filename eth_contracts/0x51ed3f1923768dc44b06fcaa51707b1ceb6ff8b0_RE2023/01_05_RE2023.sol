// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Rodro Editions 2023
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//                                                                                                //
//       __           _               __   _ _ _   _                   ____   ___ ____  _____     //
//      /__\ ___   __| |_ __ ___     /__\_| (_) |_(_) ___  _ __  ___  |___ \ / _ \___ \|___ /     //
//     / \/// _ \ / _` | '__/ _ \   /_\/ _` | | __| |/ _ \| '_ \/ __|   __) | | | |__) | |_ \     //
//    / _  \ (_) | (_| | | | (_) | //_| (_| | | |_| | (_) | | | \__ \  / __/| |_| / __/ ___) |    //
//    \/ \_/\___/ \__,_|_|  \___/  \__/\__,_|_|\__|_|\___/|_| |_|___/ |_____|\___/_____|____/     //
//                                                                                                //
//                                                                                                //
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////


contract RE2023 is ERC1155Creator {
    constructor() ERC1155Creator("Rodro Editions 2023", "RE2023") {}
}