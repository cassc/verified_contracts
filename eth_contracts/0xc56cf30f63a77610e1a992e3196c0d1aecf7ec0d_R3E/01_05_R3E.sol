// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Rinna 3 Edition
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                                                                               //
//                                                                                               //
//        ████████████████████▓████████████████████▓███████████ ║█████████████████▓██╣██╬█       //
//        ████████████████████████████████████████████████████╙ ╟████████████████▓█▓██████       //
//        ██████████████████████████████████▓████████████████╙  ██████████╣███████▓█╣█╫██╢       //
//        █████████████████████████████████████████████████▀   ╣█╬▐███████╣████▒██▓█╣█╫██╣       //
//        █████████████████████████████████▓▓████████████▀   ╔███╦▓█▒█████████████▓██████╫       //
//        █████████████████╬╬█▓██████▓╬╬█▓╫▓████▓╣██▀╨`      ╣██▒███╢████▓████▓████▓██████       //
//        █████████████████████╬▓▓▓█╬▓▓▓╬╬▓▓╩╟███▀          ╠██╠╣▌  ▐▓▓▓███████╬███▓▓███╣█       //
//        █████████▓▓▓█▓███████████▓███╬╬╠▓██╟▓▓,          ╒█▓▓▓╩  ,╢█╣███▓▓██╝▓██▓█▓██▓██       //
//        █████╫▓▓╫▓██████████▓╬╬╬╩▓╠╣╝╠▄╣╬╩╙╙▀▀▀▀█╥      ,▓▓██╙╓▄▓▓╬╬╬▓╬╬╢╩╟▀╓██╬█▓██▓███       //
//        ██▓╬╬╬╬▓╬╬▓▓╬▓╬╬████▀█▓▄████▓▓▀═▄       ,,     ╔╣█╩`é╬╩`▄╬▓╗╝╬███▀█▓█╬█╬█╬╬█████       //
//        ██▓▓███▓█╫╬╢╬▓▓╬█▌ ╬╣█▀███▀██▓███▄▀╗    ╚▓▓▓▓▓▓▓╩   ╬  ╟▓████████▀▀─╠ ║▒╙▓██████       //
//        █████╬╬▓╬▓██b└╣╬█▒ ╞▐╬█╬█▌└└└╙███▀▀▀█▌   ,▄╬╬╬╨       ▓███▀╙─ ▐▓▌ █╙╬m  ╦╚██████       //
//        █████╬██████▓  ⌐╠⌐ ╞  ╬███▓,╓▓▓▓▓,,     ╙╙╙          ╙╙╙▓▓▓µ ▓▓▌▄▀╬ ╙▒   %╠█████       //
//        █████████████Γ  ║  ║  ╩▒▀─█╙█└▌╚.   ╙                 "╙└╙█╙█▀▌▀⌐╙▌═  Q   ╙╣████       //
//        ▓████▓███╬███▌  ▒  ▌   ╣ ╙▄                               ╓╗Q'│;Q'║╕   µ   └████       //
//        ███████╬██▓█╬█  ∩ ]   ]▒⌐ ╚▒                        b    ║╬╬╬▒╣╬╬▓║ ⌐  ╙    ║███       //
//        ██▓██╬█████▓█╬▌▐  ▐   ]⌐b  ╞                       ▓     ║╬╬╬╬╬╬╬▒╛,    ⌐   ╣███       //
//        █▓██▓█████▓█╬█▓▌  ║    ▒▌  ▐                     ▄▀      ▐╬╬╬╬╬╩░╩╒`   ▐   ]████       //
//        ╢█▓████▓█╬████▓╠  ╘    ║╠   ▒                  .... ╓    j╬╬╬╩└.╩]`    Γ   ╣████       //
//        █▒████▒████████╣   b    ╣    ╕             z█▌,▄▓█▀▀╙    ]╩`  ╓╜ ╜    ▐   ]█████       //
//        ▓█████╬████████▒µ  ╠    ╚µ   └            .░░│││░╙ ;▄        Θ ,╜     ╛   ╟█████       //
//        ▓████████╢██╬██▌▒  ▐     ▒    ╚          ╙▀▄▄░░≥▒▄▓▀       ╔╜╓Θ      ^   ╔██████       //
//                                                                                               //
//                                                                                               //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


contract R3E is ERC1155Creator {
    constructor() ERC1155Creator("Rinna 3 Edition", "R3E") {}
}