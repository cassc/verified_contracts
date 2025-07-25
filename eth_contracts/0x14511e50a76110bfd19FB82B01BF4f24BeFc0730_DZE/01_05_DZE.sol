// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Andris Dzeguze
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//         _              _      _       ____                                  //
//        / \   _ __   __| |_ __(_)___  |  _ \ _______  __ _ _   _ _______     //
//       / _ \ | '_ \ / _` | '__| / __| | | | |_  / _ \/ _` | | | |_  / _ \    //
//      / ___ \| | | | (_| | |  | \__ \ | |_| |/ /  __/ (_| | |_| |/ /  __/    //
//     /_/   \_\_| |_|\__,_|_|  |_|___/ |____//___\___|\__, |\__,_/___\___|    //
//                                                     |___/                   //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract DZE is ERC721Creator {
    constructor() ERC721Creator("Andris Dzeguze", "DZE") {}
}