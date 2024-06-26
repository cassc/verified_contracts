// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Light City Auric Recon
/// @author: manifold.xyz

import "./ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                       //
//                                                                                                                                       //
//                                                                                                                                       //
//         ##### /                          /                      # ###                                                     /           //
//      ######  /        #                #/                     /  /###  / #                                              #/            //
//     /#   /  /        ###               ##           #        /  /  ###/ ###     #                                 #     ##            //
//    /    /  /          #                ##          ##       /  ##   ##   #     ##                                ##     ##            //
//        /  /                            ##          ##      /  ###              ##                                ##     ##            //
//       ## ##         ###       /###     ##  /##   ######## ##   ##      ###   ######## ##   ####          /##   ######## ##  /##       //
//       ## ##          ###     /  ###  / ## / ### ########  ##   ##       ### ########   ##    ###  /     / ### ########  ## / ###      //
//       ## ##           ##    /    ###/  ##/   ###   ##     ##   ##        ##    ##      ##     ###/     /   ###   ##     ##/   ###     //
//       ## ##           ##   ##     ##   ##     ##   ##     ##   ##        ##    ##      ##      ##     ##    ###  ##     ##     ##     //
//       ## ##           ##   ##     ##   ##     ##   ##     ##   ##        ##    ##      ##      ##     ########   ##     ##     ##     //
//       #  ##           ##   ##     ##   ##     ##   ##      ##  ##        ##    ##      ##      ##     #######    ##     ##     ##     //
//          /            ##   ##     ##   ##     ##   ##       ## #      /  ##    ##      ##      ##     ##         ##     ##     ##     //
//      /##/           / ##   ##     ##   ##     ##   ##        ###     /   ##    ##      ##      ##   # ####    /  ##     ##     ##     //
//     /  ############/  ### / ########   ##     ##   ##         ######/    ### / ##       #########  ### ######/   ##     ##     ##     //
//    /     #########     ##/    ### ###   ##    ##    ##          ###       ##/   ##        #### ###  #   #####     ##     ##    ##     //
//    #                               ###        /                                                 ###                            /      //
//     ##                       ####   ###      /                                           #####   ###                          /       //
//                            /######  /#      /                                          /#######  /#                          /        //
//                           /     ###/       /                                          /      ###/                           /         //
//                                                                                                                                       //
//                                                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract LCAR is ERC721Creator {
    constructor() ERC721Creator("Light City Auric Recon", "LCAR") {}
}