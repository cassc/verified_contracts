// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: One Day at A Time
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//    ________                  ________                         __       _____      __  .__                    //
//    \_____  \   ____   ____   \______ \ _____  ___.__. _____ _/  |_    /  _  \   _/  |_|__| _____   ____      //
//     /   |   \ /    \_/ __ \   |    |  \\__  \<   |  | \__  \\   __\  /  /_\  \  \   __\  |/     \_/ __ \     //
//    /    |    \   |  \  ___/   |    `   \/ __ \\___  |  / __ \|  |   /    |    \  |  | |  |  Y Y  \  ___/     //
//    \_______  /___|  /\___  > /_______  (____  / ____| (____  /__|   \____|__  /  |__| |__|__|_|  /\___  >    //
//            \/     \/     \/          \/     \/\/           \/               \/                 \/     \/     //
//                                                                                                              //
//                                                                                                              //
//                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract HELLO is ERC721Creator {
    constructor() ERC721Creator("One Day at A Time", "HELLO") {}
}