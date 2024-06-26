// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Message to the World
/// @author: manifold.xyz

import "./ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&#BGB&@@#GPGGPPGGBB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@#BPP55J?77!~~~^^^~!!^^~7J!~^^~~!?J5GB#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@B5Y?~^^!!~^~!!^::^~7??7777?J?~:^!???7!^:^~77J5B&@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@&G5Y7^^~~^:^~~~^:^!^:.:^^^?J!~^^^^^^~??!~~~~!7??!~~!?Y#@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@&#57!!~^~!77777!!!!!~~~!!7??~:!~:::^::^~7J?~^:^~7?!^^~~~!7!7J5G&@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@GY?7^:~?!~!77!!!~:^?~^::^~7J7^^!~::::^~!!77~~~!!::^!~~!7^^~!77J!^!P&@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@G777!77!!!!~~^~!~^:.~J!^::^!7?77?~^~!7?7!^^:.^^^!?!^^~?JJJ7~^[email protected]@@@@@@@@@@@@@@@    //
//    @@@@@@@@@#PY~~!~^~7?!~~^^~7!~^:^7?~:^7?JJ?77!7?JY?~^:^~~~!~!!!!!!!!7??!!!!!!!7!!!7?7J&@@@@@@@@@@@@@@    //
//    @@@@@@@#Y7!7????7~!?JYJ7~!7~~^^!?J!::~!~^::::^7J!^::^~!?JJ?7777~^^:^~~~~!!7??JJ!^~!!!75&@@@@@@@@@@@@    //
//    @@@@@@P77?J7!^^7J?!~!!!~~??!~^~!?J7~~~~~^^^^^~?J7~^:::~?J7^~~~^^^^^^~~!77!!!??~:^~~!777J#@@@@@@@@@@@    //
//    @@@@@P?JJJJ?7!!7!~~~~^::~7JYJ?7!!JYJ?7~^^~~7JYYJY?~::~7!::!^::::^~!~!7JJ!^^~~!7!!7777777?&@@@@@@@@@@    //
//    @@@@GJY????JJJJJ??777!~~~~^!?JYYY?77!~^^7?JJ?!~~^^^!?Y!::^~^~!!~!77!!!J?:^~!!77!!!!777777?5#@@@@@@@@    //
//    @@@#?77????7!!7Y5YY5YYJ?!!~^:^7J7~~7J7!7JJ!:~!!!7?Y5PJ^^!7!!7J?!!!!!!7??^~!!77?!!!!7777777!!Y&@@@@@@    //
//    @@@Y7??JJ?7?JJYY?77???JJJ7~~!7?J!^~7YJ???~::^^^^~!?P5!!7JY??J57!!77???5?^!7????!!7?J?77!!77!~J&@@@@@    //
//    @@B??JYYJ?7!!!??!?YJ7!!!~~~!?J55?~^[email protected]@@@@    //
//    @&JJYY?!?YYJ!~!7~!77!!!!!7?JYPGGJ[email protected]@@@    //
//    @G7??77?JJJJ!!77!!7???JY55PPPPG?77[email protected]@@    //
//    @P??JYY??J?77?JJJY55PP55P577J?J7?J777?JYJJJ??JJJYPGP5YYYY5PY!~!77???J5GJ?77777?777?5Y?777???7??!7#@@    //
//    @GJJJYJ?JJYJ???JYPJ???JJ?!!?JYY??JJ???J55??JYY5PPP5YYY5P5Y?7!77?????JP5YJ???JJ????YPY???77??77?7!?&@    //
//    @&J?JJYYYJJYYY5PPY?77!7JJ?JYP55J?Y5?[email protected]    //
//    @@#P??JYYYYY5PGPYJJ?JJJJJJJYBGP5????[email protected]    //
//    @@@&J??JJ??JY5?7?JJJYY55555P#&#B55YYY5PGBPJ7!!7????J?77????JJJJYGG5JJJJJJJJ??Y5YJJ?J5YJJ?777777!!7#@    //
//    @@@@BJ?JJJJJJJJJ??JJJYY55PG##GYJ???[email protected]@    //
//    @@@@@&GYJJ????JYYYYYYYYY5PG5J???JJJ[email protected]@    //
//    @@@@@@@@&#GGP5YYYYYYY55PP5?7??JYP5??J?77????JJY5PYJ??????JJJJJYPP5JJJJJJJJJJY5JJJJJ??????7!7777!J&@@    //
//    @@@@@@@@@@@@@@@@&&#&&&@&5???JY5PY?7?JJ?JJJJJYJJJY5JJJJJJJJYYYYYYJJJJJJJJJ????Y5YYJJJJJ??77????77#@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@Y??JJY5PY?[email protected]@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@#??JJJJY5J[email protected]@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@BYJYYJJYJ?JYYJJJJJJJJ?JJJJJJJJ????JYYYJJ?????JJJYYYYYYJJJ??????77PB#&@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@&[email protected]@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@&#[email protected]@#GGGGPPPPPP55YYYYYYYYYJJJY5B&@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#BGP55555GBBB#&B^^^[email protected]@@@BPPP55555555YYYJJJYY5PG#&@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B^^!B#@@@@@&###BP555YY55PGGB#&@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@B^:[email protected]&@@@@@@@@@@@&#B#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&GG#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MttW is ERC1155Creator {
    constructor() ERC1155Creator() {}
}