// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Abtin Zahed
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                     //
//                                                                                                     //
//     _______  ______ __________________ _          _______  _______           _______  ______        //
//    (  ___  )(  ___ \\__   __/\__   __/( (    /|  / ___   )(  ___  )|\     /|(  ____ \(  __  \       //
//    | (   ) || (   ) )  ) (      ) (   |  \  ( |  \/   )  || (   ) || )   ( || (    \/| (  \  )      //
//    | (___) || (__/ /   | |      | |   |   \ | |      /   )| (___) || (___) || (__    | |   ) |      //
//    |  ___  ||  __ (    | |      | |   | (\ \) |     /   / |  ___  ||  ___  ||  __)   | |   | |      //
//    | (   ) || (  \ \   | |      | |   | | \   |    /   /  | (   ) || (   ) || (      | |   ) |      //
//    | )   ( || )___) )  | |   ___) (___| )  \  |   /   (_/\| )   ( || )   ( || (____/\| (__/  )      //
//    |/     \||/ \___/   )_(   \_______/|/    )_)  (_______/|/     \||/     \|(_______/(______/       //
//                                                                                                     //
//                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AZMusic is ERC1155Creator {
    constructor() ERC1155Creator("Abtin Zahed", "AZMusic") {}
}