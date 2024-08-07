// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Roses Under My Skin
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//    ████████████████▓▓█▌▓▓███▒█████▓▒▒▒▒╢╢╢╨╨▓██████████████████████████████████████        //
//        ████████████████▓╢╢█▒╢▓███▒▒███▓▒░▒▒▒▒▒░ ░▒╢▓███████████████████████████████████    //
//        ███████████████▓╣▓╢▓▀▓╜▀▓██▌╟███╣░░▒╣▒▒░▒░g█████████████████████████████████████    //
//        ████████████████╣▓╜╙`╙U▒▒▓██╢▀███░░▒▒▒▒▒╢▓██████████████████████████████████████    //
//        ███████████████▒▌'╟ ░ ▒║░▒▓██████▒░░▒▒▒▒╢▓███████████▓██████████████████████████    //
//        ███████████████▓▀@╖╙╖ j ░░╢▓█████▌░░▒╢▓▓▓▓█▓▓████████▓░] ▓▓█████████████████████    //
//        ████████████████░╜╢▓░N ░░▒▒▓▓█████░╫▓▓▓▓▓▓╢▓█████▓██▒▒╓ ╖ , ▓███████████████████    //
//        ███▓▓▓▓▓▓▓▓▓▓▓███▌░╙╫╖▒ ░║▒▒▓█████░▓▌▒╜╙ ░▓█████▓▓▓╣╣▒░] r╓█▌▒▓██▓██████████████    //
//        ██▓╣▒╙░╙░╙║╨╢▓▓▓███╖░▒▒▒░░▒▒╠█████▌█▌  ╓░▓██▓███▓▓▓▒▒░,░ ▄▓▓▓▓██████▓███████████    //
//        █▓▓▒░      `▒▒▒▓▓███▒▒▒▒▒ ░▒║▓█████▓▌@▓▒▒▓█████▓▓╣▒▒▒▒╜,▓▓▓▓▓███▓▓▓╣▓▓▓█████████    //
//        ██▓▒▒      ░ ░▒▒╢▓███▓▒░▒▒ ░▒▒▓██████▓╣▒▒╫▓▓████▓▒▒▒▒▒g▒▓▓▓▓██▓▓╣╫╣╢▓▓██████████    //
//        ██▓╣▒░     ░▒▒░▒Ñ▓▓████╝╙░░░ ░╙▓█████▒▒▒▒▒╢▓▓▓█▓╢╣╢▒╓▓╢╫╣▓███▓╣╣╢╢╣▓▓▓██████████    //
//        ███▓╣▒╖     ░▒▒▒▒▓╫▓▓▓▓▓ ░░░ ░ ╙▓████▌▒╜▒▒▒╢▒█▒╢▒▒▒▒╫▓▓▓███▓▓╣▒▒╣╣▓▓████████████    //
//        ████▓▓╣▒░    ░▒╢╣▓█▓▒▒╜▒▓ '░░░░ ╠█████▓▒▒▒▒▒█▒▒░▒▒░▒╢▓▓███▓╢╣╣▒╢╢╣▓▓████████████    //
//        █████▓▓╢▒░   ░▒▒╢▓██▌░   ▌  ░░░░ ╟█████▓▒▒▒█▓░▒▒▒▒░░░▐███▓▒▒▒▒▒╢╫▓▓█████████████    //
//        ██████▓▓▒▒░     ▒╫▓██▒   ▐▒ ░░░░ └▓█████▓╣▓▓┘,╢▒▒░▒░▓███▓Ñ▒░▒▒╢╬▓▓██████████████    //
//        ███████▓╣▒▒░     ]╢▓██╖   ▌░░▒▒▒░ ╟▓███████▒ ▒▒▒▒▒▒▓████▒▒░░▒╢╫▓▓███████████████    //
//        ████████▓╣▒░░ ,   ░╫███@  ▐▒░░▒░░ ╙▓██████▓░▒▒▒▒▒▒▓████▓▒▒░▒▒╢▓▓████████████████    //
//        ████████▓▓╣▒░░░''  ░╫███@  ▌░░░░░  ╠▓████▓▒▒▒▒╢╣╢╫▓███▓▒▒▒▒╢╫▓▓█████████████████    //
//        █████████▓╣▒▒░░░   ░▒▓███▒ ▐▒░▒▒░░ ▒╫▓████▓▒▒╢╣╣╣▓███▓╣▒▒▒╢╢▓▓██████████████████    //
//        █████████▓▓╣▒▒░'    ░╠▓███▒ ▒░░▒░  ░▒╢▓█████▓╣╢╣▓██▓▓▒▒▒╢▒╫▓▓███████████████████    //
//        ██████████▓▓▒▒░      ▒╫▓██▌ ▐▒░▒░░░ ░▒╢▓██████▓▓▓██▓╣╣╣╢╫╣▓▓▓███████████████████    //
//        ██████████▓▓╣▒▒░░░  ░▒╢▓███░ ▒░░░▒░  ░▒▒▓▓████████▓▓╣╢╣▓▓▓▓▓████████████████████    //
//        ███████████▓▓▒▒░ ░░░░▒╠▓▓██▌ ▐░░ ░▒░░░░░║▓▓███████▓▓▓▓▓▓▓▓▓█████████████████████    //
//        ███████████▓▓▓╣▒░░░░░▒╫▓▓███╕ ▒   `░░░  `▒▒╢▓▓████▓▓▓▓▓▓▓▓██████████████████████    //
//        █████████████▓▓▒░░ ░░▒╢▓▓█████▓▒   ░░░    ░▒╨▓▓████████▓▓███████████████████████    //
//        ██████████████▓▓▒░░ ░▒╫▓▓████▓▒▓░   ░░░     `░▒▓████████████████████████████████    //
//        ███████████████▓▓╣▒▒░▒╫▓███▓▒╙  ╚╖. ░░░░   ,  ░▒▓▓██████████████████████████████    //
//        █████████████████▓╣▒▒▒▓███▓▒     ╙@╖░░░░░   `░░▒╢╢▓▓████████████████████████████    //
//        ███████████████████▓╢▒╢▓▓▓░       ▒▓@╢╖      ░▒▒╢▓▓▓████████████████████████████    //
//        ████████████████████▓▒▒▒▒▒       ▒╫╣▓▌▒░     ░▒▓▓▓▓█████████████████████████████    //
//        █████████████████████▓▓▒▒░ ░    ▒╢╫▓▓█▓╫╖     ]▓████████████████████████████████    //
//        ██████████████████████▓▒▒░      ▒╬▓█████▓▒░,,g▓▓████████████████████████████████    //
//        ███████████████████████▓@╖     ║▓▓█████▒▓▒▒▒▒╫▓█████████████████████████████████    //
//        █████████████████████████▓╣@╖µ@██████▓╣▒▒▒Ñ▓▓█▀▓▓███████████████████████████████    //
//        ████████████████████████████▓▓▓▓████▓╣▒▒▒▒▒▒▒╣╣╫▓▓██████████████████████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract Skin is ERC721Creator {
    constructor() ERC721Creator("Roses Under My Skin", "Skin") {}
}