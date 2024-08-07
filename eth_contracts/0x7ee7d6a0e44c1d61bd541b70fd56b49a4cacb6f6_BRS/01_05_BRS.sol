// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Berkley Rose Studio
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ░▒▒▒████▓▓▓▓░░░▄██▀▒▒▒███████▓▓▓███▓╣▒▒▒▒▒▒▄▒╢▓████████████████▓╣╢╣╢▓▓███▄▒░░░╚▓    //
//        ░▒░███╢▓▓▓▓░░░███▒▒▒▄█████████▓█████▓▒▒▒▒▒██▒█████▓▒▒▒▒████████▓╬▓▓╣╣╣▓███▌░░░░╙    //
//        ▒▄███▓▓▓▓▓░░░██▀░▒▓▄████████▓█▓██▌███▌▒▒▒██▓████▓▒╣▒▒▒▒████████▌▓▓██▓╢╢╢▓██▄░░░░    //
//        ███▌▓▓▓▓▓ ░░██▌▒╢▓█████████▓▓▓▓▓██▒▒▓▒▒╢▐█████▓▒▒▒▒▒▒▒▀▓████████▓██▓▒▒╢╢▓▓██▄░░░    //
//        ███▓▓▓▓▓ ░░▄█▌▒▒▓█████████▓╢╢▓▓▓██▒▓▓▓╢╢▓████▒╣▒▒▒▒▒▒▒▒▒▓█████████▓╬╢▒▒▒▓▓▓██▌░░    //
//        ██▌▓▓▓▓  ░▐██░░▒▓█████████▒▒▒╢╢███████▓██████▒▒▒▒▒▒▒▒▒▒▒▒█████████╣▒▒████╢╢███ ░    //
//        ██▓▓▓▓  ░┌██▓████████████▒▒▒▒▒▓██████▓▓█████▒╣╣▒▒▒▒▒╣╣╢╢╫████████╣▒▒▒████▓▓▓██▌░    //
//        █▓▓▓▓ ░░ ██▒▓▒▒▓███▓▓███▒▒▒▄▓██████▓╣▓▓█████▒▒▒▒▒▒▄▄██████▓▓▒▓██╣▒▒▒╢███████▓██░    //
//        ▓▓▓▓╛ ░ ██▓▓▒╢╢▓█▓▓▒▓▓▒▓█████████▓╢╣╣╫▓███████████████████▓╢███▓▒▒▒▒████████▓███    //
//        ▓▓▓▓  ░▄██▓▌╢╢▓██▓▒▒▒█████████▓▒▒╢╣╣▒╢╢▓███████████████▓▓▒╢╢███▒▒▒░██████████▓██    //
//        ▓▓▓  ░ ██▓███▓██▓╣▒▒▓████████╢▒▒▒▒▒▓▒▒▒▒▓▓████▀██████▒▒▒▓╢╢▓██▓▒▒░▐██████████▓▓█    //
//        ▓▓▓ ░░▐█▓███████▓╣▓██████▀▓▓▒▒▒▒░▄▓▓╣▒▒▒▒╢▓████▓███▀▀▀▄▒▒╣▓███▒╢░░███████████▓▓▓    //
//        ▓▓ ░  █▓▓███████╣▒▒▓▓▀▀▒╣╢▓▒▒▒▒▒▓▓██▓▓▒▒▒▒▒▓▓███▄▒▒▒▒▒▒▒╢╫▓██▓╣░░████╢▓█████▓▓▓▓    //
//        ▓▌ ░ ██▓███████▓▒▒▒▒▒╢╢╣╬▓▒▒▒▓▄████████▓▒▒▒▒▒▓████▓▒Å▄▄▓▓▓███╣H ▐███▒╢▓██████▓╣╫    //
//        ╣h░░▐█▓████████▓▒▒╢╢╢╣▒▒▓▒▓████████████████▄▒▒▌▓████▓▒╢╢▓███▓╢░ ███▓▒╢▓██████▓▓╢    //
//        ▒ ░^██▓████████╣╢╢╢╢▒▓▓▓███▀░░░░▄████▓▓╣▒▒▒▒███▌▒▓▓█████████▒` ▐███▒▒▒╫██████▓▓╣    //
//        ▓░ ▐█▓█████████╣╢╫▓██▓██▀░░░a█████████▌╢▒▒▒▒███▒╢▒▒▒▒▒▓████▓▒ ░███▌▒▒╢╢▓█████▓▓╣    //
//        F░ ██▓████████▓╣▓███▓▀▀▒░░░▒▒░▄███████▌▒▒▒▒▓███╣╢╢╣▒▒╢██▓██╣[ j███▒▒╢╣╢▓██████▓▓    //
//         ░░█▓▓████████▓▓▓█▓╢▓░▒░░░▄█████████▀▓▒▒▒▒╢▓███╣╫╣╣▒╢▒█▌██▓▒Ü░████▒▒╢╢╫╬▓█████▓▓    //
//         ░ █▓▓▓████▓██▓▌▓▓╢╣▓░░░▐██████████▓▒▒▒▒▒▒╫▓██▓╣╢▓▓╣▒██▐██▒▒  ███▌▒▒▒╢╣╫▓██████▓    //
//        ░░ █▓█▓████▓███▓█╣╢▒╢  ░░████▓▓█▓▓╣▒▒▒▒▒▒▒▓███▒╢╢╣╣╢▒█▌▓██▒H ▐███╢▒╢╢╢╢▓▓██████▓    //
//        ░░░█▓█▓████▓█▓▌▓▓╢╣▒╣@░░░░▀██▌▒▒▒▒▒▒▒▒▒▒▒▓███╣▒╢╢╢╣╣██▒██▌▒  ███▒▒▒▒╢╢╣▓▓█████▓▓    //
//        ░░▐█▓▌▓████▓▓▓▌▓▓╢╣▒▒╢▓▄░░░▐█████▒▒▒▒▒▒▒▓███▓▒▒▒╢╢╢╣██╟██▌▒ `██▌▒▒▒▒╢╢╢╢▓█████▓╣    //
//        ░░██▓▓▓▓███╣▒▓▌▓▓╢╣▒▒▒╢▓██████████████████▓▒▒▒▒▒╢╢╢▒█▌▐██▌▒  ██▌▒▒▒▒▒▒╢╢▓█████▌▓    //
//        ░,██▓█████▓╣▒╢▓▓▓╣╣▒▒▒▒▓██████████████▓▓▓╣╣▒▒▒▒▒╢╢╢▒█▌▓██╣╣ ░██▒▒▒▒▒▒▒▒╢▓██████▓    //
//        ▒▐█▓▓█████▓╣▒▒▓╬▓╣╣▒▒▒▒▒╢▓██████▓▓▓▓╢╢╢╢▒▒▒▒▒▒▒╢▒╢╢▒█▒▓██╣╣ ░██╢▒▒▒▒▒▒▒▒▓██████▓    //
//        ▒▓█▓▓█████▓╣╣╢╫▓╢▓╣╣▒▒▒▒╢╢╣╢╢╢╣╢█▓▒╣╢▒▒▒▒▒▒▒▒▒╢╢╣╢▒▒▓▒▓██╣[ ]██▒▒▒▒▒▒▒▒▒▓██████▓    //
//        ▒▓█▓▓█▓▓███▓▒▒▒▓▌▓▓╢▒▒▒▒▒▒╢▒╣▒╢▒▓▒▌▒▒▒▒▒▒▒▒▒▒▒╢╢╢╢╣▓▓▒▓██╣[  ██▒▒▒▒▒▒▒╢▒╫██████▓    //
//        ▒▐█▓▓█▓▓███▓▒▒▒╬▓▒▓▓╣╣▒▒▒▒▒▒▒▒▒▐▒▒█▒▒▒▒▒▒▒▒▒▒╢╢╢╣╢▒▓▓▒▒██▓╣░░██▓▒╢▒▒▒╢╢╢▓██████▓    //
//        ▒▓█▓▓▓▌▓▓██▓▒▒▒▒▒▓▓▓▓╣╣╣▒▒▒▒▒▒▒▓▒▒▓▒▒▒▒▒▒▒▒╢╢╢╣╢╣▒▓▓▓▒▒██▓╣░░██▒▒▒▒╢╢╣╢╣▓██████▓    //
//        H▓█▓▓╣█╢▒▒▒▒▒▒▒▒╢▓█▓╣▓╣╢▒▒▒▒▄▄███████▓▓▓▓▄▄▒▒▒╢╣▒╢▓▓▓▒▒▒█▓▒▒░██▒▒▒╢▒╢╢╢╢███████▓    //
//        ~▓██▓╣▒▌▒▒▒▒▒▒▒▒▒▓██▓███▓▒▒▒╢╢▒▄▒▒▓▒▒▒▒▒╢╣╣▒▒▒▀▀▓█▓╣▓▒▒▒µ▓╣╣░██╢╢▒▒╢╢╣╫▓███████▓    //
//        ░▓██▓╣╣▓▌▒▒▒▒▒▒▒╢▓███████▓╣▒╢▒▒▒▀▓▓█▀▒▒▒╢▒╢▒╢╢▒╣▓▓▓╬Ñ░░▒ █▓╣ ▓█╣▒╣╢╢╢╢▓▓███████▓    //
//        ░▓▓██▓╣╢█▒▒▒▒▒▒▒╫▓▓▓███▓▓▓▓▓▒╣╣╣▒▒▒▒▒▒▒▒▒▓▒▒╣▓▓▓▓╣▒╢▒▒▒▒ █▓╣░▐█╣╢╢╢╫╣▓▓████████▓    //
//        ▒╢▓███▓╣▒█▒▒▒▒▒▒▓▓█▓█▓▌▒▒░╢▒▓▓▓▓▓▒▒▒▒▒▒▓▓▓▓▓▓▓▓╜░║▒╢▓▒▒▒ █▓▓░░█▌╢╢╣╣▓▓█████████▓    //
//        ▒├▓▓▓██▓╣▒▀▓▒▒▒╫▓▓▓█▓▓▒▒░░▓▓Ü▒▀▓██▓█▓█▓▀▒░░░ ░,▄▄▒╣▓▓▒░▒ █▓╣µ░▓█╣╢▓▓▓██████████▓    //
//        ▒░▓▓▓▓█▓▓╣▒▒▒╢╫▓▓▓▓▓▓▌░░░]▓╬▓▓▄╖▒▓▓▓▄▄▄▄▄▄▄██████╣╣▓▓░░░░█▓╣K░░██▓▓▓███████████▓    //
//        ▒▒░▓▓████▓╣╢╢▓██▓▓▓▓▓░░▒`▓▓▓▓█▓██████████████████▌▓▓▓▒░▒░▐█▓╣ ░▐████████████████    //
//        ▒▒▒▐▓▓░░▀██▓▓██▓▓▓▓▓▌░▒░▐▓▓▓▓██▓█▓▌▒████▓▓▓▓▓▓███▓▓▓▓▌░░░░█▓▓▓░░▀███████████████    //
//        ▒▒▒▒╙▓░░░░▀▀▀▀▀███▓▓▒▒░,▓▓▓▓█▓▓█▒▓░▒░░░▌█▓▓▓▓▓▓██▓▓▓▓▓▒░▒░▓▓▓▓▓░▒▀██████████████    //
//        ▓░▒▒░░▓▄  ░░░░ ▄▓▓▓░▒▒░▓▓▓▓█▓██▐▄▀▀▄████▌█▓█▓▓▒██▓▓▓▓▓▓░░░▐▓▓▓▓▄░▒▓█████████████    //
//        ▓▓▄░▒▒░╙▓▓▓▓▓█▓▓▓▀░▒▒╓▓▓╢╬▓█╢█▓█░░█▀█▌▌▀▀█▓▓▓▓▓█▓█▓▓▓▓▓▓░░░█▓▓▓▓▄░▒▀████████████    //
//        ╣▓▓█▄░▒▒▒░▀▀▀▀▀▀░▒▒▒╓▓▓▒▒╢▓╝╝╝█▓█▄███▄▐▄████▀▀░░▓▓▓▓▓▓▓▓▓░░▐█▓▓▓█▄'▒▀███▓▓▓█████    //
//        █▒╬▓▓▓▄░░▒▒▒░░▒▒ß╣▓▓▒▒░░▓▓╜░ ░░ ,"▀██▓████▀░░░▒▒░▓█▓▓▓▓▓▓@▒░▐█▓▓▓▓▄]▒▀▓▓▓▓██████    //
//        ██▓▒▒╢▓▓▓▓█▓▓▓▓▓▓▓▒▒▒░▄▓▓▓░░░░░░░░▒. .▀█.░░▒▒▒▄▓▓█▓██▓▓▓█▓Ç░░▀█▓▓▓▓▓▓▒╖▓████████    //
//        ▓█████▒╢╢╢╢╢▓▓▓▓╜▒░▄▓▓▓▓▓▓▓████▄▄▒▒▒▒░░/░▒▄▓▓▓▓▓██████▓▓▓▓▓@▒░▐█▓▓╣╢▓▓▓▓████████    //
//        ▒▒▀██████▓▓▓▓▄▓▓▓▓▓▓▓▓▓▓████████▓██▄░▒▒▒║▓█▓▓▓▓█▓▓▓▓▓███▓▓▓▓▓▒▒░██▓▓╣╢▓▓▓█████▀▒    //
//        ▒▒▒▒▒░▀▀███████▓▀▀║▒▓████▓█╢╢▒╣╢╣▓▓▓▓██▓▒█████▓▓▓▓╢╣▒▀███▓▓▓▓▓@▒░▀██▓▓▓█████▀▒▒▒    //
//                                                                                            //
//                                                                                            //
//    asciiart.club                                                                           //
//                                                                                            //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract BRS is ERC721Creator {
    constructor() ERC721Creator("Berkley Rose Studio", "BRS") {}
}