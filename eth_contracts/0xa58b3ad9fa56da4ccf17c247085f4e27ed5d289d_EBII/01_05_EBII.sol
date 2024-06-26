// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ETERNAL BLOOM 2.0
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                //
//                                                                                                                                                //
//                                                                                                                                                //
//    '||''''| |''||''| '||''''| '||'''|, '||\   ||`      /.\      '||                                                                            //
//     ||   .     ||     ||   .   ||   ||  ||\\  ||      // \\      ||                                                                            //
//     ||'''|     ||     ||'''|   ||...|'  || \\ ||     //...\\     ||                                                                            //
//     ||         ||     ||       || \\    ||  \\||    //     \\    ||                                                                            //
//    .||....|   .||.   .||....| .||  \\. .||   \||. .//       \\. .||...|                                                                        //
//                                                                                                                                                //
//                                  _.-'''.                                                                                                       //
//                        _       .'       \                                                                                                      //
//          ,..______  .-/\`--.../          \                                                                                                     //
//          |        '\| \_`_-.  `.  _       \                                                                                                    //
//         /        _ .' / /_`\`\  \/ '.      \                                                                                                   //
//        /       /` /  /\_|_\/\ '._|   \      :                                                                                                  //
//      .'       /  :   \ _  |  `\ .'__ |      | __,'\                                                                                            //
//      \        | __'. |/.`'----./ /| `'    .'''     '-.                                                                                         //
//       :      .`"\ `'\/ |`''--.'/`  \     /          /                                                                                          //
//       |     /|   |   \ |    / |     \   /          /                                                                                           //
//       '    | '.__'____\'_ .'_.'      | /          |                                                                                            //
//      /     \     ___.-'`\`'-.._      |/          .'                                                                                            //
//     '-.     `--'` '.     `.    `'-._/__..._       |                                                                                            //
//        `-.    __    `.     \_..,____..'    \      /                                                                                            //
//         / `'-'  `---- \      .--'''`       |    ,'.__                                                                                          //
//        /               `-...:____          |  .'/ _. ''--.                                                                                     //
//      ,'              ,'`        `\--'`.   |''`,-'-.   ,'`                                                                                      //
//    .'              .'            _\    \  |,' \    _,'                                                                                         //
//    '-._            '--..._   _,-'  '.   '-'..__.-'                                                                                             //
//        `.                /`-' /    |'-._  `'.___                                                                                               //
//          \         _    /|   |     /.' .`-.__..'`\                                                                                             //
//         ,-'.---'''`/`'./ `.  |-.  |/  /    _\'-._`|                                                                                            //
//        /    -''- ,'-.   | |   \  \      /  \   ' |                                                                                             //
//       .' .-'''-,'\   \    `|/   ',.--.   '  .'\.__`|                                                                                           //
//       | '    ,'   |   '    '   ,'     `\    '  \   \                                                                                           //
//       .     / \   '   |       /         /--.    '. '.                                                                                          //
//       /   .'  |     _,'      .'  '`'--,'.   \.   \  |                                                                                          //
//       | .'    ' _.,'         |  ___ ,'  \    |`-._  |                                                                                          //
//      /.'__.,-'''            .| '   / \   |   '    `-.                                                                                          //
//     '--'                    |    ,'  |   '   /      '|                                                                                         //
//                             |  ,'    '  _,.-'                                                                                                  //
//                            .' /   _,.--'                                                                                                       //
//                                                                                                                                                //
//                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract EBII is ERC721Creator {
    constructor() ERC721Creator("ETERNAL BLOOM 2.0", "EBII") {}
}