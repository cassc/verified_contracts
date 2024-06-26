// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: SPR_Invisible_Cities
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//                                                                                        //
//    **##(/*..,,*#&&&&&&&%*.....      ..                         ,#&&&&&&&,,,**((,**.    //
//    *(#(*.,,*.&&&&&&&&&&&&&&&&&&&&&#                  %&&&&&&&&&&&&&&&&@&&&#*,/(((((    //
//    *////***&&&&&&&&&&&&&&&&&&&&&&&&@                &&&&&&&&&/           #&&&*,*,/.    //
//    //**,(&&&&&&&&&&&&&&&&&&&&&&&&&&&&              &&&&&&&@                 &&&*(,*    //
//    *..&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&           .&&&&&&&&                    @&&(.    //
//    /***&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&         /&&&&&&&&                    &&&%,,    //
//    */*,*&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&.      #&&&&&&&%                    &&&(...    //
//    //..&&%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&/    &@&&&&&&&&&                  @&&,. ..    //
//    */,&&,,(&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@      %&&&&&&&&&&&*              @&&.  ..     //
//    //, /&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&      &&&&&&&&&&&&&&&&  *&&&&&&&&&&&           //
//    **,..     &&&&&&&&&&&&&&&&&&&&&&&&&&        .&&&&&&&&&&&&&&&&&&&&&&&&&&&            //
//    **,,.           #&&&&&&&&&&&&&&&&&&&&@    /&&&&&&&&&&&&&&&&&&&&#.                   //
//    *,,               &&&&&&&&&&&&&&&&&&#   &&&&&&&&&&&&&&&&&&&&&@                      //
//    .,.                &&&&&&&&&&&&&&&&*  @&&&&&&&&&&&&&&&&&&&&&(                       //
//    ,,,,.                  .&&&&&&&&&&. &&&&&&&&&&&&&&&&&&&@                            //
//    ,,,...                  @   %&&&&.&&&&&&&&&&&&&&&&&#   ,                       #    //
//    ,,*,..                 ,&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&              . &@@@@@@@    //
//    ,,,..                    @&&&&&&&&&&&&&&&&&&&&&&&&&&&&&           @@@@@@@@@.%@@@    //
//    ,,.                       /&&&&&&&&&&&&&&&&&&&&&&&&&&.        (@ #@@&,@@@@@@@@@@    //
//    ***..                       @&&&&&&&&&&&&&&&&&&&&&&@         /&[email protected]@@@@@@@@@/@@@@@    //
//    **,..                        &&&&&&&&&&&&&&&&&&&&&(        /@@@@@@@%(@@@@@@@@@@@    //
//    /,,...                    &&   &&&&&&&&&&&&&&&&&&  .&#     .,.%@@@@@@@@@@@@@@@@@    //
//    **,.,                       %   &&&&&&&&&&&&&&&#  .#      &@@@@@@@,@@@@@@@@@@@@@    //
//    ,.,*.,                           .&&&&&&&&&&&&               @@@@@@@@@@@@@@@@@@@    //
//    */,/(,...                                                ,@@@@@@&@@@@@@@@@@@@@@@    //
//    *,,,**,.,,                          *&&&&&&                /@@@@@@@@@@@@@@@@@@@@    //
//    ***,**,*,,                            &&&&                #@@@/@@@@@@@@@@@@@@@@@    //
//    (*/*/*,,*.     ..                      (.                  &@/@@@@@@@@@@(@@@@@@@    //
//    ,,  ..*..     ,..     .                                    ([email protected]@@@%/@@@@@@@@@@@@@    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract SPRIC is ERC721Creator {
    constructor() ERC721Creator("SPR_Invisible_Cities", "SPRIC") {}
}