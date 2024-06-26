// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Route Checks
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////
//                                          //
//                                          //
//                                          //
//                          __              //
//    _______  ____  __ ___/  |_  ____      //
//    \_  __ \/  _ \|  |  \   __\/ __ \     //
//     |  | \(  <_> )  |  /|  | \  ___/     //
//     |__|   \____/|____/ |__|  \___  >    //
//                                   \/     //
//                                          //
//                          __              //
//    _______  ____  __ ___/  |_  ____      //
//    \_  __ \/  _ \|  |  \   __\/ __ \     //
//     |  | \(  <_> )  |  /|  | \  ___/     //
//     |__|   \____/|____/ |__|  \___  >    //
//                                   \/     //
//                                          //
//                          __              //
//    _______  ____  __ ___/  |_  ____      //
//    \_  __ \/  _ \|  |  \   __\/ __ \     //
//     |  | \(  <_> )  |  /|  | \  ___/     //
//     |__|   \____/|____/ |__|  \___  >    //
//                                   \/     //
//                                          //
//                          __              //
//    _______  ____  __ ___/  |_  ____      //
//    \_  __ \/  _ \|  |  \   __\/ __ \     //
//     |  | \(  <_> )  |  /|  | \  ___/     //
//     |__|   \____/|____/ |__|  \___  >    //
//                                   \/     //
//                                          //
//                                          //
//                                          //
//////////////////////////////////////////////


contract spots is ERC1155Creator {
    constructor() ERC1155Creator("Route Checks", "spots") {}
}