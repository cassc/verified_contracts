// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mel Hearts
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXOkkkkkkkkONMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMNK0KNX00KWMMMMMMMMMMMMMMMWkcccccccc:cx000XWMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMOc:cxd::oXMMMMMMMMMMMMMMMWkccccccccccccc:lOXWMMMMMMMMM    //
//    MMMMMMMMMMMMMMWWNNWMMMMMMMXko:::cdONMMMMMMMMMMMMMMMWkcccccccccccccccclONWMMMMMMM    //
//    MMMMMMMMMMMMMMKdlo0MMMMMMMKdl:lcclxNMMMMMMMMMMMMMMMMKxoccccclcccccccccloOWMMMMMM    //
//    MMMMMMMMMMMMMMXxodKMMMMMMMKdoxKOookNMMMMMMMMMMMMMMMMMMKlcclodoccccccccc:xWMMMMMM    //
//    MMMMMMMMMMMMMMXkdxKMMMMMMMMWWWMWWWWMMMMMMMMMMKkkkkkKKkdcccxNWKdcccccccc:xWMMMMMM    //
//    MMMMMMMN0O0XXOd:::oOKN0OOXMMMMMMMMMMMMMMMMWKOo:ccc:oo:ccccoOKWNKd:ccccc:xWMMMMMM    //
//    MMMMMMM0c;cOk:;:l:;;d0l;:kWMMMMMMMMMMMMMMMXo:cccccccccccccc:dXX0o:cc:cx0NMMMMMMM    //
//    MMMMMMMN0O0XXOd:::oOKN0OOXMMMMMMMMMMMMMMMMXo:cccccccccccccc:d0o::c:cx0NMMMMMMMMM    //
//    MMMMMMMMMMMMMMXkdxKMMMMMMMMMMMMMMMMMMMMMMMXo:cccccccccccccc:dKOxkxx0NMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMXxod0MMMMMMMMMMMMMMMMMMMMMMMNOdlccccccccccccldONMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMKdlo0MMMMMMMMMMMMMMMMMMMMMMMMMWOolccccccccloOWMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMWNNWMMMMMMMMMMMMMMMMMMMMMMMMMMWN0lclllcco0NWMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXKKKKKKXWMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract MH is ERC721Creator {
    constructor() ERC721Creator("Mel Hearts", "MH") {}
}