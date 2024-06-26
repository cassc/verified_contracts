// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: December sale
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////
//                                                                    //
//                                                                    //
//    ////////////////////////////////////////////////////////////    //
//    //                                                        //    //
//    //                                                        //    //
//    //    (                                                   //    //
//    //     )\ )                             )                 //    //
//    //    (()/(     (         (     )    ( /(    (   (        //    //
//    //     /(_))   ))\  (    ))\   (     )\())  ))\  )(       //    //
//    //    (_))_   /((_) )\  /((_)  )\  '((_)\  /((_)(()\      //    //
//    //     |   \ (_))  ((_)(_))  _((_)) | |(_)(_))   ((_)     //    //
//    //     | |) |/ -_)/ _| / -_)| '  \()| '_ \/ -_) | '_|     //    //
//    //     (___/ \___|\__|(\___||_|_|_| |_.__/\___| |_|       //    //
//    //     )\ )    (      )\ )                                //    //
//    //    (()/(    )\    (()/(  (                             //    //
//    //     /(_))((((_)(   /(_)) )\                            //    //
//    //    (_))   )\ _ )\ (_))  ((_)                           //    //
//    //    / __|  (_)_\(_)| |   | __|                          //    //
//    //    \__ \   / _ \  | |__ | _|                           //    //
//    //    |___/  /_/ \_\ |____||___|                          //    //
//    //                                                        //    //
//    //                                                        //    //
//    ////////////////////////////////////////////////////////////    //
//                                                                    //
//                                                                    //
////////////////////////////////////////////////////////////////////////


contract DECS is ERC721Creator {
    constructor() ERC721Creator("December sale", "DECS") {}
}