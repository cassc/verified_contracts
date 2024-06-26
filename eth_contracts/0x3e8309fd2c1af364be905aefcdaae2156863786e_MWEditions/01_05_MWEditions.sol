// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Merr Watson Editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
//              ____                                                                                                                         //
//            ,'  , `.                                       ,---,.                      ___                                                 //
//         ,-+-,.' _ |                                     ,'  .' |      ,---,  ,--,   ,--.'|_    ,--,                                       //
//      ,-+-. ;   , ||           __  ,-.  __  ,-.        ,---.'   |    ,---.'|,--.'|   |  | :,' ,--.'|    ,---.        ,---,                 //
//     ,--.'|'   |  ;|         ,' ,'/ /|,' ,'/ /|        |   |   .'    |   | :|  |,    :  : ' : |  |,    '   ,'\   ,-+-. /  | .--.--.        //
//    |   |  ,', |  ':  ,---.  '  | |' |'  | |' |        :   :  |-,    |   | |`--'_  .;__,'  /  `--'_   /   /   | ,--.'|'   |/  /    '       //
//    |   | /  | |  || /     \ |  |   ,'|  |   ,'        :   |  ;/|  ,--.__| |,' ,'| |  |   |   ,' ,'| .   ; ,. :|   |  ,"' |  :  /`./       //
//    '   | :  | :  |,/    /  |'  :  /  '  :  /          |   :   .' /   ,'   |'  | | :__,'| :   '  | | '   | |: :|   | /  | |  :  ;_         //
//    ;   . |  ; |--'.    ' / ||  | '   |  | '           |   |  |-,.   '  /  ||  | :   '  : |__ |  | : '   | .; :|   | |  | |\  \    `.      //
//    |   : |  | ,   '   ;   /|;  : |   ;  : |           '   :  ;/|'   ; |:  |'  : |__ |  | '.'|'  : |_|   :    ||   | |  |/  `----.   \     //
//    |   : '  |/    '   |  / ||  , ;   |  , ;           |   |    \|   | '/  '|  | '.'|;  :    ;|  | '.'\   \  / |   | |--'  /  /`--'  /     //
//    ;   | |`-'     |   :    | ---'     ---'            |   :   .'|   :    :|;  :    ;|  ,   / ;  :    ;`----'  |   |/     '--'.     /      //
//    |   ;/          \   \  /                           |   | ,'   \   \  /  |  ,   /  ---`-'  |  ,   /         '---'        `--'---'       //
//    '---'            `----'                            `----'      `----'    ---`-'            ---`-'                                      //
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
//                                                                                                                                           //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MWEditions is ERC1155Creator {
    constructor() ERC1155Creator("Merr Watson Editions", "MWEditions") {}
}