// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Everyday Botwins
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//                                                                                     //
//    _______         ___.           __          .__                   __  .__         //
//    \   _  \ ___  __\_ |__   _____/  |___  _  _|__| ____       _____/  |_|  |__      //
//    /  /_\  \\  \/  /| __ \ /  _ \   __\ \/ \/ /  |/    \    _/ __ \   __\  |  \     //
//    \  \_/   \>    < | \_\ (  <_> )  |  \     /|  |   |  \   \  ___/|  | |   Y  \    //
//     \_____  /__/\_ \|___  /\____/|__|   \/\_/ |__|___|  / /\ \___  >__| |___|  /    //
//           \/      \/    \/                            \/  \/     \/          \/     //
//    ___________                                             .___                     //
//    \_   _____/_________________________________________  __| _/____  ___.__.        //
//     |    __)_\_  __ \_  __ \_  __ \_  __ \_  __ \_  __ \/ __ |\__  \<   |  |        //
//     |        \|  | \/|  | \/|  | \/|  | \/|  | \/|  | \/ /_/ | / __ \\___  |        //
//    /_______  /|__|   |__|   |__|   |__|   |__|   |__|  \____ |(____  / ____|        //
//            \/                                               \/     \/\/             //
//                                                                                     //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract errdayBotwins is ERC721Creator {
    constructor() ERC721Creator("Everyday Botwins", "errdayBotwins") {}
}