// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ijiklvn
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#BG5J?77777?JYPGB&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&B5?~^:^~!?JJYYJJ?!~^^^~7JPB&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@&B57^:^!JPB##############BG5J!~^^!JP#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@&&&#P?^.:7YG#&&########BBB########&&#BPJ!^:~JP#&@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@&&&&G?:.^JG#&&&######PY?!!!!!!!7?5G#####&&&&#GY!::!YB&@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@&&&&P~ .7G&&&&&&&#&#P7^~?Y5P555555J7^~JB&##&&&&&&&#P?^.^?P#@@&@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@&&&#Y^ :Y#&&&&&&&&&&G!:?GGY????JJ??7J5G5~:J#&&&&&&&&&@@&BY~.:75#&@&&@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@&&&&#J: ^5#&&&&&@&&&&&5.!BB7!JPP555555P57~Y#5:^B&&&@@@@@@@@@@&B5!::!5#&&&&@@@@@@@@@@@    //
//    @@@@@@@@@@@@@&&&&BJ: ~5&&&&@@@@@@&&&P 7#P^JB5JY555555JJGG~!#G.^#&&@@@@@@@@@@@@@&#5!:.!YB&&&&&@@@@@@@    //
//    @@@@@@@@@@@&&&&BJ. ~P&&&&@@@@@@@@&&&~:BB^?#J?G5PPPPP5PP!GB:?#Y Y&&@@@@@@@@@@@@@&&&&#57:.~YB&&&&&@@@@    //
//    @@@@@@@@&&&&&B?. ~P#&&&&@@@@@@@@@&&#.!#P.GB~BY5PGGG5B?B?J#7^#G 7&&&@@@@@@@@@@@@@&&&&&&B5!:.~YB&&&&@@    //
//    &&&&&&&&###B?. ~5###&&&&@@@@@@@@&&&#:^#G:Y#7YGYPPPPP5YG~5B~!#5 ?&&&@@@@@@@@@@@@@&&&&#####BY: .~5&&&&    //
//    &&&&&&&#&B?. ^5B####&&&@@@@@@@@@&&&&J Y#J:5B?J5555555Y75B7^GB~.G&&&@@@@@@@@@@@@&&&&#####GY~  .7G&&&&    //
//    @@@@&&&BJ: ^5B#B###&&&@@@@@@@@@@@@&&&7 Y#5~7PPYYYYYYY5PY~!GB~.5&&&&@@@@@@@@@@@&&&&&&#BP7:  ~YB&&&&&@    //
//    @@@@@&&Y^. :!JPB##&&&&&&@@@@@@@@@@&&&&Y:~PBY77?JYYYJJ7!?PGJ:^P&&&&&@@@@@@@@&&&&&&&B57: .~JG#&&&&&@@@    //
//    @@@@@@&&#B5?^..:~?5G#&&&&&&@@@@@@@&&&&&B?^~?5P5YYYYY555Y!:~Y###&&&&&@@@@@@@@&#B5?~..^75B&&&&&&@@@@@@    //
//    @@@@@@@@&&&&&BPY7^:.:~?5G#&&@@@&&&&&&&###B5?!~~!!!!!~~~!JP####&&&&@@@&&#BPY?!^::~?5B#&&&&&@@@@@@@@@@    //
//    @@@@@@@@@@@&&&&&&&#GY?~:::^7J5GB#&&&&&&&&####BGPP5PPGGB##BBBGGPP5YJ?7!~^^~!?YPB#&@@&&@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@&&&@@&#BPY?!^^^^~!7?JYYYYYYYYYJJJ?77!!!~~~~~!!77?JY5PGB#&@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&#BP55YJJJJJJJJJJJYY55PGGBB##&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ijik is ERC721Creator {
    constructor() ERC721Creator("ijiklvn", "ijik") {}
}