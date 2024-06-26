// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 晨|曦
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////
//                                                   //
//                                                   //
//                                                   //
//              .,;//,                               //
//           .-"`_`;///,                             //
//          /._ <|> `\;:.                            //
//          '._-_  ( )|::,                           //
//            |;-.    ///:::,.                       //
//            \ ; .-'  `'':::,.                      //
//            _'-;          ':::,.                   //
//         ,-;--/ /            ':::,._               //
//             / /\               ``'.'.             //
//        _-,-/ /  '._         _.-'   '.\            //
//       ` (,--'      `""--.._(         '.           //
//         `                   \    .--'  \          //
//                             _)   ( .     \        //
//                        __.-'_._-'`  .     \       //
//                       ` (.-`)  `     `\    \      //
//                                        '.   \     //
//                                          \   \    //
//                                          `\  ;    //
//                                            | |    //
//                                           / /     //
//                                      ,__.'.'      //
//                                       '--'        //
//                                                   //
//                                                   //
//                                                   //
///////////////////////////////////////////////////////


contract SanHei is ERC1155Creator {
    constructor() ERC1155Creator(unicode"晨|曦", "SanHei") {}
}