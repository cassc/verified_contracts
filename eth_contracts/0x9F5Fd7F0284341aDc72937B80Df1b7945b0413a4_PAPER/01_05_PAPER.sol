// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: by Paper
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ,[▒░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░U┐    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░,;╓▄▄▄▄¡░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄▄▀╢▒╢╢╢╢╢Ñ▒╢▒▒▒▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄Θ▒█▒╢╢╢╢╢╢╢╢╢▓▒╢╢╢▒▒▄░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▓▒╢▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▄░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░▄█▓▀║║W▒▒╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢▒░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░▓▓▓▓█▓▓▒▒▓▒▒╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢╢▒%░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░,▐█▓▓▓▓▓▓▒▒▒▒▒▒▒▄▄▄█████████▀█▌▌░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░▄██████▓▓▓ÑÅ▀▀██▀▒░░▄░▄░▀▀█⌠░ƒ░j▓▌,▄▄▄▄░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░██▀░░▒▓▓██▓█▓▓█▀▒░▄▀█▄▄▀▌▒▒▐█▄█▌░██▓╣▓▀▓█░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░██▌░░▒░▄²▀████▓░▒▄▀▒▒▄█▀█▐░▒▌░██▄▐█▀⌠▀⌠T▐█░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░███░▒▒░▀▒▒▒▐██▓█░▒▀▀N█▄▄▄███Ñ██NM▀█▒▒▒j░░██░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░▐▓█W▒▒░∩▒▒▒░▌▓███▓▄▄²$▓▌▀▀⌠░!█▒⌠▄█▀░▒░░▄╢▀░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░▀▓█▄▒▒░░l²░████▓▓▓▄║▀███▀▌▒░█████▄▀T▄█▀░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░█▓███▄███████▓▓▓▓██▀▀▒░▒░▐░▒▒▌█▓██▀░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▐▓███▓▓██▀░▒▒░T▒▒▒▌▒▒▒▒█▌░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░██▓██▓▓▓▀▒▒▒▒▒▒▒▒▒▓▒▒▒▒▒▀░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█▓▓███▓░▒▒▒▒▒▒▒▒▒▒▒▌▒▒▒▒▒&░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▐███▓█▓░▒▒▒▒▒▒▒▒▒▒▒▒░▌▒▒▒▒▒▌░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▐▐████▌▒▒▒▒▒▒▒▒▒▒▒▒▒▒▐▌▒▒▒▒▐░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█████▒▒░░▒▒▒▒▒▒▒▒▒▒▒█░▒▐╠█░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▐█▓████▄▒▒▄▄▄▄▄▄▄▄▄Ä∞╝▀▀▓▓█$▒▀▀▀░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░▐█▓▓▓▀████████@╬▄▄╦@▓█▓▓▓▀░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░█▄▓█▓████▓█▀▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░░░░░;░∞╧▐█▓██▓▄██▌▄▓╫█░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░░░░░w╛`_,',▄█▄▓███▓▀███▀▓▓▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░╒▒"'___═╓█████▓█▓▓▓▓████▓▓███▄,░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░░█▒▓__'▀_▐▒▄▒╙▓█▀▀▓▓█▓██████▓▓████▄▄░░░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░░▐█▓█▌╙▄___███▄█░▀▄▀▀▀█▄█▓▓▓▄▓▓▓▓▓▓▓██▄░░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░░▄▌▄▓▓▀,_▀_\▐▀███▒▀█▒██▄███▓▓█████▄███▓█w░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░▐██▓█▓▓▓▄_╙▄▒░▄▒██W░░▀▒▒▒▀▒▒████▌▀░█▓████░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ░░░░░░░░░░░░░░████▓█▓█▀▄▄█▄▒█▀▄▀▌░▀███░▒▒▒▀▀▒▒▄]▒▒███▌█░░░░░░░░░░░░░░░░░░░░░░░░░    //
//                                                                                        //
//    ]░░░░░░░░░░░░▐█▓████▓████▄█▄╝▄█▀▒▒▒████░▒█████▌░╚N▄████▌░░░░░░░░░░░░░░░░░░░░░░░▒    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract PAPER is ERC721Creator {
    constructor() ERC721Creator("by Paper", "PAPER") {}
}