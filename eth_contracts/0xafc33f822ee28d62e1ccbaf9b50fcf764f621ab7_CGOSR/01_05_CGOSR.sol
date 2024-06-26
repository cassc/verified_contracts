// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ChefGlitch on Superrare
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//    /********,*,,,,....,,,,,,,,,*,,,,,,,,,,/*****,,*,,,.,,,.,,.,,.,.,,,,,,,***.,/##.    //
//    &&&&&&&&&&&&&&&&&&%%%#%#(//******,****////(((((/(((((///////**@&&&&&@@&&@&(../%#    //
//    &@,,,,,,,,,, *,%&@@&&@&@@&&/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@&&&&&&&&&&&(,..(%    //
//    &@,,,,,,,,(,,,*%&,.*/,,.,@&(,,,,,,,((,,,,,,**,,,,,,,,//,,,,,,,&&&&&&&&&@&&&,...%    //
//    &#,,,,*,,,,,**,%&,&.*@.  @&/,..,,,*.&*., ......,,,,,,*%,,,,/,/&%&..%&@&(@*#/..//    //
//    &,,,**(/#,/,,,,#&(,&&@&@.&&,,..........%&&/#( ..,/...,.....,,/&&(,,#*%( (@/(....    //
//    &,,*,,,,,,,,,,,#@*       @&,,....*,..#,%#&&&#& *,#.........,,/&&&&&&&&&@&&%/....    //
//    @,,,,,,/(*,,,,,(&/*@*&@  @&,......%.,%&&###/(/@..&.(.....,,,,*&&&,..%&(*,*@,.,,.    //
//    @.,,,,,,,,,,,,,*&([email protected]%&@( @&,....,&,(..,%&&(@%&%/,,*...,,,,,,,,#&&[email protected](&&&.,&,##(/    //
//    &&&&&&&&&&&&.,,*&&&&&&&&&&&,............#&&&&&&&%%##(((/*,,,**&&&. ,((.&#*@%****    //
//    @&        @&,,,,,.,....,#,.,..,,....//,,&@&&&&&&&&&&&&&&&#(*,*&&&@@&@&&&@&&&/*&&    //
//    @&&#&&    &&.,,....,.,.,&@&#(/*,,,,**/&&&&&&&&&&&&&&&&&&&%%/*,,@@* .,.....&&/*//    //
//    &&*@@,    @&.,....,@,.,&%#%%&,,,,,#@&&&&&&&&&&&&&&&&&&&&&&%#/***,*&&&&&  .&&*/*/    //
//    @&......,,@&...,.,@..,&%#&#@#,.,,,&&&&&&&&&&&&&&&&&&&&&&&&&#(/*,*/ ,,% *./&@#///    //
//    && @ #@   @&.....,..//,&@%%@*,(..%&&&&&&&&&&&&&&&&&&&&&&&&&##/***(    &.  &@&///    //
//    &&     .  @&.,...,../%@&@&@@%&%%&@&&&&&&&&&&&&&&&&&&&&&&&&&@%(/*//*////@@&@&@/(/    //
//    &&@@@&&&%%&&,....,%&%&&&&&&@@#@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&##//(/(/((//&&&&&###    //
//    &&&&&&&&&&&&,.....&&#%%&@&&&%&&%(@&&&&&&&&&&&&&&&&&&&&&&&&&&%#(((((%&&&&&&&@&(%(    //
//    %&   &&&( /&,...*,[email protected]&@@@@@@&&&&@%&&&&&&&&&&&&&&&&&&&&&&&&&&&&##&&&&&&&&&&&&&&#%%    //
//    %&    (@* .&*,,,**,%&%&%@@&&%&&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##    //
//    %& ,@(/#& ,&*.,,,,,,&&&&&@&%@@&&&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%#    //
//    #&@&&&&&&@&&(,,,,,,,,(/@&&&@@&@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&#&&&&&&&&&%&&&&&&%%    //
//    #&#%%@&%(#%&,,*,,** *@&&&&&.  &&@&&&&&&&&&&&&&&&&&&&&&&&&@&&%%%&%%%&&%&&&%&%&&#%    //
//    #@(&&@&&&&&&@@@@@@((&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@%%&&#&.&%%%%%&%%%&&&&&&&%%    //
//    #&&&&@&&&&&&@@@@&@,*@&&&&&&&&&&&#@&&&&&&&&&&&&&&&&&&&/@&@&&%%&%(%&(%%%*%(%%%%%%%    //
//    ,,&*@@@@@@&@@@@@&@(*&&&&&&@@&&&(&&&&%&&&&&&&&&&&&&&&&@&&@&@/%%%%&        &%%%%%%    //
//    &&&#@&&&@@&&@@&&&@ &&&&&&&&&&&&&&&&%&&&&&&&&&&&&&&&&&&@&&&%%%%%%& %  &   &&&%%%%    //
//    .&&&&&@&&&&&@@@@@ /&&&&&&&&&&&&&@&%%%%&&&&&&&&&&&&&&&&%%%.#%%%%%& ./#&&  &%%%%%%    //
//    ...&/@@@&@@@&&@&&.&&&&&&&&%&%&&&&&%%&/%@&&&&&&&&&&&&&&&%%%%%%%%%&   &&   %%%%%%%    //
//    .,,&,@@@&&@@@@&&&(&&&&&&&&&%&&&&&&%%%%%%&&&&&&&&&&&&&@&%(%%%%%%%%%%%%%%%%%%%%%%%    //
//    ,,[email protected](&@@&@&&&&@&&,&&&&&@&%%%%%@&&&/%%%%%&&&&&&&&&&&&&&@%(%%%%%%%%%%%%%%%%%%%%%%%    //
//    ,,,%%@&@&&&&&&&&&#&&&&&&&%%%%%&&@&%%%%%%,&&&&&&&&&&&&&&&%%%%%%%%%%%%%%%%%%%%%%%%    //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract CGOSR is ERC721Creator {
    constructor() ERC721Creator("ChefGlitch on Superrare", "CGOSR") {}
}