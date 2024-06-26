// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: CC0 BY YAKOB
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//       ___ ___ __    _____   __ __   ___   _  _____  ___     //
//      / __/ __/  \  | _ ) \ / / \ \ / /_\ | |/ / _ \| _ )    //
//     | (_| (_| () | | _ \\ V /   \ V / _ \| ' < (_) | _ \    //
//      \___\___\__/  |___/ |_|     |_/_/ \_\_|\_\___/|___/    //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
//                                                             //
/////////////////////////////////////////////////////////////////


contract CBY is ERC721Creator {
    constructor() ERC721Creator("CC0 BY YAKOB", "CBY") {}
}