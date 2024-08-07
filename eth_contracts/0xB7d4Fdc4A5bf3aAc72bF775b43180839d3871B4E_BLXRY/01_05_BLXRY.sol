// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GbyHectorG
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((    //
//    (((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((&@%((((((((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@%%%%%%%%%&@((((((((((((((((((((((((((((((    //
//    (((((((((((((((((((((((((((((((((((((@@@@@@@@@@((((((((@%@,...,@%%%%%%@(((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((@@%%%%%%%%%%%%%%%&@%(@@.........@%%%%%%@((((((((((((((((((((((((((((    //
//    (((((((((((((((((((((((((((((@@%%%%%%%%%%%%%%%%%%%%%@@...........@%%%%%@((((((((((((((((((((((((((((    //
//    (((((((((((((@@%%%%%%&@@(((@%%%%%%%%%%%%%%&@@@@&%%@&#..@,........&%%%%%@((((((((((((((((((((((((((((    //
//    ((((((((((&&%%%%%%%%%%%%%@@%%%%%%%@@@...................,@......@%%%%%@(((((((((((((((((((((((((((((    //
//    (((((((((@%%%%%@@...#@&@&%%%@@@...........................@...,@%%%%@(((((((((((((((((((((((((((((((    //
//    ((((((((@%%%%&/.......@.*@%%%..............................@,@%%%%@(((((((((((((((((((((((((((((((((    //
//    (((((((@%%%%%&......&@....*%%..............................,@%%%@(((((((((((((((((((((((((((((((((((    //
//    (((((((@%%%%@......@#......@@.............................../@((((((((((((((((((((((((((((((((((((((    //
//    (((((((@%%%%&*....@%......................................,@@@@@@@@@@#((((((((((((((((((((((((((((((    //
//    (((((((%%%%%%@...%@.........@@.......................@@,.....@%%%%%%%%%%&@@(((((((((((((((((((((((((    //
//    ((((((((%&%%%%@..@..........,@@..................@@..........@%%%%%%%%%%%%%%@@((((((((((((((((((((((    //
//    ((((((((((@%%%%%@...........@@%@............../@#..&........@&%%%%%%%%%%%%%%%%%@((((((((((((((((((((    //
//    (((((((((((((@%%@%@@.....&@@%%@%&@,.........*@,..@..*,.....*@%%%%%%%%%%%%%%%%%%%&@((((((((((((((((((    //
//    (((((((((((((((@%@@@@@@@%%%%%%@%%%@@.......@,....,...,,...(@%%%%%%%%%%%%%%%%%%%%%%@(((((((((((((((((    //
//    (((((((((((((((@%%%%%%%%%%%%%%@&%%%%%@,...@.&@@@@@@&(.@,.@%%%%%%%%%%%%%%%%%%%%%%%%%@((((((((((((((((    //
//    ((((((((((((((%@%%%%%%%%%%%%%%%@%%%%%%%%@@,............@&%%%%%%%%%%%%%%%%%%%%%%%%%%%@(((((((((((((((    //
//    ((((((((((((((@@%%%%%%%%%%%%%%%@%%%%%%%%%@%%%@@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@((((((((((((((    //
//    ((((((((((((((@%%%%%%%%%%%%%%%%@%%%%%%%%@&%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%@((((((((((((((    //
//    ((((((((((((((@&%%%%%%%%%%%%%%&@%%%%%%%%@&%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%@%(((((((((((((    //
//    ((((((((((((((&@%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%%%%%@&(((((((((((((    //
//    (((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%%%%%@((((((((((((((    //
//    (((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%%&@%%%%%%%%%%%%%%%%%%%@%@&%%%%%%%%%%%%%%%%%#@((((((((((((((    //
//    (((((((((((((((&@%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%%%%%%%@%%%&@%%%%%%%%%%%%%%%%%@(((((((((((((((    //
//    ((((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%%%%%%%%%@@%%%%%%@%%%%%%%%%%%%%%%%@#(((((((((((((((    //
//    (((((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%%%@(((((((((((((((((    //
//    ((((((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%%%%%%%%%%%%%@@((((((((((((((((((    //
//    (((((((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&%%%%%%%%%%%@((((((((((((((((((((    //
//    ((((((((((((((((((((@&%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&%%%%%%%%@@((((((((((((((((((((((    //
//    ((((((((((((((((((((((@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@((((((((((((((((((((((((    //
//    (((((((((((((((((((((((#@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@(((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@&((((((((((((((((((((((((((((((    //
//    (((((((((((((((((((((((((((((&@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@%((((((((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((((@@@@%%%%%%%%%%%%%%%%%%@@@@((((((((((((((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((((((((((((((%%&&&%((((((((((((((((((((((((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((    //
//    ((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BLXRY is ERC721Creator {
    constructor() ERC721Creator("GbyHectorG", "BLXRY") {}
}