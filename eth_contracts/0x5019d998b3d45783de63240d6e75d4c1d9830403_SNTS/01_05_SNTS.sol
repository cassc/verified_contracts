// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Sant0s_eth
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//     .----------------.  .----------------.  .-----------------. .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | |    _______   | || |      __      | || | ____  _____  | || |  _________   | || |     ____     | || |    _______   | || |              | || |  _________   | || |  _________   | || |  ____  ____  | |    //
//    | |   /  ___  |  | || |     /  \     | || ||_   \|_   _| | || | |  _   _  |  | || |   .'    '.   | || |   /  ___  |  | || |              | || | |_   ___  |  | || | |  _   _  |  | || | |_   ||   _| | |    //
//    | |  |  (__ \_|  | || |    / /\ \    | || |  |   \ | |   | || | |_/ | | \_|  | || |  |  .--.  |  | || |  |  (__ \_|  | || |              | || |   | |_  \_|  | || | |_/ | | \_|  | || |   | |__| |   | |    //
//    | |   '.___`-.   | || |   / ____ \   | || |  | |\ \| |   | || |     | |      | || |  | |    | |  | || |   '.___`-.   | || |              | || |   |  _|  _   | || |     | |      | || |   |  __  |   | |    //
//    | |  |`\____) |  | || | _/ /    \ \_ | || | _| |_\   |_  | || |    _| |_     | || |  |  `--'  |  | || |  |`\____) |  | || |              | || |  _| |___/ |  | || |    _| |_     | || |  _| |  | |_  | |    //
//    | |  |_______.'  | || ||____|  |____|| || ||_____|\____| | || |   |_____|    | || |   '.____.'   | || |  |_______.'  | || |   _______    | || | |_________|  | || |   |_____|    | || | |____||____| | |    //
//    | |              | || |              | || |              | || |              | || |              | || |              | || |  |_______|   | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SNTS is ERC721Creator {
    constructor() ERC721Creator("Sant0s_eth", "SNTS") {}
}