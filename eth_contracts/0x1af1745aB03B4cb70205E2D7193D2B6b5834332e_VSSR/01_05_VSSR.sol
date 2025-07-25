// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Visual Stories by Simone Rocco
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                 ,--,             .--.--.       ___                                                          //
//           ,---.  ,--,                                         ,--.'|            /  /    '.   ,--.'|_                      ,--,                              //
//          /__./|,--.'|                        ,--,             |  | :           |  :  /`. /   |  | :,'   ,---.    __  ,-.,--.'|                              //
//     ,---.;  ; ||  |,      .--.--.          ,'_ /|             :  : '           ;  |  |--`    :  : ' :  '   ,'\ ,' ,'/ /||  |,                .--.--.        //
//    /___/ \  | |`--'_     /  /    '    .--. |  | :    ,--.--.  |  ' |           |  :  ;_    .;__,'  /  /   /   |'  | |' |`--'_       ,---.   /  /    '       //
//    \   ;  \ ' |,' ,'|   |  :  /`./  ,'_ /| :  . |   /       \ '  | |            \  \    `. |  |   |  .   ; ,. :|  |   ,',' ,'|     /     \ |  :  /`./       //
//     \   \  \: |'  | |   |  :  ;_    |  ' | |  . .  .--.  .-. ||  | :             `----.   \:__,'| :  '   | |: :'  :  /  '  | |    /    /  ||  :  ;_         //
//      ;   \  ' .|  | :    \  \    `. |  | ' |  | |   \__\/: . .'  : |__           __ \  \  |  '  : |__'   | .; :|  | '   |  | :   .    ' / | \  \    `.      //
//       \   \   ''  : |__   `----.   \:  | : ;  ; |   ," .--.; ||  | '.'|         /  /`--'  /  |  | '.'|   :    |;  : |   '  : |__ '   ;   /|  `----.   \     //
//        \   `  ;|  | '.'| /  /`--'  /'  :  `--'   \ /  /  ,.  |;  :    ;        '--'.     /   ;  :    ;\   \  / |  , ;   |  | '.'|'   |  / | /  /`--'  /     //
//         :   \ |;  :    ;'--'.     / :  ,      .-./;  :   .'   \  ,   /           `--'---'    |  ,   /  `----'   ---'    ;  :    ;|   :    |'--'.     /      //
//          '---" |  ,   /   `--'---'   `--`----'    |  ,     .-./---`-'                         ---`-'                    |  ,   /  \   \  /   `--'---'       //
//                 ---`-'                             `--`---'                                                              ---`-'    `----'                   //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
//                                                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract VSSR is ERC721Creator {
    constructor() ERC721Creator("Visual Stories by Simone Rocco", "VSSR") {}
}