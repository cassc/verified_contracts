// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: BAYCartoon
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
//    ////////////////////////////////////////////////////////////////////////////////////////////    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                            .                               .                           //    //
//    //                                             *&@@@&&&#.     .  .                        //    //
//    //                  .   .                    %@@@@@@@@@@&/.          .                    //    //
//    //                                         #@@@@@@@@@@@@@#.            .                  //    //
//    //              .     . .       .     . .(&@@@@@@@@@@@@@%/,                               //    //
//    //                   .  .         .    %&@@@@@@@@@@@@@@(*,...          .                  //    //
//    //                 . ..    .       . #&@@@@@@@@@@@@@%(**,      .      .     .             //    //
//    //         .      ..  . . ...   ...#@@@@@@@@@@@@@@@(**,..  .. .      ,,***. .             //    //
//    //            .  ..      .  .... (@@@@@@@@@@@@@@@#**,          . .*&@@&@@@@%/ .           //    //
//    //       ..  .......  . .......#@@@@@@@@@@@@@@&#**,.  .         /%@@@@@@@@@@@#  ..        //    //
//    //      ...    ..... ...  ...#@@@@@@@@@@@@@@%#**,     . .    ./&@@@@@@@@@@@@@(.           //    //
//    //     .   ... . ......  . (&@@@@@@@@@@@@@&(/*,        .....(&@@@@@@@@@@@@@@#*,           //    //
//    //     ... .......,...,,.(@@@@@@@@@@@@@@@#***.       .....(%@@@@@@@@@@@@@@%/*,. ....      //    //
//    //     . ......,,,,...,/@@@@@@@@@@@@@@&#**,...... .. .../&@@@@@@@@@@@@@@#***........      //    //
//    //     .... .,.....,.(&@@@@@@@@@@@@@@(/*,.. ..  .. .  /%@@@@@@@@@@@@@&%/*,.. .,......     //    //
//    //     ... .....,.,#&@@@@@@@@@@@@@&(/*,... .........*&@@@@@@@@@@@@@&#//*.............     //    //
//    //     ....,..,..%@@@@@@@@@@@@@@&(***... . ......./&@@@@@@@@@@@@@@%/**........,,,,,..     //    //
//    //     .,,,. ../&@@@@@@@@@@@@@@#/**.    ... . ..*%@@@@@@@@@@@@@@#///,......,,.,,,,..      //    //
//    //      ../,..*#@@@@@@@@@@@@@(//*... ....  .. (&@@@@@@@@@@@@@@#/**,,.....,,,,,**,,..      //    //
//    //       .*,,,.(&@@@@@@@@@&(//*..... ..... ./&@@@@@@@@@@@@@&%//*..,..,.,,,,,,*,,,...      //    //
//    //        ..,,*,(%@@@@@&%//*,,....,......./&@@@@@@@@@@@@@@%///,.,....,,,,,*,,**,..        //    //
//    //         ,.,.,,**/////*/*,.,......,...*%@@@@@@@@@@@@@@&(/*,,.,,,,..,,,,*,**,,..         //    //
//    //          .. ,,,*..*.,,,.,..,.......(&@@@@@@@@@@@@@@&(/*,,,,*.,*,,,,,,,**,....          //    //
//    //            .,..,,*,,.,*.,,,,..,../%@@@@@@@@@@@@@@%//*,,.,.,,,,,,,,*****,...            //    //
//    //              *,,,.*,,,**,,,*,,,.#@@@@@@@@@@@@@&%/(/*,,,,,*,*,**,****,,,,..             //    //
//    //                ,,,,.,/********,*%&@@@@@@@@@@@%(/**,,,,,,,*,,***,,*,,,..                //    //
//    //                   .,,.*/**//**,/(%@@@@@@@@@%///,,*,******,*/,*,,,....                  //    //
//    //                      ...,,*****/*/##%&&%##(//******,/**,,,,,,.. .                      //    //
//    //                          ...,,**,/*((((#((//**/**,,*,*.,...,.                          //    //
//    //                                ..,.*,..,,,.*,,,.,,.,....                               //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    ////////////////////////////////////////////////////////////////////////////////////////////    //
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////


contract darko is ERC721Creator {
    constructor() ERC721Creator("BAYCartoon", "darko") {}
}