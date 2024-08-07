// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ben.eth 1/1s
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    ,▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓┐    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▀╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╣╫╬▓╬█▌▓╬▓▓▄└╙▓▓╬╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓██▓█╬╬░█╬╣█╬╬█╬╟▓  ^▓▓▓▓▓█╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓╬╣╬╬█╣▒░██▓▓▓▓▓█▓█w▌▐█▓▓╬╬▓▌╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█╬███▌╬▓▀█▓╬▓▓▓╬█╬▀,▄▀▓▓▓█╣▌╬╠╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓████▓╫▓▓░▄╬▓╣▓╣█▄ε▐▓╣░╗██╬▌▓╗█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣█████████╬▓▓╣╬▓╠▀╬██▀,╙▓╬▓▀██▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬████▓╬▓Å▒▀╗▄▄▒▄▒QpQ▄,╠t╦Q░W╝╩█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬██▓▓█▓▓╬╩▀▀▀▀▀▀▀▀▀▀▀▀▀▀╩╝╝╫╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬▓▓███╬╬█▓╠▒█▓┐ ╙╝` "╝▀ ^█▀'7▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓██▓▓█████▓▓╬▓▓▓▓▓▓▓▌╫╪╪▌▌▓╣╣▄▄▓▓▓█▓▓▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬██▀││╙╙╬█████████╬╬╬╬╬╬███████╬╬╬╬▓██╬╩██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬█▓▒Θ└░¡ÅT╙██▓▓███▓▓▓▓▓▓▒░█▌'██▓▓▓▓▓░█▀└"╫█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█░░░░╛░░░╙▓▓▓███▓▓▓▓╬░½██▀▀╬█╬▓▓╬░▄▌j░╓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓█▒░░░⌐░░░√█▓▓█████▀▒▒▒╙╙└│└╫╜╠▄▄▀▀╙>░▄██╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓█▄░░└░µÖ¡█▓▓▓▓██▄▒▀▀██▀w░7▓▀██╠▄▒Γ▄██╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓▓█▓▓▓▓▓██▓▓▓▓█▓▓██▀╙µµ░░▐░░░▒╫▓██╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬╬╬╬╬╣▓▓▓▓▓▓▓▓▀│░░¡Γ░░░▒░░░░╫█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█▓▓▓▓▓▀░░░░░░░░░▓░░░░░╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█▓▓▓▓└░░░░░░░░░░╙▌░░░░░╫▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣███▓▓▓¡░░░░░░░░░░░░╙▒░░░░│▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬╬███▓▌░░░░░░░░░░░░░░╙▌░░░░╟▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█████░░¡│░░░░░░░░░░░╫░░f╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣█▓████▄φ▒▄▄▄▄▄▄▄▄▄ke╨▀▒╠╠▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣▓▓▓█▓█████▓▓▓╦╦╗╗φφ▀╩╬╬╬╢▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓███▓▓▓▓╬╬╬╬╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╣█▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓█╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬███████████▓▓▓▓▓████▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬▓▓█████▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓╬██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓█▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████▓▓█▓▓▓███▓▓▓▓▓█╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▀╙^└░╙█████▓▓▓▌▌░╙▓▓▓▓▓█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓▓▓▓▓█▓▓▓▓╙'░░░░░░^┘▀╙▀███▀¡░░░╙██▓█╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓    //
//    ╚▓▓▓▓▓▓▓▓▓▓▓▓╣█████▓▓▓▓▓███└░░░░░░░░░░░░░░░└¼░░░░░░╟█▓█╬▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▀    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract FWORK is ERC721Creator {
    constructor() ERC721Creator("ben.eth 1/1s", "FWORK") {}
}