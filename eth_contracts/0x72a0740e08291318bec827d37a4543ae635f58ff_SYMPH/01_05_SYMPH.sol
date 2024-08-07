// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: FLORAL SYMPHONY
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//                                                                                     //
//      ___ _    ___  ___    _   _      _____   ____  __ ___ _  _  ___  _  ___   __    //
//     | __| |  / _ \| _ \  /_\ | |    / __\ \ / /  \/  | _ \ || |/ _ \| \| \ \ / /    //
//     | _|| |_| (_) |   / / _ \| |__  \__ \\ V /| |\/| |  _/ __ | (_) | .` |\ V /     //
//     |_| |____\___/|_|_\/_/ \_\____| |___/ |_| |_|  |_|_| |_||_|\___/|_|\_| |_|      //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract SYMPH is ERC721Creator {
    constructor() ERC721Creator("FLORAL SYMPHONY", "SYMPH") {}
}