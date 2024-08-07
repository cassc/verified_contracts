// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Lights Camera Action
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//        __    _       __    __          ______                                   ___        __  _               //
//       / /   (_)___ _/ /_  / /______   / ____/___ _____ ___  ___  _________ _   /   | _____/ /_(_)___  ____     //
//      / /   / / __ `/ __ \/ __/ ___/  / /   / __ `/ __ `__ \/ _ \/ ___/ __ `/  / /| |/ ___/ __/ / __ \/ __ \    //
//     / /___/ / /_/ / / / / /_(__  )  / /___/ /_/ / / / / / /  __/ /  / /_/ /  / ___ / /__/ /_/ / /_/ / / / /    //
//    /_____/_/\__, /_/ /_/\__/____/   \____/\__,_/_/ /_/ /_/\___/_/   \__,_/  /_/  |_\___/\__/_/\____/_/ /_/     //
//            /____/                                                                                              //
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LCA is ERC721Creator {
    constructor() ERC721Creator("Lights Camera Action", "LCA") {}
}