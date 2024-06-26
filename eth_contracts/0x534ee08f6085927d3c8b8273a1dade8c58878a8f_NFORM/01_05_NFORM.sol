// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: No Form
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////
//                                                        //
//                                                        //
//                                                        //
//      _   _   ____    ______  ____   _____   __  __     //
//     | \ | | / __ \  |  ____|/ __ \ |  __ \ |  \/  |    //
//     |  \| || |  | | | |__  | |  | || |__) || \  / |    //
//     | . ` || |  | | |  __| | |  | ||  _  / | |\/| |    //
//     | |\  || |__| | | |    | |__| || | \ \ | |  | |    //
//     |_| \_| \____/  |_|     \____/ |_|  \_\|_|  |_|    //
//                                                        //
//                                                        //
//                                                        //
//                                                        //
//                                                        //
////////////////////////////////////////////////////////////


contract NFORM is ERC721Creator {
    constructor() ERC721Creator("No Form", "NFORM") {}
}