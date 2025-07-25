// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: PALADIN PUNKS
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ████████████████████████████████████████████████████████████████████████████████████████████████████    //
//    ██████████████████████████████████████████╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╙╟█████████████████████████████████████    //
//    █████████████████████████████████████████▌                    ▐█████████████████████████████████████    //
//    █████████████████████████████████▌└└└└└└└└                     └└└└└└└└█████████████████████████████    //
//    █████████████████████████████████▌                                     █████████████████████████████    //
//    █████████████████████████████────                                      █████████████████████████████    //
//    █████████████████████████████─                                         █████████████████████████████    //
//    █████████████████████████                 ▒▒▒▒▒▒▒▒                         █████████████████████████    //
//    █████████████████████████                 ▒▒▒▒▒▒▒▒                         █████████████████████████    //
//    █████████████████████████            ]▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⌂            █████████████████████████    //
//    █████████████████████████            ]▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░            █████████████████████████    //
//    █████████████████████████            ]╠╠╠╠╠╠╠╠▒▒▒▒▒▒▒▒▒▒▒▒╠╠╠╠╠╠╠╠▒        █████████████████████████    //
//    █████████████████████████            ]▄▄▄╬╩╩╩╩▒▒▒▒▒▒▒▒▒▒▒▒╢▌▌▌╬╩╩╩╛        █████████████████████████    //
//    █████████████████████████            ▐████░░░░▒▒▒▒▒▒▒▒▒▒▒▒▓███▌░░░[            █████████████████████    //
//    █████████████████████▀▀▀▀            ▐███▌░░░░▒▒▒▒▒▒▒▒▒▒▒▒╫███▌░░░[            █████████████████████    //
//    █████████████████████                ]▒▒▒▒▒▒▒▒╬╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒b            █████████████████████    //
//    █████████████████████            ┌╖╖╖╖▒▒▒▒▒▒▒▒╬╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ            ╙▀▀▀█████████████████    //
//    █████████████████████            ╞╬╬╬╬▒▒▒▒▒▒▒▒╬╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ                ╫████████████████    //
//    █████████████████████            ╘╠╠╠╠▒▒▒▒▒▒▒▒╠╠╠╠████▒▒▒▒▒▒▒▒▒▒▒▒Γ                ╫████████████████    //
//    █████████████████████            ⌠▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████▌▒▒▒▒▒▒▒▒▒▒▒Γ                ╫████████████████    //
//    █████████████████████            ⌠▒▒▒▒▒▒▒Å╬╬╬╬▒▒▒▒╬╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒Γ                ╫████████████████    //
//    █████████████████████            ⌠▒▒▒▒▒▒▒╠╬╬╬╬▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ                ╫████████████████    //
//    █████████████████████                ]▒▒▒▒╩╩╩╩╠╠╠╠╠╠╠╠╠╠╠╠▒▒▒▒▒▒▒▒Γ            ▓████████████████████    //
//    █████████████████████                ]▒▒▒▒▒▒▒▒╠╠╠╠╠╠╠╠╠╠╠╠▒▒▒▒▒▒▒▒Γ            █████████████████████    //
//    █████████████████████                ]▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ            █████████████████████    //
//    █████████████████████                ]▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒Γ            █████████████████████    //
//    █████████████████████            ▐████▒▒▒╣████▒▒▒▒▒▒▒▒▒▒▒▒▓███▌                █████████████████████    //
//    █████████████████████            ▐████▒▒▒╣████▒▒▒▒▒▒▒▒▒▒▒▒▓███▌                █████████████████████    //
//    █████████████████████            ▐████╬╬╬╬▒▒▒▒████████████▌                █████████████████████████    //
//    █████████████████████            ╘███▓╝╝╝╩▒▒▒▒████████████▌        ,,,,    █████████████████████████    //
//    █████████████████████                     ▒▒▒▒▒▒▒▒████▓╬╬╬Γ       j████    █████████████████████████    //
//    █████████████████████╓╓╓╓             ,,,,▒▒▒▒▒▒▒▒████╩╝╝╝⌐   .╓╓╓▄████    █████████████████████████    //
//    █████████████████████████            ]╬╬╬╬▒▒▒▒▒▒▒▒████⌐       ▐███▌        █████████████████████████    //
//    █████████████████████████        ┌▄▄▄▄╬╬╬╬▒▒▒▒▒▒▒▒████⌐       └▀▀▀▀    ▄▄▄▄█████████████████████████    //
//    █████████████████████████        ▐████╬╬╬╬▒▒▒▒▒▒▒▒████⌐                █████████████████████████████    //
//    ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀        └▀▀▀▀╙╙╙└""""""""▀▀▀▀                 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀    //
//                                                                                                            //
//    PALADIN PUNKS                                                                                           //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PUNKS is ERC721Creator {
    constructor() ERC721Creator("PALADIN PUNKS", "PUNKS") {}
}