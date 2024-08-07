// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ANYDAY
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////
//                                                                  //
//                                                                  //
//     .----------------. .-----------------..----------------.     //
//    | .--------------. | .--------------. | .--------------. |    //
//    | |      __      | | | ____  _____  | | |  ____  ____  | |    //
//    | |     /  \     | | ||_   \|_   _| | | | |_  _||_  _| | |    //
//    | |    / /\ \    | | |  |   \ | |   | | |   \ \  / /   | |    //
//    | |   / ____ \   | | |  | |\ \| |   | | |    \ \/ /    | |    //
//    | | _/ /    \ \_ | | | _| |_\   |_  | | |    _|  |_    | |    //
//    | ||____|  |____|| | ||_____|\____| | | |   |______|   | |    //
//    | |              | | |              | | |              | |    //
//    | '--------------' | '--------------' | '--------------' |    //
//     '----------------' '----------------' '----------------'     //
//     .----------------. .----------------. .----------------.     //
//    | .--------------. | .--------------. | .--------------. |    //
//    | |  ________    | | |      __      | | |  ____  ____  | |    //
//    | | |_   ___ `.  | | |     /  \     | | | |_  _||_  _| | |    //
//    | |   | |   `. \ | | |    / /\ \    | | |   \ \  / /   | |    //
//    | |   | |    | | | | |   / ____ \   | | |    \ \/ /    | |    //
//    | |  _| |___.' / | | | _/ /    \ \_ | | |    _|  |_    | |    //
//    | | |________.'  | | ||____|  |____|| | |   |______|   | |    //
//    | |              | | |              | | |              | |    //
//    | '--------------' | '--------------' | '--------------' |    //
//     '----------------' '----------------' '----------------'     //
//                                                                  //
//                                                                  //
//////////////////////////////////////////////////////////////////////


contract ANYDAY is ERC1155Creator {
    constructor() ERC1155Creator("ANYDAY", "ANYDAY") {}
}