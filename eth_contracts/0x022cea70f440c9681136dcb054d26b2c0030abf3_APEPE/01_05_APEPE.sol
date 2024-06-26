// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ACTION PEPE
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////
//                                                                                      //
//                                                                                      //
//                                                                                      //
//                    ___                                                               //
//                   (   )   .-.                                                        //
//      .---.   .--.  | |_  ( __) .--.  ___ .-.      .-..    .--.    .-..    .--.       //
//     / .-, \ /    \(   __)(''")/    \(   )   \    /    \  /    \  /    \  /    \      //
//    (__) ; ||  .-. ;| |    | ||  .-. ;|  .-. .   ' .-,  ;|  .-. ;' .-,  ;|  .-. ;     //
//      .'`  ||  |(___) | ___| || |  | || |  | |   | |  . ||  | | || |  . ||  | | |     //
//     / .'| ||  |    | |(   ) || |  | || |  | |   | |  | ||  |/  || |  | ||  |/  |     //
//    | /  | ||  | ___| | | || || |  | || |  | |   | |  | ||  ' _.'| |  | ||  ' _.'     //
//    ; |  ; ||  '(   ) ' | || || '  | || |  | |   | |  ' ||  .'.-.| |  ' ||  .'.-.     //
//    ' `-'  |'  `-' |' `-' ;| |'  `-' /| |  | |   | `-'  ''  `-' /| `-'  ''  `-' /     //
//    `.__.'_. `.__,'  `.__.(___)`.__.'(___)(___)  | \__.'  `.__.' | \__.'  `.__.'      //
//                                                 | |             | |                  //
//                                                (___)           (___)                 //
//                                                                                      //
//                                                                                      //
//                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////


contract APEPE is ERC1155Creator {
    constructor() ERC1155Creator("ACTION PEPE", "APEPE") {}
}