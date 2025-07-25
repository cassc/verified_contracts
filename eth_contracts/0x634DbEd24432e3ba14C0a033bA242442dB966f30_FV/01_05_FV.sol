// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: frater_venus
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//            ¬╔;¬──,      ,,⌐         ⌐  ,,⌐╔≤≥≥≥≥≥≥≥≥⌐'         ,░░░ ░░░░░░░░░░╦╦≥╦≥≥⌐      //
//          ░                                           ⌐       ,                             //
//         ╠                                           ;░░░╔╔░░░░╦ε⌐                          //
//         ░                  ⌐⌐,,,,            ░░░╦╬╣╣╣╣▓▓▓▓▓╣╬╬╦╦░╦╦╦,                      //
//         ░        ;,,,╔░╦╦░╦╣╣╣▓╣▒╦ε        ╔░╬╢╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬╦ε░░░░░         ⌐     //
//               ,░░░░░╣╣▓▓▓▓▓▓▓▓▓▓▓╬╠▓▄    «░░╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░░░              //
//         ░   ╔░░░░╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ░░╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░       ⌐     //
//             ░░░╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╕  ╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░            //
//           ░║╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌  ╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░           //
//         ╦░╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ░╣▓▓╬▀▀▀▀▓▓▓▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░    ░     //
//         ╣╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ ╔╬▓╙▒∩     `▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░░░░⌐      //
//         ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀   '╙▀▓░░░`           ▀░░░░▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░░       //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀        '╚▓╬╬╕░            ▀╪░░╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░      //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀          ]▓▓╣▌░░╓█▓▓▀▀▀M╤,   ""▀╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░░░     //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓           ║▓▓▒▓▀`▀▓▓▀▀█╦        "╣▓▓▓▌-▐▓▓▓▓▓▓▓▓▓▓▓▓▌░░░      //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓          ╔╣  ╙▀   ╟▓▓▄Æ╩``      ║▓▓▓  ╣@╣▓▓▓▓▓▓▓▓▓▓▓▓░░░      //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ,á▀▌       ▐░            ▐▀▀     ▄▓▓▓▓▓▓▓▓▓▓▓▓╬░░░     //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓       ╔▓▀░░∩      ;░                ╚C ╔╣▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░░     //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ^╤╣▀▀     ╒`⌐               ]╖╗"╙╣▓▓▓▓▓▓▓▓▓▓▓▓▓▒╬░░░     //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌            ⌐   ,ê▀▀╝              ,  " ▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣╣░░░╕    //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╕             ▒╣▀▓▄                    ▐▓╣▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓╬░░░    //
//         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌               ╔▓▀▓╦                  ╘╩╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░⌐    //
//         ║▓▓▓▓▓▓▓▓▓▓▓▓▓▀▀▀             ╔ ,╣▓▓▄╦╦           ╓m      ,╠╫╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬░░    //
//         ⌠╣▓▓▓▓▓▓▓▓▀ ,╓╖                '╬╬▓▓▓▓▒∩   ,╓▄╔▄▒▓▓▌   ╓▒▓▓▒▒▒╣▓▓▓▓▓▓▓▓▓▓▓▓▓╬╡     //
//          ╙▀▓▓▓▓▓▓▓   " "≥⌐           ┘    ╣▓▓▓▓▄▄▄▄▄▓▓▓▓▓▓▓▓à▓╣▒▓▓╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒╬░    //
//             ▀▀▓▓▓▓▓░   ╓─    ╦╔╔┘   ░    ╓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀╣▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░ε    //
//         ,   `"╙▀╬▀▓▓▓▓╗╦-  "╙▀         ,╦▓▓▓▓▓▓▓▓▓▓▓▓▀░░╬╬╣╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░    //
//         ,         `"▀▀▀▀░,       : ╔▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▒▒╣╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒∩    //
//          `'  ╔                   ε,╬▓▓▓▓▓▓▓▓▓▓▓▀░╬░░╬╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒╣▓╬     //
//         #╗╦╖   `" ╙ .▄       ,▄▄▒▓▓▓▓▓▓▓▓▓▓▓▓▓▌╬░░φ╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌▒▓▌▌    //
//         ░     `"╙ε--╦╦,` ,æ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒░    //
//               ░░  '┴=φ╗▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▒▌    //
//                        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓^    //
//                        ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     //
//                         ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓m    //
//                         ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌    //
//                         ╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌    //
//                         ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌    //
//                         ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓O    //
//                         ╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓∩    //
//                         ▐╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     //
//                          ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     //
//                          ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌     //
//                          ⌠║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌     //
//                           ╙▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓⌐    //
//                            ║▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓     //
//                                                             ```````^"""""""▀"▀▀▀▀▀▀▀▀▀     //
//                                                                                            //
//    ---                                                                                     //
//    asciiart.club                                                                           //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract FV is ERC721Creator {
    constructor() ERC721Creator("frater_venus", "FV") {}
}