// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Word On The Street
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//     _____          __   __    __   ___   __     ___     ___     __     //
//    /__   \ /\  /\ /__\ / / /\ \ \ /___\ /__\   /   \   /___\ /\ \ \    //
//      / /\// /_/ //_\   \ \/  \/ ///  /// \//  / /\ /  //  ///  \/ /    //
//     / /  / __  ///__    \  /\  // \_/// _  \ / /_//  / \_/// /\  /     //
//     \/   \/ /_/ \__/     \/  \/ \___/ \/ \_//___,'   \___/ \_\ \/      //
//     _____          __   __  _____   __    __  __  _____                //
//    /__   \ /\  /\ /__\ / _\/__   \ /__\  /__\/__\/__   \               //
//      / /\// /_/ //_\   \ \   / /\// \// /_\ /_\    / /\/               //
//     / /  / __  ///__   _\ \ / /  / _  \//__//__   / /                  //
//     \/   \/ /_/ \__/   \__/ \/   \/ \_/\__/\__/   \/                   //
//       _    _            _      ___         _____     __   _            //
//      /_\  (_)  /\/\    /_\    / __\ /\  /\ \_   \ /\ \ \ /_\           //
//     //_\\ | | /    \  //_\\  / /   / /_/ /  / /\//  \/ ///_\\          //
//    /  _  \| |/ /\/\ \/  _  \/ /___/ __  //\/ /_ / /\  //  _  \         //
//    \_/ \_/|_|\/    \/\_/ \_/\____/\/ /_/ \____/ \_\ \/ \_/ \_/         //
//       __  __    ___  _____  ____   _                                   //
//      /__\/__\  / __\|___  ||___ \ / |                                  //
//     /_\ / \// / /      / /   __) || |                                  //
//    //__/ _  \/ /___   / /   / __/ | |                                  //
//    \__/\/ \_/\____/  /_/   |_____||_|                                  //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract TWOTS is ERC721Creator {
    constructor() ERC721Creator("The Word On The Street", "TWOTS") {}
}