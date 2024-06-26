// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Palatial Frostscapes by Unalacuna
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//    .---.        .-.          .-.  _        .-.                               //
//    : .; :       : :         .' `.:_;       : :                               //
//    :  _.' .--.  : :   .--.  `. .'.-. .--.  : :                               //
//    : :   ' .; ; : :_ ' .; ;  : : : :' .; ; : :_                              //
//    :_;   `.__,_;`.__;`.__,_; :_; :_;`.__,_;`.__;                             //
//                                                                              //
//                                                                              //
//    .---.                   .-.                                               //
//    : .--'                 .' `.                                              //
//    : `;  .--.  .--.  .--. `. .' .--.  .--.  .--.  .---.  .--.  .--.          //
//    : :   : ..'' .; :`._-.' : : `._-.''  ..'' .; ; : .; `' '_.'`._-.'         //
//    :_;   :_;  `.__.'`.__.' :_; `.__.'`.__.'`.__,_;: ._.'`.__.'`.__.'         //
//                                                   : :                        //
//                                                   :_;                        //
//    .-.           .-..-.             .-.                                      //
//    : :           : :: :             : :                                      //
//    : `-. .-..-.  : :: :,-.,-. .--.  : :   .--.   .--. .-..-.,-.,-. .--.      //
//    ' .; :: :; :  : :; :: ,. :' .; ; : :_ ' .; ; '  ..': :; :: ,. :' .; ;     //
//    `.__.'`._. ;  `.__.':_;:_;`.__,_;`.__;`.__,_;`.__.'`.__.':_;:_;`.__,_;    //
//           .-. :                                                              //
//           `._.'                                                              //
//                                                                              //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract PFbU is ERC721Creator {
    constructor() ERC721Creator("Palatial Frostscapes by Unalacuna", "PFbU") {}
}