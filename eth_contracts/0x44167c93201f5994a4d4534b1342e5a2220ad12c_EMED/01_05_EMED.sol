// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Erin McGean Editions
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                            //
//                                                                                                                                                            //
//         ▄▄▄▄▄  ▄▄▄▄▄   ▄▄  ▄▄   ▄▄     ▄▄    ▄▄       ▄▄▄▄    ▄▄▄▄▄   ▄▄▄    ▄▄▄▄  ▄▄                                                                      //
//         ██▄▄   ██ ▐██  ██  ███▄ ██     ███▄▄███  ▄██▄ ██▀▀▀   ██▄▄   ██████  ████▄▐██                                                                      //
//         ██     ██▀██▄  ██ ▐█▌▀████     ██ █▀ ██ ██    ██  ▀█  ██     ██▄▄██  ██▌▀████                                                                      //
//         █████▌ ██  ██  ██ ▐█▌  ▀██     ██    ██  ▀██▀ ██████  █████  ██  ██  ██   ▀██                                                                      //
//        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░                                                                    //
//        ░░░░░░      EDITIONS    EDITIONS    EDITIONS     g▄&&▄▄▄▄▄▄g,░░▒▓▄,`─▒░░░░░░░░░░                                                                    //
//        ░░░         EDITIONS    EDITIONS    EDITIONS   ,╖▒▒╢▒▒@▒╗░▒░▒▐▓▓▓▓█▓▓&╖ `▒░░░░░░                                                                    //
//                              ,▄▄▓Ñ"                   ░╢▓██████████▓▓▓▓▓▓██▓╣▓▓█▄  `─▒░                                                                    //
//        EDITIONS       ░ ,φ▐▀▀▓▓╣╣▒▒░                .╫▓███████▀▀███████████▓▓▓▓      .                                                                     //
//        EDITIONS       ,ªv╙▄▓▓██████▓▓@░           ░░░▒▓▓▓██████'`▒╣▓███████▓▓▓▓       ░                                                                    //
//        EDITIONS     ╓▒░½╫▓███████▀▓▓╣╢▒▒          ░░░▒▓-╫, ,,,▄▄▄▄███████▓▓▓▒Ñ      .░░                                                                    //
//        EDITIONS    .▒▒$Ñ▓██▓███▓`   ╙─ '          ░░ ░ `'╙▒░▒░╟▒▓▓▓████▓▓▓▒▒╜       ░░░                                                                    //
//                     ░▒▒▀▓█▌▒  ,, eYe░`           ░▒▒   ╜`\    ░░▒▒▒▒see▓u▓╝      .░░░░░                                                                    //
//                    ░░▒╨▓███▓▀▀Ñ▒╜╙╜╓M`            ▒▒▒    '        ░░░░▒░░╜      .░░░░░░                                                                    //
//        analog▒"▀▓      ▒╙└"' '                    ]╢▒░               ░░▒╜      .░░░░░░░                                                                    //
//        ▓▓▓▓▓▓░          ─                          '╟▓@               ░░`      .░░░░░░░                                                                    //
//        █▓▓▓art  ▓██▄▄                               '▓▓╣             ░░`      .░░░░░░░░                                                                    //
//        ████▓▓▓▓████████▌╖                           ░▒▓▒▓,         ░░░`      .░░░░░░░░░                                                                    //
//        ▓▓▓▓╣▓▓▓██████████░╢▓me                   ╓@▓▓▓╣╫█▒  Γ     ░░       .░░░░░░░░░░░                                                                    //
//        ▓▓▓▓▓▓ ▓██████████▌▓▓▓▓▓▓          ╓▀▀▀┴░▒g███▀▀'▐█╜        ░       .░░░░░░░░░░░                                                                    //
//               ████████████▓▓▓▓▓▓▓▓▓▓▓▄,          ╙╙'  `                    ░░░░░░░░░░░░                                                                    //
//               ███████████▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄▄                              ╓▄▒░░░░░░░░░░░                                                                    //
//              ▐██████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄,                        ╓██▓▓░                                                                             //
//              ▓███████████████▓▓▓▓dadada▓▓▓▓▓▓▓▓▓▓▓▓▄▄    .      ░       ╒█████▓▓▓                                                                          //
//              █████████████████▓▓▓╣▒▒▒▒╢╢╫▓▓▓██████████▌▄, `╚Ñ▄@       ╒███████▓▓▓                                                                          //
//           ▐▓███████████████████▓▓╣▒▒░░▒╫▓▓▀▀▀▀▀▀▀▀▓▓▓▓▓▓▓▓▓╦,        ,█████████▓▓▓                                                                         //
//         ▄▓███████████████████████▓▓╣▒▒▒▒▒▒▒▒▒▒╖╖░╓▒╢▓▓▓▓▓▓╢╢╣╣▓▌▄,  ,████████████▓▓█▄                                                                      //
//        ████▓███████████████████████▓  * L I F E  W I T H  A R T * ████████████████████▓                                                                    //
//                                                                                                                                                            //
//                                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract EMED is ERC1155Creator {
    constructor() ERC1155Creator() {}
}