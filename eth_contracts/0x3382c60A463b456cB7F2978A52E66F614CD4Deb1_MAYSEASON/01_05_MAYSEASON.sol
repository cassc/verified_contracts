// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: MAYNAKASAKISEASON
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//              ____                                                                               ,----..            ,--.     //
//            ,'  , `.   ,---,                    .--.--.       ,---,.   ,---,       .--.--.      /   /   \         ,--.'|     //
//         ,-+-,.' _ |  '  .' \            ,---, /  /    '.   ,'  .' |  '  .' \     /  /    '.   /   .     :    ,--,:  : |     //
//      ,-+-. ;   , || /  ;    '.         /_ ./||  :  /`. / ,---.'   | /  ;    '.  |  :  /`. /  .   /   ;.  \,`--.'`|  ' :     //
//     ,--.'|'   |  ;|:  :       \  ,---, |  ' :;  |  |--`  |   |   .':  :       \ ;  |  |--`  .   ;   /  ` ;|   :  :  | |     //
//    |   |  ,', |  '::  |   /\   \/___/ \.  : ||  :  ;_    :   :  |-,:  |   /\   \|  :  ;_    ;   |  ; \ ; |:   |   \ | :     //
//    |   | /  | |  |||  :  ' ;.   :.  \  \ ,' ' \  \    `. :   |  ;/||  :  ' ;.   :\  \    `. |   :  | ; | '|   : '  '; |     //
//    '   | :  | :  |,|  |  ;/  \   \\  ;  `  ,'  `----.   \|   :   .'|  |  ;/  \   \`----.   \.   |  ' ' ' :'   ' ;.    ;     //
//    ;   . |  ; |--' '  :  | \  \ ,' \  \    '   __ \  \  ||   |  |-,'  :  | \  \ ,'__ \  \  |'   ;  \; /  ||   | | \   |     //
//    |   : |  | ,    |  |  '  '--'    '  \   |  /  /`--'  /'   :  ;/||  |  '  '--' /  /`--'  / \   \  ',  / '   : |  ; .'     //
//    |   : '  |/     |  :  :           \  ;  ; '--'.     / |   |    \|  :  :      '--'.     /   ;   :    /  |   | '`--'       //
//    ;   | |`-'      |  | ,'            :  \  \  `--'---'  |   :   .'|  | ,'        `--'---'     \   \ .'   '   : |           //
//    |   ;/          `--''               \  ' ;            |   | ,'  `--''                        `---`     ;   |.'           //
//    '---'                                `--`             `----'                                           '---'             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
//                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MAYSEASON is ERC721Creator {
    constructor() ERC721Creator("MAYNAKASAKISEASON", "MAYSEASON") {}
}