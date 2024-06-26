// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 0M2S
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////
//                                                //
//                                                //
//              _   .-')              .-')        //
//             ( '.( OO )_           ( OO ).      //
//      .----.  ,--.   ,--.).-----. (_)---\_)     //
//     /  ..  \ |   `.'   |/ ,-.   \/    _ |      //
//    .  /  \  .|         |'-'  |  |\  :` `.      //
//    |  |  '  ||  |'.'|  |   .'  /  '..`''.)     //
//    '  \  /  '|  |   |  | .'  /__ .-._)   \     //
//     \  `'  / |  |   |  ||       |\       /     //
//      `---''  `--'   `--'`-------' `-----'      //
//                                                //
//                                                //
////////////////////////////////////////////////////


contract MISC is ERC721Creator {
    constructor() ERC721Creator("0M2S", "MISC") {}
}