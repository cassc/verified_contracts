// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Metaversal Badges Test
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////
//                                                                //
//                                                                //
//          ___           ___                         ___         //
//         /\  \         /\__\                       /\  \        //
//        |::\  \       /:/ _/_         ___         /::\  \       //
//        |:|:\  \     /:/ /\__\       /\__\       /:/\:\  \      //
//      __|:|\:\  \   /:/ /:/ _/_     /:/  /      /:/ /::\  \     //
//     /::::|_\:\__\ /:/_/:/ /\__\   /:/__/      /:/_/:/\:\__\    //
//     \:\~~\  \/__/ \:\/:/ /:/  /  /::\  \      \:\/:/  \/__/    //
//      \:\  \        \::/_/:/  /  /:/\:\  \      \::/__/         //
//       \:\  \        \:\/:/  /   \/__\:\  \      \:\  \         //
//        \:\__\        \::/  /         \:\__\      \:\__\        //
//         \/__/         \/__/           \/__/       \/__/        //
//                        ___           ___                       //
//          ___          /\__\         /\  \                      //
//         /\  \        /:/ _/_       /::\  \                     //
//         \:\  \      /:/ /\__\     /:/\:\__\                    //
//          \:\  \    /:/ /:/ _/_   /:/ /:/  /                    //
//      ___  \:\__\  /:/_/:/ /\__\ /:/_/:/__/___                  //
//     /\  \ |:|  |  \:\/:/ /:/  / \:\/:::::/  /                  //
//     \:\  \|:|  |   \::/_/:/  /   \::/~~/~~~~                   //
//      \:\__|:|__|    \:\/:/  /     \:\~~\                       //
//       \::::/__/      \::/  /       \:\__\                      //
//        ~~~~           \/__/         \/__/                      //
//          ___           ___                                     //
//         /\__\         /\  \                                    //
//        /:/ _/_       /::\  \                                   //
//       /:/ /\  \     /:/\:\  \                                  //
//      /:/ /::\  \   /:/ /::\  \   ___     ___                   //
//     /:/_/:/\:\__\ /:/_/:/\:\__\ /\  \   /\__\                  //
//     \:\/:/ /:/  / \:\/:/  \/__/ \:\  \ /:/  /                  //
//      \::/ /:/  /   \::/__/       \:\  /:/  /                   //
//       \/_/:/  /     \:\  \        \:\/:/  /                    //
//         /:/  /       \:\__\        \::/  /                     //
//         \/__/         \/__/         \/__/                      //
//                                                                //
//                                                                //
////////////////////////////////////////////////////////////////////


contract MVBt is ERC1155Creator {
    constructor() ERC1155Creator("Metaversal Badges Test", "MVBt") {}
}