// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: EXPECTRAL
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//    ___________                             __                .__       //
//    \_   _____/__  _________   ____   _____/  |_____________  |  |      //
//     |    __)_\  \/  /\____ \_/ __ \_/ ___\   __\_  __ \__  \ |  |      //
//     |        \>    < |  |_> >  ___/\  \___|  |  |  | \// __ \|  |__    //
//    /_______  /__/\_ \|   __/ \___  >\___  >__|  |__|  (____  /____/    //
//            \/      \/|__|        \/     \/                 \/          //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
//    ___.                           .__                                  //
//    \_ |__ ___.__.     _____ ___  _|__| ___________  ____               //
//     | __ <   |  |     \__  \\  \/ /  |/    \_  __ \/  _ \              //
//     | \_\ \___  |      / __ \\   /|  |   |  \  | \(  <_> )             //
//     |___  / ____|     (____  /\_/ |__|___|  /__|   \____/              //
//         \/\/               \/             \/                           //
//                                                                        //
//                                                                        //
//                                                                        //
//                                                                        //
////////////////////////////////////////////////////////////////////////////


contract EXPTRL is ERC721Creator {
    constructor() ERC721Creator("EXPECTRAL", "EXPTRL") {}
}