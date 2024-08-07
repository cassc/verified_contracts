// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Boomer Pass
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                        ,╓▄▄▄▓▓▓████████▓▓▄▄           //
//                                  ╓▄▓▓█████████████▀▀█████████▄        //
//                             ,▄▓███████▀▀╙▄███████▌   └█████████▄      //
//                          ▄▓███████▀`   ╓█████████     ▐█████████      //
//                       ╓▓███████▓`     ]█████████▌      █████████▌     //
//                     ╓█████████─       ▓█████████⌐     ▐█████████⌐     //
//                    ▓████████▌         ██████████      █████████▌      //
//                   ██████████         ]█████████▌    ,█████████╨       //
//                  ██████████▌         ╟█████████▌  ╓▓████████╙         //
//                 j███████████▄   ,╓   ▓█████████████████▀▀`            //
//                  █████████████████   █████████████████████▓▄          //
//                  ▓███████████████    █████████▌    └▀█████████▄       //
//                   ▀████████████╙    j█████████▌       ██████████▄     //
//                     ╙▀▀███▀▀╙       ▐█████████▌        ██████████▌    //
//                                     ╟█████████⌐        ███████████    //
//                                     ▓█████████         ███████████    //
//                                     ██████████         ███████████    //
//                                     ██████████        ▐██████████⌐    //
//                                    ▐██████████        ██████████▀     //
//                                    ╟██████████µ     ▄█████████▀       //
//                                    █████████████▓▓▓█████████▀         //
//                                   ▓█████▀╙╙▀▀█████████▀▀▀└            //
//                                  ╚██▀`                                //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
///////////////////////////////////////////////////////////////////////////


contract BOOM is ERC721Creator {
    constructor() ERC721Creator("The Boomer Pass", "BOOM") {}
}