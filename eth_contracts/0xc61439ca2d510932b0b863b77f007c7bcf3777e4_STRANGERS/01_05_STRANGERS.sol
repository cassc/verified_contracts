// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Strangers
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    &WWW&&WW&&WWMWWWWWMMMz#MMMWWMMM##MWMWW8&&&&&&WWWM#M&88&&8&8&&&WWW&&&WMWW&WMMWWM#####MMMM##MMMW#MWMMW    //
//    WWW##W&W&W&&&W&&####W&WMMMMWMWWWWWWWW&&&&M##W&&&&&&88888&&&M##M&WWWW&WW&W####W&WM#M##MWM#MWWMWWMMM##    //
//    &&WMM&&&&&&&&&&&WWMWWW&&&&WWWMWWWWWWWWW&&M#M&&&&&&&&W#M&&88&WM&&&&WWMMW&WWWMW&&&MMMMMM##MMMMW&&WMMM#    //
//    WW&&&&&&&###MWW&&&&&&&M##WW&WWWWWWWMM&&8&&&&&&&8&&&&MMM&&88&&&&&&WM###&&&&W&WW&M*#MMMMMMMMWMWWWWWWW#    //
//    &8&*M&&88WMW&W&&&&WW&WM#MWWMMW###W&WMW88&&&&&&&WMMW&&&8&&&&&&&&&&&WMMW&8&&&&&&WM##MWMMM###WW&WWWWWW#    //
//    &M##M888&&&&&&&&&WWWW&W&&&WWWWM##WWWMMM##&8&&&&####WWW&&&&M##M&&WWW&&&&&W&&&&&&&&WWWWWMW#MW&&WWW##MM    //
//    &M#MW&&8&&&&8&&W##MW&&W&&8W&WMWWWWWWWMWMW8W8&W&WMWW&&&&W&WM##MWW&&&&&&&&&##M&&W&&&&WWMWMW#WWWMWMMMMW    //
//    &8&&&&&&&&&&&&WWMMWWMW&WW&WWMMWWWWMMWW&&&&&WWW&&WWWWWWW&&&&&&&&&&&&&&&&&&MMWWW&WWW&&WWWWW&WM#xWWWW&W    //
//    ##M&&8888&&&8WW&&&&W&MWWW&WM#MMMWM##MW&&&WMMWWW&&WMW&&&&&##M&&&&&&&W&&&W&W&W&WWWWWWWW&&W&&###MWWWWWM    //
//    WWW&&8&&&&&8W##W&&&WM##&WWMMMMMWWW&&WW8&&M##MW&&&###&&&&&MMM&&&&W&W&&W##W&&&WM##MWWWW&&&WW&W&W&W&WM#    //
//    8&&&&&WMW&&&&WW&&&&WMMMWMMM#MMWW&&&&&W&&Wz{1M8&&&WM&&<'lMW&&&88WMMWW&&WW&&*&&WMMWWWW##MM&&W&&&WWW&WW    //
//    &8&&&&###&8&&888&&WWWWWWWMM##MWWW##WWW&&8i  'WWW&&88"   /W&&&8/[c#MW&&&&&&WW&&&&&WWW###WW&&&WMWWW&MW    //
//    &&&&8&&&888&&&&M#MWWWWWWMMMMW&&&<  "##&&%x   ]&&&88-   iWWWWx'  ^&&&&&W&M#MW&WWWW&WW&WWW&W&M###M&WMW    //
//    &&&&&888&&&&&8WM##WWWWWWWWMM&W&8|.  ;W88%r   '+}1};    >WW&1   `vW&&&W(~n##W&&&&WW&W&&&&&&&&MMMW&&WM    //
//    &W&W&8888&W&88&8&&&&&W&&v}c##M&&8f   "]~,                .'   ,&&WW&_.  ?&&&&W&&&&&MM##W&&&8&&&&&M##    //
//    &&&&&&8M&MMW88&&&&WWM#W8\  ^|MW&8/                            "jWW{'  ^n&&&W&M#MWW&WMMM&&888&&WWWMMM    //
//    ##M&&888&M#M8888&&&&MM&8B]   `\r~.                               .  '{&&&&W&WM#W&&&&&8&&8&&###WWWWWM    //
//    M##W888&&8&8888WMM&&88888%z,                                       .W&&&#M#f}\WWWWW&&&&&&&&MMMW*#ccc    //
//    W&&&8&8&&88888M###W88%%88&W&]                                       `uW|,'   .&&&&&###M&&&&&WWW&&WWM    //
//    &&WM&&&WW&&&888WWv.'~n888WM/                                             .^~)W&&W&M###W&&M&&&W&&WM##    //
//    MMWW&&M#MW8888888%]`  .`"I;                                            'u88MMMWWWW&WW&&W&WMM&W&#MM#M    //
//    ##M&&&&&&&88888&8&W&u<"'                                               '*Mx1]<++~\##W&&&&W##&&&&&&&&    //
//    MW&&888&8&8888888&8888%%u                                                       .'nMM88&88W&MW&88&88    //
//    88&&8888&M#M888888&888%B[                       .'`.         '''         ,<_|xcW8&&&W8&88&W&W&&W###&    //
//    &&&8&&88&WW&8888&#ctjj1~.                      I*MMz"      .fWM#{.      ,8MM#&88&WWWW###&WW&W&WWM#MW    //
//    88&W&&&&888&8888&&.                            :*MMu^      '\#M*}.       :[nM&&&WWWWW##MMW#MWW&W*WMW    //
//    &&###&8&8&888&&&8%*(+i>i,                       .''.         '``            .^l(*&WMMMMWWW&WMM##W#M&    //
//    &M&WW88888W##W8888%8%8&&%{                                             '}}_!^'..<WWMMM#M##MMMMWW#W8&    //
//    8888&88888M##W8888888&#M%B^                                            ]&8W&&&&W#WWWMWM####MM#WMM&&&    //
//    88&WW88888888888WMMW8888fI                                              `<u###*MWWWMW**z*#MM&&WWMMWW    //
//    88W##&%8&88888%%M##M8Mi.                                           ';,`.   :*M#WW&WM#**zz###WMMMM###    //
//    8&8888888&WW&8%%888%%('',_tMB|.                                   ^M&&8%x;. ^8WWMW#MMMM#MMWW&W&WWWM#    //
//    &8&888888###W8%8888%%8WMM&#88%&'                                   ^|MW&8%BvW&&###M#MMWM#W&&&W&WWWWW    //
//    &&W&888888&&888&888%88&&&8888%)                               ~?I.   !&&&&&88&WWMMMMWWMM##M&8&8&#M&W    //
//    8####%8%8&88&8&8WW8888%%8888t,  't%M1"                   .    :W%8{"  ~W&WMW&&&&&WMW&&MWWWWW&&&W##&W    //
//    8&W&88%88888888&##W%%%%%88%/..`_&88%Bc.  .::'    .`^'   !B|.   .n%%BtI{8&##M8&&W&&&&8&&8&&&&&W&&MMW&    //
//    WW8888888&&88%%8&&%%%%%%%%&%%%%88W#M*.  .z8%t   ,8%B8'   n&&_.   }&8888&8WW&&&&WWW&&&&8&88W##MW&WW#M    //
//    ###888&888&88WM8%%%%8&8%%%88&&88&WW&,  `#W#W8   |WMW%r   !#M%8]'.i88&&MMW&&&&&WW&W&&88&8&8WMM&&8&8M#    //
//    &&8%%%88%888&##8%%%%###8%888888&88%%l,/%8&W&8   W###%B]  `888%%%%%8&&&##&8888M##&WW&&&&&8&888&&&&8W#    //
//    %8%%%8###&88%%8888%%8&%%%M&##M8888W8W&88888%#`':8&&8%%B};|88&88M##&88888&&&888W&8&&&###8&&&&&8888&&8    //
//    888%%%WWW8%%%%%&88%%%%%8%%&WM&&%%88WMM8888%88&%888888%8%%%88888WMW8&888%&&&&888888&8WM#W888&W#M&&88&    //
//    %%%%%8%%%8%%%%8###M%%%%%%%8%%%%%%8&###8%88%888%8888888%%888888888&&8%%%8###W%%%%%&8888888&&&###W8888    //
//    %8%%%%%%%8%%%%%&W&%%%%%%%%%8W888%%8%8%%%8WMW8%%The&###8%%8888%%88%%88%8%&MW888%8%%88&W&88888&&W8&&MM    //
//    %%%%%%%%%&%%%8%%%%%%88%%%%W###88%88%8%%%&###MutantsWMW%%%%8888%%%888&%%%888%%88%8%%8###8888&8%888&##    //
//    8&8%%%%%&##W8%%%%%%8##&&%%88888%8%&W&%%8%%%%%%%8%%8%%%%%2022%88%%&##W%8888%%8##M&M&88&88&88&WW8%8&88    //
//    ###&%%%%%WW&%%8%%%%%&&%%%%8%8%88%&###8%%%%%%by%8%%%8%%%%%###&%%8%%&#z%%%8&8888&%%%%%8888%8&###&88&88    //
//    &WW%8%%%%%%%%%&###&%%%%%%8&&&%8%%%8&8%%8%%%%%%8%%%Awadoy%&W&8%888%%%%%%8###W%%%%%%%8&&88888&&&88888&    //
//    888%%%%%%8%%%%&##M88%8%%%W###W%888%8%%%%8W&&8%%%%%M##8%8%%%8888888&888%8###W%8%8%8W###W%%888W88888W&    //
//    %8%%%%WMM&%%%%%%8%8&88&88&WW&8%88%%%%%%%M##8%%8%%888%%%%8%%8%%%&MMW8%%%%%8%8&%%%%%8&W&8%%888%8&88M##    //
//    ##W&8%&W&&%%%%%%%%###8888W&%%%%8M#W8%%%%8&8%%%%88%888888WM#&8%88WW&%%8%8888###8%%8&8888%%W#M8%888&WW    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract STRANGERS is ERC721Creator {
    constructor() ERC721Creator("The Strangers", "STRANGERS") {}
}