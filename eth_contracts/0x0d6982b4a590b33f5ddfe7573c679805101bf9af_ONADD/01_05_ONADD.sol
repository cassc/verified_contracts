// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Open Addictions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//                                                                                             //
//                             ,-----. ,------. ,------.,--.  ,--.                             //
//                            '  .-.  '|  .--. '|  .---'|  ,'.|  |                             //
//                            |  | |  ||  '--' ||  `--, |  |' '  |                             //
//                            '  '-'  '|  | --' |  `---.|  | `   |                             //
//                             `-----' `--'     `------'`--'  `--'                             //
//                                                                                             //
//                                                                                             //
//                                                                                             //
//           ,---.  ,------.  ,------.  ,--. ,-----.,--------. ,-----. ,--.  ,--. ,---.        //
//          /  O  \ |  .-.  \ |  .-.  \ |  |'  .--./'--.  .--''  .-.  '|  ,'.|  |'   .-'       //
//         |  .-.  ||  |  \  :|  |  \  :|  ||  |       |  |   |  | |  ||  |' '  |`.  `-.       //
//         |  | |  ||  '--'  /|  '--'  /|  |'  '--'\   |  |   '  '-'  '|  | `   |.-'    |      //
//          `--' `--'`-------' `-------' `--' `-----'   `--'    `-----' `--'  `--'`-----'      //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract ONADD is ERC1155Creator {
    constructor() ERC1155Creator("Open Addictions", "ONADD") {}
}