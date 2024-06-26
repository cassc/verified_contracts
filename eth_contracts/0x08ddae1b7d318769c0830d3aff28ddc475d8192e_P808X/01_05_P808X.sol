// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ROBBIEP808X
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//    ██████╗  ██████╗ ██████╗ ██████╗ ██╗███████╗██████╗  █████╗  ██████╗  █████╗ ██╗  ██╗    //
//    ██╔══██╗██╔═══██╗██╔══██╗██╔══██╗██║██╔════╝██╔══██╗██╔══██╗██╔═████╗██╔══██╗╚██╗██╔╝    //
//    ██████╔╝██║   ██║██████╔╝██████╔╝██║█████╗  ██████╔╝╚█████╔╝██║██╔██║╚█████╔╝ ╚███╔╝     //
//    ██╔══██╗██║   ██║██╔══██╗██╔══██╗██║██╔══╝  ██╔═══╝ ██╔══██╗████╔╝██║██╔══██╗ ██╔██╗     //
//    ██║  ██║╚██████╔╝██████╔╝██████╔╝██║███████╗██║     ╚█████╔╝╚██████╔╝╚█████╔╝██╔╝ ██╗    //
//    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚═╝╚══════╝╚═╝      ╚════╝  ╚═════╝  ╚════╝ ╚═╝  ╚═╝    //
//    Ok, It's 808 Robbie!                                                                     //
//                                                                                             //
//                                                                                             //
//                                                ,,,                                          //
//                                       ,╓╓ß╬╢▒▒▒▒▒▒█▄╥╗                                      //
//                                  ,╓ß╢▒▒▒▒▒▒▒▒▒▒▒▒▐███▓▓o~                                   //
//                                φ╢▒▒▒▒▒▒╢╢▓▓@▒▒▒▒▒████████▄░─                                //
//                              ¢╢╢▒▒▒▒╢╢╣╢╢╢╢▓╣╣╣▒▒██████████▌ .                              //
//                            Æ▒▒╢╢╢╢╢╢╢╬╬▓▓╣╢╢╢╣╢╣╣████████████ ;╓µg▄,                        //
//                .╙@µ╖,╖ , ,▓▒▒╢╢╢╢╢╢╣╢╢╢╢▓▓▓╢╢╢╢╣╣▒████████████,▒▓██████▄╖,                  //
//              ╓@µ╠▓╢╣╫▓▓▓▒╢▒▒▒▒▒╫▓▓▓▓▓▓▓╢╢╢▓▓▓╣╢╢╢╣╢██████████████████████████▄,             //
//             \╢╫▓▓▓▓╣▓╢▓▓▓╣▒▒▒╢▒▒▒▓▓▓▓▓▓▓▓╣╢╢▓▓▓▓▓▓▓▓███████████▓████████████████▄           //
//              `╟╢▓▓▓█╢▓╣▓▓╣▒▒╣▒╣╢╣╣▒▓╣╣╢▓▓▓▓▓▓▓▓▓▓▓▓▓▓███████████▓ ▀▀▀▀███████████           //
//             N]▓▓▓▓▓╣╫╣▓▓▓▒▒▒▒╢╣▒╢▒▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╢███████████      ▄████████           //
//             ╠╢▓▓▓▓▓▓▓╣▓▓▓▓▒▒▒▒╢▓╫▓▓▓▓▓▓▓▀▀▓▓▓▓▀▀▀╙""``  '█████████▌   ,████████             //
//             ]╫▓▓▓▓▓▓▓▓▓▓▓▓▓▒▒▒╢╫▀╙▀"      ▐▓▓▓            ▀████████  ╒███████▀              //
//             #▓▓▓▓▓█▀"` `"""╚▒▒╢╢           ╚▓▓▓            ▐███████W▓██████▀                //
//            ,ß▓▓▓▓`         ╒▒▒╢▓            ╘▓╣             ██████████████                  //
//             ╜╩╜            ╫▒▒╢             ╔╫╣▓           j████████████▓`                  //
//                            ▒▒▒▓              ]▓╣▓          ]████████████                    //
//                            ▒▒▒                 ╕╙`         ▐█████████▓█▌                    //
//                           ╔▒▒▌                              ███████████,                    //
//                          ╬▒╢▒▒                             ╙████████████,                   //
//                          ╬▒▒▒▒[                            ]██████▀███████▄                 //
//                          ╞▓▒▓▓╣                             ▓████▓██████████                //
//                          ║ ╟ ╫                              ▓████████▀██████                //
//                          ╚  ╜                               ▓███████▒U   ▀▀                 //
//                                                             ▓███████████▄▄▄▄▄               //
//                                                             ▓▓▓▓▓▓▓███████████▄             //
//                                                            ,▓██████████████████             //
//                                                            ██████████████████▀▀             //
//                                                            "▀▀▀▀▀▀▀                         //
//                                                                                             //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract P808X is ERC1155Creator {
    constructor() ERC1155Creator() {}
}