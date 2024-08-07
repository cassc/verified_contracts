// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Onboard Vault
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                    //
//                                                                                                                                    //
//                                                                                                                                    //
//    _______/\\\\\_____________________/\\\___________________________________________________________/\\\____________               //
//     _____/\\\///\\\__________________\/\\\__________________________________________________________\/\\\____________              //
//      ___/\\\/__\///\\\________________\/\\\__________________________________________________________\/\\\____________             //
//       __/\\\______\//\\\__/\\/\\\\\\___\/\\\____________/\\\\\_____/\\\\\\\\\_____/\\/\\\\\\\_________\/\\\____________            //
//        _\/\\\_______\/\\\_\/\\\////\\\__\/\\\\\\\\\____/\\\///\\\__\////////\\\___\/\\\/////\\\___/\\\\\\\\\____________           //
//         _\//\\\______/\\\__\/\\\__\//\\\_\/\\\////\\\__/\\\__\//\\\___/\\\\\\\\\\__\/\\\___\///___/\\\////\\\____________          //
//          __\///\\\__/\\\____\/\\\___\/\\\_\/\\\__\/\\\_\//\\\__/\\\___/\\\/////\\\__\/\\\_________\/\\\__\/\\\____________         //
//           ____\///\\\\\/_____\/\\\___\/\\\_\/\\\\\\\\\___\///\\\\\/___\//\\\\\\\\/\\_\/\\\_________\//\\\\\\\/\\___________        //
//            ______\/////_______\///____\///__\/////////______\/////______\////////\//__\///___________\///////\//____________       //
//    _________/\\\_____________________________________________________________________________________/\\\\\\____                   //
//     ________\/\\\____________________________________________________________________________________\////\\\____                  //
//      ________\/\\\________________________________/\\\\\\\\\_____________/\\\____________________________\/\\\____                 //
//       ________\/\\\___/\\/\\\\\\\______/\\\\\_____/\\\/////\\\___________\///___/\\/\\\\\\________________\/\\\____                //
//        ___/\\\\\\\\\__\/\\\/////\\\___/\\\///\\\__\/\\\\\\\\\\_____________/\\\_\/\\\////\\\_______________\/\\\____               //
//         __/\\\////\\\__\/\\\___\///___/\\\__\//\\\_\/\\\//////_____________\/\\\_\/\\\__\//\\\______________\/\\\____              //
//          _\/\\\__\/\\\__\/\\\_________\//\\\__/\\\__\/\\\___________________\/\\\_\/\\\___\/\\\______________\/\\\____             //
//           _\//\\\\\\\/\\_\/\\\__________\///\\\\\/___\/\\\___________________\/\\\_\/\\\___\/\\\____________/\\\\\\\\\_            //
//            __\///////\//__\///_____________\/////_____\///____________________\///__\///____\///____________\/////////__           //
//     ___________________________________________________________________________________________________________________            //
//      ___________________________________________________________________________________________________________________           //
//       ___________________________________________________________________________________________________________________          //
//        ______________________________________________________________________________________________________/\\\____/\\\_         //
//         _____________________________________________________________________________________________________\//\\\__/\\\__        //
//          ______________________________________________________________________________________________________\//\\\/\\\___       //
//           _______________________________________________________________________________________________________\//\\\\\____      //
//            ________________________________________________________________________________________________________\//\\\_____     //
//             _________________________________________________________________________________________________________\///______    //
//                                                                                                                                    //
//                                                                                                                                    //
//                                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract OBDV is ERC721Creator {
    constructor() ERC721Creator("Onboard Vault", "OBDV") {}
}