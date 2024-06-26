// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Life Juice AI
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//       ,--,                                                                                                       //
//    ,---.'|                                               ,---._                                                  //
//    |   | :                                             .-- -.' \                                                 //
//    :   : |     ,--,     .--.,                          |    |   :                ,--,                            //
//    |   ' :   ,--.'|   ,--.'  \                         :    ;   |         ,--, ,--.'|                            //
//    ;   ; '   |  |,    |  | /\/                         :        |       ,'_ /| |  |,                             //
//    '   | |__ `--'_    :  : :     ,---.                 |    :   :  .--. |  | : `--'_       ,---.     ,---.       //
//    |   | :.'|,' ,'|   :  | |-,  /     \                :         ,'_ /| :  . | ,' ,'|     /     \   /     \      //
//    '   :    ;'  | |   |  : :/| /    /  |               |    ;   ||  ' | |  . . '  | |    /    / '  /    /  |     //
//    |   |  ./ |  | :   |  |  .'.    ' / |           ___ l         |  | ' |  | | |  | :   .    ' /  .    ' / |     //
//    ;   : ;   '  : |__ '  : '  '   ;   /|         /    /\    J   ::  | : ;  ; | '  : |__ '   ; :__ '   ;   /|     //
//    |   ,/    |  | '.'||  | |  '   |  / |        /  ../  `..-    ,'  :  `--'   \|  | '.'|'   | '.'|'   |  / |     //
//    '---'     ;  :    ;|  : \  |   :    |        \    \         ; :  ,      .-./;  :    ;|   :    :|   :    |     //
//              |  ,   / |  |,'   \   \  /          \    \      ,'   `--`----'    |  ,   /  \   \  /  \   \  /      //
//               ---`-'  `--'      `----'            "---....--'                   ---`-'    `----'    `----'       //
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LIFEJUICEAI is ERC721Creator {
    constructor() ERC721Creator("Life Juice AI", "LIFEJUICEAI") {}
}