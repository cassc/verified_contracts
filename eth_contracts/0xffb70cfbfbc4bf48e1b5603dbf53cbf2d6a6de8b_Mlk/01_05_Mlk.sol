// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Milk
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////
//                                                          //
//                                                          //
//          ___                       ___       ___         //
//         /\__\          ___        /\__\     /\__\        //
//        /::|  |        /\  \      /:/  /    /:/  /        //
//       /:|:|  |        \:\  \    /:/  /    /:/__/         //
//      /:/|:|__|__      /::\__\  /:/  /    /::\__\____     //
//     /:/ |::::\__\  __/:/\/__/ /:/__/    /:/\:::::\__\    //
//     \/__/~~/:/  / /\/:/  /    \:\  \    \/_|:|~~|~       //
//           /:/  /  \::/__/      \:\  \      |:|  |        //
//          /:/  /    \:\__\       \:\  \     |:|  |        //
//         /:/  /      \/__/        \:\__\    |:|  |        //
//         \/__/                     \/__/     \|__|        //
//                                                          //
//                                                          //
//////////////////////////////////////////////////////////////


contract Mlk is ERC721Creator {
    constructor() ERC721Creator("Milk", "Mlk") {}
}