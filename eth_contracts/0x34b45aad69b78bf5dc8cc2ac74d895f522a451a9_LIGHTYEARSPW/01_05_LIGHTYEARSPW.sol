// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Light Years: Process Works
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//      _     ___ ____ _   _ _____                   //
//     | |   |_ _/ ___| | | |_   _|                  //
//     | |    | | |  _| |_| | | |                    //
//     | |___ | | |_| |  _  | | |                    //
//     |_____|___\____|_| |_|_|_| ____               //
//     \ \ / / ____|  / \  |  _ \/ ___|              //
//      \ V /|  _|   / _ \ | |_) \___ \              //
//       | | | |___ / ___ \|  _ < ___) |             //
//      _|_| |_____/_/__ \_\_|_\_\____/___ ____      //
//     |  _ \|  _ \ / _ \ / ___| ____/ ___/ ___|     //
//     | |_) | |_) | | | | |   |  _| \___ \___ \     //
//     |  __/|  _ <| |_| | |___| |___ ___) |__) |    //
//     |_|   |_| \_\\___/_\____|_____|____/____/     //
//     \ \      / / _ \|  _ \| |/ / ___|             //
//      \ \ /\ / / | | | |_) | ' /\___ \             //
//       \ V  V /| |_| |  _ <| . \ ___) |            //
//        \_/\_/  \___/|_| \_\_|\_\____/             //
//                                                   //
//                                                   //
//                           Dmitri Cherniak 2022    //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract LIGHTYEARSPW is ERC721Creator {
    constructor() ERC721Creator("Light Years: Process Works", "LIGHTYEARSPW") {}
}