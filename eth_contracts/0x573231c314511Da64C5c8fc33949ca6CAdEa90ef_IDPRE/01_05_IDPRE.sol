// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Whispers in the Snow | 雪のささやき
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////
//                                          //
//                                          //
//                    ()                    //
//                    /\                    //
//                   //\\                   //
//                  <<  >>                  //
//              ()   \\//   ()              //
//    ()._____   /\   \\   /\   _____.()    //
//       \.--.\ //\\ //\\ //\\ /.--./       //
//        \\__\\/__\//__\//__\\/__//        //
//         '--/\\--//\--//\--/\\--'         //
//            \\\\///\\//\\\////            //
//        ()-= >>\\< <\\> >\\<< =-()        //
//            ////\\\//\\///\\\\            //
//         .--\\/--\//--\//--\//--.         //
//        //""/\\""//\""//\""//\""\\        //
//       /'--'/ \\// \\// \\// \'--'\       //
//     ()`"""`   \/   //   \/   `""""`()    //
//              ()   //\\   ()              //
//                  <<  >>                  //
//                   \\//                   //
//                    \/                    //
//                    ()                    //
//                                          //
//                                          //
//////////////////////////////////////////////


contract IDPRE is ERC721Creator {
    constructor() ERC721Creator(unicode"Whispers in the Snow | 雪のささやき", "IDPRE") {}
}