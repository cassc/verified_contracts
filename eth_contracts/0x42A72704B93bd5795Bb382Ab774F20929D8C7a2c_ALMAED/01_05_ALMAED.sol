// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Almajoyart Editions
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//      _____   __                     _           ______     _  _  _    _                         //
//     (_____) (__)                   ( ) ____    (______)   (_)(_)(_)_ (_)        _      ____     //
//    (_)___(_) (_)   __   __    ____ () (____)   (_)__    __(_) _ (___) _   ___  (_)__  (____)    //
//    (_______) (_)  (__)_(__)  (____)   (_)__    (____)  (____)(_)(_)  (_) (___) (____) (_)__     //
//    (_)   (_) (_) (_) (_) (_)( )_( )    _(__)   (_)____(_)_(_)(_)(_)_ (_)(_)_(_)(_) (_) _(__)    //
//    (_)   (_)(___)(_) (_) (_) (__)_)   (____)   (______)(____)(_) (__)(_) (___) (_) (_)(____)    //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract ALMAED is ERC721Creator {
    constructor() ERC721Creator("Almajoyart Editions", "ALMAED") {}
}