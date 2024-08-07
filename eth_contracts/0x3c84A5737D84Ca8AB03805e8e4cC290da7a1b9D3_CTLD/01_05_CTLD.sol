// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Checks - The Lost Donkeys Edition
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    //
//    //////////////////////////////////////////////////////////////////////////////////////////,,,,        ,,,*//////////////    //
//    ///////////////////////////////////////////////////////////////////////////////////////,,,,,            ,,,/////////////    //
//    ///////////////////////////////////////////////////////////////////////////////,,,,,,,,,.                ,,,,///////////    //
//    ///////////////////////,,,,,,,,,,,///////////////////////////////////////////,,,,        ,              ,,,,,,,/////////    //
//    /////////////////////,,,,       ,,,,/////////////////////////////////////////,,,,         ,,          ,.       ,,///////    //
//    /////////////////,,,,,,           ,,,,/////////////////////////////////////////,,,,         ,,      ,,         ,,///////    //
//    //////////,,     ,,,,                 ,,,,///////////////////////////////////////**,,,,,,,,,,,,,,,,,,,,,,,,,,****///////    //
//    ////////,,,,       ,,             ,,,,,,,,//////////////////////////////////////////////////////////////////////////////    //
//    ////////,,,,         ,,         ,,      @@@@@@@/////////////////////////////////////////////////////////////////////////    //
//    //////////**,,,,,        ,,,,,,,@@@@@@@@#######@@@@@@@@////////////////////////////@@@@@@@@@////////////////////////////    //
//    /////////////*,,,,,,,,,,,,,,/@@@@@@@(((((((((((((((@@@@////////////////////////@@@@@@@@@@@@@@@@@////////////////////////    //
//    /////////////////////////@@@@@@@(((((((((((((((((((((@@@@//////////////////@@@@@@@@(((((((((@@@@@@@@////////////////////    //
//    ///////////////////////@@@@##((((((((((((((((((((((((##@@@&/////////////@@@####(((((((((((((((((####@@@&////////////////    //
//    ///////////////////////@@@@(((((((((((((((%%%@@@@((((((@@@&///////////@@@@((((((((((((((((((((((((((((@@@///////////////    //
//    ///////////////////////@@@@(((((((((((((((@@@@@@@%%((((@@@&///////////@@@@((((((((((((((((((((((((((((@@@///////////////    //
//    /////////////////////////@@@@@%#######@@@@@@%%%%%%%##((##@@@////////@@@@(((((((((@@@@@@@@###((((((((##@@@////////////,,,    //
//    /////////////////////////@@@@@@@@@@@@@@@@@@@%%%%%%%%%((((@@@//////@@@@(((((((((%%%%%%@@@@@@@%%%%%%%%@@@&/////,,,,,,,,,.     //
//    //////////////////////////////@@@@@@@@//@@@@%%%%%%%%%((((@@@@@@@@@@@@@(((((((%%%%%%@@@@/(@@@@@@@@@@@@@@&/////,,      ,,,    //
//            ,,,,//////////////////////@@@@@@@@%%%%%%%%%((((((((///////////(((((((%%%%@@@@//////////////////////,,,,             //
//              ,,,,////////////////////@@@@%%%%%%%%%((((((((/////////////////(((((((%%@@@@////////////////////////,,,,           //
//                ,,,/////////////////@@@@%%%%%%%%%((((((((((////////////////////////@@@@////////////////////////////,,,,,,       //
//              ,,,,,,,/////////////@@@@%%%%%%%%%%%%%########((((////////////////////(/@@@@////////////////////////////*******    //
//            ,,       ,,///////////@@@@%%%%%%%%%%%%%%%%%%%(((((((/////////////////////@@@@///////////////////////////////////    //
//          ,,         ,,///////////@@@@%%%%%%%%%%%%%%%%%%%(((((((///////////////////////@@@@/////////////////////////////////    //
//    ,,,,,,,,,,,,,,,****/////////(@@@%%%%%%%%%%%%%%%%%%%%%%%%%#%@@@@@@@@@/////////////@@@@@@@&///////////////////////////////    //
//    ////////////////////////////(@@@%%%%%%%%%%%%%%%%%%%%%%%%%@@@    @@@@@@/////////@@@@  @@@&///////////////////////////////    //
//    ////////////////////////////(@@@%%%%%%%%%%%%%%%%%%%%%((((@@@    @@@@///////////@@@@@@@@@@@//////////////////////////////    //
//    ////////////////////////////(@@@%%%%%%%%%%%%%%%%%%%##((((#%@@@@@@@((             [email protected]@@@@@@@//////////////////////    //
//    ////////////////////////////(@@@%%%%%%%%%%%%%%%%%%%%%((((/////////    ,,,,,,,             .,**@@@@//////////////////////    //
//    ////////////////////////////(@@@%%%%%%%%%%%%%%%%%%%((((/////////      ,,,/@@@@@//      @&/  ,,**@@@@////////////////////    //
//    //////////////////////////////@@@@%%%%%%%%%%%%%##((////..*,...**..       .***@@//  ,,,,@@@&&&&  [email protected]@@@//////////////////    //
//    //////////////////////////////@@@@%%%%%%%%%%%((((//////...,*....**        ,,,@@//  ,,,,@@@@@@@    @@@@//////////////////    //
//    ////////////////////////////////@@@@%%%%%%%#(((((//,,//                                           @@@@//////////////////    //
//    ///////////////////,,,,     ,&&&@@@@@@@@%%%#(((////,,,,  ..                      ,,&&             @@@@//////////////////    //
//    ///////////////,,,,,,       *@@@////@@@@@@@&(((////,,,,,,,.                      **@@             @@@@//////////////////    //
//    ////////,,,,,,,,,        @@@@@@@*///////@@@@@@@////,,,,,,,,,                     **@@           ,,@@@@/////,,,,,,,,,,,,/    //
//    //////,,,,       ,,  &&&&@@@@&&&&&&&//////,****@@@@&&&&,,,,,,,,,,,,,,,,,&&&&&&&&&&&@@&&&&&&&,,,,@@@@//,,,,,            ,    //
//    //////,,,,         ,,@@@@///*,,,,,,,@@@@,,,. ,,,,,,@@@@@@@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@,,,,,.                    //
//    ////////,,,,     @@@@@@@@///*,,,,,    ,,@@,,,  ,,  ,,,,@@@@@@@,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@    ,,,                   //
//    //////////**,,,[email protected]@@@////,,,,,            @%,,,..         .///@@@@@@@@@@@@@@@@@@@@@@@@@@@@((//,,         ..          ..     //
//    /////////////////@@@@////,,,.              *@@@,,             ,,@@%%%%%%%%%%%@@,,,,@@@@///////,,,,         ,,      ,,       //
//    /////////////(@@@@@@@////,,                *@@@,,               ,,@@@@@@@@@@@,,    @@@@/////////,,,,,,       ,,,,,,,,       //
//    /////////////(@@@////,,,,,,               %&@@@..           ////      (((((.     &&//@@@&/////////**********************    //
//    /////////////(@@@////,,,,                 @@@,,             (#####  #####/       @@////@@@//////////////////////////////    //
//    /////////////(@@@////,,,,                 @@@,,,,             ######  ###/       @@////@@@//////////////////////////////    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CTLD is ERC1155Creator {
    constructor() ERC1155Creator("Checks - The Lost Donkeys Edition", "CTLD") {}
}