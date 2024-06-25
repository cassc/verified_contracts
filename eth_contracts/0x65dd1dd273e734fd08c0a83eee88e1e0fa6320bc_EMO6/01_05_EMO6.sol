// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Crypto Nothing
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                    //
//                                                                                                                    //
//    Arseneca is an artist not deceased since 1974.                                                                  //
//    He is the creator of emochain, a new way of creating dynamic NFTs                                               //
//    in the art world.                                                                                               //
//    For each NFT created, there is a physical action performed, whose generated emotion is captured                 //
//    on the surface of an electronic chip and connected to the blockchain.                                           //
//    Arseneca exhibits regularly in galleries in Paris. He is the pioneer in 'dynamic art of NFTs'                   //
//    ⨁the buy nothing contract contains the tokens which poetically represent an act of real purchase of nothing,    //
//    a person who bought nothing at a given moment and who received nothing.                                         //
//                                                                                                                    //
//                                                                                                                    //
//                                                            ,--.                                                    //
//       ,---,       ,-.----.    .--.--.       ,---,.       ,--.'|    ,---,.  ,----..     ,---,                       //
//      '  .' \      \    /  \  /  /    '.   ,'  .' |   ,--,:  : |  ,'  .' | /   /   \   '  .' \                      //
//     /  ;    '.    ;   :    \|  :  /`. / ,---.'   |,`--.'`|  ' :,---.'   ||   :     : /  ;    '.                    //
//    :  :       \   |   | .\ :;  |  |--`  |   |   .'|   :  :  | ||   |   .'.   |  ;. /:  :       \                   //
//    :  |   /\   \  .   : |: ||  :  ;_    :   :  |-,:   |   \ | ::   :  |-,.   ; /--` :  |   /\   \                  //
//    |  :  ' ;.   : |   |  \ : \  \    `. :   |  ;/||   : '  '; |:   |  ;/|;   | ;    |  :  ' ;.   :                 //
//    |  |  ;/  \   \|   : .  /  `----.   \|   :   .''   ' ;.    ;|   :   .'|   : |    |  |  ;/  \   \                //
//    '  :  | \  \ ,';   | |  \  __ \  \  ||   |  |-,|   | | \   ||   |  |-,.   | '___ '  :  | \  \ ,'                //
//    |  |  '  '--'  |   | ;\  \/  /`--'  /'   :  ;/|'   : |  ; .''   :  ;/|'   ; : .'||  |  '  '--'                  //
//    |  :  :        :   ' | \.'--'.     / |   |    \|   | '`--'  |   |    \'   | '/  :|  :  :                        //
//    |  | ,'        :   : :-'   `--'---'  |   :   .''   : |      |   :   .'|   :    / |  | ,'                        //
//    `--''          |   |.'               |   | ,'  ;   |.'      |   | ,'   \   \ .'  `--''                          //
//                   `---'                 `----'    '---'        `----'      `---`                                   //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract EMO6 is ERC721Creator {
    constructor() ERC721Creator("Crypto Nothing", "EMO6") {}
}