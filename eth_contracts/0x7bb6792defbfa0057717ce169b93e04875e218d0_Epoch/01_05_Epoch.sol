// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mt.Epoch
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//    ███    ███ ████████    ███████ ██████   ██████   ██████ ██   ██     //
//    ████  ████    ██       ██      ██   ██ ██    ██ ██      ██   ██     //
//    ██ ████ ██    ██       █████   ██████  ██    ██ ██      ███████     //
//    ██  ██  ██    ██       ██      ██      ██    ██ ██      ██   ██     //
//    ██      ██    ██    ██ ███████ ██       ██████   ██████ ██   ██     //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract Epoch is ERC721Creator {
    constructor() ERC721Creator("Mt.Epoch", "Epoch") {}
}