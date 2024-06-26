// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Music Connects Us by FB
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                 //
//                                                                                                                                                                 //
//    ##   ##  ##  ###   ## ##     ####    ## ##             ## ##    ## ##   ###  ##  ###  ##  ### ###   ## ##   #### ##   ## ##            ##  ###   ## ##       //
//     ## ##   ##   ##  ##   ##     ##    ##   ##           ##   ##  ##   ##    ## ##    ## ##   ##  ##  ##   ##  # ## ##  ##   ##           ##   ##  ##   ##      //
//    # ### #  ##   ##  ####        ##    ##                ##       ##   ##   # ## #   # ## #   ##      ##         ##     ####              ##   ##  ####         //
//    ## # ##  ##   ##   #####      ##    ##                ##       ##   ##   ## ##    ## ##    ## ##   ##         ##      #####            ##   ##   #####       //
//    ##   ##  ##   ##      ###     ##    ##                ##       ##   ##   ##  ##   ##  ##   ##      ##         ##         ###           ##   ##      ###      //
//    ##   ##  ##   ##  ##   ##     ##    ##   ##           ##   ##  ##   ##   ##  ##   ##  ##   ##  ##  ##   ##    ##     ##   ##           ##   ##  ##   ##      //
//    ##   ##   ## ##    ## ##     ####    ## ##             ## ##    ## ##   ###  ##  ###  ##  ### ###   ## ##    ####     ## ##             ## ##    ## ##       //
//                                                                                                                                                                 //
//                                                                                                                                                                 //
//                                                                                                                                                                 //
//                                                                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MCUFB is ERC721Creator {
    constructor() ERC721Creator("Music Connects Us by FB", "MCUFB") {}
}