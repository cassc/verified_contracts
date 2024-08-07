// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Santa's Helper
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
//    ________                __                    __     _____ ___.             __                        __        //
//    \______ \ _____ _______|  | __ ____   _______/  |_  /  _  \\_ |__   _______/  |_____________    _____/  |_      //
//     |    |  \\__  \\_  __ \  |/ // __ \ /  ___/\   __\/  /_\  \| __ \ /  ___/\   __\_  __ \__  \ _/ ___\   __\     //
//     |    `   \/ __ \|  | \/    <\  ___/ \___ \  |  | /    |    \ \_\ \\___ \  |  |  |  | \// __ \\  \___|  |       //
//    /_______  (____  /__|  |__|_ \\___  >____  > |__| \____|__  /___  /____  > |__|  |__|  (____  /\___  >__|       //
//            \/     \/           \/    \/     \/               \/    \/     \/                   \/     \/           //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SHW is ERC721Creator {
    constructor() ERC721Creator("Santa's Helper", "SHW") {}
}