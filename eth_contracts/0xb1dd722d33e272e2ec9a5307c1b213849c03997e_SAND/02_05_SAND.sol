// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sandytoes contract
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//         _______.     ___      .__   __.  _______  ____    ____              //
//        /       |    /   \     |  \ |  | |       \ \   \  /   /              //
//       |   (----`   /  ^  \    |   \|  | |  .--.  | \   \/   /               //
//        \   \      /  /_\  \   |  . `  | |  |  |  |  \_    _/                //
//    .----)   |    /  _____  \  |  |\   | |  '--'  |    |  |                  //
//    |_______/    /__/     \__\ |__| \__| |_______/     |__|                  //
//                                                                             //
//    .___________.  ______    _______     _______. ___    ___    __   __      //
//    |           | /  __  \  |   ____|   /       ||__ \  |__ \  /_ | /_ |     //
//    `---|  |----`|  |  |  | |  |__     |   (----`   ) |    ) |  | |  | |     //
//        |  |     |  |  |  | |   __|     \   \      / /    / /   | |  | |     //
//        |  |     |  `--'  | |  |____.----)   |    / /_   / /_   | |  | |     //
//        |__|      \______/  |_______|_______/    |____| |____|  |_|  |_|     //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract SAND is ERC721Creator {
    constructor() ERC721Creator("Sandytoes contract", "SAND") {}
}