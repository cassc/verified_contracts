// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ricardo Takamura
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
//                                                                                ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄                                                                                //
//                                                                           ▄▄████▀▀███▀▀███▀▀███▀▀████▄▄                                                                           //
//                                                                       ▄▄███▄▄███████████████████████▄▄███▄▄                                                                       //
//                                                               ▄▄▄█▀▀▀▀▀▀▀▀                             ▀▀▀▀▀▀▀▀█▄▄▄                                                               //
//                                                           ▄▄█▀▀         ▄▄▄▄▄▄█████████████████████▄▄▄▄▄▄         ▀▀█▄▄                                                           //
//                                                         ▄█▀      ▄▄▄████████████████▀▀▀▀▀▀▀▀▀████████████████▄▄▄      ▀█▄                                                         //
//                                                         ▀█▄     ██████████████▀▀                 ▀▀██████████████     ▄█▀                                                         //
//                                                           ▀▀█▄▄  ▀▀███████▀▀                         ▀▀███████▀▀  ▄▄█▀▀                                                           //
//                                                               ▀▀▀▀█▄▄▄▄▄▌                               ▐▄▄▄▄▄█▀▀▀▀                                                               //
//                                                                        ▐                                 ▌                                                                        //
//                                                                        ▐                                 ▌                                                                        //
//                                                                        ▌                                 ▐                                                                        //
//                                                                        ▌                                 ▐                                                                        //
//                                                                       ▐                                   ▌                                                                       //
//                                                                       ▐                                   ▌                                                                       //
//                                                                                                                                                                                   //
//     ▐████████████████        ▐█████         █████▌     ██████▌        ▐█████         ████████       ▐███████▌  █████▌         █████▌  █████████████▌            ▐█████            //
//     ▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓        ▓▓▓▓▓▓▌        ▓▓▓▓▓▌    ▓▓▓▓▓▌          ▓▓▓▓▓▓▌        ▓▓▓▓▓▓▓▓▌      ▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▌         ▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌           ▓▓▓▓▓▓▌           //
//           ▓▓▓▓▓▌            ▓▓▓▓▓▓▓▓▌       ▓▓▓▓▓▌   ▓▓▓▓▓▌          ▓▓▓▓▓▓▓▓▌       ▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓▓▓▓▓▓▌  ▓▓▓▓▓▌         ▓▓▓▓▓▌  ▓▓▓▓▓▌    ▓▓▓▓▓▌         ▓▓▓▓▓▓▓▓▌          //
//           ▓▓▓▓▓▌           ▓▓▓▓▌ ▓▓▓▓▌      ▓▓▓▓▓▌  ▓▓▓▓▌           ▓▓▓▓▌ ▓▓▓▓▌      ▓▓▓▓▓▌▓▓▓▓▌  ▓▓▓▓▌▓▓▓▓▓▌  ▓▓▓▓▓▌         ▓▓▓▓▓▌  ▓▓▓▓▓▌    ▓▓▓▓▌         ▓▓▓▓▌ ▓▓▓▓▌         //
//           ▓▓▓▓▓▌          ▓▓▓▓▌   ▓▓▓▓▌     ▓▓▓▓▓▓▓▓▓▓▓▓▌          ▓▓▓▓▌   ▓▓▓▓▌     ▓▓▓▓▓▌ ▓▓▓▓▌▓▓▓▓▌ ▓▓▓▓▓▌  ▓▓▓▓▓▌         ▓▓▓▓▓▌  ▓▓▓▓▓▓▓▓▓▓▓▓▓▌         ▓▓▓▓▌   ▓▓▓▓▌        //
//           ▓▓▓▓▓▌         ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓▓▌  ▓▓▓▓▓▌        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓▓▌  ▓▓▓▓▓▓▓▌  ▓▓▓▓▓▌   ▓▓▓▓▓▌       ▓▓▓▓▓▌   ▓▓▓▓▓▌  ▓▓▓▓▓▓▌       ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌       //
//           ▓▓▓▓▓▌        ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▌    ▓▓▓▓▓▌     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌   ▓▓▓▓▓▌   ▓▓▓▓▓▌   ▓▓▓▓▓▌    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌    ▓▓▓▓▓▌    ▓▓▓▓▓▌     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▌      //
//           ▓▓▓▓▓▌       ▓▓▓▓▓▌       ▓▓▓▓▓▌  ▓▓▓▓▓▌      ▓▓▓▓▓▌  ▓▓▓▓▓▌       ▓▓▓▓▓▌  ▓▓▓▓▓▌    ▓▓▓▌    ▓▓▓▓▓▌      ▓▓▓▓▓▓▓▓▓▓▓▓▌      ▓▓▓▓▓▌      ▓▓▓▓▓▌  ▓▓▓▓▓▌       ▓▓▓▓▓▌     //
//                                                                                                                                                                                   //
//                                                                     ▐                                       ▌                                                                     //
//                                                                     ▐                                       ▌                                                                     //
//                                                                     ▌                                       ▐                                                                     //
//                                                                     ▌                                       ▐                                                                     //
//                                                                    ▐                                         ▌                                                                    //
//                                                                    ▐                                         ▌                                                                    //
//                                                                    ▌                   ██                    ▐                                                                    //
//                                                                    ▌                  ▄▓▓▄                   ▐                                                                    //
//                                                                   ▐                  ▐▓▓▓▓▌                   ▌                                                                   //
//                                                                   ▐                  ▐▓▓▓▓▌                   ▌                                                                   //
//                                                                   ▌                  ▐▓▓▓▓▌                   ▐                                                                   //
//                                                                   ▌                   ▓▌▐▓                    ▐                                                                   //
//                                                                                       ▓▌▐▓                                                                                        //
//                                                                                       ▓▌▐▓                                                                                        //
//                                                                                       ▓▌▐▓                                                                                        //
//                                                                                       ▀  ▀                                                                                        //
//                                                                                                                                                                                   //
//                                                                                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TKM is ERC721Creator {
    constructor() ERC721Creator("Ricardo Takamura", "TKM") {}
}