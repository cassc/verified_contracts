// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: SPAM
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//     $$$$$$\  $$$$$$$\   $$$$$$\  $$\      $$\     //
//    $$  __$$\ $$  __$$\ $$  __$$\ $$$\    $$$ |    //
//    $$ /  \__|$$ |  $$ |$$ /  $$ |$$$$\  $$$$ |    //
//    \$$$$$$\  $$$$$$$  |$$$$$$$$ |$$\$$\$$ $$ |    //
//     \____$$\ $$  ____/ $$  __$$ |$$ \$$$  $$ |    //
//    $$\   $$ |$$ |      $$ |  $$ |$$ |\$  /$$ |    //
//    \$$$$$$  |$$ |      $$ |  $$ |$$ | \_/ $$ |    //
//     \______/ \__|      \__|  \__|\__|     \__|    //
//                                                   //
//     $$$$$$\  $$$$$$$\   $$$$$$\  $$\      $$\     //
//    $$  __$$\ $$  __$$\ $$  __$$\ $$$\    $$$ |    //
//    $$ /  \__|$$ |  $$ |$$ /  $$ |$$$$\  $$$$ |    //
//    \$$$$$$\  $$$$$$$  |$$$$$$$$ |$$\$$\$$ $$ |    //
//     \____$$\ $$  ____/ $$  __$$ |$$ \$$$  $$ |    //
//    $$\   $$ |$$ |      $$ |  $$ |$$ |\$  /$$ |    //
//    \$$$$$$  |$$ |      $$ |  $$ |$$ | \_/ $$ |    //
//     \______/ \__|      \__|  \__|\__|     \__|    //
//                                                   //
//     $$$$$$\  $$$$$$$\   $$$$$$\  $$\      $$\     //
//    $$  __$$\ $$  __$$\ $$  __$$\ $$$\    $$$ |    //
//    $$ /  \__|$$ |  $$ |$$ /  $$ |$$$$\  $$$$ |    //
//    \$$$$$$\  $$$$$$$  |$$$$$$$$ |$$\$$\$$ $$ |    //
//     \____$$\ $$  ____/ $$  __$$ |$$ \$$$  $$ |    //
//    $$\   $$ |$$ |      $$ |  $$ |$$ |\$  /$$ |    //
//    \$$$$$$  |$$ |      $$ |  $$ |$$ | \_/ $$ |    //
//     \______/ \__|      \__|  \__|\__|     \__|    //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract SPAMART is ERC721Creator {
    constructor() ERC721Creator("SPAM", "SPAMART") {}
}