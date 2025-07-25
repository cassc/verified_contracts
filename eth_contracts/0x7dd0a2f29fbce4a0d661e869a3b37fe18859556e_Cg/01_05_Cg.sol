// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Digital reality
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                            //
//                                                                                                                                                                                            //
//                                                                                                                                                                                            //
//     .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.     //
//    | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |    //
//    | |     ____     | || | ____    ____ | || |     _____    | || |  ________    | || |  ___  ____   | || |   ________   | || |  _________   | || | ____    ____ | || |     _____    | |    //
//    | |   .'    `.   | || ||_   \  /   _|| || |    |_   _|   | || | |_   ___ `.  | || | |_  ||_  _|  | || |  |  __   _|  | || | |_   ___  |  | || ||_   \  /   _|| || |    |_   _|   | |    //
//    | |  /  .--.  \  | || |  |   \/   |  | || |      | |     | || |   | |   `. \ | || |   | |_/ /    | || |  |_/  / /    | || |   | |_  \_|  | || |  |   \/   |  | || |      | |     | |    //
//    | |  | |    | |  | || |  | |\  /| |  | || |      | |     | || |   | |    | | | || |   |  __'.    | || |     .'.' _   | || |   |  _|  _   | || |  | |\  /| |  | || |      | |     | |    //
//    | |  \  `--'  /  | || | _| |_\/_| |_ | || |     _| |_    | || |  _| |___.' / | || |  _| |  \ \_  | || |   _/ /__/ |  | || |  _| |___/ |  | || | _| |_\/_| |_ | || |     _| |_    | |    //
//    | |   `.____.'   | || ||_____||_____|| || |    |_____|   | || | |________.'  | || | |____||____| | || |  |________|  | || | |_________|  | || ||_____||_____|| || |    |_____|   | |    //
//    | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |    //
//    | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |    //
//     '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'     //
//                                                                                                                                                                                            //
//                                                                                                                                                                                            //
//                                                                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Cg is ERC721Creator {
    constructor() ERC721Creator("Digital reality", "Cg") {}
}