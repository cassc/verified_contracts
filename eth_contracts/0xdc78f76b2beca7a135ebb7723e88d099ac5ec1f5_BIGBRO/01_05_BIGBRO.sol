// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 1984 - Big Brother is Watching You
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    @##((((((((((////***((**,**/,,,*.,,*,,,.,.,,.,,*.........,,,**,,/**//////(((((((    //
//    &###(#((/#(/%///****///*,,*/,,*/*/,,.,,,,,,.,..,..,.*,,,,,,*,*,,*//*/////(((((#(    //
//    &#&(&((%%//&&/%&**&*&(#&#,.,,,,,,,,,&&@@@@&&&@&@@,..,,*,,,,,,,,*(**/*////((((##(    //
//    &#(((////(//*****,,,,,,,//,.,,.....*&&&&%(//*/&&&(..,...,..,..,****,***(*///((#(    //
//    %##%&%//&&/&%*&##,,,,*,.,../@@%#...%&&&&&&&&&*%&&&%&&@&&%,.....,,,,,//**///////(    //
//    &#(////////*****,,,,,,,,,&&@&##&#..%&&&&&&&&#&&&&&&@&@@%&@.,,,,*,,,**/***(((//((    //
//    %#&(&(%&*&(&&*&%,&,,#&,.,*...,.....&&&&&&@@@&&&@&&/...,......,,..,,,,*%***///(((    //
//    %#(/(*/**/*/,*,,,,,,.,..%,...,&&@&&@&&&&&&*&&%&@%%&&%%#/....,,,.,,,,,******////(    //
//    %((&/&/&&*/&#,*,,,,,,,.,(/,.,&&&&&&&&&&@&&%&&&&*,%&&&&&%&.....,.*.,*,,****//////    //
//    (#(//*****,**,,**,..,...,..#&&&&&&&&&&@&&&#&@&&@&&&&&&&&&&.....*.,,,,*,,*#*/////    //
//    %#(//*(**,,,,,.,.*,,/,....%&&&@&&&&@&&@&&&%&&&&&&&&&&&&&&%%....,...,,,,*****/*//    //
//    #%(//*/*****,,.,,,..,...&&&&&&&&.(&&&@@@&@@@@&&&@&&&,.&&&&&%%,,,....,*,,,,***///    //
//    #(//*******,,,,,.,.((%%&&&@&&%....&&@&@@@@%&&@&&@&&%. ..%&&&&&%%#/.,,,,,,****/*/    //
//    #(///****,,**,,,,#&%%&&&%&&(,.,..*&&&&&@&&%@&&&&&&&%..,.(.&%&&&&&%%..,,,,*,**///    //
//    //**/*****,%@#@&&&%&&&&%#.,... ..&&@&&&&&&#&&&&@&&&%.........&&&&&&&&&&*/%%**/(/    //
//    (///(*****/(##%&&&#..** ........ &&&@&&&&&%&&&&&&&&#.,,... .....,,&&%%##(***/*/*    //
//    //******/#&/&&&&,,.,....,....... &&&&&@&&&%@&&&&&@&%....,,.........,(&&%&%@/*/(/    //
//    **/****,(#%*@,[email protected],,........,.....,&&&&&&&&&#&@@&&%@@@,.......,......*&,%,%/##(/**    //
//    *//*****/%&,@/,&*...(.........,*%&&&&&&&&&&&&&&@&&&&/,*.. *..... ..*(,%,%*%*//**    //
//    */*******&@*@*,(,.......,.... ,/%&&&&@&&&&&@&&&&&&&&%..,..,..,..,,,#,*%,&*%/**(*    //
//    ******,**&@*@*,,*.......... ,...&&&@&&&&&&&&&@&@&&&&&....... ...,,,%,/&.&*%***/*    //
//    *******//&@*@*.,(,....,..*.,**..&&&&&&&&&@,&&&&&&@&&%, ..%( ..*,..#*./&*%#&**,**    //
//    *///**/**@&,@,..&,..... ....,%%#@&&@&&&&&&.&&&&@&&&%%,%%..*,,*//*/%.,,%,%,%*****    //
//    ****,,,,,@%*&/#%@,......,..,,.%@@&@&&&@&&&.*&&@&&&&&%%%...*(#%#####((/%/#/%/*,**    //
//    ****,,,,*&(*@&&%%%#*...... . #%@@&&&&@&&&&..&@@@&&&&@%&*,,/(##%##%##%%@%%#&#/***    //
//    /*/***/,/@&&&&&&&(*,.,,,/.,.,*%@@@#%#@&@@(.,@@&@@@@@@&#,..,,*//(#####%%#&%@%#(((    //
//    //*/*//%&&&&#/,*****,,,,,,.,,,(%@@&&&&@&@*#(@@@@&@@@@@...........,.,*(%&%%%%%%((    //
//    /*(/*/%&&&&&%**,,.,,.,,.**,..,.(@@@@&@@@&&%%&@@&@@@@@/.,.,...*.,*,***(##%%&&%%%#    //
//    *****/%&&&&&%/..,,,**........,,*@@@@@@@@%%%%%@@@@@@@&,,..,....,.,.,,,/##%%%%%%%#    //
//    ****/#&&&&&&%/,,,,..,.,.,,...*.*&&@@@@@&%%%&%@@@@@@&&.,.,.,,,,.%&&..&*(@%@%@%%%%    //
//    /*/*(&&&&&&&%/*,,,..........,,..&&@@@@@%%%%%%%@@@@&&&....,.%*,&.,&.,&*@#@@%%%%%%    //
//    /***#&&&&&&&%/,,......,.,..,....&&@@@@@%%%%%%%@@@@@&&,.,.,.,..,%.&..&*@@%%@%%%%%    //
//    /**(&&&&&&&&#,,...... ......,.,.&@@@@@&%%%%%%%@@@@@&&(.... ,%.&&&(.,,/&%&&&&&&&&    //
//    **(%//#&&&&&%/,.,,........,....*&@@@@@&%%%%%%%@@@@@@%,......./(/...,#@##%%%%%%%%    //
//    ///***/%&&&&%*.,,,,.,,.*.,.,.*,,@@@@@@&%&%&%&%@@@@@@&,...*....,,,**&@@#%#%%%&%%%    //
//    ////**#&&&&&&/,,,.,.,.,*,,..,,,(@@@@@&&%%%%&&&@@@@@&@/,*..**,*,,*/###%%%%%&&%%%&    //
//    /(/(//(%&&&&&%/,,,,,...*,,...,,[email protected]&@@&%%%%%%%&%&@@@@&*..,,,.,.*,/**,**(#%%&%%%%%%    //
//    ////**(&&&&&&%/,,.,,..,..,..*,.*&%@@@&%%%%%%%%%%@&%&/,..*...,,,,..##%##&%%%%%%&%    //
//    ((////%&&%%&&#/,,,,,,,.,..*/,.*&&%@@&%%%%%&&%%%&@&#%%*.,.,(.,,,*,*,*/#%%%&&%%%&&    //
//    ((/(/(%&&&#%&&#/,,,,,,,,.,..,*&&*@@&%%%%(,%&%%%%&@&(&@*,..,,**,,,/*/##%%%%%%&%&%    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract BIGBRO is ERC721Creator {
    constructor() ERC721Creator("1984 - Big Brother is Watching You", "BIGBRO") {}
}