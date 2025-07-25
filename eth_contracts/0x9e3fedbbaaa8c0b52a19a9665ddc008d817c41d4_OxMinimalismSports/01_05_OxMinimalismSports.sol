// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 0xMinimalism Sports
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
//       ___       __  __ ___ _   _ ___ __  __    _    _     ___ ____  __  __   ____  _____ ____  ___ _____ ____      //
//      / _ \__  _|  \/  |_ _| \ | |_ _|  \/  |  / \  | |   |_ _/ ___||  \/  | / ___|| ____|  _ \|_ _| ____/ ___|     //
//     | | | \ \/ / |\/| || ||  \| || || |\/| | / _ \ | |    | |\___ \| |\/| | \___ \|  _| | |_) || ||  _| \___ \     //
//     | |_| |>  <| |  | || || |\  || || |  | |/ ___ \| |___ | | ___) | |  | |  ___) | |___|  _ < | || |___ ___) |    //
//      \___//_/\_\_|  |_|___|_| \_|___|_|  |_/_/   \_\_____|___|____/|_|  |_| |____/|_____|_| \_\___|_____|____/     //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract OxMinimalismSports is ERC721Creator {
    constructor() ERC721Creator("0xMinimalism Sports", "OxMinimalismSports") {}
}