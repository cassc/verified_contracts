// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: NOfomo
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                  //
//                                                                                                                                  //
//                                                                                                                                  //
//    /$$$$$$$$ /$$$$$$ /$$ /$$ /$$                                                                                                 //
//    |__ $$__/ /$$__ $$ | $$ | $$ |__/                                                                                             //
//       | $$ /$$ /$$ /$$$$$$ /$$$$$$ | $$ \__/ /$$$$$$ /$$$$$$/$$$$ /$$$$$$ /$$$$$$ | $$$$$$$ /$$ /$$$$$$$ /$$$$$$                 //
//       | $$| $$ | $$ /$$__ $$ /$$__ $$ | $$$$$$ /$$__ $$| $$_ $$_ $$ /$$__ $$|_ $$_/ | $$__ $$| $$| $$__ $$ /$$__ $$              //
//       | $$| $$ | $$| $$\$$| $$$$$$$$ \____ $$| $$\$$| $$ \ $$ \ $$| $$$$$$$$ | $$ | $$\$$| $$| $$\$$| $$\$$                      //
//       | $$| $$ | $$| $$ | $$| $$_____/ /$$ \ $$| $$ | $$| $$ | $$ | $$| $$_____/ | $$/$$| $$ | $$| $$| $$ | $$| $$ | $$          //
//       | $$| $$$$$$$| $$$$$$$/| $$$$$$$ | $$$$$$/| $$$$$$/| $$ | $$ | $$| $$$$$$$ | $$$$/| $$ | $$| $$| $$ | $$| $$$$$$$          //
//       |__/ \____ $$| $$____/ \_______/ \______/ \______/ |__/ |__/ |__/ \_______/ \___/ |__/ |__/|__/|__/ |__/ \____ $$          //
//            /$$| $$| $$ /$$ \ $$                                                                                                  //
//           | $$$$$$/| $$ | $$$$$$/                                                                                                //
//            \______/ |__/ \______/                                                                                                //
//                                                                                                                                  //
//                                                                                                                                  //
//                                                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract fomo is ERC721Creator {
    constructor() ERC721Creator("NOfomo", "fomo") {}
}