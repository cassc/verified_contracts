// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ATMSPHR EDITIONS
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//         _  _____ __  __ ____  ____  _   _ ____    _____ ____ ___ _____ ___ ___  _   _ ____      //
//        / \|_   _|  \/  / ___||  _ \| | | |  _ \  | ____|  _ \_ _|_   _|_ _/ _ \| \ | / ___|     //
//       / _ \ | | | |\/| \___ \| |_) | |_| | |_) | |  _| | | | | |  | |  | | | | |  \| \___ \     //
//      / ___ \| | | |  | |___) |  __/|  _  |  _ <  | |___| |_| | |  | |  | | |_| | |\  |___) |    //
//     /_/   \_\_| |_|  |_|____/|_|   |_| |_|_| \_\ |_____|____/___| |_| |___\___/|_| \_|____/     //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract ATMSPHRxED is ERC1155Creator {
    constructor() ERC1155Creator("ATMSPHR EDITIONS", "ATMSPHRxED") {}
}