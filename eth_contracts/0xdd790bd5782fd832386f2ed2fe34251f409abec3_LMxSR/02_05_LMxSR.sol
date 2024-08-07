// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Lil Mahnaji x SuperRare
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//           ░███▓     ░▀▀▀ ░███▒     ▒████░   ▓████             ▓███                               ▀▀▀░ ░▀▀▀            //
//           ░███▒     ▒███  ███▒     ▒█████▒░██████  ░▓███▄▓██▓ ▓███▒████░ ░███▒▓███▒   ▄███▓▒███░ ███▓ ▓███            //
//           ░███▒     ▒███  ███▒     ▒█████████████ ▒█████████▓ ▓█████████ ░█████████▒ ▓█████████░ ███▓ ▓███            //
//           ░███▒     ▒███  ███▒     ▒███ ▀██▓ ████ ████   ███▓ ▓███░ ▓███  ███▒ ░███▒ ███▓  ▒███░ ███▓ ▓███            //
//           ░███▓     ▒███  ███▒     ▒███  ░▀  ████ ▓███░ ▒███▓ ▓███  ▒███  ███▒  ███▒ ████░░▓███░ ███▓ ▓███            //
//           ░████████ ▒███  ███▒     ▒███      ████ ░█████████▓ ▓███  ▒███  ███▒  ███▒ ▒█████████░ ███▓ ▓███            //
//            ▀▀▀▀▀▀▀▀ ░▀▀▀  ▀▀▀░     ░▀▀▀      ▀▀▀▒   ▀▓▓▀ ▀▀▀▒ ░▀▀▀  ░▀▀▀  ▀▀▀░  ▀▀▀░   ▀▓▓▀ ▀▀▀░░███▓ ░▀▀▀            //
//                                                                                                ▒████░                 //
//                                                                                                 ░░░                   //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                      ░░░░   ▄░▄░                                                      //
//                                                       ████░███▓                                                       //
//                                                        ▓█████▒                                                        //
//                                                         █████                                                         //
//                                                        ███████                                                        //
//                                                      ░███▓ ████░                                                      //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//            ▓█████████                                           ▒██████████░                                          //
//           ▒███▓▀▀▀▀▀▀ ░███▒  ███▒ ███▓▄███▓░   ░▓████▓   ███░▓█░▒███▓▀▀▀████  ▄███▓▒███▒ ▓██▒░█▓  ▄█████▄             //
//           ▒███▓▓▓▓▓▄  ░███▒ ░███▒ ██████████░ ▓███▓▓███  ██████░▒███░░░░████ ▓█████████▒ ██████▓ ████▓███▓            //
//            ▀█████████  ███▒ ░███▒ ████  ░███▓ ███▓▄▄███▒ ████▀▀ ▒██████████░ ███▓  ░███▒ ████▓▀░▒███▄▄▓███░           //
//                  ▒███▒ ███▓ ▒███▒ ████░ ▄███▒ ███▒ ░▒▒▒░ ███▒   ▒███░ ░███▓  ████░ ▒███▒ ████   ▒███░ ░▒▒▒            //
//           ░██████████  █████████▒ ██████████  ▒████████  ███▒   ▒███   ▓███░ ▒█████████▒ ████    ▓███████▓            //
//           ░▀▀▀▀▀▀▀▀░    ▀▓▓▀ ▀▀▀░ ███▓░▓▓▓░     ▀▓▓▓▀░   ▀▀▀░   ░▀▀▀    ▀▀▀▀   ▀▓▓▀ ▀▀▀░ ▀▀▀▀     ░▀▓▓▓▀░             //
//                                   ███▓                                                                                //
//                                   ░░░░                                                                                //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
//                                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LMxSR is ERC721Creator {
    constructor() ERC721Creator("Lil Mahnaji x SuperRare", "LMxSR") {}
}