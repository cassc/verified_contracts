// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Eden
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////
//                                                                              //
//                                                                              //
//    🌸#### ##        ##### ##        ##### ##       ##### #     ##            //
//      ######  /### /  /#####  /##     ######  /### / ######  /#    #### /     //
//     /#   /  / ###/ //    /  / ###   /#   /  / ###/ /#   /  / ##    ###/      //
//    /    /  /   ## /     /  /   ### /    /  /   ## /    /  /  ##    # #       //
//        /  /            /  /     ###    /  /           /  /    ##   #         //
//       ## ##           ## ##      ##   ## ##          ## ##    ##   #         //
//       ## ##           ## ##      ##   ## ##          ## ##     ##  #         //
//       ## ######       ## ##      ##   ## ######      ## ##     ##  #         //
//       ## #####        ## ##      ##   ## #####       ## ##      ## #         //
//       ## ##           ## ##      ##   ## ##          ## ##      ## #         //
//       #  ##           #  ##      ##   #  ##          #  ##       ###         //
//          /               /       /       /              /        ###         //
//      /##/         / /###/       /    /##/         / /##/          ##         //
//     /  ##########/ /   ########/    /  ##########/ /  #####                  //
//    /     ######   /       ####     /     ######   /     ##                   //
//    #              #                #              #                          //
//     ##             ##               ##             ##🌸                      //
//                                                                              //
//                                                                              //
//////////////////////////////////////////////////////////////////////////////////


contract EDN is ERC721Creator {
    constructor() ERC721Creator("Eden", "EDN") {}
}