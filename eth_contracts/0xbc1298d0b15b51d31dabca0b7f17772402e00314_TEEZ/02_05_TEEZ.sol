// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TEEZ
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////
//                                                      //
//                                                      //
//     /$$$$$$$$ /$$$$$$$$ /$$$$$$$$ /$$$$$$$$          //
//    |__  $$__/| $$_____/| $$_____/|_____ $$           //
//       | $$   | $$      | $$           /$$/           //
//       | $$   | $$$$$   | $$$$$       /$$/            //
//       | $$   | $$__/   | $$__/      /$$/             //
//       | $$   | $$      | $$        /$$/              //
//       | $$   | $$$$$$$$| $$$$$$$$ /$$$$$$$$          //
//       |__/   |________/|________/|________/          //
//                                                      //
//                                                      //
//                                                      //
//                                                      //
//                                                      //
//////////////////////////////////////////////////////////


contract TEEZ is ERC721Creator {
    constructor() ERC721Creator("TEEZ", "TEEZ") {}
}