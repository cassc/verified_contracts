// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: King of Midtown
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                            //
//                                                                                            //
//                                                                                            //
//        ▒▒▒╫@▓@░░░░▌ß▒▒░▒░▌Ñ▒▒░░j║▓╣@▒▒░▒▒▒▒w╖ww╦╦ww╖w░▒░░░╥╥╥░░░░░░░░───▒╗g,  ` g  ░▀▒▐    //
//        ▒░▓▀▀▀▒░░░▀▀▀N░░▒áMN▀░▒▒║╢▓▓▓▒▒▒▒▒░▓▓████████▄▒▒▓▓▒░╟▓▓░░▓▓░░▓▓░░╙▓▌▒N▄  ╙`▐▄▒▒▀    //
//        ▒▀╬╬m▒▒▒░╜m▒M░░▒░╜▒▒╜░▒░[╬╣▒▒▒▒▒▒▓█████████████▓█▒▒░░▒▄▄░░░▄░░░▄▄░░▓▓▒▀▌▄╖╖▀█╣▒╢    //
//        ▀▀▀▀▒▒░░Æ▀▀▀N░░░╟▀▀▀▒░▒▒L▒╣╣▒▒▒╠██████████████▓▓██▌╣▒▒▒▒▒▒▒╙▒▒░▒▒▒▒▒▒▓▓▓█▓▒╣▒╫██    //
//        ▄▄╓▒▒▒▒▒▒╥▒▒░░░░▌╖▒«▒▒▒▒░]▓▓▀▒▄█▓███████▓▓░██████▀█▓▓░░╙▀▓▒▒▒▓Ñ▒▒▒▀▒▒▒▓▓▓▓██╣╢▒▀    //
//        ▄▒▒▒░▒░▄▄▄▄░▒░▒▄▄▄▄▄▒▒▒▐]╢▒▓▓██▌█▓█████▓███▄██████▐█▓▓░░╙▓▓░░╙▓%░░▒▀▓▒▒▀██╢▓╫█▓╣    //
//        ╥▒▒░▒░▌═@═▒▒▒░░▌╧╩╩▒░▒▒║╟╣▒▓██▀▓▒▒▓▓▓▓▓▓▓█▀█▓▓▒▒▀▀H██░░░░░▄▄░░░▄▄░░▒▒▄▄╢▒▓██▒█▓╢    //
//        ▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒▒▒▌╢▓▓▓█▌▒▓▓▓╣▓▓▓████▓█▄▓▓▒░▒  █▓╢▓░░╙▓▓░░░]▒▒░▒▒▓▓▒▒▀▓█╣╣█    //
//        ▒▒▒▒███▓█▒▒▒▒▒████▌▒▒▒▒▌▌╢▒██▌╣▓▓▓██████▀`████▓▌░░░ █▌#▓▄░░j▓▓▄░░▀▀Ñ░░╙▓█▄▒▒███╢    //
//        ▒▒▒▓════▒▒▒▒▒█┴j**▒▒▒▒▒▒▒▓▓█████████████▌,▄█████∩░░,█▌░▒▒▒░▒▒▒▀▒▒▒HN▒▒▒▒▓▓╢╢╣▓▓▓    //
//        ▒▒▒▓@╢ß╢▒▒▒▒▒▒Ñ▒▒▒▒▒▒▒▐▐╫╢▓█████████████████████▓▓▓▓▓▌▒▒▓▓▌▒▒▐▓▓▌▒▒▀▓▀▌▒╢▀██▌╣╢█    //
//        ▒▒▒▒╢▒▒▒▒▒▒▒▄▒▒▄▄▒▒▒▒▒▓▐▓╣█████████████████████████▓▀▒▒▒▒╬╣▒▒▒▒╣▒▒▒▒▒@▓╢╣╢╢▓▓▓▓▓    //
//        ▒▀▀▀▀▀▒▒╣╢╢▒▀╜▓▒▒▒▒▒▒▒╢╟╢╣▓███████████████████████▓██▓▒▒▒╫▓▓▌▒▒▒▓▓▓▒▒▒███▒╢╣███▌    //
//        █""▀"║╢╢╢╣╢█  ▀ ▐▒▒▒▒▒▒▓╣╣██████████████████████████▒▓▓▒▒▒▓▓▐▒▒▒▒║▄▓▒▒▒▓██╣╣▓╫▓▓    //
//        ╫╬▓ÑÑ▒╫╣╣╣▒╢▓▒▒▒▒▒╣╢╣▐▒▌▓╣╢███▓▓████████████████▌░██▒▒▒▒▒▒▒▒▒▒▒▒▒╢▒▒▒▒╣╢▒▓█▓╣▓▓▓    //
//        ▓╣╣╬╣╬╣╢▓▓▓╬▓╣╣╣╣╣╣╣▒▐▒╬▓▐████▓█████████████████▌▒█░▒▓██▌▒▒▒Å╖▐▒▒▒╫╝▓█▒╢╣▓▓██╣▓╣    //
//        ▓▓▓▓▓▓▓▓╣╬▓▓▓▓╣╢╢╢╫╣╣▓▒▓▓▓▓▓██▓█████████████████▓▒║▒▒▒╣▀▀▒▒╢╫@@▓╣╢╣▓▓▓▓╣╢╢▓▓▓▓▓▓    //
//        ╣▓╢▓▓▓▓▓▓██████╣▓▓▓▓▓╢▓▓▓▓▓▓╫▓▓████████████████▓▓▒`╖▒╙╜▀╙╩Ñ╣╢▒▓▓▓╬╢╣╫▓▓▓▌▓╣╫████    //
//        ▒▒╣▓▓▓▓▓▓▒╢╫▒╢▓▓▓▓▓▓▀"▓▓▌░▒░░█████████████████▓▓▓Ñ ╫╬▓ ▒▒╖     ╓╖           ╙▀██    //
//        ▒▓▓▓▓▓▓▓█▀▀▀ ░      @▓█▓▒░▒▒▒▒▀███████████████▀▀░░░▓▓▓U║▓▓▒░╫▓Ñ▒╢@ ░░░░░░▒░,  ░     //
//        ▓▓▓▀"╙      ░░,▒░`╓▓█▀▒▒░░╢▒░╙▒▒▀╢██████▓▓▓▓╣▒▒░░░╥╫▓▓▌░▓▓▓░░▒▓▓╬╣╣▒╢▒▒▒╫╣▒▒@@▒m    //
//        ▀░  ╓,░╖]╖░░▒░▒▒ ▓▓░▒▒▒░░░▒▒░░╙▒▓▓@▒╢▓▓▓▓▓▓▓▓╢▒░░▒▒╢▓█▓▒╟▓█▒░╢▓▓▓▓╣▓▓▓▓▓▓▓▓▓▓▓▓▒    //
//        ░▒▒▒▒▓▒▓▒▓▒▒▒▒░░╣╣░▒▒░░░░░▒▒▒▒▒╙▒░▀▓▓░╙╢▓▓▓▓▓▒▒░▒╢╣▓▓▓▓╣▓╢▓█@╠╬▓▓▓▓▓▓▓█▓████▀▒▒▓    //
//        ▄▄╢▓▒▒▓▓▒▓▓▓▒▒▒▒╣▒▒▒░░▒▒░░▒▒▒▒▒▒░▒▒╫▓▓@ ░▒▒▒▒▒░░▒╢╣▓▓▓█▓▒▓▓▓█@▓▓▓██▓███████▒▓▓▓╣    //
//        ▒▒▓▓▓▓▒▓▓▓▓▓▓╣▓▓╢╢▒▒▒▒▒▒▒▒▒▒▒▒╢▒░▒▒▒▓▓▓▓╖ ░▒▒▒░░▒╢╢╢▓▓▓▓╣╫▓███▌▓▓▓███████▓▓▓▓╣▓▒    //
//                                                                                            //
//                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////


contract KOM is ERC1155Creator {
    constructor() ERC1155Creator("King of Midtown", "KOM") {}
}