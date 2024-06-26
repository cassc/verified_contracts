// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: occulted
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //
//                                                                                  //
//                                                                                  //
//                                             ###                        ##        //
//                                              ###                        ##       //
//                                               ##     #                  ##       //
//                                               ##    ##                  ##       //
//                                               ##    ##                  ##       //
//       /###     /###      /###   ##   ####     ##  ######## /##      ### ##       //
//      / ###  / / ###  /  / ###  / ##    ###  / ## ######## / ###    #########     //
//     /   ###/ /   ###/  /   ###/  ##     ###/  ##    ##   /   ###  ##   ####      //
//    ##    ## ##        ##         ##      ##   ##    ##  ##    ### ##    ##       //
//    ##    ## ##        ##         ##      ##   ##    ##  ########  ##    ##       //
//    ##    ## ##        ##         ##      ##   ##    ##  #######   ##    ##       //
//    ##    ## ##        ##         ##      ##   ##    ##  ##        ##    ##       //
//    ##    ## ###     / ###     /  ##      /#   ##    ##  ####    / ##    /#       //
//     ######   ######/   ######/    ######/ ##  ### / ##   ######/   ####/         //
//      ####     #####     #####      #####   ##  ##/   ##   #####     ###          //
//                                                                                  //
//                                                                                  //
//                                                                                  //
//                                                                                  //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////


contract occulted is ERC721Creator {
    constructor() ERC721Creator("occulted", "occulted") {}
}