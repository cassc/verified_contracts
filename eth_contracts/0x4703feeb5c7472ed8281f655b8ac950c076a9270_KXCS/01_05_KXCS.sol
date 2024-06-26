// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: GLITCHERZ
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                          //
//                                                                                          //
//    ╓█▓▓╠╠▓╣██▓╩  ..      ╟███' ╓▓█▀`        ╟████████▌          ▐╟████▌                  //
//    ███▓╣╬╟▓╬╣█▓≈╕      ,╣▓█▓▌Q▄▓█╜          ▓████████▌.╔φ       ║╫█████▒                 //
//    ╠╬╬██▓▓░╢╬╝█▒▒     ╠████▓▓▓█▀            █████████▌φ╠▄       ╠╬╬█████                 //
//    ████████▓░░╙▀▓▄`.╓▓█▀  ███▌              ██████████╬╠▓▒½    ;╬╬█████▌                 //
//    ██▓███████▓▓▓╣█▓▓▓▀╓   █▓▌               ██████████▓████▄   ╟██╟█████                 //
//    ████████████████▓▓▒░▓φ╟█▓▒              .█████████▓╠█████▀  φ╟▓╟█████▌                //
//    ╬╙██▓▓███████████▓▓▓░╠▓█▓▓▓ε           ,▐██████████▒╟╬▒╙▀  ]▒▓█▓█████▌╦»≤≥╦,          //
//    █████████████▓██▓╙╠╬╣▓██╣███▓▓ε  ,     ╚███████████▌▄╟▓▒▄▄█∩╣██╣██████▓▓▓╬▓▓▒▄        //
//    ████████▓▓█╬██▓█▓▒╣▓███▓▓▓▄▄╬╬▒▒▒▒▒»╓,, ██████████████████▀.╠╣▓███████╢╣▓▓╬▓█▓▒▒      //
//    ████████████▓█╬██▓██████▓█████████████▓▓▓▓╬╬╙▀▀███▌≤φ╙███▓▓▒█▓▓████████▓████▓╬▓▓      //
//    █████████████╬███████████▓█████████████████▓▓██▓▓▓█▓▓▓▒▒░│░½▄╠╬▒│╠╠╙╠▀╩╝█▓▓█▓╬╣╬      //
//    █████████████▓█▓▓█████████████████████████▓█████████████▓╣▓▓████▓▓▓▓████▓▓╬╬▓▒╬╬      //
//    ▓███████████▓▓█▓▓██▓███████████████▓██████╣╣██████▓████▓███████████████████▓▓▓▓▓      //
//    ██▓▓████▓╣█▓╣╬╣╣▓██████████████████████▓█▓█▓██████████████████████████████▓▓▓███      //
//    ▓▓█▓███▓╣╣╬╬╠╟╬╬▓██▓██▓███▓███████▓████████▓███████████████████████████████▓████      //
//    ╬╣█▓██▓█▓▓╫╬█╬╟╣███▓██╬███████████▓██▀▀╙╙╙,..╓╓╓,.,,,,,└└└└╙╙╠▀▀████████████████      //
//    ▓▓▓██▓████╬░╚▓▒╟███▓██╬▓████████╫███▀                 '' .│░╔╙████╬▀████████████      //
//    █████████▓▒╬▓▒▓▓███╣▀██╣██╫████▀▀`                 ..;░░░░░φφ▌╙▓██▓█▓▒╚▀▀▀██████      //
//    █▓███▓███╬╣╣▓▓▓▓▓▓▓▓▓█▌  ╙╬█▀╙                   ' "░░░░φ▒╠╠╠╟ ╟█████~   ░╟█████      //
//    ▓██╣██╬╬█▓╣▓▓▓█╬▓█╣▓▓███▓▓█▓##º#K≥╗╗▄▄▄▄▄▄╓╓   µ▄▄▄▄▄▄▄▄▄▄▄▒╢╬▌ ▓╬██¬   .'▐█████      //
//    ████▓█▓█▓▓╣╬▓█▀▀`       `"'"∩         ` `╙╙╙╙╙╙╙╙"""╙""╙╚╙╩╩╩╝╩ ╩▀▀░░░Γ^.█╟█████      //
//    ███████████▀╙               `░                                  "░   ,░φ╬▀╚╙╩▀╙╙      //
//    ████░└└╙╙╙░▄▄▓▓⌐            '. '                                 ▄▓░░░╙░░▒▒░≤φ░╠      //
//    █▓███▒  '"▓╬╠╬╟⌐,'                       ▓▓█▓▓▓▓▒▒▓▓L           ▓██▒░▒╠╠╬▒╬╬▓▓▓╬      //
//    █████▓░  φ╬╬▄▀└                          ╟█▒"╙▒▒╠▓╬╣▌        .≥╚███▌░░▄▓█╣▓▓▓╬╣╬      //
//    ███▌ '└╙╙╙╙└                             ╟╬╦Γ`└░║╣▓█░"     ≤φ░░░▒░▀█▌▓████▓▓▓▓▓╣      //
//    ╢█▌ ' `"¬~-..                            ╫▓█▓▄▄▓▓▓▀'    »░░░░░░ ╟▒╚╟███▓█▓█▓▓▓╠╣      //
//    ▓█▌▓▒≈═w,            ``^"¬¬~--...,                  ,=";░φφ▓░░▄╠▒ ;▐█╣▓▓╣╣╬▓╣╬▓╬      //
//    ╣██╣╣   `█~╠██████▄▄▄▄▄,,                           ╓φ ░░░│░░░╙╠░╩'║█▓╣╬╬╬╣╬╠╣▓╣      //
//    ╠▒░╠╬╩▀▀▀▀▌ ╚████████╩╘███████████▌*▄▄▄æ≡≡µµ╓╓╓,,≤φ▒▒▒;░░░░░░,µ╙╫  ██╣▓▓╬▓▒╙╣╣╣▓      //
//    ╠▒░╠   "░░░ ╓▄;│╙╙▀▀▀▀Æ████████████ ╟██ε    ╬╠╠╬▌░░╠▒░░░░░░░▐▓⌐  ,██╣▓╬╣▓▓╬▒╬╬╬╣      //
//    ░░░╟,   ''  └╙╙╙▀▀▀████▄▄▄▄▄│╙╙╙▀▀▀╛ ▀▀##▓╗▄▓▓▓▓▌░░░░░░░░Γ░░▄▄▄▄#▓╬╬╬╬╬▓╬▓╬▓╬▓╢╫      //
//      `╙╚╩▀▓▓▓▄▄▄╓,         ¬└╙╙▀▀▀▀███▌  `""φ╩╩╚╚╚Γ░░░░░ΓΓ░;,▄███▓╬▓▓▓╬╬╬╬╠╣╣▓▓▓▓╣╣      //
//      `ⁿ=, ^╙╚╚╬████████▓▄▄▄µ,,       ¡'     .'          ,▄▓▓▓█▓╣▓╬╣▓▓╣╣╬╢╬╣╬╬╣▓▓▓▓▓      //
//    ╬╬   `░░≥,     "ⁿ."╚░░░░░╙╙╙╚╚╩╚╚▀╩▒╚╠╫▓█████████████╬╬╬▒╠╚╚╩░╠╠▒░░╙╚╠╩░╚▒╬╠≥╩╠╠╠░    //
//                                                                                          //
//                                                                                          //
//////////////////////////////////////////////////////////////////////////////////////////////


contract KXCS is ERC721Creator {
    constructor() ERC721Creator("GLITCHERZ", "KXCS") {}
}