// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Art Blocks Universe
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                            ,▄████████▄,                                                         //
//                           ████████████████▄▄                                                    //
//                          ████▀     '╙▀▀█████████▄▄,,                                            //
//                         ████▌     ,▄▄█████████████████████▄▄                                    //
//                        ████▌  ▄█████████▀▀▀▀╙╙╙╙╙╙╙▀▀▀▀████████▄▄                               //
//                       ▓████████████▌'                     ██▀██████▄                            //
//                      ▐████████▀'   █─                    ]█    ╙▀█████▄                         //
//                     ▐██████▀                               ▄      └▀████▌                       //
//                    ╔████▀─                 ,,▄▄▄▄╓,       █▌         ╙████▌                     //
//                   █████`             ,▄█████████████████▄██            ╙█████▄ç                 //
//                 ╓████─           ,▄██████└'    █    '└╠█████▄            ▀████████▄             //
//                ▄███▀           ▄███▀╙   █▌           ▄███▀╙████▄          └█████████            //
//               ▄███▌          ╓████▄     ███▄       ╓████▌   ╫████,          ████████▌           //
//              ▐█████▄,       ▓██▀  ╙      ████     ▓█████    └  ▀██▌       █▀▀███████▌           //
//              ████   '      ███`          ██████▄▄██████         ╙███         └██████            //
//             ▓███          ███           ╓█▀`   ███████,   ,▄▄▄██▀▀███         ╟████             //
//             ███▌         ▐██─     ▀█████└    ▄███████▀▀██████▀╙   ╟██µ         ███▌             //
//            ▐███▌         ███         ╙█    ,██▀▀████▌  ╙██▀╙       ███         ████             //
//            ▐███─         ███,,       ▐▌   ,██    ╙██    █        ╓▄███         ████             //
//            ▐███─         ██▌└       ▄█▌   ███,   ▄█     █          ███         ████             //
//            j███▌         ███     ▄█████  ████████▀     ▓███▄       ██▌         ████             //
//             ████         ╙██▌ ▄█████▀▀▀█████████─    ,█▀  '└╙     ╟██─        ┌███▌             //
//            █████µ         ╟██▌¬        ▐██████▀  ,▄▄██           ╔██▌         ████              //
//           ███████          ▀██▄       ┌██████╙╙╙╙▀████µ         ▄██▀      ▄▄,▄███▌              //
//          j█████████▀▀       ╙███  ▄µ  █████▀       ████     ╗,╓███▀         ▐████               //
//           █████████           ▀███▌  ████▀          ╙██     ▄███▀          ,████                //
//           ╙█████████            ▀███████╙             █▌ ▄▓███▀           ▄████                 //
//             ╙▀███████▄            ╙██████▄▄,   █▌ ,╓▄▄█████▀`            ████▀                  //
//                 ╙▀▀████▄           ██─└▀▀█████████████▀▀└              ▄████`                   //
//                     ▀████▄        █▀                                ,▓████▀                     //
//                       ▀█████▄                                     ▄█████▀                       //
//                         ╙██████▄    █¬                     █, ,▄█████▀`                         //
//                            ╙▀███████▌,                   ,▄█████████                            //
//                               └╙▀████████████▄▄▄▄▄█████████████████¬                            //
//                                    └╙▀▀███████████████████████████─                             //
//                                               '       '╙▀▀█████▀¬                               //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract ABU is ERC721Creator {
    constructor() ERC721Creator("Art Blocks Universe", "ABU") {}
}