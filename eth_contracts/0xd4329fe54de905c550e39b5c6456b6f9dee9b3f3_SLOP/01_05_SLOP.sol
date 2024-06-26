// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: SlopCulture_
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                //
//                                                                                                                //
//                                                                                                                //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐▌    ▐  ▓   ▐▓            ▐  ▌░  ▌▌▐  ▐   ▓  ▐  ▐  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐▌    ▐  ▓   ▐▓            ▐  ▌░  ▌▌▐  ▐   ▓  ▐  ▐  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐▌    ▐  ▓   ▐▓            ▐  ▌░  ▌▌▐  ▐   ▓  ▐  ▐  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐▌    ▐  ▓   ▐▓         ▄▄▄▄▄▄█▄▄ ▌▌▐  ▐   ▓  ▐  ▐  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐▌    ▐  ▓   ▐▓  ▄▄▄█████████████████▄▄▐   ▓  ▐  ▐  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐▌    ▐  ▓   ▄███████▀▒▒▒▒▒▒▒▒▒▒▒▀███████████▄▄  ▐  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐███████████████████▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀█████████▄▄  ▓  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌ ▄████████████████▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀██████████  ▓   ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒█████▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀█████████▄  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▄████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀████████▄▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐████▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████▄    ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▀█████   ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░▄███▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▄▄▄██▓▓█████▓▓▓▓▓▓█████████████▄▒▒▒▒▒▒▒▒▒▒▒▒████▄▄▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▓▓█▀▀▓▀▀▀▀▀ ▀▓██▒▓▓▓▓▓██▓▓▀   ▀▓▓██▓▀  ▀▓███████████▄▄▒▒▒▒▒▀████▄▌ ▐   ▐▌▐    //
//        ░  ▓▐ ███▒▒▒▒▒▒▒▒▒▓▀▀   ▀▓▓▓▌           ▓▓▓▓   ▓▓▓▓      ▐▓▓▓▓▓▓   ▓▓███████████████████████▄▐   ▐▌▐    //
//        ░  ▓▐▐███▒▒▒▄▓▓▓▀         ▓▓            ▐▓▓▓    ▓▓▓   ▄   ▓▓▓▓▓███████████████████████████████   ▐▌▐    //
//        ░  ▓▐ ███████▌▓▓           ▓             ▓▓▌    ▓██▓▄▄▓▓▄▄▓▓██████████████████████████████████▀  ▐▌▐    //
//        ░  ▓▐ ░▀▀█████▓▓▓          ▐▌  ▄▄▄▄     ▓▓▌    ▐▓█████▓▓██████████████████████████████████████   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▀███▓▓▌         ▐▓▓██████████████████████████████████▀▀▓▒▓▓▓▀     ▓██████████▀▒▒███   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▐███▓▓▄   ▄▓██████████████████████████████████▓▓       ▐█▌▓▓▓▓▓▄▓▓██████▀▒▒▒▒▒████   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒█████▓▓ ▐▓██████████████████████████▀     ▀█▓▓▄       ▓█████▓▓▓▀▒▒▒▒▒▒▒▒▒▒▒████▀▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒█████▓▓▓▓▓███████████████████▀▀▀███▌       ▐▓▓▓▓▓▓▓▄▄▓█▀▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒████▌▌▀▓███████▀▀▀▓ ▀▀▀▀▓▓      ▐▓▓▓▄     ▄▓██▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄█████▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒█████▌ ▀▓▀▀▀▀    ▄▓▓▄▄▄▄▓▓▄▄▄▄▄▄▓▓█▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████▀  ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒█████▌▌ ▄   ▄▄▓▓▓▓▓██▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄▒▒▄▒██▓██████▀     ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▓█████▓▓▓▓▓▓▓▓▓▓▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▌█▒██▓████ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌▀███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▌█▒██▓█▀ ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌▐█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌█▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██████▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒█▒█▐▓▌█▒█▒▒▒▒▒▒▄████████████▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▐██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▌█▒█▐▓▌█▒███████████████  ▐██▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒█████▒▒▒▒█▒█▒█▐▌▒█▒▒▒▒▄▄▄███▌█▒█▐▓▌█▒███████████▀▀ ▓  ▐██▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌▀████████▒█▒█▐▌▒███████████▌█▒█▐▓▌█▒████████▀▀▐   ▓  ▐██▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ▒▀█████▒█▒█▐▌▒█▀▀▀█████▀█▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐██▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    █▌█▒█▐▓▌█▒█▌░  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//        ░  ▓▐ ░  ▐▐▌▒▌  ░ ▐▓░▐█▒█▒█▐▌▒█   ▐▓    v▌u▒l▐▓▌o▒n▌_  ▌▌▐  ▐   ▓  ▐ █▒▌█▒██▓█  ▌ ▌      ▌▐▌ ▐   ▐▌▐    //
//                                                                                                                //
//                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SLOP is ERC721Creator {
    constructor() ERC721Creator("SlopCulture_", "SLOP") {}
}