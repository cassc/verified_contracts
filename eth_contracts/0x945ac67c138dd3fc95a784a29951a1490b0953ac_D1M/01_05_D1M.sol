// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: liquidfy
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//         000000000          000000000       1111111        000000000       1111111     1111111        000000000         //
//       00:::::::::00      00:::::::::00    1::::::1      00:::::::::00    1::::::1    1::::::1      00:::::::::00       //
//     00:::::::::::::00  00:::::::::::::00 1:::::::1    00:::::::::::::00 1:::::::1   1:::::::1    00:::::::::::::00     //
//    0:::::::000:::::::00:::::::000:::::::0111:::::1   0:::::::000:::::::0111:::::1   111:::::1   0:::::::000:::::::0    //
//    0::::::0   0::::::00::::::0   0::::::0   1::::1   0::::::0   0::::::0   1::::1      1::::1   0::::::0   0::::::0    //
//    0:::::0     0:::::00:::::0     0:::::0   1::::1   0:::::0     0:::::0   1::::1      1::::1   0:::::0     0:::::0    //
//    0:::::0     0:::::00:::::0     0:::::0   1::::1   0:::::0     0:::::0   1::::1      1::::1   0:::::0     0:::::0    //
//    0:::::0 000 0:::::00:::::0 000 0:::::0   1::::l   0:::::0 000 0:::::0   1::::l      1::::l   0:::::0 000 0:::::0    //
//    0:::::0 000 0:::::00:::::0 000 0:::::0   1::::l   0:::::0 000 0:::::0   1::::l      1::::l   0:::::0 000 0:::::0    //
//    0:::::0     0:::::00:::::0     0:::::0   1::::l   0:::::0     0:::::0   1::::l      1::::l   0:::::0     0:::::0    //
//    0:::::0     0:::::00:::::0     0:::::0   1::::l   0:::::0     0:::::0   1::::l      1::::l   0:::::0     0:::::0    //
//    0::::::0   0::::::00::::::0   0::::::0   1::::l   0::::::0   0::::::0   1::::l      1::::l   0::::::0   0::::::0    //
//    0:::::::000:::::::00:::::::000:::::::0111::::::1110:::::::000:::::::0111::::::111111::::::1110:::::::000:::::::0    //
//     00:::::::::::::00  00:::::::::::::00 1::::::::::1 00:::::::::::::00 1::::::::::11::::::::::1 00:::::::::::::00     //
//       00:::::::::00      00:::::::::00   1::::::::::1   00:::::::::00   1::::::::::11::::::::::1   00:::::::::00       //
//         000000000          000000000     111111111111     000000000     111111111111111111111111     000000000         //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract D1M is ERC721Creator {
    constructor() ERC721Creator("liquidfy", "D1M") {}
}