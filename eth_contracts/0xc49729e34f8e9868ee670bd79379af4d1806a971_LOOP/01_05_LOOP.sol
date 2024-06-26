// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: loopgangNFT
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@#*.            *#&@@@@@@@@@@@@@@&#/            .,/%@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@&(,    ..             ./%@@@@@@@@@#,                    *#@@@@@@@@@@@    //
//    @@@@@@@@@&(.     ./%@@@@@@@%(,     ./&@@@@&(      .*#&@@@@@@&#*.     ,#@@@@@@@@@    //
//    @@@@@@@@%*     *%@@@@@@@@@@@@@&(,..,#@@@@/.     ,#@@@@@@@@@@@@@&/.    ,(&@@@@@@@    //
//    @@@@@@@%/    .*%@@@@@@@@@@@@@@@@@@@@@@@%,     *%@@@@@@@@@@@@@@@@@#,    ,#@@@@@@@    //
//    @@@@@@@(,    ,%@@@@@@@@@@@@@@@@@@@@@@&(.    ,&@@@@@@@@@@@@@@@@@@@&/.    /@@@@@@@    //
//    @@@@@@@(.    ,%@@@@@@@@@@@@@@@@@@@@@%*    .(&@@@@@@@@@@@@@@@@@@@@@/..   /@@@@@@@    //
//    @@@@@@@#,    *%@@@@@@@@@@@@@@@@@@@@(.    *#@@@@@@@@@@@@@@@@@@@@@@@/    ./@@@@@@@    //
//    @@@@@@@%*    ./@@@@@@@@@@@@@@@@@@#.     /&@@@@@@@@@@@@@@@@@@@@@@@#,    ,#@@@@@@@    //
//    @@@@@@@@%*     ,#&@@@@@@@@@@@@&(,     ,#&@@@#,.,(%@@@@@@@@@@@@@%(.    .(&@@@@@@@    //
//    @@@@@@@@@&*.     ,/&@@@@@@@&#*      ,(&@@@&(.     ./#@@@@@@@@#*.      %@@@@@@@@@    //
//    @@@@@@@@@@@%*                     *#@@@@@@@@&/.                    *#@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@&(,             ./%@@@@@@@@@@@@@@%(*             ./%@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract LOOP is ERC721Creator {
    constructor() ERC721Creator("loopgangNFT", "LOOP") {}
}