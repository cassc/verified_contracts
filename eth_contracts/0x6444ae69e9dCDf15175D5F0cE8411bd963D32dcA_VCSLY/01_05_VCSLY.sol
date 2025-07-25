// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Vicariously. By Daws
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                             //
//                                                                                                                                                                                             //
//                                                                                                                                                                                             //
//                                _..._                        .-'''-.                                                                                                                         //
//                             .-'_..._''.                    '   _    \                  .---.                                                        _______                                 //
//     .----.     .----.--.  .' .'      '.\                 /   /` '.   \                 |   |                         /|                             \  ___ `'.                              //
//      \    \   /    /|__| / .'                           .   |     \  '                 |   |.-.          .-          ||    .-.          .-           ' |--.\  \              _     _        //
//       '   '. /'   / .--.. '                      .-,.--.|   '      |  '                |   | \ \        / /          ||     \ \        / /           | |    \  '       /\    \\   //        //
//       |    |'    /  |  || |                 __   |  .-. \    \     / /                 |   |  \ \      / /           ||  __  \ \      / /            | |     |  '    __`\\  //\\ //         //
//       |    ||    |  |  || |              .:--.'. | |  | |`.   ` ..' /_    _         _  |   |   \ \    / /            ||/'__ '.\ \    / /             | |     |  | .:--.'.\`//  \'/ _        //
//       '.   `'   .'  |  |. '             / |   \ || |  | |   '-...-'`| '  / |      .' | |   |    \ \  / /             |:/`  '. '\ \  / /              | |     ' .'/ |   \ |\|   |/.' |       //
//        \        /   |  | \ '.          .`" __ | || |  '-           .' | .' |     .   | /   |     \ `  /              ||     | | \ `  /               | |___.' /' `" __ | | '    .   | /     //
//         \      /    |__|  '. `._____.-'/ .'.''| || |               /  | /  |   .'.'| |//   |      \  /               ||\    / '  \  /               /_______.'/   .'.''| |    .'.'| |//     //
//          '----'             `-.______ / / /   | || |              |   `'.  | .'.'.-'  /'---'      / /                |/\'..' /   / /                \_______|/   / /   | |_ .'.'.-'  /      //
//                                      `  \ \._,\ '/_|              '   .'|  '/.'   \_.'        |`-' /                 '  `'-'`|`-' /                              \ \._,\ '/ .'   \_.'       //
//                                          `--'  `"                  `-'  `--'                   '..'                           '..'                                `--'  `"                  //
//                                                                                                                                                                                             //
//                                                                                                                                                                                             //
//                                                                                                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract VCSLY is ERC1155Creator {
    constructor() ERC1155Creator("Vicariously. By Daws", "VCSLY") {}
}