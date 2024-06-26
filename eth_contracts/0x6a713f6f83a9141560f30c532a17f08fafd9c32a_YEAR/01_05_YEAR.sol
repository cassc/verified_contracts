// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: A Very Good Year
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                          //
//                                                                                                                          //
//        __        _    _                               __                                 _     _                         //
//        / |       |   /                              /    )                      /        |    /                          //
//    ---/__|-------|--/------__----)__---------------/----------__-----__-----__-/---------|---/------__-----__----)__-    //
//      /   |       | /     /___)  /   )  /   /      /  --,    /   )  /   )  /   /          |  /     /___)  /   )  /   )    //
//    _/____|_______|/_____(___ __/______(___/______(____/____(___/__(___/__(___/___________|_/_____(___ __(___(__/_____    //
//                                          /                                                /                              //
//                                      (_ /                                             (_ /                               //
//                                                                                                                          //
//                                         ______              __       __)                                                 //
//                                       (, /    )           (, )  |  /      ,     /)                      /)  /)           //
//                                         /---(                | /| /   _      _ (/    _ __   _  _/_  _  //  //  _  __     //
//                                      ) / ____)  (_/_         |/ |/  _(/__(_ (__/ )__(/_/ (_/_)_(___(/_(/_ (/__(/_/ (_    //
//                                     (_/ (      .-/           /  |                                                        //
//                                               (_/                                                                        //
//                                                                                                                          //
//                                                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract YEAR is ERC721Creator {
    constructor() ERC721Creator("A Very Good Year", "YEAR") {}
}