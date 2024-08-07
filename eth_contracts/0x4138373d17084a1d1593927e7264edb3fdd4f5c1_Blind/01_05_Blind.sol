// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Checks Never Say Die
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//                                                                    //
//     __                                     __          _           //
//    /  |_  _  _  |  _    |\| _     _  __   (_  _  \/   | \ o  _     //
//    \__| |(/_(_  |<_>    | |(/_\_/(/_ |    __)(_| /    |_/ | (/_    //
//                                                                    //
//                                                                    //
//          _______________                                           //
//         /               \                                          //
//        /                 \                                         //
//       /                   \                                        //
//     |      /\       /\      |                                      //
//     |     (  )     (  )     |                                      //
//     |      \/       \/      |                                      //
//       \         _         /                                        //
//        \       / \       /                                         //
//         \               /                                          //
//           |  |  |  |  |                                            //
//           |  |  |  |  |                                            //
//           |  |  |  |  |                                            //
//           |  |  |  |  |                                            //
//           |  |  |  |  |                                            //
//           |  |  |  |  |                                            //
//                                                                    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract Blind is ERC1155Creator {
    constructor() ERC1155Creator("Checks Never Say Die", "Blind") {}
}