// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 8 Week Edition Set Tokens
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                             //
//                                                                                                             //
//     ,-.    ,   .         ,     ,--.   .   .                    ,-.      .     ,---.     ,                   //
//    (   )   | . |         |     |      | o |   o               (   `     |       |       |                   //
//     ;-:    | ) ) ,-. ,-. | ,   |-   ,-| . |-  . ,-. ;-. ,-.    `-.  ,-. |-      |   ,-. | , ,-. ;-. ,-.     //
//    (   )   |/|/  |-' |-' |<    |    | | | |   | | | | | `-.   .   ) |-' |       |   | | |<  |-' | | `-.     //
//     `-'    ' '   `-' `-' ' `   `--' `-' ' `-' ' `-' ' ' `-'    `-'  `-' `-'     '   `-' ' ` `-' ' ' `-'     //
//                                                                                                             //
//    ,-.         ,-. .         .   ,---.         ,       .                                                    //
//    |  )       /    |         |     |           |       |                                                    //
//    |-<  . .   |    |-. ,-: ,-|     |   ,-. ;-. | , ,-. | ,-. ,-. ;-.                                        //
//    |  ) | |   \    | | | | | |     |   | | |   |<  |-' | `-. |-' | |                                        //
//    `-'  `-|    `-' ' ' `-` `-'     '   `-' '   ' ` `-' ' `-' `-' ' '                                        //
//         `-'                                                                                                 //
//                                                                                                             //
//                                                                                                             //
//                                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract Set is ERC721Creator {
    constructor() ERC721Creator("8 Week Edition Set Tokens", "Set") {}
}