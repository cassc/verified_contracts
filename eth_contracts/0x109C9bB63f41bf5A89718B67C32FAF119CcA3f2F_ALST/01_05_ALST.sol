// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Allowlists
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                            //
//                                                                                                                                                                                                            //
//                                                                                                                                                                                                            //
//                                                                                                                                                                                                            //
//                      ___                                ___                    ___           ___           ___           ___                                ___                                ___         //
//          ___        /\  \                   ___        /\  \                  /\__\         /\__\         /\  \         /\  \                   ___        /\  \                   ___        /\  \        //
//         /\  \       \:\  \                 /\  \      /::\  \                /:/ _/_       /:/  /        /::\  \        \:\  \                 /\  \       \:\  \                 /\  \      /::\  \       //
//         \:\  \       \:\  \                \:\  \    /:/\ \  \              /:/ /\__\     /:/__/        /:/\:\  \        \:\  \                \:\  \       \:\  \                \:\  \    /:/\ \  \      //
//         /::\__\      /::\  \               /::\__\  _\:\~\ \  \            /:/ /:/ _/_   /::\  \ ___   /::\~\:\  \       /::\  \               /::\__\      /::\  \               /::\__\  _\:\~\ \  \     //
//      __/:/\/__/     /:/\:\__\           __/:/\/__/ /\ \:\ \ \__\          /:/_/:/ /\__\ /:/\:\  /\__\ /:/\:\ \:\__\     /:/\:\__\           __/:/\/__/     /:/\:\__\           __/:/\/__/ /\ \:\ \ \__\    //
//     /\/:/  /       /:/  \/__/          /\/:/  /    \:\ \:\ \/__/          \:\/:/ /:/  / \/__\:\/:/  / \/__\:\/:/  /    /:/  \/__/          /\/:/  /       /:/  \/__/          /\/:/  /    \:\ \:\ \/__/    //
//     \::/__/       /:/  /               \::/__/      \:\ \:\__\             \::/_/:/  /       \::/  /       \::/  /    /:/  /               \::/__/       /:/  /               \::/__/      \:\ \:\__\      //
//      \:\__\       \/__/                 \:\__\       \:\/:/  /              \:\/:/  /        /:/  /        /:/  /     \/__/                 \:\__\       \/__/                 \:\__\       \:\/:/  /      //
//       \/__/                              \/__/        \::/  /                \::/  /        /:/  /        /:/  /                             \/__/                              \/__/        \::/  /       //
//                                                        \/__/                  \/__/         \/__/         \/__/                                                                               \/__/        //
//                                                                                                                                                                                                            //
//                                                                                                                                                                                                            //
//                                                                                                                                                                                                            //
//                                                                                                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ALST is ERC1155Creator {
    constructor() ERC1155Creator("Allowlists", "ALST") {}
}