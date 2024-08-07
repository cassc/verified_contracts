// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Characters of Eterea
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//          ___           ___                    ___           ___           ___          //
//         /__/\         /  /\                  /  /\         /  /\         /  /\         //
//        _\_ \:\       /  /:/_                /  /::\       /  /::\       /  /:/_        //
//       /__/\ \:\     /  /:/ /\              /  /:/\:\     /  /:/\:\     /  /:/ /\       //
//      _\_ \:\ \:\   /  /:/ /:/_            /  /:/~/::\   /  /:/~/:/    /  /:/ /:/_      //
//     /__/\ \:\ \:\ /__/:/ /:/ /\          /__/:/ /:/\:\ /__/:/ /:/___ /__/:/ /:/ /\     //
//     \  \:\ \:\/:/ \  \:\/:/ /:/          \  \:\/:/__\/ \  \:\/:::::/ \  \:\/:/ /:/     //
//      \  \:\ \::/   \  \::/ /:/            \  \::/       \  \::/~~~~   \  \::/ /:/      //
//       \  \:\/:/     \  \:\/:/              \  \:\        \  \:\        \  \:\/:/       //
//        \  \::/       \  \::/                \  \:\        \  \:\        \  \::/        //
//         \__\/         \__\/                  \__\/         \__\/         \__\/         //
//          ___         ___           ___           ___                                   //
//         /  /\       /  /\         /  /\         /__/\                                  //
//        /  /:/_     /  /::\       /  /::\       |  |::\                                 //
//       /  /:/ /\   /  /:/\:\     /  /:/\:\      |  |:|:\                                //
//      /  /:/ /:/  /  /:/~/:/    /  /:/  \:\   __|__|:|\:\                               //
//     /__/:/ /:/  /__/:/ /:/___ /__/:/ \__\:\ /__/::::| \:\                              //
//     \  \:\/:/   \  \:\/:::::/ \  \:\ /  /:/ \  \:\~~\__\/                              //
//      \  \::/     \  \::/~~~~   \  \:\  /:/   \  \:\                                    //
//       \  \:\      \  \:\        \  \:\/:/     \  \:\                                   //
//        \  \:\      \  \:\        \  \::/       \  \:\                                  //
//         \__\/       \__\/         \__\/         \__\/                                  //
//          ___                       ___           ___                       ___         //
//         /  /\          ___        /  /\         /  /\        ___          /  /\        //
//        /  /:/_        /  /\      /  /:/_       /  /::\      /  /\        /  /::\       //
//       /  /:/ /\      /  /:/     /  /:/ /\     /  /:/\:\    /  /:/       /  /:/\:\      //
//      /  /:/ /:/_    /  /:/     /  /:/ /:/_   /  /:/~/:/   /__/::\      /  /:/~/::\     //
//     /__/:/ /:/ /\  /  /::\    /__/:/ /:/ /\ /__/:/ /:/___ \__\/\:\__  /__/:/ /:/\:\    //
//     \  \:\/:/ /:/ /__/:/\:\   \  \:\/:/ /:/ \  \:\/:::::/    \  \:\/\ \  \:\/:/__\/    //
//      \  \::/ /:/  \__\/  \:\   \  \::/ /:/   \  \::/~~~~      \__\::/  \  \::/         //
//       \  \:\/:/        \  \:\   \  \:\/:/     \  \:\          /__/:/    \  \:\         //
//        \  \::/          \__\/    \  \::/       \  \:\         \__\/      \  \:\        //
//         \__\/                     \__\/         \__\/                     \__\/        //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract COE is ERC721Creator {
    constructor() ERC721Creator("Characters of Eterea", "COE") {}
}