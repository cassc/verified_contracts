// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DAMNENGINE
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                         ╓█W                                //
//                                                       ╔██████                              //
//                                                     ▄██████████,        ,╓▄███,            //
//                                                   ███████████████,   ██████████▌           //
//                                                ,███████████████████,  ▀██████████          //
//                                              ╓███████████████████████  '██████████         //
//                                            ╔██████████████████████████,  ██████████        //
//                                          g█████████████████████████████╕  ██████████       //
//                                        █████████████████████████████████╕  █████████▌      //
//                                     ,█████████████████▀  "███████████████   █████████      //
//                                   ╓█████████████████▀      ███████████████  j██████▀`      //
//                                 ╔█████████████████▀         ╙█████████████▌  ██▀"          //
//                               g█████████████████`            ▐█████████████                //
//                             ██████████████████                █████████████   ███╦╓,       //
//                          ,█████████████████▀                  ▐████████████   █████████    //
//                        ╓█████████████████▀                    ╞████████████   ████████▌    //
//                      ╔█████████████████▀                      ╞████████████  ╒████████▌    //
//                    ╔█████████████████`                        █████████████  █████████▌    //
//                  ██████████████████                          ,████████████╛  █████████     //
//               ,█████████████████▀                            █████████████  ▐█████████     //
//             ╓█████████████████▀                            ,█████████████  ┌█████████      //
//           ╓█████████████████▀                             ██████████████   █████████▌      //
//         ╔█████████████████▌                             g██████████████   ╨▀▀▀██████       //
//         ▀███████████████████▄,                       ╓████████████████  ,W                 //
//           ▀█████████████████████╦,              ,╓██████████████████╜  ╔███╗               //
//             ██████████████████████████████████████████████████████▀  ,███████,             //
//               ╙█████████████████████████████████████████████████▀  ,███████████            //
//                  ▀████████████████████████████████████████████`  ,███████████▀             //
//               ██,   ▀█████████████████████████████████████▀`   ╔████████████`              //
//              ██████,   `▀█████████████████████████████▀"   ,▄█████████████╜                //
//             ▐██████████,    `╙▀▀███████████████▀▀▀`    ,⌐  ▀████████████`                  //
//            ╔████████████████╦,,                 ,,╓█████▌    ╙███████▀                     //
//             ╙████████████████████   █████████████████████       ▀█▀                        //
//                "▀███████████████    █████████████████████                                  //
//                    "▀█████████▀      ████████████████████                                  //
//                          "▀▀▀╜       ▐█████████████▀▀"                                     //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract DMN is ERC721Creator {
    constructor() ERC721Creator("DAMNENGINE", "DMN") {}
}