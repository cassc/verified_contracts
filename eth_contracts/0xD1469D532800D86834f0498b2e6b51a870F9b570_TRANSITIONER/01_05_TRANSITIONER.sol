// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TRANSITIONER
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                        `                                               //
//                                                                                        //
//             ██                                                                `        //
//                                                                                        //
//             █▌██                                                                       //
//                                                                                        //
//             ▀█ ▀█                                                       ▄█             //
//                                                                                        //
//              ██  ██                                                   ,█▀▌             //
//                                                                                        //
//               ██  ▀██                                                █▀ ▐█             //
//                                                                                        //
//                ▀█    ██████████▄▄▄▌██████████▄▄                    ▄██  █▌             //
//                                                                                        //
//                 █    █▀       ╘█▀▀▀╧▐  ╛▐╚ `-╝███▀████▄         ▄███    █▀             //
//                                                                                        //
//                 ██ ▐██                                ███████████      ██              //
//                                                                                        //
//                  ████▀                                       ██▄      ██               //
//                                                                                        //
//                    ▐█                                          ████▄ ▐█L               //
//                                                                                        //
//                     █     ▄▄                  █████              █████▀                //
//                                                                                        //
//                     █  ▄██▀▀▀████           ██▀   ▀██              ¬██                 //
//                                                                                        //
//                     █  █- █▄ ██▄██         ▓█   ▄█  '▀█             "██                //
//                                                                                        //
//                    ▐█ j█ ▐███████▐█        ██ ████ █▌ █              ██                //
//                                                                                        //
//          `         █▌  █ ▐███████ █        █ ▀███████ █              █                 //
//                                                                                        //
//                    ██  ██ ███████j█        ▀█ ██████▀ █             ██                 //
//                                                                                        //
//                    █    █ ▀████████         █▄█▀████ ▐█            ██                  //
//                                                                                        //
//                   ██    ▐█  █▐  ▄█          █ ▐████  ▐█           ▐█                   //
//                                                                                        //
//                   ██     ▐█   ,██          ██        ██           ██                   //
//                                                                                        //
//                   █▌    ▄███████▄          ▐█       ▄█            ██                   //
//                                                                                        //
//                   █   ████████████████▌     ▀█     ██             █                    //
//                                                                                        //
//                   ███████████▌ ▀█████████▄    █████▐            ▄██                    //
//                                                                                        //
//                  ██████▀▀▄███▀████ ,▄██████                     █▌                     //
//                                                                                        //
//               ,███████µ █▀██▀▀▀████████████                    ▄█                      //
//                                                                                        //
//              █████▀██▄█▀██████████▀ ██████                     █                       //
//                                                                                        //
//            ▄█▐█████████████████▀██████¬                       █▀                       //
//                                                                                        //
//            ██████████████████▌███▀█                          ██                        //
//                                                                                        //
//           ██,███████████████████                            ██                         //
//                                                                                        //
//            █████████████████▐                              ██                          //
//                                                                                        //
//             ██████████████████▄                           ██                           //
//                                                                                        //
//                    ▄███∞   ╚  ███▌                      ¬█▀█████                       //
//                                                                                        //
//                  ████            █▀██             ▄████▀█      ▀█▀██▌                  //
//                                                                                        //
//              ██████▄                ▀██████████████▀                ▀███               //
//                                                                                        //
//               ╓██▀███▀███████▌▄,                                      ██               //
//                                                                                        //
//             ▄█████████▌█  ▓█ ▐█████████████▄            `         ,▄▄▄███              //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract TRANSITIONER is ERC721Creator {
    constructor() ERC721Creator("TRANSITIONER", "TRANSITIONER") {}
}