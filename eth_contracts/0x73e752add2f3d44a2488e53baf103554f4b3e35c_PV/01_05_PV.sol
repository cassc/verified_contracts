// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Polar Vortex
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    By: @Dewucme/@Dew_u_c_me 2023                                                                           //
//    555GJ!!!~~^~77YB&BY5PPGGG5JJJJJJJ??Y5YYJ?7J55557::75PPPPPPPPPPGGPPPPPPPPPP555555555YYYYYYYYYYYYYYYYY    //
//    &GJ#55555J5GJ5Y?G@@&&&&#&#BG5J?7!!77?!^.  :7!^.::  .^?YYYYY55PPPP55YYYYYYYYYYYYJYYY55YP5YYJJJ???JJJJ    //
//    G^:PY##GB#G#5B#GP@@&@&#G7^!B@&#5!7^^^~!??J~:.::.      :7Y5Y5555P5PP5YYYYYYYYYYYPBBB##GBGPPPP5YYYYYY5    //
//    !YPBB#&&&BG&#&#BB&@#&BYY7?PB@@&G?!.^7GB5!:::.           .!PBGPYPB#&#BG5Y5YYY5B##@&&@&&&#GGBBGP555Y?!    //
//    :~YB&&&&&GB@&@&&#&###&GP#YB#&@@B^:^?77:.::.              ..^JGBGGP#@@@&BGPPGB#&&&&@@@&&&&#&##BGY!.      //
//    J!^:^?G&&&#&@@@@@@&&@@&&&JB&&@@P.^:..:^:                 .   :75GGB@@@@@&BBG#&&@@@@&@P5PPPPPP?:.  ..    //
//    &#GY?~:^7G&&&&@@@@@@@@@@@!G@@@&Y. .^^.                         .::B@@@@@@@#55GB#&&&#@J.::::.........    //
//    &&&&&#PJ!~!?P#&@@@@@@@@@@75#G7:.:~:.                           .  :5&@@@@@&PYJ5P#&##@J.:............    //
//    &&&&&&&#B5J777JG#&&##&@@@~?~..^^.                                   .~JPGG@&#GBGB@&GP7.............     //
//    &&&&&#GGGGGPP5YYY5B#BGGP!..:!:.                                      . ..!@#BGBB#@#??!~^^::......       //
//    7#&&&&&&&&&@@&&BP5#&&&J   J?                                          ... .5@@&&&@@~??777?7^^^.  ..     //
//    B#@@&GBB##&@&@&B5JB###&B?.?&7::^::^^^:^^:^.:^^^. .J!^^^^~^^:::^^^^::^. .:!^Y@@@BPBG^JY~~~!!!!JJ^.::!    //
//    #####PB#B#&&&@&BG5B####B#.!#?7J!!!!Y#&@&#@&&@@@? .#@@@@@@@@&&@@@&&&&&P  .#@@@@@Y7!!?YGPJ!~^:.7Y7. :&    //
//    JJYY5PB###&&&@&#BP#&&&G7P .:^!!::..:^~!~:^!7!!!. .~!777~!JJ???!!7777?^ .:#@@@@@Y7JYBPGBBJ~~^.^::  .^    //
//    P555PPB#&&&&&&&&BG#&&&#&G                        .                     ..Y&@@@@#&@@&G57~^^~^.:.:        //
//    GPPPPPB#&&&&#&&&#B&&&&&@B                                             ..~7YG#&PB##G7^:.::~^^^^:         //
//    Y55PPP#&&&&&&&&&##&@@@&@5                                              .:PB##&@@@@#~^:.:^:^:^^^.        //
//    GBB#BG&@#&&@&&&&&#&@@@@@G .                      .:                  . .^@@@@@@@@@@G!~~!7~~.~^~.        //
//    GB###B#@#&&@@&&&&&&@@@@&G . .    .   .        ..:.    .    .    .    . .:PBGGPGGG#&P^:YPG?~.^:~.        //
//    #&@@@&#&#&&@@@@@@&&@@@@@G . ..   .   .             .       .    .   .. ..?777?G##&&P!~B@G!~.:.:.  ..    //
//    &@@@&&##&&&@@@&&&&&&&&&@G . ..   .   ..        .      ..   .    .   .. .:##BB@@&&@@5!.P@57!:^.:  ..     //
//    G&#BBB###BBGGB#######BY?7 .              .. .~:  .. .~:         .   .. .~@@&@@@@&@@5~:J7^^~!~::....     //
//    7GBBPJ!:^.:^75P####Y:..~7:. ........ :!:  . .75!Y:. .?G~:...... .. ..: .7@&&&&&&&&&5?~:.::.::!:   .     //
//    ?&@#!. ..:!Y##P###B:  ~7~...      ..^~!^::.  JG@@&~.^5&5J^     .:...:^^.!B####BPJ??JJ~:....  ..         //
//    ?G#P:.:^7PB&&@@&#B?   .~!.^~... .^J?J?J??7~  5Y&@@^.~GP77.           .J5J##GY?7!~~~!7:.     .  :...     //
//    !!!.  !5G#&&#B5J!^    .!J7..!?!7??PPP5YJJ7:.:~:7@&..:GP7~:..:.:.......Y#5?!^::::^^:^~:.....:..::.       //
//    ::^: .?B#G?~:^^^:    .:^7::^~5Y5J!!7!77!^::::::~GG7^^^^^::::::::.:::::^:::::^:^^^^::^^::::::::::::::    //
//    ^^^^:^!7!^:::::.     ~~.~Y!:.BBY~^^:.::~^::::::^~~~::::::::::::::::::::::::::::::.^^::::::::::::::::    //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PV is ERC1155Creator {
    constructor() ERC1155Creator("Polar Vortex", "PV") {}
}