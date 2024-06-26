// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Soul lost in art - Series
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                       //
//                                                                                                       //
//                                                                                                       //
//                                                                                                       //
//                                                                                                       //
//                                                                                                       //
//          __        __              __        _______  ___________  __      ________  ___________      //
//         /""\      |" \            /""\      /"      \("     _   ")|" \    /"       )("     _   ")     //
//        /    \     ||  |          /    \    |:        |)__/  \\__/ ||  |  (:   \___/  )__/  \\__/      //
//       /' /\  \    |:  |         /' /\  \   |_____/   )   \\_ /    |:  |   \___  \       \\_ /         //
//      //  __'  \   |.  |        //  __'  \   //      /    |.  |    |.  |    __/  \\      |.  |         //
//     /   /  \\  \  /\  |\      /   /  \\  \ |:  __   \    \:  |    /\  |\  /" \   :)     \:  |         //
//    (___/    \___)(__\_|_)    (___/    \___)|__|  \___)    \__|   (__\_|_)(_______/       \__|         //
//                                                                                                       //
//                                                                                                       //
//                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Souls is ERC721Creator {
    constructor() ERC721Creator("Soul lost in art - Series", "Souls") {}
}