// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: JQART
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

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
//    @@@@@@@@@@@@@%//////////////////////(#@@@@&%#(///////////////////////(#%&@@@@@@@    //
//    @@@@@@@@@@@@%/,,,,,,,,,,,,,,,,,,,,,,/#@@@(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,/#&@@@@@    //
//    @@@@@@@@@@@&/*,,,,,,,,,,,,,,,,,,,,,,(&@&(*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,#@@@@@    //
//    @@@@@@@@@@@&###########(*,,,,,,,,,,*%@@%*,,,,,,,,,,*(#########*,,,,,,,,,,,#@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@&*,,,,,,,,,*/&@&(,,,,,,,,,,(%@@@@@@@@@@(,,,,,,,,,,/%@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@&#*,,,,,,,,,/%&&#/,,,,,,,,,*#&@@@@@@@@&#/,,,,,,,,,*#&@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@#/,,,,,,,,,,(@@&/*,,,,,,,,,/&@@@@@@@@@%/,,,,,,,,,,/&@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@(,,,,,,,,,,*%@@%*,,,,,,,,,*(&@@@@@@@@@#,,,,,,,,,,/#@@@@@@@    //
//    @@@@&((//////(((((((/*,,,,,,,,,,*#&@&#*,,,,,,,,,,,********/#&@@@@@@@@@@@@@@@@@@@    //
//    @@@&#,,,,,,,,,,,,,,,,,,,,,,,,,,*(@@@&#*,,,,,,,,,,,,,,,,,,,/%&@%#//(%&@@@@@@@@@@@    //
//    @@@#/,,,,,,,,,,,,,,,,,,,,,,,,*(&@@@@@@%/,,,,,,,,,,,,,,,,,,(@&%/,,,,*/%@@@@@@@@@@    //
//    @@@&%#(((((((((/////////((#%&@@@@@@@@@@@@%((/////////////(%@@@#**,*/#&@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&@@@@@@@@@@@@@    //
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
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract JQ is ERC1155Creator {
    constructor() ERC1155Creator("JQART", "JQ") {}
}