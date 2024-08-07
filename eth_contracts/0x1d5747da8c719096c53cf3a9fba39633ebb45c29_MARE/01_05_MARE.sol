// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Rare 'Mare Bears 2
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////
//                                                                                  //
//                                                                                  //
//    //////////////////////////////////////////////////////////////////////////    //
//    //                                                                      //    //
//    //                                                                      //    //
//    //                    ,---.                       ,----.                //    //
//    //      .-.,.---.   .--.'  \      .-.,.---.    ,-.--` , \               //    //
//    //     /==/  `   \  \==\-/\ \    /==/  `   \  |==|-  _.-`               //    //
//    //    |==|-, .=., | /==/-|_\ |  |==|-, .=., | |==|   `.-.               //    //
//    //    |==|   '='  / \==\,   - \ |==|   '='  //==/_ ,    /               //    //
//    //    |==|- ,   .'  /==/ -   ,| |==|- ,   .' |==|    .-'                //    //
//    //    |==|_  . ,'. /==/-  /\ - \|==|_  . ,'. |==|_  ,`-._               //    //
//    //    /==/  /\ ,  )\==\ _.\=\.-'/==/  /\ ,  )/==/ ,     /               //    //
//    //    `--`-`--`--'  `--`        `--`-`--`--' `--`-----``                //    //
//    //     .--.-.         ___     ,---.                       ,----.        //    //
//    //    /==/  /  .-._ .'=.'\  .--.'  \      .-.,.---.    ,-.--` , \       //    //
//    //    \==\ -\ /==/ \|==|  | \==\-/\ \    /==/  `   \  |==|-  _.-`       //    //
//    //     \==\- \|==|,|  / - | /==/-|_\ |  |==|-, .=., | |==|   `.-.       //    //
//    //      `--`-'|==|  \/  , | \==\,   - \ |==|   '='  //==/_ ,    /       //    //
//    //            |==|- ,   _ | /==/ -   ,| |==|- ,   .' |==|    .-'        //    //
//    //            |==| _ /\   |/==/-  /\ - \|==|_  . ,'. |==|_  ,`-._       //    //
//    //            /==/  / / , /\==\ _.\=\.-'/==/  /\ ,  )/==/ ,     /       //    //
//    //            `--`./  `--`  `--`        `--`-`--`--' `--`-----``        //    //
//    //                      ,----.    ,---.                     ,-,--.      //    //
//    //        _..---.    ,-.--` , \ .--.'  \      .-.,.---.   ,-.'-  _\     //    //
//    //      .' .'.-. \  |==|-  _.-` \==\-/\ \    /==/  `   \ /==/_ ,_.'     //    //
//    //     /==/- '=' /  |==|   `.-. /==/-|_\ |  |==|-, .=., |\==\  \        //    //
//    //     |==|-,   '  /==/_ ,    / \==\,   - \ |==|   '='  / \==\ -\       //    //
//    //     |==|  .=. \ |==|    .-'  /==/ -   ,| |==|- ,   .'  _\==\ ,\      //    //
//    //     /==/- '=' ,||==|_  ,`-._/==/-  /\ - \|==|_  . ,'. /==/\/ _ |     //    //
//    //                                                                      //    //
//    //                                                                      //    //
//    //////////////////////////////////////////////////////////////////////////    //
//                                                                                  //
//                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////


contract MARE is ERC721Creator {
    constructor() ERC721Creator("Rare 'Mare Bears 2", "MARE") {}
}