// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Blast
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                 //
//                                                                                                                 //
//          :::::::::  :::            :::      :::::::: :::::::::::              :::     ::::::::: :::::::::::     //
//         :+:    :+: :+:          :+: :+:   :+:    :+:    :+:                :+: :+:   :+:    :+:    :+:          //
//        +:+    +:+ +:+         +:+   +:+  +:+           +:+               +:+   +:+  +:+    +:+    +:+           //
//       +#++:++#+  +#+        +#++:++#++: +#++:++#++    +#+              +#++:++#++: +#++:++#:     +#+            //
//      +#+    +#+ +#+        +#+     +#+        +#+    +#+              +#+     +#+ +#+    +#+    +#+             //
//     #+#    #+# #+#        #+#     #+# #+#    #+#    #+#              #+#     #+# #+#    #+#    #+#              //
//    #########  ########## ###     ###  ########     ###              ###     ### ###    ###    ###               //
//                                                                                                                 //
//                                                                                                                 //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BLAST is ERC721Creator {
    constructor() ERC721Creator("Blast", "BLAST") {}
}