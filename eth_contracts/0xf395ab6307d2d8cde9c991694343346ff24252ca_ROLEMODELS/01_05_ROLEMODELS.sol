// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Boss Beauties Role Models
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//               ╓▄▓▓███████████▓▓▄▄▄▄▄,                    ,▄▄▄▄▄▓▓████████████▓▄▄           //
//            ▄▓██▀▀▀▀╙▀▀▀▀██████████████▒                1▓█████████████▀▀▀▀▀╙▀▀▀███▄        //
//           █▀└              └╙▀▀███████▌                "███████▀▀╙└`             └╙█▄      //
//          └       Ω               └╙▀█▌⌐                 ╣█▀▀└               j       └      //
//              ,\╘ ╟µ.;¡░░░░;-                                     .;;░░░░░;..▓ ╛╒.          //
//         , ½\Å▄▓▓╬▓▓██▓█▀▀███▄▄░.                              .░▄▄▓███▀███▓█▄▓▓█▒#é╒,.     //
//        ⁿ %▓▓▓███▀▀└  ]░░▐▓▓░░╙▀▀▄,                          ;▄▓▀╙░░▓▓▌░░▒  '╙▀█████▓#░-    //
//            └╟╝▓██▄    ╚░░╙╙░░╩   ╙¼                    '   ▄▀.  ╚░░╙╙░░▒    ,▓███╬└'       //
//               ║╙╙╙▀▀╗▄µ╓░░▒▒`      └                      "       Σ▒░░░,▄▄#▀▀╙╩╚¬          //
//                                                                                   "        //
//                                                                                            //
//                                                                     '                      //
//         '                         'Γ                                                       //
//                 .              .                             '            -                //
//          .             "            .                                ∩                     //
//                                           ░                    '                           //
//                                                                                            //
//                                                  '                                         //
//                                                                                            //
//                                      .                  ;                                  //
//        .                              "░⌐ ≥⌐       ≥⌐ ░░                              ,    //
//        █                                                                              ▓    //
//        █⌐                                                                            ]█    //
//        █▌                                                                            ╫█    //
//        ██µ                             ,▄▄▄▄▄    ,▄▄▓▄▄                             ]██    //
//        ███                         ,▄▓███████████████████▓▄,                        ███    //
//        ████                    ,▄▓████████▀▀███████▀▀▓███████▓▄                    ▓███    //
//        ████▌                  ╙█████▓██▄▄█╓    ╠     ▐█▓▓███████└                 ▓████    //
//        ██████                   ▀██████████████▓██████████████▀                  ▓█████    //
//        ███████                   ╙▓█████████▓▓▓█▓█▓▓████████▀`                  ███████    //
//        ████████µ                   ╙▀███████▓▓▓█▓█████████▀.                  ╓████████    //
//        █████████▌                     └╙▀█████████████▀╙─                    ▄█████████    //
//        ███████████▄                         `└└└└└`                        ╓███████████    //
//        █████████████,                                                    ,█████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract ROLEMODELS is ERC721Creator {
    constructor() ERC721Creator("Boss Beauties Role Models", "ROLEMODELS") {}
}