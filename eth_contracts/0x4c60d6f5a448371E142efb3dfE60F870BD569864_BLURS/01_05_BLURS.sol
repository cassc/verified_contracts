// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Blurs
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//                                                                  //
//                               ____________ _________________     //
//      ______ _________________/_   \_____  \\_____  \______  \    //
//     /  ___// __ \_  __ \____ \|   | _(__  <  _(__  <   /    /    //
//     \___ \\  ___/|  | \/  |_> >   |/       \/       \ /    /     //
//    /____  >\___  >__|  |   __/|___/______  /______  //____/      //
//         \/     \/      |__|              \/       \/             //
//                                                                  //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract BLURS is ERC721Creator {
    constructor() ERC721Creator("Blurs", "BLURS") {}
}