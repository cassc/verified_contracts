// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Stipple Studio
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//      .:: ::  .::: .::::::.::.:::::::  .:::::::  .::      .::::::::    //
//    .::    .::     .::    .::.::    .::.::    .::.::      .::          //
//     .::           .::    .::.::    .::.::    .::.::      .::          //
//       .::         .::    .::.:::::::  .:::::::  .::      .::::::      //
//          .::      .::    .::.::       .::       .::      .::          //
//    .::    .::     .::    .::.::       .::       .::      .::          //
//      .:: ::       .::    .::.::       .::       .::::::::.::::::::    //
//                                                                       //
//      .:: ::  .::: .::::::.::     .::.:::::    .::    .::::            //
//    .::    .::     .::    .::     .::.::   .:: .::  .::    .::         //
//     .::           .::    .::     .::.::    .::.::.::        .::       //
//       .::         .::    .::     .::.::    .::.::.::        .::       //
//          .::      .::    .::     .::.::    .::.::.::        .::       //
//    .::    .::     .::    .::     .::.::   .:: .::  .::     .::        //
//      .:: ::       .::      .:::::   .:::::    .::    .::::            //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
//                                                                       //
///////////////////////////////////////////////////////////////////////////


contract STPL is ERC721Creator {
    constructor() ERC721Creator("Stipple Studio", "STPL") {}
}