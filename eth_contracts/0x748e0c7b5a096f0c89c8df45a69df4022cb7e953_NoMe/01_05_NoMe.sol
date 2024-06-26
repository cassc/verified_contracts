// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NoManaEdition
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//             <-. (`-')_            <-. (`-')   (`-')  _ <-. (`-')_ (`-')  _               //
//                \( OO) )     .->      \(OO )_  (OO ).-/    \( OO) )(OO ).-/               //
//             ,--./ ,--/ (`-')----. ,--./  ,-.) / ,---.  ,--./ ,--/ / ,---.                //
//             |   \ |  | ( OO).-.  '|   `.'   | | \ /`.\ |   \ |  | | \ /`.\               //
//       (`-') |  . '|  |)( _) | |  ||  |'.'|  | '-'|_.' ||  . '|  |)'-'|_.' |   (`-')      //
//    <-.(OO ) |  |\    |  \|  |)|  ||  |   |  |(|  .-.  ||  |\    |(|  .-.  |<-.(OO )      //
//    ,------.)|  | \   |   '  '-'  '|  |   |  | |  | |  ||  | \   | |  | |  |,------.)     //
//    `------' `--'  `--'    `-----' `--'   `--' `--' `--'`--'  `--' `--' `--'`------'      //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract NoMe is ERC1155Creator {
    constructor() ERC1155Creator("NoManaEdition", "NoMe") {}
}