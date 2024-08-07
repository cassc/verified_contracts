// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Honey
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                                                            ,#▓▓▓▒╦                   //
//                                                           ]╬╬╬╬╬╬╬▓                  //
//                                                           ║╬╬╬╬╬╬╬▓                  //
//                                                        ╓╣╬╬╬╣╣╬╣╝╙                   //
//              ,╓╗╗@▒▒▓╣╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╣▓▒▒▒▒▓╬╬╬╩                          //
//           #╣╬╬╬╫╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬╬╬╣╬╬╬▒                         //
//          ║╬╬▒▒▒▒▒╠╬╬╬▒░░░░╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠░░░░░▒▒░╟╬╬╬╬╬╬╣                        //
//           ╣╬▒▒▒▒╠╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╬╬╬╬╬╬⌐                        //
//            ╬▒▒▒▒╠╬╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒╬╬╬╬╬µ                         //
//           ╬░░░░░╠╬╬╬╬▒░░╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚╚░░░░░░░░╚╬╬╬╬╬                         //
//          ╔▒░░░Å╬╬╬╬╬╬▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╚╬╬╬╬▒                        //
//          ╠░░░╠╬╬╬╬╬╬╬▒░░░╬╬╬░░░░░░░░░░░░░░░░░░░░░░░░░░░░╚╬╬╬╬µ                       //
//         ⌠╙░░▐╬╬╬╬╬╬╬╬▒░░╬╬╬╬╬░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░╬╝╨╙└                       //
//         ';░░∩ └└╙╙╙╙╨▒░░╬╬╬╬╬▒░░░░φ╬╬╬╬▒░░░░╠╬╝╝╩╜╙φ░░░"╚∩                           //
//          :░░∩        ]░░      ░░░░⌐     ░░░⌐        ░░░                              //
//           ░░∩        ;░░      φ░░░                  ░░░       -                      //
//        '  ^φ⌐        ;░░       ╙╙                   ░░░⌐                             //
//                      ]░░                           .░░░                              //
//                      ]░░                           ]░░░                              //
//         '             '                            φ░░░                              //
//         '                                          ░░░░      '                       //
//          ¡                                         ░░░░                              //
//                                                     "                                //
//                                                          ,╓ε                         //
//            ╙╬▒▒φ╗▄╓╓╓,,,                      ,,,╓╓▄φ@▒╬╬╬╩                          //
//             └╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╙                           //
//               ║╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬                             //
//                └╝╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╝╙                              //
//                     `╙╙╙╚╝╝╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╝╝╝╜╙╙`                                   //
//                __  __  ______  __   __  ______  __  __                               //
//               /\ \_\ \/\  __ \/\ "-.\ \/\  ___\/\ \_\ \                              //
//               \ \  __ \ \ \/\ \ \ \-.  \ \  __\\ \____ \                             //
//                \ \_\ \_\ \_____\ \_\\"\_\ \_____\/\_____\                            //
//                 \/_/\/_/\/_____/\/_/ \/_/\/_____/\/_____/                            //
//                       𝙬𝙝𝙚𝙧𝙚 𝙗𝙪𝙯𝙯𝙮 𝙠𝙚𝙚𝙥𝙨 𝙩𝙝𝙚 𝙜𝙤𝙤𝙙 𝙨𝙩𝙪𝙛𝙛    //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract HONEY is ERC721Creator {
    constructor() ERC721Creator("Honey", "HONEY") {}
}