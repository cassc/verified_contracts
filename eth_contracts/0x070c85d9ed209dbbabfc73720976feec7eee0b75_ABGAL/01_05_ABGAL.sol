// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ABZU
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                                                                       //
//    #       _____/\/\_____     _/\/\/\/\/\___     _/\/\/\/\/\/\_     _/\/\____/\/\_    //
//    #      ___/\/\/\/\___     _/\/\____/\/\_     _______/\/\___     _/\/\____/\/\_     //
//    #     _/\/\____/\/\_     _/\/\/\/\/\___     _____/\/\_____     _/\/\____/\/\_      //
//    #    _/\/\/\/\/\/\_     _/\/\____/\/\_     ___/\/\_______     _/\/\____/\/\_       //
//    #   _/\/\____/\/\_     _/\/\/\/\/\___     _/\/\/\/\/\/\_     ___/\/\/\/\___        //
//    #  ______________     ______________     ______________     ______________         //
//                                                                                       //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract ABGAL is ERC721Creator {
    constructor() ERC721Creator("ABZU", "ABGAL") {}
}