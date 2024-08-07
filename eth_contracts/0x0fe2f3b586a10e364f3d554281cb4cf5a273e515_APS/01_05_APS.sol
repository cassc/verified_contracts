// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ARYE PACK SONG
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//       _____ _______________.___.___________ __________  _____  _________  ____  __.    //
//      /  _  \\______   \__  |   |\_   _____/ \______   \/  _  \ \_   ___ \|    |/ _|    //
//     /  /_\  \|       _//   |   | |    __)_   |     ___/  /_\  \/    \  \/|      <      //
//    /    |    \    |   \\____   | |        \  |    |  /    |    \     \___|    |  \     //
//    \____|__  /____|_  // ______|/_______  /  |____|  \____|__  /\______  /____|__ \    //
//            \/       \/ \/               \/                   \/        \/        \/    //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract APS is ERC1155Creator {
    constructor() ERC1155Creator("ARYE PACK SONG", "APS") {}
}