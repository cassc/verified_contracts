// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Chrome Destroyer
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//       ╓██▀▀▀▄█"ß███Φ "▀██▌T"ß███▀▀█▄    ▄▓▀▀██▄ "ñ███▄    ]███Φ T▀██▀▀▀▀█     //
//      ██▌     █  ╟█▌    ██▄   ╫█▌   ██ .██    ╟██  █╟██    █╫██   ▐██    ╙     //
//     ╫██         ╟█▌    ██▄   ╫█▌ ,▓██ ██▌     ██▌ █ ███  ▓Ö╫██   ▐██  ,▌      //
//     ╫██         ╟█▌└└└└██▄   ╫█▌▀██   ███     ██▌ █  ██▌╓▌ ╫██   ▐██┘┘╙▌      //
//      ██µ     ▐═ ╟█▌    ██▄   ╫█▌ ╙██  ╙██     ██─ █  ╟███  ╫██   ▐██     Æ    //
//       ▀█▓▄╓▄▓╙ ,███   ,██▌   ███  ╙██▄ ╙██▄ ,██└ ,█▄  ██b  ███   ▄██▄▄▄▄▓U    //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract CD is ERC721Creator {
    constructor() ERC721Creator("Chrome Destroyer", "CD") {}
}