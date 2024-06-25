// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ArtVikkyFoto
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////
//                                                            //
//                                                            //
//    ██▓▒­░⡷⠂"""""""""""""""""""""""""""""""⠐⢾░▒▓██          //
//                                                            //
//       █▓▒­░⡷⠂""""""𝔸𝕣𝕥𝕍𝕚𝕜𝕜𝕪𝔽𝕠𝕥𝕠""""""⠐⢾░▒▓█    //
//                                                            //
//    ██▓▒­░⡷⠂"""""""""""""""""""""""""""""""⠐⢾░▒▓██          //
//                                                            //
//                                                            //
//                                                            //
////////////////////////////////////////////////////////////////


contract AVikkyF is ERC721Creator {
    constructor() ERC721Creator("ArtVikkyFoto", "AVikkyF") {}
}