// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: United Glitched Nations (Separate But Equal)
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//     ________  __              __                      __        _______   __                      __     //
//    /        |/  |            /  |                    /  |      /       \ /  |                    /  |    //
//    $$$$$$$$/ $$ |  ______   _$$ |_     ______    ____$$ |      $$$$$$$  |$$/  __    __   ______  $$ |    //
//    $$ |__    $$ | /      \ / $$   |   /      \  /    $$ |      $$ |__$$ |/  |/  \  /  | /      \ $$ |    //
//    $$    |   $$ | $$$$$$  |$$$$$$/   /$$$$$$  |/$$$$$$$ |      $$    $$/ $$ |$$  \/$$/ /$$$$$$  |$$ |    //
//    $$$$$/    $$ | /    $$ |  $$ | __ $$    $$ |$$ |  $$ |      $$$$$$$/  $$ | $$  $$<  $$    $$ |$$ |    //
//    $$ |_____ $$ |/$$$$$$$ |  $$ |/  |$$$$$$$$/ $$ \__$$ |      $$ |      $$ | /$$$$  \ $$$$$$$$/ $$ |    //
//    $$       |$$ |$$    $$ |  $$  $$/ $$       |$$    $$ |      $$ |      $$ |/$$/ $$  |$$       |$$ |    //
//    $$$$$$$$/ $$/  $$$$$$$/    $$$$/   $$$$$$$/  $$$$$$$/       $$/       $$/ $$/   $$/  $$$$$$$/ $$/     //
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract UGNS is ERC721Creator {
    constructor() ERC721Creator("United Glitched Nations (Separate But Equal)", "UGNS") {}
}