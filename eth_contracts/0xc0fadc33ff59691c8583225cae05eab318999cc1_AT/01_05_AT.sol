// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Adventure Time
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                      //
//                                                                                                                                      //
//          ___           ___           ___           ___           ___           ___           ___           ___           ___         //
//         /\  \         /\  \         /\__\         /\  \         /\__\         /\  \         /\__\         /\  \         /\  \        //
//        /::\  \       /::\  \       /:/  /        /::\  \       /::|  |        \:\  \       /:/  /        /::\  \       /::\  \       //
//       /:/\:\  \     /:/\:\  \     /:/  /        /:/\:\  \     /:|:|  |         \:\  \     /:/  /        /:/\:\  \     /:/\:\  \      //
//      /::\~\:\  \   /:/  \:\__\   /:/__/  ___   /::\~\:\  \   /:/|:|  |__       /::\  \   /:/  /  ___   /::\~\:\  \   /::\~\:\  \     //
//     /:/\:\ \:\__\ /:/__/ \:|__|  |:|  | /\__\ /:/\:\ \:\__\ /:/ |:| /\__\     /:/\:\__\ /:/__/  /\__\ /:/\:\ \:\__\ /:/\:\ \:\__\    //
//     \/__\:\/:/  / \:\  \ /:/  /  |:|  |/:/  / \:\~\:\ \/__/ \/__|:|/:/  /    /:/  \/__/ \:\  \ /:/  / \/_|::\/:/  / \:\~\:\ \/__/    //
//          \::/  /   \:\  /:/  /   |:|__/:/  /   \:\ \:\__\       |:/:/  /    /:/  /       \:\  /:/  /     |:|::/  /   \:\ \:\__\      //
//          /:/  /     \:\/:/  /     \::::/__/     \:\ \/__/       |::/  /     \/__/         \:\/:/  /      |:|\/__/     \:\ \/__/      //
//         /:/  /       \::/__/       ~~~~          \:\__\         /:/  /                     \::/  /       |:|  |        \:\__\        //
//         \/__/         ~~                          \/__/         \/__/                       \/__/         \|__|         \/__/        //
//                                                                                                                                      //
//                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AT is ERC721Creator {
    constructor() ERC721Creator("Adventure Time", "AT") {}
}