// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Burn Frenz
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ____________________________________________________________________________________▒▒________________________________________________________________    //
//    __________________________________________________________________________________▒▒██________________________________________________________________    //
//    __________________________________________________________________________________▓▓██________________________________________________________________    //
//    __________________________________________________________________________________████________________________________________________________________    //
//    __________________________________________________________________________________▓▓██________________________________________________________________    //
//    __________________________________________________________________________________▒▒██________________________________________________________________    //
//    ____________________________________________________________________________________▒▒________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ____________________________________________________________________________▒▒██______________________________________________________________________    //
//    ____________________________________________________________________________████____________██________________________________________________________    //
//    __________________________________________________________________________▓▓██▓▓__________▒▒██________________________________________________________    //
//    __________________________________________________________________________██████__________████________________________________________________________    //
//    ________________________________________________________________________▓▓██████________▒▒████▓▓______________________________________________________    //
//    ________________________________________________________________________████████________████████______________________________________________________    //
//    ________________________________________________________________________████████________████████______________________________________________________    //
//    ______________________________________________________________________▒▒████████________████████______________________________________________________    //
//    ______________________________________________________________________██████████▓▓______██████▒▒______________________________________________________    //
//    ______________________________________________________________________████████████______▓▓████________________________________________________________    //
//    __________________________________________________________▒▒▓▓________████████████▒▒______██__________________________________________________________    //
//    __________________________________________________________▒▒████______██████████████______▒▒______▓▓██________________________________________________    //
//    ____________________________________________________________██████____██████████████▓▓__________████▓▓________________________________________________    //
//    ____________________________________________________________██████▒▒▒▒████████████████________██████__________________________________________________    //
//    ____________________________________________________________████████▒▒██████████████████____▒▒████▓▓__________________________________________________    //
//    ____________________________________________________________████████████████████████████____██████____________________________________________________    //
//    ____________________________________________________________██████████████████████████████████████____________________________________________________    //
//    ____________________________________________________________██████████████████████████████████████__________▓▓________________________________________    //
//    __________________________________________________________▒▒██████████████████████████████████████________▒▒██________________________________________    //
//    __________________________________________________________▓▓████████████████▒▒████████████████████________████________________________________________    //
//    __________________________________________________________██████▓▓▒▒████████▒▒▒▒████▓▓████████████________████▓▓______________________________________    //
//    __________________________________________________██______██████▒▒▒▒████████▒▒▒▒████▒▒████████████▓▓______██████______________________________________    //
//    ________________________________________██________████__████████▒▒▒▒▓▓██████▒▒▒▒▓▓██▒▒▓▓████████████______██████______________________________________    //
//    ________________________________________██▒▒______▓▓████████████▒▒▒▒▒▒████▓▓▒▒▒▒▒▒██▒▒▓▓████████████______████▓▓______________________________________    //
//    ________________________________________████______▓▓████████████▒▒▒▒▒▒████▒▒▒▒▒▒▒▒██▓▓▓▓████████████______████________________________________________    //
//    ______________________________________▓▓████______▓▓████████████▓▓▒▒▓▓████▒▒▒▒▒▒▒▒▓▓████████████████▓▓____████________________________________________    //
//    ______________________________________██████______████████████████▒▒████▓▓▒▒▒▒▒▒▒▒▓▓████▓▓▓▓██████████____▒▒▒▒________________________________________    //
//    ____________________________________▓▓██████______████████▓▓▒▒██████████▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒████████████▒▒______________________________________________    //
//    ____________________________________████████______██████████▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒██████████████______________________________________________    //
//    ____________________________________██████▒▒____▒▒██████████▓▓▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████████████▒▒____██______________________________________    //
//    ____________________________________██████______██████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████████____██______________________________________    //
//    ____________________________________▓▓██▒▒______██████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████████▒▒██████____________________________________    //
//    ______________________________________██______▓▓████▓▓▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓██████████████████████____________________________________    //
//    ________________________________________▓▓____██████▒▒▒▒██████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████████████████████____________________________________    //
//    ________________________________________▓▓__▒▒██████▒▒▒▒████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▒▒████████████████____________________________________    //
//    ____________________________________________████████▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓▒▒▒▒████████████████____________________________________    //
//    __________________________________░░______▒▒████████▒▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓████▒▒▓▓████████▒▒__________________________________    //
//    __________________________________██▓▓____██████████▓▓▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓████▒▒▒▒██████████__________________________________    //
//    __________________________________██████__████████████▓▓██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▒▒▒▒▓▓████████__________________________________    //
//    __________________________________████████████████████████▒▒▒▒▒▒▒▒▒▒░░▒▒▒▒░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▒▒▒▒▒▒████████__________________________________    //
//    __________________________________██████████████████▓▓██▓▓▒▒▒▒▒▒▒▒▒▒░░░░▒▒░░░░░░░░▒▒▒▒░░░░▒▒▒▒▒▒▒▒████▓▓▒▒▒▒████████__________________________________    //
//    __________________________________████████████████▓▓▒▒██▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░▒▒░░▒▒▒▒▒▒▒▒▒▒▓▓████▒▒▒▒████████__________________________________    //
//    __________________________________▒▒██████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒████▒▒▓▓████████__________________________________    //
//    ____________________________________██████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓██▒▒██████████__________________________________    //
//    ____________________________________██████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████████████__________________________________    //
//    ____________________________________▒▒████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒████████████▒▒__________________________________    //
//    ______________________________________████████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▒▒████____________________________________    //
//    ______________________________________▓▓████████▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████____________________________________    //
//    ________________________________________████████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████____________________________________    //
//    __________________________________________██████▓▓▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▓▓██______________________________________    //
//    __________________________________________▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒██▓▓______________________________________    //
//    ____________________________________________▓▓██▓▓▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒██________________________________________    //
//    ______________________________________________▓▓██▒▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▓▓__________________________________________    //
//    ________________________________________________▒▒▒▒▒▒░░░░▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒▒▒____________________________________________    //
//    __________________________________________________░░▒▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒▒▒▒▒______________________________________________    //
//    ______________________________________________________░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▒▒░░________________________________________________    //
//    __________________________________________________________░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░____________________________________________________    //
//    ______________________________________________________________░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░__________________________________________________________    //
//    ______________________________________________________________________░░░░░░░░░░░░____________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//    ______________________________________________________________________________________________________________________________________________________    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BRNFNZ is ERC1155Creator {
    constructor() ERC1155Creator("Burn Frenz", "BRNFNZ") {}
}