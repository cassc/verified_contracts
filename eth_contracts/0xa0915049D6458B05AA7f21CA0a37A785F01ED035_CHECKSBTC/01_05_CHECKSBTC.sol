// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Checks - Bitcoin Edition
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//     ______     __  __     ______     ______     __  __     ______        ______     ______   ______        //
//    /\  ___\   /\ \_\ \   /\  ___\   /\  ___\   /\ \/ /    /\  ___\      /\  == \   /\__  _\ /\  ___\       //
//    \ \ \____  \ \  __ \  \ \  __\   \ \ \____  \ \  _"-.  \ \___  \     \ \  __<   \/_/\ \/ \ \ \____      //
//     \ \_____\  \ \_\ \_\  \ \_____\  \ \_____\  \ \_\ \_\  \/\_____\     \ \_____\    \ \_\  \ \_____\     //
//      \/_____/   \/_/\/_/   \/_____/   \/_____/   \/_/\/_/   \/_____/      \/_____/     \/_/   \/_____/     //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CHECKSBTC is ERC721Creator {
    constructor() ERC721Creator("Checks - Bitcoin Edition", "CHECKSBTC") {}
}