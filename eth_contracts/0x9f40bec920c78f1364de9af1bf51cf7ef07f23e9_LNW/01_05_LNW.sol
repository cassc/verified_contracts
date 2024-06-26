// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Lil Nouns Weekly
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//       ,--,                ,--,                                                                                                                                                   //
//    ,---.'|             ,---.'|                                                                                                                                                   //
//    |   | :       ,---, |   | :                                                                                                                    ,-.    ,--,                    //
//    :   : |    ,`--.' | :   : |                                                                                                                ,--/ /|  ,--.'|                    //
//    |   ' :    |   :  : |   ' :            ,---,     ,---.            ,--,        ,---,                          .---.                       ,--. :/ |  |  | :                    //
//    ;   ; '    :   |  ' ;   ; '        ,-+-. /  |   '   ,'\         ,'_ /|    ,-+-. /  |   .--.--.              /. ./|                       :  : ' /   :  : '                    //
//    '   | |__  |   :  | '   | |__     ,--.'|'   |  /   /   |   .--. |  | :   ,--.'|'   |  /  /    '          .-'-. ' |    ,---.      ,---.   |  '  /    |  ' |          .--,      //
//    |   | :.'| '   '  ; |   | :.'|   |   |  ,"' | .   ; ,. : ,'_ /| :  . |  |   |  ,"' | |  :  /`./         /___/ \: |   /     \    /     \  '  |  :    '  | |        /_ ./|      //
//    '   :    ; |   |  | '   :    ;   |   | /  | | '   | |: : |  ' | |  . .  |   | /  | | |  :  ;_        .-'.. '   ' .  /    /  |  /    /  | |  |   \   |  | :     , ' , ' :      //
//    |   |  ./  '   :  ; |   |  ./    |   | |  | | '   | .; : |  | ' |  | |  |   | |  | |  \  \    `.    /___/ \:     ' .    ' / | .    ' / | '  : |. \  '  : |__  /___/ \: |      //
//    ;   : ;    |   |  ' ;   : ;      |   | |  |/  |   :    | :  | : ;  ; |  |   | |  |/    `----.   \   .   \  ' .\    '   ;   /| '   ;   /| |  | ' \ \ |  | '.'|  .  \  ' |      //
//    |   ,/     '   :  | |   ,/       |   | |--'    \   \  /  '  :  `--'   \ |   | |--'    /  /`--'  /    \   \   ' \ | '   |  / | '   |  / | '  : |--'  ;  :    ;   \  ;   :      //
//    '---'      ;   |.'  '---'        |   |/         `----'   :  ,      .-./ |   |/       '--'.     /      \   \  |--"  |   :    | |   :    | ;  |,'     |  ,   /     \  \  ;      //
//               '---'                 '---'                    `--`----'     '---'          `--'---'        \   \ |      \   \  /   \   \  /  '--'        ---`-'       :  \  \     //
//                                                                                                            '---"        `----'     `----'                             \  ' ;     //
//                                                                                                                                                                        `--`      //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//                                                                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LNW is ERC1155Creator {
    constructor() ERC1155Creator() {}
}