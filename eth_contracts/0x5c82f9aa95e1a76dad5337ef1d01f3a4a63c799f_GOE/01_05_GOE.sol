// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: openEdition
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                             //
//                                                                                             //
//    IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII          //
//    I                 @@& @@@@@@@@# #@@@@    @@@@@@   @@@@@@@@@@@@@@@@  @         I          //
//    I                 @@@@@@ @@@ @@@@@#&&@ @  @@@@@@@@@@@@@@@@@@@@@@@             I          //
//    I                    @@/ @ @@@@ /@@@@@*   @@@@@  @@@@@@@@@@@@@@@@@@           I          //
//    I                   @@,  @@@@@@@@@@@@*@@@@@@@   @@@@@&@@@@@@@@@@@@@@          I          //
//    I                   @@@@@@@@@@@@@ @@ ,@@ &@@@@(@@@@@@@@@@@@       @@          I          //
//    I                        @@@@@% @@@@@@@@@@@@@@@@@@@@@@@@@@#                   I          //
//    I                         @@ @@@@@@@@@@&@@@@ @@@@   @@@  @@                   I          //
//    I                       @@@@@@@@@@@@@@@@  @    @     @    @@@                 I          //
//    I                         @@@@@@@@@@@@         @     @                        I          //
//    I                         @@@@@@@@ @                                          I          //
//    I                       @@@@@@@@  @@                                          I          //
//    I                       @@%@@@@@@@@@@@.,@@@@@@@@                              I          //
//    I                        @@@@@@@@@@&(@    @@@@                                I          //
//    I                         @@@@@@   @@@     &@                                 I          //
//    I                           @@@@@   @@                                        I          //
//    I                           @@@@@@*@@@@@@/       @                            I          //
//    I                            @@@@@@@@@,       @@@@                            I          //
//    I                             @@@@@@@@@@@@@[email protected]@@@  @@                          I          //
//    I                             @@@@@ ,@@@@   @ ,. *@@@@                        I          //
//    I                        @  @@@@@@@@@@&  @@@@@  ,*@@@@@@@                     I          //
//    I                   *@@@@@@@@@@@@@@@@@@@@&@@@&  @@@@@@@@@@@@@                 I          //
//    I            [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@,@@@@@@            I          //
//    I           @@&@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@/  @@@@@@@@@@@#      I          //
//    I          @@@@@@@@@@@@   @@@@@@@@@@@@@  @@@@@@@@@@@@@[email protected]@@@@@@@@@@@@@@@@      I          //
//    I         @@@@@@@@@@@@@@@@@@@(         @@@@@@@@@@@@@@@@@@*@@@@@@ @@@@@@@@     I          //
//    I        @@@@@@@@@@@@@@@@@@@@       @@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@,   I    I	    //
//    IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII          //
//                                                                                             //
//                                                                                             //
/////////////////////////////////////////////////////////////////////////////////////////////////


contract GOE is ERC1155Creator {
    constructor() ERC1155Creator("openEdition", "GOE") {}
}