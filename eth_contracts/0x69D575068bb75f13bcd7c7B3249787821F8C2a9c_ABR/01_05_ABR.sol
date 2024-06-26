// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: AlteredBearRecords - Which Side You Are Gonna Pick?
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////
//                                                                                //
//                                                                                //
//       _____  .____  ___________________________________________________        //
//      /  _  \ |    | \__    ___/\_   _____/\______   \_   _____/\______ \       //
//     /  /_\  \|    |   |    |    |    __)_  |       _/|    __)_  |    |  \      //
//    /    |    \    |___|    |    |        \ |    |   \|        \ |    `   \     //
//    \____|__  /_______ \____|   /_______  / |____|_  /_______  //_______  /     //
//            \/        \/                \/         \/        \/         \/      //
//                 _____________________   _____ __________                       //
//                 \______   \_   _____/  /  _  \\______   \                      //
//                  |    |  _/|    __)_  /  /_\  \|       _/                      //
//                  |    |   \|        \/    |    \    |   \                      //
//                  |______  /_______  /\____|__  /____|_  /                      //
//                         \/        \/         \/       \/                       //
//    ______________________________  ________ __________________    _________    //
//    \______   \_   _____/\_   ___ \ \_____  \\______   \______ \  /   _____/    //
//     |       _/|    __)_ /    \  \/  /   |   \|       _/|    |  \ \_____  \     //
//     |    |   \|        \\     \____/    |    \    |   \|    `   \/        \    //
//     |____|_  /_______  / \______  /\_______  /____|_  /_______  /_______  /    //
//            \/        \/         \/         \/       \/        \/        \/     //
//                                                                                //
//                                                                                //
//                         Which Side You Are Gonna Pick?                         //
//                                                                                //
//                                     22/02/23                                   //
//                                                                                //
//                                                                                //
//                               Credits: 3RW1N.ETH                               //
//                                                                                //
//                                                                                //
////////////////////////////////////////////////////////////////////////////////////


contract ABR is ERC721Creator {
    constructor() ERC721Creator("AlteredBearRecords - Which Side You Are Gonna Pick?", "ABR") {}
}