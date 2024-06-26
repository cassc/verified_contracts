// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: VOIDLAND
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//    ;╗╗╖▄▄▄▄▄▄  ,▓█▄   ▓▄▄▄▓]▓▄▄▄▄▄   ▓▄▄▄▓      ┌▄▄╕   Æ▄╖╗╕ Æ╗╗▄Æ╗╖▄╗▄       //
//    ╚▓▓▓█▌████ ╒█████  █████"███████  █████      ╟███   ║▓▓▓▓ ╣▓▓▌╫▓▓▓███▄     //
//     ╟▓██  ██  ███╙██▌ └███  ╟███╨███  ███▌      ╫███    ▓▓╬╬  ╬╬  ▓▓▓▌║██     //
//      ███  █▌ ▐██  ███  ███   ███ ╟██  ███       ████    ╚╬╬╬  ╬▌  ║╣▓  ▓█▌    //
//      ███  █⌐ ███  ╟██  ███   ██▌ ]██b ╟██       █╝██    '╬╬╬▒ ║Γ  ▐╬▓  ▓█▓    //
//      ╟██  █  ███  ▐██⌐ ╟█▌   ██▌  ██▌ ▐██       █ ██     ╬╬╬╣ ║ε  ╒╣▓  ╫██    //
//      ▐██ ▐█  ███  ▐██µ ║╬▌   ██▌  ██▌ ▐██       █ ██b    ▓╣╬╬╕║L  '▓▌  ╫██    //
//       ██ ▐▌  ███  ▐██µ ╚╬Γ   ╫█b  ██▌ ▐██   ▌  ▐█ ██▌    ▓ ▓▓▓▓L  '▓▌  ╫██    //
//       ██b╫▌  ███  ▐██⌐ ║▓▒   ▓█b  ██▌ ▐██   █  ╟█████    █ ▓▓▓▓L  ]█▓  ▓██    //
//       ██▌█µ  ███  ╞▓▓  ║▓▌   ▓█L  ██▌ ▐██   █  ██████   ╒█ ▐███▌  ▐██  ███    //
//       ████   ╫██  ║▓▓  ╫╬▌   ▓▓▌ ┌██⌐ ╟██  ▐█  █▌ ███⌐  ▐█  ███▌  ║██  ███    //
//       ████   ╘█▓  ▓╬▌  ╬╬╣   ▓▓▌ ║██  ███  ▓█ ▐█▌ ╟██▌  ╫█  ███▌  ███  ██▌    //
//       ╟███    ▓▓▓#╬╬  /╬╬╬  á╬▓▓╗▓█▌ ,████▄██ ███ ████  ██▌ ╟██▌ ,███████     //
//       ▐███     ▓▓▓╬⌐  ╬╬╬╬╬«╬╬▓▓▓▓▌  ██████████████████▓▓╬▓L▐██▌ ███████      //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract VOIDLAND is ERC721Creator {
    constructor() ERC721Creator("VOIDLAND", "VOIDLAND") {}
}