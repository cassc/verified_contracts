// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: After Love
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//        ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//        █████████████████████████████████████████████████████████████████████████████████████████████████▓▓▓    //
//        ███████████████████████████████████████████████████████████████████████████████████████████████▓▓▓▓▓    //
//        ██████████████████████████████████████████████████████████████████████████████████████████████▓▓▓▓▓▓    //
//        █████████████████████████████████████████████████████▌▄█████████████████████████████████████▓▓▓▓▓▓▓▓    //
//        ███████████████████████████████████████████████▀███▀▄████████▀▄▄█▌█████████████████████████▓▓▓▓▓▓▓▓▓    //
//        █████████████████████████████████████████████▄██▀▄████████▀▄█████▄████████████████████████▓▓▓▓▓▓▓▓▓▓    //
//        ██████████████████████████████████████████▄███▀▄████████▀▄█████▄█████████████████████████▓▓▓▓▓▓▓▓▓▓║    //
//        █████████████████████▀▄████▄█▀█████████▄████▀▄████████▀▄████▄██▀ ,▄█████████████████████▓▓▓▓▓▓▓▓▓▓ÜÜ    //
//        ████████████████████▌█████████▄████▀▄████▀▌▄███████▌▀▄█▀█▄███▀`╓▄███████████████████████▓▓▓▓▓▓▓▓▓ÜhÜ    //
//        ████████████████████▐██████████▄▀██████▀╓▄███████▀ ,▄▄████▀^ ,▄▄▄████████████▀▀█████████▓▓▓▓▓▓▓▓▓ÜhÜ    //
//        ████████████████████▄██████████▄▐████▀╓▄███▌▀██▀ ▄██████▌^ ,██████▀▀██▀█████▀▄▀▀████████▓▓▓▓▓▓▓▓▓ÜµÜ    //
//        █████████████████████▄▀███▀█▄███▐██▀╓████▀▀ ▄▀ ▄██████▌▀ ▄████▀▀ ▄██▀▀▄███▄██▀ ▄████████▓▓▓▓▓▓▓▓▓ÜhÜ    //
//        ████████▀▀█████████████L▀B█████▌▀ ,▄██████▌^ 4███████▀ ▄█████ ,▄▄▄▄███▀▄███▀╓▄██▀▄██████▓▓▓▓▓▓▓▓▓ÜhÜ    //
//        ███████W█▄███████████▄████▄███▀  ▐▀█▄████  ▄████████▀▄██▀▄██▌▐██████▄█████ ▄▀▀▄█████████▓▓▓▓▓▓▓▓▓ÜhÜ    //
//        ██████████▀▀▀▀██▄▄███████████▄▄▄██████▌  ▄████▀▀▀████▄████████RÇ▀▀████████▄██████████████▓▓▓▓▓▓▓▓ÜhÜ    //
//        █████████████████████████████████████▀ ,▄▄███████████████▀▀▄▄████ ███████████████████████▓▓▓▓▓▓▓▓hhÜ    //
//        ███████████████████████████████████▀,▄████████████████▀▀▄███████▌▄███████████████████████▓▓▓▓▓▓▓▓hhÜ    //
//        ████████████████████████████████▌▀,▄████████████████▀╓▄██████▀,▄██████████████████████████▓▓▓▓▓▓▓hhÜ    //
//        ██████████████████████████████▌  ▄████████████████▀╓██████▀█▄█████████████████████████████▓▓▓▓▓▓▓ÜhÜ    //
//        ████████████████████████████████⌐███████████████▀,▄███▀█▄█████████████████████████████████▓▓▓▓▓▓▓▓hÜ    //
//        █████████████████████████████████▄▀███████████▀ ]▀█▄▄█████████████████████████████████████▓▓▓▓▓▓▓▓hÜ    //
//        ████████████████████████████████████▄▄▄▄▄▄▄▄  ,▄██████████████████████████████████████████▓▓▓▓▓▓▓▓Üh    //
//        ██████████████████████████████████████████▀` ▄██████████▀▀█▄█▀█████▀█▀████▀▀████▀▀▀▄▄▀████▓▓▓▓▓▓▓▓▓h    //
//        █████████████████████████████████████████▀ ▄████████▀▀ ,▄███▌▐███▄█▀ ▄███▀▄█▀▀ ╓▄██▀▄▄████▓▓▓▓▓▓▓▓▓h    //
//        ██████████████████████████████████████▀ ,▄█████████  ,████▀▌▄▄▄█▀  ▄███▀▄▄▄` ▄▄▄▄█████▄██▓▓▓▓▓▓▓▓▓║µ    //
//        ███████████████████████▀██▄██▀▀▀███▀█▄██████████▄██ █████▄██████ ▄██▀▄▄████▌▐███▀▀▄▄████▓▓▓▓▓▓▓▓▓▓ÜÜ    //
//        ███████████████████████▄█▀▀▀▀▀█▄▄▄▄▄██▀▀▀▀▀█▄▄███████████████████▄███████████▄▄███████▓▓▓▓▓▓▓▓▓▓▓║hÜ    //
//        ████████████████████████████████████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║ÜhÜ    //
//        ███████████████████████████████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓hhÜÜh    //
//        ████████████████████████████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ÜhhÜÜ▒▒░    //
//        ████████████████████████████████████████████████████████████████████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓║hµÜÜÜ▒░░░    //
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract AfterLove is ERC721Creator {
    constructor() ERC721Creator("After Love", "AfterLove") {}
}