// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Absents
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJ?J??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJ??JJ?JJJJJJJJJJJJJ?JJJJJJJJJJJJJ?J?JJ??J?JJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJ?JJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJ???JJJJJ??JJJJJJJJJJJJJJJJJJJJ??JJJJJ??J??JJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJ??JJJJJJ?JJ?JJJJJJJJJJJJJJJJJ??JJJJJJ????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJ???JJJJJ??J?JJJJJJ?JJJJJJJJJJJ?J?JJJ??JJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJ???JJJJJJ????JJJJJJJJJJJJJJJJJ?JJJ?JJ????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJ?JJJ?JJ???J??JJJ?JJJJJJJJJJJJJ?JJJJJ??J??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJ?????JJJJJJJJJJJJJJJJJJJJJJJ??J??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??    //
//    JJJJJJJJ??JJJJJJJ?J??JJJJJJJJJJJJJJJJJJJJJJ??J??JJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???    //
//    JJJJJJJ???J??JJJ????JJJJJJJJJJJJJJJJJJ???JJ?J??JJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????    //
//    JJJJJJJ??J??JJ???????JJJJJJJJJJJJJJJJJJJ???J??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?????J????JJ?????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJ??    //
//    JJJJJJ?JJJ?JJ???????JJJJJJJJJJJJJJJJJ???J?JJ?JJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JYPGB5^.:Y##&#BG55?7??JJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?    //
//    JJJJJJ?JJJJJJ??????JJJJJJJJJJJJJJJJJ?JJJ??J?JJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??!^~YG#@@&&B5:  !Y55PB#&&?.:~JYJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJ??JJ?JJJJ?????JJJJJJJJJJJJJJJJJJ?J?JJ?JJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ7!?J!. .YBPJ!^:.          .::. [email protected]&BPYJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?    //
//    JJJJJ?JJJJJJJ?????JJ?JJJJJJJJJJJJJJ?JJJ?JJJJJJJJJJJJJJJJJJJJJ???JJJJJ?JJJJJJJJJJJJJJJJJJJJJ?!75#@@J.                         ^[email protected]@&GYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?    //
//    JJJJ??JJJJJJJ????JJJJJJJJJJJJJJJJJJ?J??JJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJ775&@@G7:                             ~5&@#Y?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?    //
//    JJJJ?JJJJJJJ?????JJJJJJJJJJJJ[email protected]@P!                                  ^!^^?JJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJ??JJJJJJ??J?JJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJ?:~~?!.                                     .?GGYJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJ?JJJ?JJJ????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJYP57                                         [email protected]@GJJJJJJJJJJJJJJJJJ?J?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJ??JJJJJ?????JJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJ?JJJ?JJJJJJ??JJJJJJJJJJJJJJJJJJJ5#@@J.                                         [email protected]@#YJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJ??JJJJJJ?????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJ?JJJJJJJJJJ??JJJJJJJJ5&@&?                                           [email protected]@B?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    J??JJ??JJJ????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJJJJ????JJJJJJJJ??J?JJJJJY&@&?                                            ^5G?~?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    J?JJ??JJ??????JJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJ?????JJJJJ7?Y!                                                 ~?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    ??JJ?JJ???????JJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J?JJJJJJJJ???JJJJJJJJ~:                                              ~GG?.7?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    ??JJJJJJ?????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJ??JJ?JJJJ5&@P.                                            :[email protected]@?~?JJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    ?JJ?JJ??????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJ?JJJJJJ?????J???J?J#@@?                                            [email protected]@5^7?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJ?????JJJJJJJJ[email protected]@G:                                            [email protected]@P^7?JJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJ?????JJJJJJJJ[email protected]&7                                             ^??^!??JJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJ????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJ??JJJJJJJJ?????JJJJJJ?!^.                                          .77^  !??JJJJJJJ?7?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ    //
//    JJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJ??JJJ?JJJJJJJJJJ?J?JJJJJJY5!.                                          ^[email protected]@J.!?JJJJJJJJJ???JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJ    //
//    JJJJJ?JJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJ??JJ??JJJJJJJJ??JJ??JJJJJY&@#~                                         [email protected]@J:7JJJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJJJ    //
//    ??JJJ?J?JJJJJJJJJ[email protected]@P.                                       [email protected]@#!:7JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J????JJJJJJJJJJJJJ    //
//    ?????JJJJJJJJJJJJJJJJJJJJJJJJ?JJ?JJJJJJJJJJ?JJJJJJJ???????JJJJJJJJ???J???JJJJJY#@@?                                         !5Y^^?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJJJ    //
//    ?J???JJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJ????J???JJJJJJJJ??????JJJJJJ?YB&G:                                      ^7^  .!?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J???JJJJJJJJJJJJJJ    //
//    ????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????????JJJJJ?JJJ??????JJJJJJ?^.:.                                     .?&@B^^?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJ?J???JJJJJJJJJJJJJJ    //
//    J??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????????JJJJJJ?J???????JJJJJ???JJ^                                     :[email protected]@G!7JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJ????JJJJJJJJJJJJJJJ    //
//    J?JJJJJJJJJJJJJ[email protected]@7                                    :[email protected]@P!7??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??????JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJ[email protected]@P.                                    :YGJ~!!?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J??J?JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJ[email protected]@B^                                   .:. ~7???JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????JJJJJJJJ??JJ??????JJ?JJ??~.7PP~                                   .Y&#YJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJ??J???????JJJJJJ?!::                                       7&@&YJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J???JJJJJJJJJJJJJJJJJJJJJJ??J???JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJ???????JJJJJJ?7!Y&&J.                                    [email protected]@P??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J?JJJJJJJJJJJJJJJ    //
//    JJJJJJJJJ[email protected]@5^                                     [email protected]@?^~~!77?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J???JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJ?????J?????????75&@&P~                                        ^7!.:!7777777?????JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?????????JY5GBY^.~Y?^                                              ~#@@&&#BG5777777???JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J?JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJ????JJJ5GB&@@@#Y.                                                   .^!7JY5GB5:.^5BPY?7??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J?JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??????Y#@&BY7^.                                                             .   :YB&@@BPYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J?JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J?J5GY^:^~:                                                                        .^[email protected]&Y!??JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?JJJJJJJJJJJJJJJ    //
//    [email protected]@G:                                                                                .^^. ~55JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJ??JJJJJJJJJJJJJJJJJJJJJJJJJJ?JJ?Y#@&?.                                                                                     [email protected]@BYJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J???JJJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJ?JJ??JJJJJJJJJJJJJJJJJJJJJJJJ?J??J7?&@#!                                                                                        .J&@&5JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J????JJJJJJJJJJJJ    //
//    JJJJJJJJJJJ???JJJJJJJJJJJJJJJ?JJJJJJJJJJJ?JJ?J?.^?J^                                                                                           !#@@PJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??????JJJJJJJJJJJJ    //
//    JJJJJJJJJ???JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J7^~^                                                                                              !P5JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???????JJJJJJJJJJJJ    //
//    JJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J??JJJJ#@G:                                                                                                :7JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???????JJJJJJJJJJJJ    //
//    [email protected]@5.                             .^:.                                                             .5#BY?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J???J?JJJJJJJJJJ    //
//    [email protected]@?                       .^7?!..755^                :.                                           [email protected]@5?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J???JJJJJJJJJJJJ    //
//    [email protected]#~                       :Y55Y^.75Y:               ^55!                                           [email protected]@P?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J??JJJJJJJJJJJJJ    //
//    JJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJJ??J????JJJJ~:!^                        :J55!.:J5?...~7!!!!!~^:...?55?.    :~~~~~~^:.                            [email protected]@P?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J?JJJJJJJJJJJJJJ    //
//    JJJJJJJJJJ?JJJJJJJJJJJJJJJJJJJJJJ???????JJJJ?^!~.                        .?5Y:.:Y5?.:?55555555555YJ5557.   .J55555555J!:                          ^?J7?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J?J?JJJJJJJJJJJJ    //
//    [email protected]@?                       .:J57:.:J57..~J55Y~^~~~!??J5557.   .^Y5Y^:~~7Y557:.                        .:^?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJ    //
//    [email protected]&!                      .7Y55YJJJ55Y?!:!55?:..... .^555!.    .?55!.   .~Y5Y~.                      7##5?JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ?J?JJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???????JJJ?Y&@#^                      .!Y5555555555?!Y555YY5YY57.~555~.    .755?.    .7557.                      [email protected]@GJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??J???JJJJJY&@P:                       .~55Y^:^J55!:7555YJY5YJ7^.7555~.    .7555!:^~7J55?:                       [email protected]@BJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJ??    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??????JJJJJ??^:                        .~55Y:..755!.:J55?:::..  .!555?.   .~Y55555555J7^.                        !&@#YJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ??????JJ?JJYY~.                         ^YP5^..755?..?555J?????^.^Y555?77?J55555Y?~^:.                           .!?7JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???JJJJJJJJJJJJ    //
//    [email protected]@7                         .~7!. .755Y:.:7Y555555J^..~55555PP555?Y5Y:                                .:^JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ????JJJJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???????JJ?J#@&!                                ^Y5?.   .:^~!^:.   .!77?JJ?!~^.~5~.                               .5&#5JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???J??JJJJJJJJJ    //
//    JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ???J?JJJJJY&@&~                                 ::.                           ^Y                                                                                           //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract abs is ERC721Creator {
    constructor() ERC721Creator("Absents", "abs") {}
}