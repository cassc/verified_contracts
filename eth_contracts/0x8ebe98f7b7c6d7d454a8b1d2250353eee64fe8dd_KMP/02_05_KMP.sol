// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Krampus
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        █████████████████████████████▓╣╬╠╚╙╙╚░└░░│╙╙╙╚╚╩╬▒╠╬▓▓███████▓╬╣▓███████████████    //
//        █████████████▓╬╬▓████████████▒╠▒░░░░░░'-:¡░░░░░φ╚╠╠╣██████▓╬╬╣▓▓████████████████    //
//        ███████████████▓▒▄╠╬▓██████╬╬╬╠▒φ░≤φφ░;╓░;░░░░░░φ╠╠╠╬████╬╬▒╠╬▓█████████████████    //
//        ███████████████████▓╬▒╠╬╬▓▓╣▓▓╣▒φφ╠╬░-░╠▒▒░,░▒░,▒╠╢╬╬╬╬╬╬▓╬╠▓███████████████████    //
//        ██████████████████████▓╣▓╫╢╚╠╢╬▒░╙╠╬▒▒╔╣╬▓▒φ▒╠░,░φ╠╠╣╩╠╣╬▒╠╠████████████████████    //
//        ██████████████████████╬╬█▓▒░¼╙╚╣▒φ░░∩░░╠╟╬'░┐░φφ╬╫▀▒▄╢╣▓▌╠▓█████████████████████    //
//        ███████████████████████╬████▓▓▒╦░░▒░░,5╠╠▒░,≡░Γ░│░▄╬▓▓██╬▓▓█████████████████████    //
//        ██████████████████████╬╬████████▓▓╬▓╬╬▓█╬█▓▓╫╬╬╬╣▓██████╬╠██████████████████████    //
//        ████████▓▓▓╬╬▀▓██████▓╣╬╫████████████╬╬▒▒╠╬╬╬██████████▒╠▒╬███▓▓▓▓▀╬╬╬╬▄▓▓▓▓████    //
//        ███████████████▓▓▓▓██╣╬╬╣▓▓█╬╬╬▓█████╬▒░░░φ╠╣█████╬╬╬█▓╢╢╠╬▓▓▓▓▓▓▓▓█████████████    //
//        ████████████████████╬╬╬╣╣██▓╬╬╬╣▓╬▓▓██╬╠╩╠╠╬▓▓▓▓╬╬╠╬╣╫▓▓╬╫╬╬████████████████████    //
//        ████████████████████▓▓╣╬╬╩╠╩╝╣╬╬╠╠╠╬▓╬▓▒▒▒╠╠╣╬╠╠╠╬╩╫╫╬╩╠╠╠╬╬████████████████████    //
//        ██████████████████████▓▓▓╬▄╣▓╫╬╬╬╣╬╩╬█▓▓▒╬╬╣▓╩╠╬▒╠╠▒φ▒▒╠╬╣▓▓████████████████████    //
//        █████████████████████████████▓╬▒╟███▓███████▓▓▓█▒╠╫╣▓██▓▓▓██╣███████▓▓▓█████████    //
//        ███████████████████████████▓█╬╣▓█╬╬█▓▒╟▓██╬╙╫█▓╬█▓╬╬╣▓██████▓█████▓╬╬▓██████████    //
//        ████████▓██████████████████▓▓▓██╬╬╠▒╩░╙╣▓╬╩░╠╬╙╠╣▓█▓▓╬╬▓██████▓▓╬╣▓█████████████    //
//        █████████▓▓▓██████████████████╣▓█▓╬╬╣▄▒φ▒φ░φ▄▓▓╬▓╬███▓▓██████████████▓▓█████████    //
//        █████████▓▓▓▓████████████████╣╣▓█████▓╬╚█▌╙╬╣████▓╬╬╣▓▓█████████▓▓▓▓▓▓▓█████████    //
//        █████████▓▓▓▓██████████████▓▓▓▓▓╬╬╬████▓██▓████╬╠█▓╬╬▓█▓▓█████▓▓▓▓▓▓▓▓██████████    //
//        █████████▓▓████████████████▓▓▓█▓▓╬╬╬╬███████▓▓╬╩╬╬█▓▓▓█▓█████▓▓▓██▓▓▓▓▓█████████    //
//        ████████████████████████╣██▓▓▓██▓▓▓▓╬╬╬╬╬╬╬╬╬╬╬╬╬╣▓▓▓███████████▓▓█▓▓▓▓█████████    //
//        ██████████▓███████████████▓█████████▓▓▓▒▒╚╠░╠╣▓▓█▓█▓▓█████████████▓▓▓█▓█████████    //
//        ███████████████████████████████████████████████████▓▓▓█████████▓████████████████    //
//        █████████████████████████████████████▓▓█████▓▓███╬▓╣█████▓██████████████████████    //
//        ██████████████████████████████████████╬█╬█▓╬███▓▓▓▓███████████████████████▓█████    //
//        ███████████████████████████████████████████▓▓██╬╬▓████████████████████████▓█████    //
//        ████████████████████████████████████████▓▓▓▓▓▓▓▓▓███████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        ████████████████████████████████████████████████████████████████████████████████    //
//        █████████████████████████████████████████████████████████████████▓████████████▓█    //
//        ██████████████████████████████████████████████████████████▓███████████████▓█████    //
//        ████████████████████████████████████████████████████████████████████▓███████████    //
//        ███████████████████████████████████████████████████████████████████▓███▓▓███████    //
//        ████████████████████████████████████████████████████████████████████▓▓███▓██████    //
//        ███████████████████████████████████████████████████████████▓▓▓██████████████████    //
//                                                                                            //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract KMP is ERC721Creator {
    constructor() ERC721Creator("Krampus", "KMP") {}
}