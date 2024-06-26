// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Iris Anthology
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//    Iris Anthology                                                                                                                                                        //
//    A Bouquet of Fine Art NFT's with utility of benefitting planetary wellbeing                                                                                           //
//                                                                                                                                                                          //
//    Curator: Isla Moon                                                                                                                                                    //
//    Futurist Dream Symbology Artist                                                                                                                                       //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//    .-./`) .-------.   .-./`)    .-'''-.            ____    ,---.   .--.,---------. .---.  .---.     ,-----.      .---.       ,-----.      .-_'''-.      ____     __      //
//    \ .-.')|  _ _   \  \ .-.')  / _     \         .'  __ `. |    \  |  |\          \|   |  |_ _|   .'  .-,  '.    | ,_|     .'  .-,  '.   '_( )_   \     \   \   /  /     //
//    / `-' \| ( ' )  |  / `-' \ (`' )/`--'        /   '  \  \|  ,  \ |  | `--.  ,---'|   |  ( ' )  / ,-.|  \ _ \ ,-./  )    / ,-.|  \ _ \ |(_ o _)|  '     \  _. /  '      //
//     `-'`"`|(_ o _) /   `-'`"`(_ o _).           |___|  /  ||  |\_ \|  |    |   \   |   '-(_{;}_);  \  '_ /  | :\  '_ '`) ;  \  '_ /  | :. (_,_)/___|      _( )_ .'       //
//     .---. | (_,_).' __ .---.  (_,_). '.            _.-`   ||  _( )_\  |    :_ _:   |      (_,_) |  _`,/ \ _/  | > (_)  ) |  _`,/ \ _/  ||  |  .-----. ___(_ o _)'        //
//     |   | |  |\ \  |  ||   | .---.  \  :        .'   _    || (_ o _)  |    (_I_)   | _ _--.   | : (  '\_/ \   ;(  .  .-' : (  '\_/ \   ;'  \  '-   .'|   |(_,_)'         //
//     |   | |  | \ `'   /|   | \    `-'  |        |  _( )_  ||  (_,_)\  |   (_(=)_)  |( ' ) |   |  \ `"/  \  ) /  `-'`-'|___\ `"/  \  ) /  \  `-'`   | |   `-'  /          //
//     |   | |  |  \    / |   |  \       /         \ (_ o _) /|  |    |  |    (_I_)   (_{;}_)|   |   '. \_/``".'    |        \'. \_/``".'    \        /  \      /           //
//     '---' ''-'   `'-'  '---'   `-...-'           '.(_,_).' '--'    '--'    '---'   '(_,_) '---'     '-----'      `--------`  '-----'       `'-...-'    `-..-'            //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//                                                                                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract iris is ERC721Creator {
    constructor() ERC721Creator("Iris Anthology", "iris") {}
}