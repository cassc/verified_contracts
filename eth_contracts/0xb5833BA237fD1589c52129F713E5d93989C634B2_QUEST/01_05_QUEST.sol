// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Paulo's Quest
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//                                                                            //
//                        ___           ___           ___                     //
//          ___          /__/\         /  /\         /  /\          ___       //
//         /  /\         \  \:\       /  /:/_       /  /:/_        /  /\      //
//        /  /::\         \  \:\     /  /:/ /\     /  /:/ /\      /  /:/      //
//       /  /:/\:\    ___  \  \:\   /  /:/ /:/_   /  /:/ /::\    /  /:/       //
//      /  /:/~/::\  /__/\  \__\:\ /__/:/ /:/ /\ /__/:/ /:/\:\  /  /::\       //
//     /__/:/ /:/\:\ \  \:\ /  /:/ \  \:\/:/ /:/ \  \:\/:/~/:/ /__/:/\:\      //
//     \  \:\/:/__\/  \  \:\  /:/   \  \::/ /:/   \  \::/ /:/  \__\/  \:\     //
//      \  \::/        \  \:\/:/     \  \:\/:/     \__\/ /:/        \  \:\    //
//       \__\/          \  \::/       \  \::/        /__/:/          \__\/    //
//                       \__\/         \__\/         \__\/                    //
//                                                                            //
//                                                                            //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


contract QUEST is ERC721Creator {
    constructor() ERC721Creator("Paulo's Quest", "QUEST") {}
}