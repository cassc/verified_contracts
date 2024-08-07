// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: VIP_MEMBER
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////
//                                                                //
//                                                                //
//                __..                     ..__                   //
//             .gd$$$$$b                 .$$$$$bp.                //
//            d$$$$$$$$$$               $$$$$$$$$$b               //
//           g$$$$$$$$$$$$     ___     $$$$$$$$$$$$p              //
//          !$$$$$$$$$$$$$.--''   ''--.$$$$$$$$$$$$$!             //
//          !$$$$$$$$$P^"               '-$$$$$$$$$$!             //
//           T$$$$$$P"                     '-$$$$$$P              //
//           !$$$$P"                          $$$$$!              //
//            T$$P                             $$$P               //
//             ^$        .             .        $^                //
//             :      .d$$             $$b.      :                //
//             :   .d$$$$$b           d$$$$$b.   :                //
//            :   g$$$$$$$$           $$$$$$$$p   :               //
//            :  d$$$$$$$$$b         d$$$$$$$$$b  :               //
//           :  !$$$$$$$$$$$         $$$$$$$$$$$!  :              //
//           :  $$$$$$$(O)$$b _..._ d$$(O)$$$$$$$  :              //
//           :  $$$$$$$$$$P^"       "^T$$$$$$$$$$  :              //
//            : T$$$$$$$P"     _._     "T$$$$$$$P :               //
//            : '$$$$$P       $$$$$       T$$$$$' :               //
//            :  "$$$P        "T$P"        T$$$"  :               //
//             :   T$           :           $P   :                //
//             :                :                :                //
//              :    "      _..' '.._      "    :                 //
//               :   '.                   .'   :                  //
//                '-.                       .-'                   //
//                   '-. '-._  __   _.-' .-'                      //
//                      '--.._ ___ _..--'                         //
//               ....eee$P"   """""    "T$aaa..._                 //
//          _.ee$$$$$P""                  ""T$$$$$aa.             //
//       .gd$$$$$$$P"                  fsc   "T$$$$$$bp.          //
//                                                                //
//                                                                //
////////////////////////////////////////////////////////////////////


contract VIP is ERC721Creator {
    constructor() ERC721Creator("VIP_MEMBER", "VIP") {}
}