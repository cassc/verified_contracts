// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DIBIA AND THE MASQUERADE
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                        ,⌐",,,,,,,,"∞                            //
//                                      ¿┘,▒▒¿░░░░░░░░▒'╕                          //
//                                     Æ ▒  ░░░░░░░░░░░▒ L                         //
//                                    ▐ ▒  ▒░░░░░░░░░░░░▒├                         //
//                                    ▐ ▒▒▒░░░░░░░░░░░░░░▌                         //
//                                     N`("▒░░░├░░░░r""`Φ                          //
//                                     \`,Y V░░░░░░/ ╛,'╛                          //
//                                      Y⌐∩  Y░░░░▒   W²                           //
//                                     . ⁿw ,╜░░░░▒,¿"  ╓                          //
//                                    ╣▒▓▄ └Ñ╪≡≡╪╪░⌠⌐▄╣╢╢@            ╓██▄▄        //
//                                  ╔╣╢╢╢╝'║░░⌠⌡░░░⌐Ç ╙╣╢╢▓         ╓████▀████▄    //
//                                 ▐╢╢▒╝   '═~Äl░░┘"    ║╣╢▓       ▐███▐█▐█j██▌    //
//                                 ▒╢╢╢╦, ╔▓▓▓▓▓▓▓▓▓╦╗╣╣╢╢▒╝      ⁿ▀███▄▀▀▄███     //
//                                  ╙▓╢╢╢╢╢▒▒▓▓▀▓▓▓▒╢╢▒▒╝"           ███████▀▀     //
//                                     ▀▒╢╢╢╢╢╢╢╢╢╢╢╢╢▒              ¬▀▀¬          //
//                                     ▐╢╢╢╢╢╢╢╢╢╢╢╢╢╢▓                            //
//                                     ╣╢╢╢╢╢╢╢╢╢╢╢╢╢╢╣                            //
//                                    ▐╢╢╢╣▒▒▒▒▒▒▒▒▒▒╢╢▌                           //
//                                    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                           //
//                                    ▓▓▓▓▓▒▓▓▓▓▓▓╢▓▓▓▓▓                           //
//                                    ▀▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓                            //
//                                     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌                            //
//                                     ▐▓▓▓▓▓▓█▐▓▓▓▓▓▓▌                            //
//                                      ▀▓▓▓▓▓"'╙▓▓▓▓▌                             //
//                                      j╢╢╢╢▌   ▌╢╢╢▌                             //
//                                       ╣╢╢╢▌   ▌╢╢╢▌                             //
//                                      ╔▓▓▓▓▓r @▓▓╣▓▓                             //
//                                     ,▓▓▓▓▓▓⌐ ▓▓▓▓▓▓@                            //
//                                    ]╢▓▀▓╢╣▓▌ ╣▌▓╢▓▓▓▌  , ,                      //
//                                 ;▄▄▄▓▓▓▒▓▓▓███▓▓▓▓▓▄█▄▄▄▄▄▄▄▄,                  //
//                            "▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀└-╘¬                  //
//                                                                                 //
//         <3 Philheal                                                             //
//                                                                                 //
//                                                                                 //
//                                                                                 //
//                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////


contract DAM is ERC721Creator {
    constructor() ERC721Creator("DIBIA AND THE MASQUERADE", "DAM") {}
}