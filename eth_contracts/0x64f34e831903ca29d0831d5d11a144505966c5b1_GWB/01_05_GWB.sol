// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Great Wall Of Benin
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    ^^::::::::::::::::::::..:::::::......::::....::::::.::::::::::::::.::::..:::::..::::.....:::::::::::    //
//    ^:^^:::::::::::::::::::..:::::......................:::::::::::::::::::::::...::::::...::.::::::::::    //
//    ^^^^:^^::::::::::~~::::...:::::..::...................::...::::..........:..................::.:::::    //
//    ^^^::::::::::::::!~::::::::::::::...:............ .................................:.::.:...::::::::    //
//    ^^^::::::::::::::::::::::::::::::..................................................::::::..:::::::::    //
//    ^^^^^^::::::::::::::::::::::::::::..............................:^^^:......::......:::::::.:::::::::    //
//    ^^^^^^^^::::::::::::::::::::::::::..:::................^:....:~7JYYYJ7~:........::::::::..::::::::::    //
//    ^^^^^^^7??7~^^:::::::::^!77~::::..:::::::::...:^:.....^7^::!JYY555555YJJ?!^.......:::...::::::::::::    //
//    ^^^^^^75GGY7~^::^^^:::^!5PY7:::::::::::::::::::~:..:~?YJ?7J55PPPPPPP5YJJYJ?!:.:.........::::::::::::    //
//    ^^~7~^75PP5J!^::^^::::^!YJ?7^:::::::^:::::::::::::::~YYY5555PPPPPPP55Y?7777~..::.::::::.::::::::::::    //
//    7?JY?7?5YPYJ7~~!~^^~!~~^~!^^^^^^^^^J5J~:^^^:~YY!^^::~JJYYY55PPP5P555J!^~7!!^....::..............:::.    //
//    JJJ??YYYYJ????JYJJJJYYJJJJJJ???JJJJ55Y???JJ?YP5J?????JJJYY55J555555Y?~:^~~^~!!!!!7!!!!!!!!!!!!777!7?    //
//    ?JJ?JJ7?5YJ77????5YJYYYYYYYYYY5YYYYY55YJYYYYJYJJJYYJJ???JYYY7J55PP5Y?~^^^^^~777!!!~!~~~!!7??JJ??7?Y5    //
//    ??JJ?J5YP5YYJ77?7???J????JJ???JY?7?JJJJ?????77777?7!7~~!JJJY7JY5PP5Y?!~~~^^^^^::::::::~77?JJ?7777???    //
//    ????JJJ???JPJ77?7777777777777!!!7!!!7!~!7~~~!7~~~~!^~~^~JJJY?YYY5555J7!!!!~~:.~!7~77:!:~?Y5JJ?77?JJJ    //
//    J??????????J?77?777!!!!7!!!7?!!!!!~!!!~~!!~~~~^~^^~^^^^~??Y5PGPPPPP5J7!!??7!:.^^::^!^..:!YYYJJJJP5J?    //
//    7777?777777!!7!77!!!!!!!!!!!7~!!?!^~!~~~!?~~^^^^^^^^^^~~7JPPGGPGGGGP5J?777!^......:YY~~~^^~77JJJ????    //
//    777777!!!!!!!!!7!!~~~~~!~~~~!!YJJ7!~~~~^?Y77~~~~!!!!7?JJJJJJJYYYYYYJ?7777!~^......:5PYPP55Y?7!!!77?J    //
//    !!!77!!!!!!~~~~!!!~~~^^~~~~~!?5Y5JJJ!??!?Y?????Y5JJJJJJYYJJJ7?JJYYYJ?77!!!~^......:JGGBGGBGG555YJJ7!    //
//    !!7!!!~~~~~~~~~~~~^^^^^^^^^!7J5YJJJJ?JJJ7?JJ??JYPJJ?7777???J7?JJYYYJ?!~~~~~^......:JJYPBBBBGGPPYGBP~    //
//    !!7~~~~~~~~~~^^~~^^^^^:^:^!J??????J5YJ5Y7YP5J?JJJY?!!!77??JJ7?JJJJJJ?~^:^~~^.......^~^~7JY5Y7?GJ?57:    //
//    !~7!~~~~~^^^^^^^^^::::^~!7J5?7!?Y?55Y55Y?5555YJJPGPJ!7???JJJ7?JJJJJJ7^::^~~^............:::::7BG77:.    //
//    ~~?!~^^^^^^^^^^^^^::^!7???PPYY?PYYP55PP55P5?7J5PPP5Y7JJJJJJJ?JJJJJJJ7~::~!!:...............^5BB#BP7~    //
//    ~~J?~^^^^^^^^^^:^~!?JJ????YP5JPGPYY5P5P5PPPPY??JJ5Y?!Y5YYYYYYYJJJJJJ7~7!7!~:................?BB###BG    //
//    ~~Y5!~^^^^^^:^^!JJYYJJJJ??JP5?PBGYJYP55P55PPGGPJ?JJ7:7YYYJ??YYYYYYYYYY55YJ7!:..............::?GBB###    //
//    ~~YP?^^^^^~!7?J5B#GYJJJ?77JP5JYG#G5YYY?PPYPPGGGGPGP5?JP5?7?7?JJJYYYJJJYJ??!:.................~55JP55    //
//    ?75GJ~!7?JJYYJJJ5&&GJ7!!~~~Y??55##Y777~J#GPGGGGGGG5PPJP#5?!:^~!7?JJ????7!~:..................^?7:!^^    //
//    5YPBY7YYYYYYJJ???P#&BY!!!!!!?GBG5YJJJ7?5BYJYPGGGGGGPGBGGGBP7...:~!7???7!^....................:7~:^::    //
//    YY5##PYYJJJJJJJY5G##5J~^^^^^5BB#G5YGGGP5J77J5GGGGBBBBG555PP5J:....::^:.......................:~:::::    //
//    5PPGG5JJJJJJJ5BGPP5J7J5J^~~~5PB#BP5GGBBBPJ!YPPGGBBBBBBBG55YJJ7^...............................:..:::    //
//    BGP5JJY5YYYJY#BG#BPYJJG57~!!5PB#BPPGPBBGP5??GPGGBBBBBBBBBGPYJJJ?~:...............................:::    //
//    GG#B5YPPYYYYPBGB#BGPYYGPY?!~5YPBGPP5P5PGGP5Y5GPGBBBBBBBBBGGGPYJYJ?7~...........................:::::    //
//    PG#BP5PP5YY5BGP5##B5PPPPP7~^JPGP5P5Y5YGGGGG5?PGGBBBBBBBBBGGBBBGPYYYYJ7^...................::::::::::    //
//    PG#BGPPP5YJPB55G##B555?PY!^~5GPGGG5YJPGBGGGP7?GBBB####BBBBBBBBBBBG5YYYYJ!:..............::::::::::::    //
//    BGB#BGPPP5Y5GYG#BBG5Y5YJY77!YBGBBBG5?PGGGGGG5?GBBB######BBBBBBBBBBBGP5YYYJJ!^.....:.::::::::::::::::    //
//    ##GGGPYY55YYPPBBBBGPY5YY5JYJJBBBBBBGYPGGGGGGG5PBB########BBBBBBBBBBBBBP5YY55Y?~::.:::::::::::::::^^^    //
//    ###GGG5JY555GBPBBBGPYYYGG5???JBBBBB#PY5PBPPGGGGB##########B#BBBBBBBBBBBBG5YYYYYJ?!::::::::::::^^^^^^    //
//    ##BGGG5J5P55G##BBBGP5YP557~~~~PGY5PBJ777PYJY5GPGB##############BBBBBBBBBBBBGP5Y5Y5Y7^::::::::^^^^^^^    //
//    #BBBGBB55YJJPG#BBBBPJY5!^^~^^^7Y^^?BJ???5577!55PB################BBBBBB#BB###BG5YYYYYJ?!^^^::^^^^^^^    //
//    75BYJYB5!~~7J5###BBPYJ??JJJJ?7JP!^!5Y55YJ?777YGGB######&###################BB###BP5YYY55YYJ?!~^^^^^^    //
//    7YB~^7BJ^^~?!7JB##BBP5YYYYYYYJJJ7!75!!~~~~~!!7?5GGB##&#&&##########################GP5Y555555Y?!~^^^    //
//    5YP~~!G!~^!7~^^PPYB#B5!~~~~~~~~~!!?JJ?~~~~!?Y55PGBBB#&&&&###&#&#####&################BP555555555Y?7~    //
//    PPGJ7?P7~~?!~~!GP~G#J~^~~^^^^^^^^^^~~~~~~~~!J5PPGGBBB#&&&#&&&&&&&&#&&###################GP55555YY55Y    //
//    55YJJYYYJYP5P5PBP7B5~~~~~~^^^^^^~~!7?JYYJJ??Y55PGBB###&&&&&&&&&&&&&&&&#&###&#&############BPP5555555    //
//    BBBBGGGPGGGGGGP5JJP~~~~~~~~~~~~~~~~7?JYYYJYYJ??JPB####&#####&&&&&&&&&&&&&&&&&&&&&#&&#####&&&#BGP5555    //
//    PYJJYYY5YYYJJ????PPJ!~~~~~~~~~~~!!!!!!7???JY5PPPGGB#&&&######&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#BPP5    //
//    J77!!!!7!!!!!!!777JJ7!!!!!!!!!!!7777?YGBBBBBGBBBBBB##&&&&&###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#B    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract GWB is ERC721Creator {
    constructor() ERC721Creator("The Great Wall Of Benin", "GWB") {}
}