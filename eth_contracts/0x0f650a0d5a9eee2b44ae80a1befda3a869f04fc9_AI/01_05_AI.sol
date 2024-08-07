// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: AI Photography
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                                                                             //
//                                                                                                                                                                                                                                                                             //
//                                                                                                                                                                                                                                                                             //
//                                                                                                                                                                                                                                                                             //
//     .----------------.  .----------------.   .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. | | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | |      __      | || |     _____    | | | |   ______     | || |  ____  ____  | || |     ____     | || |  _________   | || |     ____     | || |    ______    | || |  _______     | || |      __      | || |   ______     | || |  ____  ____  | || |  ____  ____  | |    //
//    | |     /  \     | || |    |_   _|   | | | |  |_   __ \   | || | |_   ||   _| | || |   .'    `.   | || | |  _   _  |  | || |   .'    `.   | || |  .' ___  |   | || | |_   __ \    | || |     /  \     | || |  |_   __ \   | || | |_   ||   _| | || | |_  _||_  _| | |    //
//    | |    / /\ \    | || |      | |     | | | |    | |__) |  | || |   | |__| |   | || |  /  .--.  \  | || | |_/ | | \_|  | || |  /  .--.  \  | || | / .'   \_|   | || |   | |__) |   | || |    / /\ \    | || |    | |__) |  | || |   | |__| |   | || |   \ \  / /   | |    //
//    | |   / ____ \   | || |      | |     | | | |    |  ___/   | || |   |  __  |   | || |  | |    | |  | || |     | |      | || |  | |    | |  | || | | |    ____  | || |   |  __ /    | || |   / ____ \   | || |    |  ___/   | || |   |  __  |   | || |    \ \/ /    | |    //
//    | | _/ /    \ \_ | || |     _| |_    | | | |   _| |_      | || |  _| |  | |_  | || |  \  `--'  /  | || |    _| |_     | || |  \  `--'  /  | || | \ `.___]  _| | || |  _| |  \ \_  | || | _/ /    \ \_ | || |   _| |_      | || |  _| |  | |_  | || |    _|  |_    | |    //
//    | ||____|  |____|| || |    |_____|   | | | |  |_____|     | || | |____||____| | || |   `.____.'   | || |   |_____|    | || |   `.____.'   | || |  `._____.'   | || | |____| |___| | || ||____|  |____|| || |  |_____|     | || | |____||____| | || |   |______|   | |    //
//    | |              | || |              | | | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' | | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'   '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                                                                                                                                                                                                             //
//                                                                                                                                                                                                                                                                             //
//                                                                                                                                                                                                                                                                             //
//                                                                                                                                                                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AI is ERC721Creator {
    constructor() ERC721Creator("AI Photography", "AI") {}
}