// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Two Dancers
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//    mainconvertsampleshelpabout                                                                                                                               //
//    Result                                                                                                                                                    //
//    &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&############################B##BBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGGGGPPPPPPPPPPP5PPPPPPPP55555YYYYYYYYY555    //
//    &&&&&&&&&&&&&&&&&&#######################################BBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPP555555555555555YYYYYYYYYY55    //
//    &&&&&&&&&&&&&&&&#######################################BBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPP555555555555555YYYYYYYYY555    //
//    &&&&&&&&&&&&&&&&######################################BBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPP5555555555555555YYYYYYYYY55Y    //
//    &&&&&&&&&&&&&&#####################################BBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPP55555555555555555YYYYYYYYY555    //
//    &&&&&&&&&&&&&#################################BB#BBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPPPP55555555555555555YYYYYYYYY55Y    //
//    &&&&&&&&&&&&##############################BBBBBBBBBBBBBBBBBBBBBBBBBBBBGBGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPPPPP55555555555555555YYYYYYYYYYY55    //
//    &&&&&&&&&&&###########################BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPPP55555555555555555555YYYYYYYYYYYYY    //
//    &&&&&&&&&########################BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPPPPPPPP5555555555555555555YYYYYYYYYYYYYYY    //
//    &&&&&&&&#####################BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPPPPP5P555555555555555555555555YYYYYYYYYYYYYYYYYY    //
//    &&&&####################BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBG5GBBBGGGGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPPPPPP555P555555555555555555555555YYYYYYYYYYYYYYJJJJJJJJ    //
//    &&###############BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBG7!J!^JGGGGGGGGGGGGGGGGGPPPPPPPPPPPPPPP55555555555555555555555555555555Y55YYYYYYYYYYYJJJJJJJJJJJJ    //
//    &##########BBBBBBBBBBBBBBBBBBBBBBBBBBBBGGGGGGGGGGGGGBJ~?P5^ ~GGGGGPPPPPPPPPPPPPPPPP5555555555555555J~^:...:7555555YYYYYYYYYYYYYYYJJYYJJJJJJJJJJJJJJJJJ    //
//    &########BBBBBBBBBBBBBBBBBBBBBBBBGGGGGBBGGGGGGGGGGGGG7?J5Y^  ?GPPPPPPPPPPP55555555555555YYYY5YYYYY5~        ~YYYYYYYYYYYYJJJJJJJJJJJJJJJJJJ???????????    //
//    ####BBBBBBBBBBBBBBBBGGGG5?!!77YPGB5:^~!7??JY55YJJYPP!..::..  .5P555555555555555YYYYYYYYYYJJJJJJJJJJ?:..      !?????????JJJJJJJJJJJJJ??????????????????    //
//    #BBBBBBBBB##BBBBBGGGGGGPY?77Y5P55Y?^::..          .: ^^:~:  .^YP555555555555YYYYYYYYJJJJJJJ?????????:..      :7???????????????????????????????????7???    //
//    BBBGGGGGGGBBBBBGGPPPPPPPPPPPPPPPPPPGGGGPY?!^:..      ?&&&Y  ...^7?JYYYY555YYYYYYYYJJJJJJJ?????????7~..       :7777?7777777777777777777777!!!7777777777    //
//    GGGGGGGPPPPPPPPPPPP55555555555555Y555555555PP55?     ^@&Y.         ..:^~!!7JYY5YYYYYYYYYYY55YJJJYY!!?...::^JJJPPYJ77!!!!!!!!!!!!!!~~!!~~~~!!!!!!!!!!!!    //
//    P55555PPPPPPPPPPPPPP55555555YYYYJYYYYYYYYYYYY555.     7:     .:^^:::::.....:J!!!^^~~~!!!7JJ7~^:::.:&&!~!J5&@GY7!?JYY55YJ?7!!~~~~~~~~^^^^^^^^^^^~~~~~~~    //
//    YYJ?JJJJJJ?JJYYY55P55YYYYYYYYYYYJJJJJJJJYJYYY5J^           :JPP555P5YJJJ???77!!!!!777!!!!!!~~~~~~~5&&5!5#&@@?..::::^!?J5PP55YJ?7!~~~~^^^^^^^^^~~~~~~~~    //
//    JJ??777????7777??JJYYYJ????JYYYYYYYJJJJJJJJY7:            ^Y5555YYYJ??JJJJJ?77777777777!!!!!!!!!!?#&&&B&@@@@J^~~~~~^^^^^^^^^~!77!~~~~7~^^^^^^^^^^^^^^^    //
//    J???77777777777777777?J????JYYJJJJJJJJJJJJJ~              ~??JJJJJ?J?????777!!!!!!!!!!!777!!!!!!!!JP#&#YG&&&J^^^~~~~~~~~^^^^^^^^^::.:~~^^^^^^:^:::::^^    //
//    J??77777777777!777!777??????777???????????~               .??7777777?7777!~~~~~!!7!!~~~~!!~~~~~^^^JP5JB5?5&&P:^^^^^^^^^^^^^^^^^^^^^^^^^^^^::::::::::::    //
//    YJ77777777!!!!!!7!!!777!777?7!7777777???7:                 7?77777777!!!!!~!~~^^^^~!!~~~^^^^^^^^^^~!G555?7P&@J:^^^^^^^^^^^^^^^^^^^^^^^::::::::::::::::    //
//    J?7!7?77!!!!!!!!!~~~!!~~~~~~~!!!!!!!!!7~.                  !?7!7!777!!!~~^^^::::::^~~~!!!!~^^^^^^~~^~JP#[email protected]:::::::^:::^^^^^^^^^^^^:::::::::::::::::    //
//    ?7!!!!!7!!!!!!!!~~~~~~~~~~~~~~~!!~~~!~.                    :!!~~~~~^^^^^^::::::::^^^^:^!777!~^^^^~J!~~!YG##G&&~::::::::::::::^^^^^^^^^^:::::::::::::::    //
//    J7!!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~.                     .~~^^^^^^^^^^^::::::::::::^^~~~~~^::::7?YY?JJP&@&@@J::^::::::::::::::^^^^^^^:::::::::::::::    //
//    77!!!!!!~~~~~~~~~~~~~^~~~^~~~^^^~~~:.                       .^^^^^^^^:::::::::::::::^^^~~~^^^::.J&#GYJ7Y#&@@@@Y::::::^^^::::::::::::::::::::::::::::::    //
//    77!!!!!7!!~~!!!!~~~~~~~~~~^^^^^^^^.                          .^^^::::::::::::::::::^^^^^^^~~~^^?#&&@@#5P&@@@@&~:::::::::^^::::::::::.:..:::::::::::.::    //
//    !~!!!77!!7777777777!!~~~~~~~~~^^^.                           .::::::::::::::::::::::::::::::::!#&@&#&&P#@@@@&J~::::::::::::::::::::...............:..:    //
//    !~^^^~~~~~!~~~!!!!!777!!~^^^^~~~.               ..         .:::::::::::::::::^^:::::..:......~GB&@@&BPG&@@@#JJ^.....:::::::.:::::::.............::::::    //
//    ?!~^^^^^^^^^^^^^^^^^^^^^^^^^^^^.      ....::::::^:..   .   .:::::::..:.:::.........:........^P#&P5#&P5&@@@B?JY:..........................::::::^^^^^^^    //
//    !!~^^:::::^^:^^^^^^^^::::::^^~?7:..::^^^^^^^::::::.:^^::..:::::::::::::....................P##B##5J5YG&@@BYY57.................................::::^^^    //
//    !~~^^^^:::::^^^^^:^^^:::::::~5Y^:^^:::::::::^:::::.^?Y~:::::::::.::::....................:[email protected]&&#GGBP7^!P&@GB55:......................................::    //
//    ~~^^^~~~^^:::^:::::::^^::^77?!..:::::::::^^^::::::.:!!::::.......::.....................~B#@@@&#BJ~:::^!B&#5^ ............. ........ .................    //
//    JJ????????77777!7!!7777!!Y5!^~~!!~~^^^^:::::::.....:7!:::::::^::::::::::::::::::::::::^Y&&##&&#5!^::::^[email protected]@5................................::........    //
//    YJJJ????7777!!!!!7777777!7!~!!!~^:::...............:J!.:::^^~!^^^^^^^^^^^^^^^~~^^^^^^7B&&55P5?^::::::^!J5&@B:::^^^::::::^^^^::::::::::::::::::::::::::    //
//    J??????77!7??~^~!!77!!!!!~~~^^^:::::::::::::::::::..YJ:::^^^^^^^^^~~^^^^^^^^^^^^^~7J5G5^:.:[email protected]^^^^^^^^^^::::::::::::::::::::::::::::::::    //
//    JJJJ?????7777777777777!!!^^~~~~~~~~~~~~~~~~^^^~~~~^:.5P?~~~~^^^^^~~~~~~~~^^^^^^!?J7^^!7::::.........~~^:~7!?^^^^^^^^^^^^^^^^::::::::::::::::::::::::::    //
//    JJJJ????????777777!!!!!!!!!!!!!!!~~~~~~~~~~~~~~^^^^^.^~~^~~~~^~^^~~~~~~~~~^~~~~^^^:::::^^^^^:::::::..:~~::^^^^^^^^^^^^^^^^^:^^::::::::::::::::::::::::    //
//    YJJJJ??????7777777!!!!!!!!!!!~~~~~~~~~~~~~~~~~~^^^^^::^^^^^^^^~~~~~~~~~~~~~~~^^^~^^^^^^^^^^^^^:::::::::::^^^^^^^^^^^^^^^^^^:::::::::::::::::::::::::::    //
//    YJJJJ????777777!!!!!!!!!~!!~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^~~^^^^^^~~~~~~~^^^^^^^^^^^^^^^^^^^^^::::::::::^^^^^^^^^^^^^^^^^^:::::::::::::::::::::::::::    //
//    JJ??????777777!!!!!!!!!!!~~~~~~~~^^^^^^^~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^~^~^~~^^^^^^^^~~^~^^^^:::::::::^^^^^^^^^^^^^^:::::::::::::::::::::::::::::::    //
//    J?????????777777!!!!!!!~~~~~~~~~~^^^^^^^~~^^^^^^^^~^^^^^^^^^^^^^^^^~~~~^^^^^^^^^^^^^^^^^^^^~^^^^^::::::::::^^^^^^^^^^^^^::::::::::::::::::::::::::::::    //
//    JJJJJ?????777777!!!!!!!!!!!!!~~~~~^^^^^:::::^^^^^^^^^^^^^^^^^^^^^^^~~~~^~^^^^^^^^^^^^^^^^~~~~^^^^:::::::::^::::::::^^^::::::::::::::::::::::::::::::::    //
//    JJJJJJJ????7777!!!!!!!!!!!!!!!~~~~~^^^^:::^^^^^^^^^^^^^^^^^^^^^^^^^^^~^^^^^^^^^^^^^^^^^^^^^^^^^^^^:::::^^^^^^^^^::::::::::::::::::::::::::::::::::::::    //
//    YYYYYYJYJJJJ???7777777777777777!!~~~^^^^^^^^^^^^~^^^^^^^^^^^^^^~~~~~~~~~~~~~~^^^^^^^^^^^^^~~~~~^^^^^^^^^^^^^^^^^^^^^^^^:::::::::::^^^^^^::::::::::::::    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TWODANCERS is ERC721Creator {
    constructor() ERC721Creator("Two Dancers", "TWODANCERS") {}
}