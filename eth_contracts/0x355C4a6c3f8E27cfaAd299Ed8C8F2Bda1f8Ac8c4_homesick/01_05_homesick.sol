// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Homesick For A Place I've Never Been
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                               //
//                                                                                               //
//     ___                                                                     ___               //
//    (   )                                                    .-.            (   )              //
//     | | .-.     .--.    ___ .-. .-.     .--.       .--.    ( __)   .--.     | |   ___         //
//     | |/   \   /    \  (   )   '   \   /    \    /  _  \   (''")  /    \    | |  (   )        //
//     |  .-. .  |  .-. ;  |  .-.  .-. ; |  .-. ;  . .' `. ;   | |  |  .-. ;   | |  ' /          //
//     | |  | |  | |  | |  | |  | |  | | |  | | |  | '   | |   | |  |  |(___)  | |,' /           //
//     | |  | |  | |  | |  | |  | |  | | |  |/  |  _\_`.(___)  | |  |  |       | .  '.           //
//     | |  | |  | |  | |  | |  | |  | | |  ' _.' (   ). '.    | |  |  | ___   | | `. \          //
//     | |  | |  | '  | |  | |  | |  | | |  .'.-.  | |  `\ |   | |  |  '(   )  | |   \ \         //
//     | |  | |  '  `-' /  | |  | |  | | '  `-' /  ; '._,' '   | |  '  `-' |   | |    \ .        //
//    (___)(___)  `.__.'  (___)(___)(___) `.__.'    '.___.'   (___)  `.__,'   (___ ) (___)       //
//                                                                                               //
//                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////


contract homesick is ERC721Creator {
    constructor() ERC721Creator("Homesick For A Place I've Never Been", "homesick") {}
}