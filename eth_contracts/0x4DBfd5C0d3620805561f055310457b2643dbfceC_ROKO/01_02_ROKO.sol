// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

// name: HIROKOS QUEST
// contract by: buildship.xyz

import "./ERC721Community.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ........................................,,,,,,,,,,........................................    //
//    .................................,,::;;+++++**++++++;;::,,................................    //
//    .............................,,:;+*****+++++++++++++*****+;:,,............................    //
//    ..........................,:;+***+++;;;;;+;;+;;+;+;;;;;+++***+;:,.........................    //
//    .......................,,;+**+++;++;+;:+:;;:+;;;:+;:+:;+;+;;++*++;,,......................    //
//    .....................,:;+++;:;:;;:;;:;:;;:;:;:;;:;:;;:;::;:;;::;+++;:,....................    //
//    ....................::++;,:;:::::;,;::::::::::::::::::::;:::::;,,:;+;::...................    //
//    ..................,:;+;::;:::;:;::::::,,,,,,,,,,,,,,::::::::;:::;,::;+;:,.................    //
//    .................,:;+;:;::;;:;::::::::;++::::::::::::::::::::;;::;;::;+;:,................    //
//    ................,,;+;+;;;+;;;;;;;+++*%#@@?;;;;;;;;;;;;;;;;;;;;;+;;;+;;;+;,,...............    //
//    ...............:,;*+*;;++++++++*********SS+++++++++++++++++++++++*;;+;++*;,,..............    //
//    ..............,,;***++*;************+;;+?**************************+;*++**;,,.............    //
//    .............,,:??*++*;***?????????+:+???*???????????????????????**?+;*++?*,,,............    //
//    .............:,+??*+*+*?*??????????;;?????????***?????????????????*??++*+*?+,,............    //
//    ............,:;???+**+?????????????*;+*??%%%++:,:;**?????????????????*+*++??::,...........    //
//    ............:;+??*;*+*?*????????????*+++**;,,,,,:;***?%????????????*??++*;??+;,...........    //
//    ............;+*??++*+***??????????????**++;:,:;?%%%?*++++*?????????**?*;*;*?*+:...........    //
//    ............++***++*;**********************++*?%*;+++;:;;+*************;*+***+;...........    //
//    ............;****++*;************************+:,:*?*++;;;;;;**********+;*;****;...........    //
//    ............:?****;+++*************************:,;*?????**************+;*;***?:...........    //
//    ............,??***;++;**************************;+********************;+++**?*,...........    //
//    .............+%*+++;+;;+++++++++++++++++++++++++*+++++++++++++++++++*;;+;++*%;............    //
//    .............,?%+;+;;+;;;;;;;;;;;;;;;;;;;;;;;;;++;;;;;;;;;;;;;;;;;;+;;+;;;+%?,............    //
//    ..............:S?;:;;;;;:::::::::::::::::::::::;+:::::::::::::::::;;:;;::;%%:.............    //
//    ...............;S?::;;:;;::::::::::::::::::::::;;::::::::::::::::;;;;:::;%S;..............    //
//    ................;S%;,:;:;;::::::::::::::::::,,,;;,::::::::::::::;::;:,,;%S;...............    //
//    .................:%S+,,:;:;;::,,,,,,,,,,,,,,:::;+:,,,,,,,,,,::;;:;:,,,+S%:................    //
//    ..................,*S?:,,:::;:::,,,,,,,,,,,,:;;:,,,,,,,,,,:::;:::,,,;?S*,.................    //
//    ....................:%S?:,,:::+:;;,:,,,,,,,,,,,,,,,,,,:,;::+:::,,,;?S?:...................    //
//    ......................;?S?;:,,:,;,;+:;::;,::::,:,:::;,+;:;:::,,:+?S?;.....................    //
//    ........................:*%%*;:::::::;:+;:+:++:+:;+:;::;:::::+?%%*:.......................    //
//    ..........................,;*%%?*+;:::::::;:;;:;::::::::;+*?%%*:,.........................    //
//    ..............................:;*????*+++;;;;;;;;;++**????*;:.............................    //
//    ..................................,:;;+*****??*****++;::,.................................    //
//    ............................................,,,...........................................    //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////

contract ROKO is ERC721Community {
    constructor() ERC721Community("HIROKOS QUEST", "ROKO", 10000, 500, START_FROM_ONE, "ipfs://bafybeihsgghvnzcqijcffwbyp6ldibjwtlit2oitc7f2ueey4e5avdsnjy/",
                                  MintConfig(0.001 ether, 15, 15, 0, 0x9eC62B92B05e070E1A9f9db1D2b8dE473D381A8E, false, false, false)) {}
}