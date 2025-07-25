// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Jenk Editions - 2023
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                //
//                                                                                                //
//        .---.                                                                                   //
//        |   |                                                                                   //
//        '---'      __.....__        _..._        .                                              //
//        .---.  .-''         '.    .'     '.    .'|                                              //
//        |   | /     .-''"'-.  `. .   .-.   . .'  |                                              //
//        |   |/     /________\   \|  '   '  |<    |                                              //
//        |   ||                  ||  |   |  | |   | ____                                         //
//        |   |\    .-------------'|  |   |  | |   | \ .'                                         //
//        |   | \    '-.____...---.|  |   |  | |   |/  .                                          //
//        |   |  `.             .' |  |   |  | |    /\  \                                         //
//     __.'   '    `''-...... -'   |  |   |  | |   |  \  \                                        //
//    |      '                     |  |   |  | '    \  \  \                                       //
//    |____.'                      '--'   '--''------'  '---'                                     //
//                                                                                                //
//                                                          .-'''-.                               //
//                        _______                          '   _    \                             //
//           __.....__    \  ___ `'.   .--.         .--. /   /` '.   \    _..._                   //
//       .-''         '.   ' |--.\  \  |__|         |__|.   |     \  '  .'     '.                 //
//      /     .-''"'-.  `. | |    \  ' .--.     .|  .--.|   '      |  '.   .-.   .                //
//     /     /________\   \| |     |  '|  |   .' |_ |  |\    \     / / |  '   '  |                //
//     |                  || |     |  ||  | .'     ||  | `.   ` ..' /  |  |   |  |       _        //
//     \    .-------------'| |     ' .'|  |'--.  .-'|  |    '-...-'`   |  |   |  |     .' |       //
//      \    '-.____...---.| |___.' /' |  |   |  |  |  |               |  |   |  |    .   | /     //
//       `.             .'/_______.'/  |__|   |  |  |__|               |  |   |  |  .'.'| |//     //
//         `''-...... -'  \_______|/          |  '.'                   |  |   |  |.'.'.-'  /      //
//                                            |   /                    |  |   |  |.'   \_.'       //
//                                            `'-'                     '--'   '--'                //
//                                                                                                //
//                                                                                                //
//           .-''-.                          .-''-. ..-'''-.                                      //
//         .' .-.  )                       .' .-.  )\.-'''\ \                                     //
//        / .'  / /                       / .'  / /        | |                                    //
//       (_/   / /         .-''` ''-.    (_/   / /      __/ /                                     //
//            / /        .'          '.       / /      |_  '.                                     //
//           / /        /              `     / /          `.  \                                   //
//          . '        '                '   . '             \ '.                                  //
//         / /    _.-')|         .-.    |  / /    _.-')      , |                                  //
//       .' '  _.'.-'' .        |   |   ..' '  _.'.-''       | |                                  //
//      /  /.-'_.'      .       '._.'  //  /.-'_.'          / ,'                                  //
//     /    _.'          '._         .'/    _.'     -....--'  /                                   //
//    ( _.-'                '-....-'` ( _.-'        `.. __..-'                                    //
//                                                                                                //
//                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////


contract J2023 is ERC1155Creator {
    constructor() ERC1155Creator("Jenk Editions - 2023", "J2023") {}
}