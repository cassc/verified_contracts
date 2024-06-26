// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Scenic Dreams
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                               //
//                                                                                                                                                               //
//       .-'''-.     _______      .-''-.  ,---.   .--..-./`)     _______            ______     .-------.        .-''-.     ____    ,---.    ,---.   .-'''-.      //
//      / _     \   /   __  \   .'_ _   \ |    \  |  |\ .-.')   /   __  \          |    _ `''. |  _ _   \     .'_ _   \  .'  __ `. |    \  /    |  / _     \     //
//     (`' )/`--'  | ,_/  \__) / ( ` )   '|  ,  \ |  |/ `-' \  | ,_/  \__)         | _ | ) _  \| ( ' )  |    / ( ` )   '/   '  \  \|  ,  \/  ,  | (`' )/`--'     //
//    (_ o _).   ,-./  )      . (_ o _)  ||  |\_ \|  | `-'`"`,-./  )               |( ''_'  ) ||(_ o _) /   . (_ o _)  ||___|  /  ||  |\_   /|  |(_ o _).        //
//     (_,_). '. \  '_ '`)    |  (_,_)___||  _( )_\  | .---. \  '_ '`)             | . (_) `. || (_,_).' __ |  (_,_)___|   _.-`   ||  _( )_/ |  | (_,_). '.      //
//    .---.  \  : > (_)  )  __'  \   .---.| (_ o _)  | |   |  > (_)  )  __         |(_    ._) '|  |\ \  |  |'  \   .---..'   _    || (_ o _) |  |.---.  \  :     //
//    \    `-'  |(  .  .-'_/  )\  `-'    /|  (_,_)\  | |   | (  .  .-'_/  )        |  (_.\.' / |  | \ `'   / \  `-'    /|  _( )_  ||  (_,_)  |  |\    `-'  |     //
//     \       /  `-'`-'     /  \       / |  |    |  | |   |  `-'`-'     /         |       .'  |  |  \    /   \       / \ (_ o _) /|  |      |  | \       /      //
//      `-...-'     `._____.'    `'-..-'  '--'    '--' '---'    `._____.'          '-----'`    ''-'   `'-'     `'-..-'   '.(_,_).' '--'      '--'  `-...-'       //
//                                                                                                                                                               //
//                                                                                                                                                               //
//                                                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SD is ERC1155Creator {
    constructor() ERC1155Creator("Scenic Dreams", "SD") {}
}