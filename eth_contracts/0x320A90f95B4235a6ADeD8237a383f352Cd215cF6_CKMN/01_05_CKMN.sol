// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Checkmons
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//                                                                                      //
//       ______  __                    __                                               //
//     .' ___  |[  |       ✓          [  |  _                                           //
//    / .'   \_| | |--.  .---.  .---.  | | / ]  _ .--..--.   .--.   _ .--.   .--.       //
//    | |        | .-. |/ /__\\/ /'`\] | '' <  [ `.-. .-. |/ .'`\ \[ `.-. | ( (`\]      //
//    \ `.___.'\ | | | || \__.,| \__.  | |`\ \  | | | | | || \__. | | | | |  `'.'.      //
//     `.____ .'[___]|__]'.__.''.___.'[__|  \_][___||__||__]'.__.' [___||__][\__) )     //
//                ."-,.__                                                               //
//                     `.     `.  ,                                                     //
//                  .--'  .._,'"-' `.                                                   //
//                 .    .'         `'                                                   //
//                 `.   /          ,'                                                   //
//                   `  '--.   ,-"'                                                     //
//                    `"`   |  \                                                        //
//                       -. \, |                                                        //
//                        `--Y.'      ___.                                              //
//                             \     L._, \                                             //
//                   _.,        `.   <  <\                _                             //
//                 ,' '           `, `.   | \            ( `                            //
//              ../, `.            `  |    .\`.           \ \_                          //
//             ,' ,..  .           _.,'    ||\l            )  '".                       //
//            , ,'   \           ,'.-.`-._,'  |           .  _._`.                      //
//          ,' /      \ \        `' ' `--/   | \          / /   ..\                     //
//        .'  /        \ .         |\__ - _ ,'` `        / /     `.`.                   //
//        |  '          ..         `-...-"  |  `-'      / /        . `.                 //
//        | /           |L__           |    |          / /          `. `.               //
//       , /            .   .          |    |         / /             ` `               //
//      / /          ,. ,`._ `-_       |    |  _   ,-' /               ` \              //
//     / .           \"`_/. `-_ \_,.  ,'    +-' `-'  _,        ..,-.    \`.             //
//    .  '         .-f    ,'   `    '.       \__.---'     _   .'   '     \ \            //
//    ' /          `.'    l     .' /          \..      ,_|/   `.  ,'`     L`            //
//    |'      _.-""` `.    \ _,'  `            \ `.___`.'"`-.  , |   |    | \           //
//    ||    ,'      `. `.   '       _,...._        `  |    `/ '  |   '     .|           //
//    ||  ,'          `. ;.,.---' ,'       `.   `.. `-'  .-' /_ .'    ;_   ||           //
//    || '              V      / /           `   | `   ,'   ,' '.    !  `. ||           //
//    ||/            _,-------7 '              . |  `-'    l         /    `||           //
//    . |          ,' .-   ,' ||               | .-.        `.      .'     ||           //
//     `'        ,'    `".'    |               |    `.        '. -.'       `'           //
//              /      ,'      |               |,'    \-.._,.'/'                        //
//              .     /        .               .       \    .''                         //
//            .`.    |         `.             /         :_,'.'                          //
//              \ `...\   _     ,'-.        .'         /_.-'                            //
//               `-.__ `,  `'   .  _.>----''.  _  __  /                                 //
//                    .'        /"'          |  "'   '_                                 //
//                   /_|.-'\ ,".             '.'`__'-( \                                //
//                     / ,"'"\,'               `/  `-.|"                                //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract CKMN is ERC1155Creator {
    constructor() ERC1155Creator("Checkmons", "CKMN") {}
}