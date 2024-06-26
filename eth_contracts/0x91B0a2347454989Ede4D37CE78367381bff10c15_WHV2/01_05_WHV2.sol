// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Working Hands Vol.2
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                   //
//                                                                                                                                                                   //
//                                                                                                                                                                   //
//    .::        .::                 .::                               .::     .::                        .::            .::         .::           .::               //
//    .::        .::                 .::      .:                       .::     .::                        .::             .::       .::            .::    .:::.:     //
//    .::   .:   .::   .::    .: .:::.::  .::   .:: .::     .::        .::     .::   .::    .:: .::       .:: .::::        .::     .::     .::     .::   .:    .:    //
//    .::  .::   .:: .::  .::  .::   .:: .:: .:: .::  .:: .::  .::     .:::::: .:: .::  .::  .::  .:: .:: .::.::            .::   .::    .::  .::  .::       .::     //
//    .:: .: .:: .::.::    .:: .::   .:.::   .:: .::  .::.::   .::     .::     .::.::   .::  .::  .::.:   .::  .:::          .:: .::    .::    .:: .::     .::       //
//    .: .:    .:::: .::  .::  .::   .:: .:: .:: .::  .:: .::  .::     .::     .::.::   .::  .::  .::.:   .::    .::          .::::      .::  .::  .::   .::         //
//    .::        .::   .::    .:::   .::  .::.::.:::  .::     .::      .::     .::  .:: .:::.:::  .:: .:: .::.:: .::           .::         .::    .:::.::.:::::::    //
//                                                         .::                                                                                                       //
//                                                                                                                                                                   //
//                                                                                                                                                                   //
//                                                                                                                                                                   //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract WHV2 is ERC721Creator {
    constructor() ERC721Creator("Working Hands Vol.2", "WHV2") {}
}