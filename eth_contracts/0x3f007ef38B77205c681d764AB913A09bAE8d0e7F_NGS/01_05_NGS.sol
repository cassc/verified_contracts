// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Node Gardens
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                            //
//                                                                                                                            //
//    ___/\/\/\/\/\__________________________________________________/\/\______________/\/\_______________________________    //
//    _/\/\__________/\/\__/\/\____/\/\/\______/\/\/\/\______________/\/\____/\/\/\____/\/\________/\/\/\/\______/\/\/\/\_    //
//    _/\/\__/\/\/\__/\/\/\/\____/\/\/\/\/\__/\/\__/\/\______________/\/\__/\/\__/\/\__/\/\/\/\____/\/\__/\/\__/\/\/\/\___    //
//    _/\/\____/\/\__/\/\________/\/\__________/\/\/\/\______/\/\____/\/\__/\/\__/\/\__/\/\__/\/\__/\/\__/\/\________/\/\_    //
//    ___/\/\/\/\/\__/\/\__________/\/\/\/\________/\/\________/\/\/\/\______/\/\/\____/\/\__/\/\__/\/\__/\/\__/\/\/\/\___    //
//    _______________________________________/\/\/\/\_____________________________________________________________________    //
//                                                                                                                            //
//                                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract NGS is ERC721Creator {
    constructor() ERC721Creator("Node Gardens", "NGS") {}
}