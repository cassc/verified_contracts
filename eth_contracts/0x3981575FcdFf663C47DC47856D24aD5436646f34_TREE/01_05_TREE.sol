// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NFTREES
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////
//                                                                               //
//                                                                               //
//     )\  )\  )`-.--. .-,.-.,-.    /`-.   )\.---.   )\.---.    )\.--.           //
//    (  \, /  ) ,-._( ) ,, ,. (  ,' _  \ (   ,-._( (   ,-._(  (   ._.'          //
//     ) \ (   \ `-._  \( |(  )/ (  '-' (  \  '-,    \  '-,     `-.`.            //
//    ( ( \ \   ) ,_(     ) \     ) ,_ .'   ) ,-`     ) ,-`    ,_ (  \           //
//     `.)/  ) (  \       \ (    (  ' ) \  (  ``-.   (  ``-.  (  '.)  )          //
//        '.(   ).'        )/     )/   )/   )..-.(    )..-.(   '._,_.'           //
//                                                                               //
//                                                                               //
//                                                                               //
///////////////////////////////////////////////////////////////////////////////////


contract TREE is ERC1155Creator {
    constructor() ERC1155Creator("NFTREES", "TREE") {}
}