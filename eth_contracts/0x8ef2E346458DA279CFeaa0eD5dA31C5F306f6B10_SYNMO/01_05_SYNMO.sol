// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Synthetic Emotions
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////
//                                    //
//                                    //
//                __,__               //
//       .--.  .-"     "-.  .--.      //
//      / .. \/  .-. .-.  \/ .. \     //
//     | |  '|  /   Y   \  |'  | |    //
//     | \   \  \ 0 | 0 /  /   / |    //
//      \ '- ,\.-"""""""-./, -' /     //
//       ''-'  / \     / \ '-''       //
//            |   \   /   |           //
//            \    '-'    /           //
//             '--.   .--'            //
//                                    //
//                __,__               //
//       .--.  .-"     "-.  .--.      //
//      / .. \/  .-. .-.  \/ .. \     //
//     | |  '|  /   Y   \  |'  | |    //
//     | \   \  \ 0 | 0 /  /   / |    //
//      \ '- ,\.-"""""""-./, -' /     //
//       ''-' /_   ^ ^   _\ '-''      //
//           |  \._   _./  |          //
//           \   \ '~' /   /          //
//            '._ '-=-' _.'           //
//               '-----'              //
//                                    //
//                                    //
////////////////////////////////////////


contract SYNMO is ERC721Creator {
    constructor() ERC721Creator("Synthetic Emotions", "SYNMO") {}
}