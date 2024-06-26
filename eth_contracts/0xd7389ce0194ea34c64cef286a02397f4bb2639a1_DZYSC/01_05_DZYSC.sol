// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DZY Sun Collection
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
//                   ('-.   .-') _          _ .-') _              .-') _    .-') _                 //
//                 _(  OO) (  OO) )        ( (  OO) )            (  OO) )  (  OO) )                //
//      ,----.    (,------./     '._        \     .'_   ,-.-') ,(_)----. ,(_)----.  ,--.   ,--.    //
//     '  .-./-')  |  .---'|'--...__)       ,`'--..._)  |  |OO)|       | |       |   \  `.'  /     //
//     |  |_( O- ) |  |    '--.  .--'       |  |  \  '  |  |  \'--.   /  '--.   /  .-')     /      //
//     |  | .--, \(|  '--.    |  |          |  |   ' |  |  |(_/(_/   /   (_/   /  (OO  \   /       //
//    (|  | '. (_/ |  .--'    |  |          |  |   / : ,|  |_.' /   /___  /   /___ |   /  /\_      //
//     |  '--'  |  |  `---.   |  |          |  '--'  /(_|  |   |        ||        |`-./  /.__)     //
//      `------'   `------'   `--'          `-------'   `--'   `--------'`--------'  `--'          //
//                                                                                                 //
//                                                                                                 //
//                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////


contract DZYSC is ERC721Creator {
    constructor() ERC721Creator("DZY Sun Collection", "DZYSC") {}
}