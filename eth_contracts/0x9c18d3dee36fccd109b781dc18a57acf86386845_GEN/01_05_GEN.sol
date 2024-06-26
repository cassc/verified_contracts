// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Generative by Godwits
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//     ██████╗ ███████╗███╗   ██╗███████╗██████╗  █████╗ ████████╗██╗██╗   ██╗███████╗    //
//    ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██║██║   ██║██╔════╝    //
//    ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ██████╔╝███████║   ██║   ██║██║   ██║█████╗      //
//    ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ██╔══██╗██╔══██║   ██║   ██║╚██╗ ██╔╝██╔══╝      //
//    ╚██████╔╝███████╗██║ ╚████║███████╗██║  ██║██║  ██║   ██║   ██║ ╚████╔╝ ███████╗    //
//     ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═══╝  ╚══════╝    //
//                                                                                        //
//    ██████╗ ██╗   ██╗                                                                   //
//    ██╔══██╗╚██╗ ██╔╝                                                                   //
//    ██████╔╝ ╚████╔╝                                                                    //
//    ██╔══██╗  ╚██╔╝                                                                     //
//    ██████╔╝   ██║                                                                      //
//    ╚═════╝    ╚═╝                                                                      //
//                                                                                        //
//     ██████╗  ██████╗ ██████╗ ██╗    ██╗██╗████████╗███████╗                            //
//    ██╔════╝ ██╔═══██╗██╔══██╗██║    ██║██║╚══██╔══╝██╔════╝                            //
//    ██║  ███╗██║   ██║██║  ██║██║ █╗ ██║██║   ██║   ███████╗                            //
//    ██║   ██║██║   ██║██║  ██║██║███╗██║██║   ██║   ╚════██║                            //
//    ╚██████╔╝╚██████╔╝██████╔╝╚███╔███╔╝██║   ██║   ███████║                            //
//     ╚═════╝  ╚═════╝ ╚═════╝  ╚══╝╚══╝ ╚═╝   ╚═╝   ╚══════╝                            //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract GEN is ERC721Creator {
    constructor() ERC721Creator("Generative by Godwits", "GEN") {}
}