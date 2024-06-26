// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 2023
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ▓▓███▓█▓▓███████▓▓▓▓▓▓╬╬╬▓▓▓██▓▓▓████████▓▓▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬    //
//        ╬╫▓╬╬▓▓╣╣╬╣▓▓███▓█████▓╬╬▓▓▓█▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╣╣    //
//        ▓╬╠╣╬╬╠╠╠╠╠╟▓╬██████▓╬▓███▓▓╬╬▓█▓▓▓▓╣╬╬╬╣╬╣▓▓╣▓▓▓▓▓▓▓╣▓▓▓▓▓▓████▓▓▓╬╬╣╣▓▓▓▓▓▓▓▓▒    //
//        ╬╠╬▒▒▒╠╠╠║▒░░╠╬███▓▓▓▓▓╬╬███▓▓▓╬╬╬▓▓╬╬╬╬╬╬▓▓▓╬▓▓▓▓▓▓▓█▓╬╬╬╬╬╬╢╬╬▓█▓▓▓╣╣╣╣▓▓▓▓▓▓▓    //
//        ╬╠╬▒▒▒╬╠▒╬╬▒Ö½▓▓▓██╬▓▓██▓╣▓╬╬▓╣╬╣╣▓╣▓╬╬╬╬╬╬╣▓╣▓███▓▓▓▓▓▓▓▓▓▓▓▓▓╫╣╣╣╫╬╬╣▓▓╣▓▓▓▓▓▓    //
//        ▓▒╣▒╠╠╝╩╠╠▒φ.╫▓█╟▓██╬▓▓▓▓▒╣╬▓▓╬▓╢╬╬╣▓▓╬╬╬╣╬▓▓▓██▓█▓▓╢╫╬╬▓▓▓▓▓╣╬╣╣╫╣╬╬╬╣▓╣╬▓▓╬▓▓▓    //
//        ▓▓╣╬▒▒╙╙╩╠╢╬░║▓█▒▓▓█▓▓▓╩╣▓╬╬╣▓╬╬╬╬╬╬╬▓╣▓▓▓▓▓▓████▓▓▓▓▓▓▓▓╬╣╣▓▓▓▓╬╣╣╣▓╬╬╫╬╬╬╣╬╣▓▓    //
//        ██▓▓▓╢φ▒▄▒╣▒▒▒╠╬▓╬╣▒╬╬╣▓╝▒░╠╣▓▓▓╠╬╣╫╬▓╣╣▓▓▓▓█▓▓▓▓▓██▓▓╣╬╬╬╫╬╬▓▓▓╠╬╣╣▓▓╬▓▓╣╬╬╣╣╣▓    //
//        █▓█╬▓╬▓▓▓▓▓▓╣╬╠╬▓▓╬╣▓╬╗φ#╠░╚╬╣╬╣╣╬╣▓▓▓▓╬╬╣▓▓╬╬╬╬╬╬╬╬██▓▓▓╬▓╣╬╬▓╬▓▓█▓▓╣╣╣╬▓╟╬╫▌▓▓    //
//        ██▓▓▓▓██▓╬╩╠╠╣▓╠▒╚▓╣▓╬╣▒▒╠╣╬╬╬╫╬╬╬╣▓▓▓╬▓▓▓▓╬╫╬▓▓▓▓▓╣╣╬╬▓▓▓▓╬╬╬╣▓▓╬▓╣▓▓╬╬╢▒╠╬╣▓▓╫    //
//        █████▓▓╬╬╬░╠╠╣╣╬▒╬φ╟╬▓╣╬╢╣╬╣▓▓╬╬▓▓╬╬╬╢╬▓╬▓▓▓▓████▓▓▓▓▓▓▓▓▓▓╣▓╬╬╣╣╟▓╬╬▓▓╬╬▒╠▓╬╬╬╫    //
//        ████╬╬╠▒╚▒░╠╬╬╣╬▓╬▒╬╠╣▓▓╬╩╣╣╬╬╬▓▓▓╢╬╬╫▓▓╬╫▓▓╣█▓▓▓▓▓█╠▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓▓▓▓╫╬╬╣▓╣▓╬╠    //
//        █▓╬╠▒▒░░╔▒╢╬╣▓▓▓▓╬╬╬▓▒╣╣▓▓▒╠╣▓▓▓▓╬▓╬╬╬▓▓╣╫╬▒▒▒╬╣╬▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓╬╣╬╬╬╬╬╫▓╬╬▓▓    //
//        ▒▒▒╚░░░╠╠╫▓╬╬╣▓╬╣╬╣╬╬╣▒╬▓╬╬╣╢▓▓▓▓╬╣▌╬╬▓▓╣▌▒╠▒║╠╬╣▓▓▓╣╣▓╬╣▓▓▓▓▓▓╣╣▓▓▓╬▓▓╬╬╬╣▓╫▓▓▓    //
//        ╬╚░░@░░▒╟╢╬╣╬╬å▓▓▓▓▓▓▓▓▓▓╬╣▓▓▓▓▓█▓▓▓╬╬╬╣▓╣╫╬╬╢▓╬▓▓▓▓▓▓█▓╬╬╬╣▓▓▓▓▓▓▓▓╬╫╬╬╬╬▓▓╚▓▓▓    //
//        ░░â╟▒½▒╟╬▓▓╬╬╬▓▓▓▓▓▓▓▓▓╣╫╬▓╬╣▓▓╬█▓█▓▌╬╣╣▓╫╣▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╣╢▓▓▓▓▓╣▓▓▓╬╬▒▓╬║╬╣▓    //
//        #╠╬╬░╠╠╬╣╬╬╬╣███▓╬╬╫▓╬╬╢╢╣▓╬╣╫╣╬▓█▓▓█╬╬▓▓▓╣▓▓▓▓▓▓▓▓██▓▓▓▓╬╠╬╫╣╢▓╣▓▓╬╬▓▓▓╣╬╬╬╠╬╬╬    //
//        ╬╣╬╠¼╬╟╣╬╬▒╬▓██▓▓▓╣╬╬╬╬╬╬╬╬╬╢╣╠╬╬╫█▓▓▓▓▓▓▓▓▓▓██▓█▓▓▓╬╬╣╣╣╬▓╣╬╬╬╬╠╠╬╬╠╬╬╣╬╠▒▒╩╟╬╬    //
//        ▓╬╬╬╠╬▒╠╩╠╢██▓████▓▓▓▓╬╣╬╬╢╬╢╣╬╩╬╠╣▓▓▓▓▓╬▓╬▓▓▓▓▓█╬╬╠╣╣╠╬╣╬╬╣╬╬╢╬▒░Å╠╩▒▒╠╣╣╣╣▓╣▓▓    //
//        ╣╬╬╬╠▒▒╩▒█▓█████████▓▓╬╫▓▓╬╠╬╫╢▒╟╬╬╣╣╬▓╬▓▌╣▓▓▓▓▓╬▒▒▒╠▓▓╬╬╬╬╬╬╬╣╬╬╬╠▒▒φ╠╣╬▓▓▓╬╬╣▓    //
//        ╣╬╬╠░╬╠╠╬░█████████▓██▓▓▓╣╬╠╠╬╣╬╫╬╚╬▓▓▓╣▓╬▓█▓▓╬╠╩░╬╬╬╣▓▒╠╬╢╬▒╝╠╬╬╬╣╠╬╣▓▓██▓█▓╣▓▓    //
//        ╬╬╠╬╣╬╬╠▒░╢█████████████▓▓╬╬╬╬╬╬▒φ╔╚╣╬╬▓▓╫▓██╬╫╬φ▓╬╬▓╬▓▓▒╣▒╠╬╠╬╬╬╠╬╬╬╬╬▓▓▓██▓╣▓╬    //
//        ▓╬╬╣╬╬╣░╠▒▒╣╬█████████▓███▓▓╬╬╬╬╬╫╟▒╙╫╬╣╫╣▓▓▓▓██████▒▓██▓███╬╠▓▓╬▓▓██▒╠╬╬╬╬▓▓▓▓╣    //
//        ▓╬╣╬╬╬╠╬▒▒▒║╫╣████████████████╬╬╬╬╬╬#╚╬╬▓╣▓▓▓▓█▓▓███▄╬╬▓██████████████▓▓▓▓╬╬▓▓█▓    //
//        ▓╬▓╬╬╣╣╬╣╬╬╬╬╬╣╬▓╬╬╬╫▓▓▓╣╣╬╬╬▓███▓▓╬╬▓▒╠╣▓█▓▓█▓▓╬▓▓▓██▓╫╣██▓▓▓███▓███▓╬▓╬▓▓▓▓▓▓▓    //
//        ╬╣▓▓╣▓╣╣▓╣╢╬╬╠╠╠╬╣▓╬▓▓▓╣▓╬▓▓█▓▓▓▓█████▓▓▓▓███▓▓▓╣▓╬╬╩▓██╬▓╬▓█████▓╣▓▓╬▓▓╬╣▓╣╬▓▓▓    //
//        ╣▓▓▓▓▓╣╬╬╠╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬╬▓▓▓▓▓▓██████████████████▓▓▒≥╟██▓▓███▓╬╬╬▒░╬╬▓▓▓╩╫▓╛]▓▓    //
//        ▓▓▓▓▓▓▓╬╣▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓╬╬▓▓▓▓▓█╬╫╣███████████████╬▒░▓██▓╬╬╣▓▓█▓▓╬╢╬▓╬╙╓▓▒,╬╬▓    //
//        ▓▓╬╣▓╣▓▓██████▓▓▓▓▓▓▓╬╢╣▓╫╬╬╬╬╩╣█▓╣╣╬▓████▓╬╬█▓██████▓▓▒███╬╬╠╬╬▓▓▌ ║▓╣╙φ╬╩╔▓╩ ╫    //
//        ▓╬╣▓▓▓▓██████████▓▓▓╢╬╣╬╫╠╣╬╬╬▓█▒▒░φ▓████╬░φ▒╟╝████▓╬╠╬╣╬███╣╬╬╣╩╠▄╣▓╣░╠╬╬φ╣╬ ▓▓    //
//        ▓╬▓▓╬▓███████▓▓▓╬╝╬╬╬╠╠╣╣╬╣▓╢▓█╬╣▀▀▓████╬▒▒▒▒▒╫▓▓█▓▒╬▓╬╬▒▓█▀▀╠╠φ▓╣╬▓╬╠╣╣╩å╬╣░║▓█    //
//        ▓╬▓▓▓▓████▓▓╬╬╠▒φ░░▒╬╬╣╬╩╫╬╫██▓╩▓▓╬▓▓╣█▓╩▒╠▒φ╝╩╙╣▓▓▒▒╠╣▓╬▓███▓╬╣╬╬╬╣▓▓╬▒╣╬╬░╣▓▓▓    //
//        ▓▓▓▓▓██▓╬╬╬╬╬╬╬╬╬╣╣▓▓▓╬Σ╙╠▓███╬╬╬╬╟▓▓██╬╬╩╠▒▄##å▓██▓▒▒╬╣╣▓▓███╣╣╣╬╣╬╢▓╬▓╬╬╗╣╣▓█▓    //
//        ▓█████▓▓╬╬╬╬╬╬╠╠╣▓▓▓▓╬╬╠╟▓▓██▒░▒░╠▓▓▓█▓░╣▒╦φ╠▒╠╬╬╣▓█╬╬╣╣▓╬╣███╬╬╣▓╣▓▓╣▓▓▓▓╣▓▓▓▓╬    //
//        ▒▓██▓▓▓▓╬╫╣╬╣╬╣╣▓▓▓╬╬╬╣╣╣▓▓█▓╬▒╠╠╣▓▓██▒╠▒╠╠╠╠╬╬╬╬╣╣█▓╬╣▓╬╬╬▓██▓╣╣╣╣▓▓╬╣▓▓▓╩╓▓▓╬╣    //
//        ▓▓█▓▓▓▓▓▓▓▓▓▓╬▓▓▓▓╫╣╬╬╬╬▓▓██╬╬╬╬╬▓▓███╬╬╬╬╣╫╣╣╣╬╬╫╣█▓╣▓╣╬╬╬╣███╣╣╫╣╬╣╬▓▓▓╬▓▓╬╬╣▓    //
//        ███▓▓▓▓▓▓╣╬▓▓▓▓▓▓╣╬╬╣╬╬▓▓██╬╠╬╬╬╟▓███▓╣╬╬╬╫╬╣╣╣▓▓╬╣█▓╬╬╬╬╠╟╫███▓╫╣╢╬╣▓▓╬╫▓╣╣╣▓╬╬    //
//        ███▓╬╣╣╬╬▓╣▓▓▓▓▓▓╣▓╣▓▓▓▓▓█▓╬╬╝╬╣╣████▓╬╬╬╬▓▓▓▓▓▓╣╣╣██╬╬╬╬╬╣╫███▓╬╬▓▓█▓╣╣╣▓╬╣▓▓╬▓    //
//        ███▓▓╬╬╬╬╠╣╬▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓╬╣████▓╬╬╬╬╬╬╬╬╬╬╣╬╬▓▓╬╬╬╬╬╬▓█████▓▓╬╣▓╬╬╬╬▓███▓╬    //
//        ▓██╬▓▓╬╬╬╣▓▓╬╬╬╬╬╬╬╬╬▓▓▓▓▓╣╬▓▓▓▓▓████▓╣▓▓▓╣╬╬╬╬╬╠╠╟▓█╬╬╣╣▓▓████████▓▓╬╬╬▓███▓╬╩▒    //
//        ╣███▓╬╬╫╬╬╣▓╣╬╬╬╬╠╬╬╣╬╬╣▓╬╠╬╬╬╬╬▓▓███╬╬╬╬╬╠▒φ╬╠╠╠╠╣▓█▓▓▓▓▓████████▓╬╬▓██████▒▒▒░    //
//        ╣▓███▓╬╬╬╣╣╬╬╣╣╬╬╬╬╬╬╣╬╣╣╬╠╠╬╠╬╠╣╬▓▓█╬╠╠╠╠╬╬╬╬╣╣▓▓╣▓█▓▓▓▓▓████▓▓╬▓███████╬╬▒▒░▒▒    //
//        ▓▓▓████▓╬╬╬╬╢▓╬╬╬╬╣▓▓▓▓╬╣╬╬╬╬╬╬╬╣╬╣╣▓▓╬╬╬╬╬╬╬╬╣╣╣▓▓██▓▓▓██╬╬╣██████▓╬╬╬╬╬╬╝╣╣╬╬▓    //
//        ▓╫████████▓╬╬╬╬╣╣╣╣╬╬╫╬╬╣▓▓▓▓▓▓▓▓╫╣╫▓▓▓▓▓▓▓▓▓▓▓▓█████▓▓▓▓╣▓████▓▓╬╢╣▓▓▓▓▓▓▀╣╬╬╬╬    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract a23 is ERC721Creator {
    constructor() ERC721Creator("2023", "a23") {}
}