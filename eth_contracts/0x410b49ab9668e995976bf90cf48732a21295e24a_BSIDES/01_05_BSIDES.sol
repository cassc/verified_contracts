// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: LLD B-Sides
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//                                                    ε ╠                                                     //
//                                                                                                            //
//                                                    ] ╠µ                                                    //
//                                                                                                            //
//      ╞█▀▀▀██  ██▀▀▀^   ▐██─   ╟█                     ]▒                                                    //
//      ╞█─ ,██  ██▄▄,   ┌█¬██   ╟█                    ε ╠                                                    //
//      ╞█▀██╙   █▌└└└   ██▓███  ╟█                    ╘ ╠⌐                                                   //
//      ╞█─ ╙█▄  █▌     ██   ╙█▌ ╟█,                     '▒                                              é    //
//      └╙   └╙` ╙╙╙╙╙└'╙     ╙╙ └╙╙╙╙╙^                ╔ ╠                                             ╛     //
//      ╒▄        ╓▄─    ,▄▓▓▄▄  ╒▄▄▄▄▄  ▄▄▄▄▄          ╘ ╚                                            ╛ ╛    //
//      ╞█─      ┌███    ██   ╙  ╞█─     █▌  ╙█µ           ε                                         ,╙ ╜     //
//      ╞█─      █▀ ██   ╙███▄,  ╞██▓▓µ  ██▄▄██          ╔ ╠                                        ╔`,┘      //
//      ╞█─     ██▀▀▀█▌      ╙██ ╞█─     █▌└██           ╘ ▐                                       @ ,¬       //
//      ╞█▓▄▄▄▄▓█    ██▄ ██▄▄██▀ ╞█▓▄▄▄⌐ █▌  ▀█▄          ε ε                                     ╩ ╔         //
//                                                        ╙ φ                                   ,▌ á          //
//      ▐██▀██▄  ▓█▀▀██  ▐█⌐ ██▀▀█▓▄  ▐██▀▀▀  ▓█▀▀██      ' ╘        ,                         ╔▀ #           //
//      ╞█─  ██  ██▄     ▐█⌐ ██   ╙█▌ ▐█▌     ██▄          ε    ╝▓▒▄▓▓▓▓▄                     ▄╨ ╩            //
//      ╞█▀▀▀█▄   ╙▀███µ ▐█⌐ ██    ██ ▐██▀▀"   ╙▀███,      « [ .-╬▓▓▓▓████▓▓▓▒åφφ-           ▓" ╩             //
//      ╞█─  ▐█▌ ╓,   ██ ▐█⌐ ██  ,██⌐ ▐█▌     ╓    ██        ]  ╣╣▓▓▓▓▓▓███████▓▄▒▓▄       ,▓ ,▀              //
//      └▀▀▀▀▀└  ╙▀▀▀▀▀  └▀─ ▀▀▀▀▀╙   ╙▀▀▀▀▀⌐ ╙▀▀▀▀▀        ε ,φ╬╣▓▓▓▓███████████▓▓▓▓µ    ╓▌ ╓▀               //
//                                                       ,.φ. ╙╠╬╬▓▓▓▓████████████████▌  ▄▌ ▄╜                //
//                                                    ╓▒░░░░░  ░╙╙╚╬╬╣▓▓▓▓▓█████▓╬▓█▓▓█▓▓▀ Æ▌                 //
//                                                  φ╠▒░░!┐░░φφφ░░░░╠╬╬╬╬╬╬╣▓██╬╬╣╬▒▒▒╠╣╙ ║╬╣╬╗               //
//                                                 ╠╩░░░░░░░╠╣╠╙╙░░φ╠╠╬╬╬╬╬╣▓▓▓╬▒╬╬▒░▒▓▓▒▓╬╠▒╩╠╬▌╖            //
//                                             ┌@▒╠▒░░░░░░░▒╣▒░φφ▒▒╠╬╣╬╬╬╬╬╣▓▓╬╬╬▓╬▒▒░╠▓█╬╬▒▒▒▒▒╚╠╬╗,         //
//                                           ╓▓╬╠▒▒░░░░▒░░▒╣╣▓╬╬╠╠╬╬╣╬▓╬╠╠╠╬▓▓╬╬╣╬╬▓▓╬▒╟▓█▓▒▒░▒░░░▒╠╬▓,       //
//                                     ,╦▒▒╬╬╠╩▒▒▒░░░░▒░▒▒╣╬╬▓╣╣╬╬╬╬╬╣╬╬╬╬╬╬▓▓▓▓╬╬▓╬╠╠▓▓▓██╬▒▒░░▒▒░▒▒╠╬▓      //
//                                   ▄▓╬╬▒▒▒▒▒░░░░░░░░▒╠╠╣▓╬╬▓▓▓▓▓╬▓╬╬██╬╬╣█╬▓▓╬▓▓╬╣█▓╬╣╬▓██╬╠▒░░▒▒▒░░╚╩╬▓    //
//                                ▄▓▓╬╬╬╠╠╠╠▒▒▒░▒▒▒▒▒▒╠╠╣╬╬╬╬╬╬╬╬╬▒╠▓██▓╬╬╣██▓╬╬╣╬▓██╬╬╬╬╬╣▓█╬╠╠▒▒▒▒▒░░░░╚    //
//                             ▄▓█╬╣╬╬╬╬╬╬╠╠▒▒▒╠╠╠▒╠╠╠╬╣╬╩╠╠╠╠╬▒╠╠╣╬╬╣▓╬╬╬╬╣▓▓▓╬╬╬╠╫▓╬╬╬╠╠╠╠▓▓╬╠▒▒▒▒▒▒▒▒▒░    //
//                          ▄▓█▓▓╬╬╬╬╬╬╬╠╠▒▒╠╠╬╠╠╠╠╠╬╠╠╠▒▒▒╠╠╬╬▓╬╬╬╬╬╬╬╣╠╠╬╬╬╬╬╬╣╣▓▓╬╬╬╬╠╠▒▒╠╬╬╬╠▒▒▒▒▒▒▒▒▒    //
//                       ▄▓█▓▓▓╣╣╬╬╬╠╠╠▒╠▒╠╬╬╬╬╠╠╠╬╬╬╠╠╠╠╠╬╬╬╣▓╬╬╬╬▓╬██▓▓▓▓█▓╬╬╠╠╬██▓╬╬╬╬╠▒▒▒▒╠╠╠╠▒╠▒╠▒▒▒▒    //
//                   ,▄▓█▓▓╬╬╬╬╬╬╠╠╩╠▒╠╠╠╬╣╬╬╬╬╣▓▓▓▓▓▓╬╬╬╣▓▓▓╬╣╬╣▓████████████╬╬╬▒╬╢███╣╣╬╬╬╠╠▒╠╠╠╬╬╬╠▒╠╠╠    //
//              ╓▄▓██▓▓╬╬╬╬╬╬╠╠╠╠▒▒╠╠╠╠╠╬╬╣▓╬╣▓▀╙─  ╟█████▓╬╬╬▓████████╬╬▓▓████▓╣╬╬╬╣███▀▀▓▓╬╬╬╬▓╬╣╬╬╣╬╠╠╠    //
//         ╓▄▓████▓▓╬╬╬╬╬╬╠╠╠▒╠▒╠▒╠╠╠╠╬╬╬▓▓▓▀`       █████╣╬╬▓█████████▓▓▓▓╬╣███▓╬╬╬╬▓█▌         └╙▀█▓╬╬╬▒    //
//    ▄▄▓█████▓▓╬╬╬╬╬╬╬╬╠╠╠╠╠▒▒▒╠╠╠╠╬╬╬╬▓█▀          ╟███▓▓╬▓███████▓▓▓▓▓████████▓╬╬╣██▌             ╙▀█▓╬    //
//    █████▓╬╬╬╬╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬╬╣█▀            ╟███▓████▓╬▓█▓╬╬╬╣▓╣╣╣▓██╣███╬╣▓██▌                ╙▀    //
//    █▓╬╬╬╬╬╬╬╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬▓█╙             ▐███▓████╬╣████╬╬╣▓╬▓████╬████▓███▀                      //
//    ╬╬╬╬╬╬╬╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬╫▓█                ████╬▓╬╬╬╬▓▓▓▓█▓▓▓█████▓╬███████▀                       //
//    ╬╬╬╬╬╬╠╠╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬╣╣█▀                 ╟███▓▓╣╬╣▓▓▓▓╬╬╬╬╬╬╬▓▓▓▓╬╬▓▓▓██▌                        //
//    ╬╬╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬╬╬╣╣█                    ██████▓▓▓▓█▓╬╬╬╬╬╬╬╣▓█▓▓▓████▌                         //
//    ╬╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬╬╬╬╣╣▓▀                     █████████████████████████████▌                         //
//    ╬╬╬╠╠╠╠╠╠╠╠╠╠╠╠╬╬╬╬╬╬╬╬╣▓█                       ███████████▓▓╬╬╬╬▓███████████▌                         //
//    ╠╬╠╠╠╠╠╠╠╠╬╠╠╬╬╬╬╬╬╬╬╬╣▓▌                       ╟██████████████▓▓▓▓███████████▌                         //
//    ╠╠╠╠╠╠╠╠╠╬╬╬╬╬╬╬╬╬╬╬╣▓█▀   ,               ,╔╗╗╬█████▓███████████████████▓▓████                         //
//    ╠╠╠╠╠╠╠╠╬╬╬╬╬╬╬╬╬╬╬▓▓███▓████▓#╦╗╗╗╥,      ▓╠╠╢╬╬╬███▓▓╬▓▓▓▓▓█████████▓▓▓█▓▓██▒╬▓@@@▄   ,╓╗╗╗╗╗╥▄  ,    //
//    ╬╬╠╠╠╠╬╬╬╬╬╬╬╬╬╣▓▓▓██▓▓▓╬╣╬╬╣╬╬╬╣╬╬╣╬╬╬╬╬╣▓▓╬╠╬╬╠╠╠╠╬▀▓▓▓╬╬▓▓▓▓▓▓╬▓▓╣▓▓╬╬╣▓▓╬╬╠╠╬╬╬╬╬██╬╬╬╬╬╬╬╬╬╬▓╬╬    //
//    ^^^^╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙^""`"``""`````╙╙╙╙╙╙╙╙╙╙╙╙╙```"""""^"^╙╙╙╙╙╙╙^╙╙╙╙"╙╙╙     //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BSIDES is ERC721Creator {
    constructor() ERC721Creator("LLD B-Sides", "BSIDES") {}
}