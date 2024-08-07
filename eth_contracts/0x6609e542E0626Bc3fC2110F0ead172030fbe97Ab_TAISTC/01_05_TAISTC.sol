// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: This Artwork Is Subject To Change
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//                                                                        //
//     ______  ______  ______  ______  __      __  __   __  ______        //
//    /\  ___\/\  __ \/\  ___\/\  __ \/\ \    /\ \/\ "-.\ \/\  ___\       //
//    \ \ \__ \ \  __ \ \___  \ \ \/\ \ \ \___\ \ \ \ \-.  \ \  __\       //
//     \ \_____\ \_\ \_\/\_____\ \_____\ \_____\ \_\ \_\\"\_\ \_____\     //
//      \/_____/\/_/\/_/\/_____/\/_____/\/_____/\/_/\/_/ \/_/\/_____/     //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract TAISTC is ERC721Creator {
    constructor() ERC721Creator("This Artwork Is Subject To Change", "TAISTC") {}
}