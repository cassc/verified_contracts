// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Abstractism
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠▄▄▓▓▓▓▓▓▄▄▄▒▒▒░░░░░░░░░░░░░░░░░░░░░░░░░░░╚╢    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╣███████████████████▓▄▒░░░░░░░░░░░░░░░░░░░░░░░░╫    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╬╠╠╠╠╠╠╠╠╠╠╠╠╠╠▄▓██████████████████████████▒▒░░░░░░░░░░░░░░░░░░░░░╫    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠▓████████████████████████████████▒░░░░░░░░░░░░░░░░░░░╫    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠▓███████████████████████████████████▓▒░░░░░░░░░░░░░░░░░╫    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟███████████████████████████████████████▒░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╢█████████████████████████████████████████▒░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╣███████████████████████████████████████████▒░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╣█████████████████████████████████████████████░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟████████████╬▓╬▓█████████████████████████████░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╬╠╠╠╠╠╠╠╠╠╟████████▓╬╬╬╬╠╢╢╢╢╢╣╣▓▓╣▓▓▓▓▓▓▓██████████████░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟█████▓╢╬╠╠╢╠╠╠╢╢╢╢╢╣╣╣╣╣▓▓▓▓▓▓▓▓█████████████▒░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟█████▒╬╬╬╠╬╬╢╢╢╢╣╢╢╣╣╣╣╣╣▓▓▓▓▓▓▓▓████████████▒░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╣████▓╬╬╬╠╠╠╬╣╠╢╠╣╢╟╣╢╢╢╬╣╣╣▓▓▓▓▓▓████████████▌░░░░░░░░░░░░░║    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟████▒╬╠╬╠╣▓▓▓▓▓▓▓▓▒╣╬╣╬╣╣╣▓▓▓████████████████▒░░░░░░░░░░░░░║    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╬╠╠╠╠╠╠███▓╬╢╢╠╢╫╣╬╬▓█████▓▓╣╣▓▓▓███████████████████░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟██▓╬╬╠╬╬╫╠▓▓█████▓▓╢╢╣▓▓▓█▓▓▓▓▓▓▓▓▓████████▒░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╢╢╬███╬╬╠╠╬╬╬▓▓█████▓▓▒╬╢▓▓▓▓███████████████████▒░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟▓██▓▓▓╬╠╠╠╠╠╠╠╬╠╢╬╢╢╬╬╬╬╢▓▓▓▓▓▓▓╢╬╬╢▓╣▓▓█████▓██▌░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟█████╬╬╠╠╠╠╠╠╠╢╢╢╢╠╬╬╠╠╠╣╣▓▓▓▓▓╣╣╣╣╣╣╣╣▓████████▓░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟███╬╣╬╠╠╠╠╠╠╠╬╬╬╢╠╬╠╠╠╠╢╣▓▓▓▓╣╣╫╣╢╢╢╣╣▓████████▒░░░░░░░░░░░░║    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟▓╬╬╠╢╢╠╠╠╠╠╬╬╠╠╬╢╬╠╠╠╠╬╬╢▓▓▓╣╣╣╢╢╢╣╣▓▓███████▀░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╣╢╬╢╣╠╬╠╠╠╬╠╢╠╢╢╬╣██▓▓▓██▓▓▓╣╣╣╣╣╣▓▓██████▀░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩╬╣╣╬╢╬╬╬╬╠╠╬╬╬╬╬╬╠╬╢╣╣╣╣▓╣╣╣╣▓▓▓███▀╚░░░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟▒╬╢╢╢╠╢╢╢╬╬╬╠╬╟╢╬╢╣▓▓▓▓▓▓▓▓▓████▓░░░░░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╠╠╠╠╠╠╠╣▓╣╣╣╬╢╣╣▓█████████████▓▓▓▓█████╩░░░░░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╟▓▓╣╣╣╣╣╣╬╬╟╣▓▓▓▓▓▓█▓▓▓▓▓████▓░░░░░░░░░░░░░░░░░░░░░░╫    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠░╠╠╣▓▓▓▓╣╣╣╢╣╣╣╣╢╣╣▓▓▓▓▓██████╬░░░░░░░░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╬╠╠╠╠╠╠╠▓█╢╣▓▓▓▓╣╣╣╢╢╢╣╣╣▓▓▓▓████████▒░░░░░░░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩╠╟██╢╢╢▓▓███▓▓▓▓▓▓▓▓▓▓█████████▓▒░░░░░░░░░░░░░░░░░░░░░╟    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╩░░╟▓█╬╢╢╢╣▓▓▓████████████████████╬╣▒░░░░░░░░░░░░░░░░░░Å╣    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠░░░╠╬█▓╠╠╢╢╣╣╣╬╢▓▓▓▓▓▓▓▓▓▓▓██████╬╬╣╢╣▒░░░░░░░░░░░░░░░░╠╬    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠╠░╠╠╠╠░░░░╠╠╬▓▓╢╣╣╣╣╣╣╣╣▓▓▓▓▓▓▓▓▓▓▓████▒╠╠╠╠╬╬▒░░░░░░░░░░░░░░░╠╬    //
//        ╠╠╠╠╠╠╠╠╠╠╠╠░░░░╠╠╩░░░░░░░╠╠╠╣█▓▓╣╣╣╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓████╠╠╠╠╠╢╢╢╬╫▒▒░░░░░░░░░░░╠╬    //
//        ╠╠╠╠╠╠╠╠░░╠░╠╠╟▒╠░░░░░░░░░╠╠╠╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▒░╚╠╠╠╣╢╠╬╬╣╣╣▒▒▒░░░░░░░║╬    //
//        ╠╠╠╠╠╠╠╠░░╠╠╟╣▒╠░░░░░░╠▓▓▓▒╠╠╠╬██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▒░░░░░░╠╢╠╢╠╠╬╫╢╢╠╢▒▒▒░░░║▒    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract ABST is ERC721Creator {
    constructor() ERC721Creator("Abstractism", "ABST") {}
}