// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Flying Farting Ducks 'n EGGs by Karrie Ross
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                      //
//                                                                                                                                                                                      //
//                                                              ,      ,,,,,,,,                                                                                                         //
//                                                    ,,;|||________________________ ___||;  _                                                                                          //
//                                               ,,l|||________________________||_________ __ |                                                                                         //
//                                           ,<l||____________________________________||_________ | _                                                                                   //
//                                        ,L||__|'   _____________________________________|||________!,                                                                                 //
//                                    ,Ll||___ _ _ ___________________________|________  __||||||||_____|__| _                                                                          //
//                                ,||_________________________________________________________||||||||||______|                                                                         //
//                              ,l__|__|||||___________________________ __ _____________________|||||||||||||___| _                                                                     //
//                           ,!|_||_||||||||______________ _,,gg@@@@@@@@@@gmppg,,_    _____________||||||||||||____L                                                                    //
//                         ,l__|___|||||||____________,gg@@@@@@@@@@@@@@@@@@@@@@@@@@@@Nwg,_ ______________|||||||||__ | _                                                                //
//                      _;|||_ __|||||||||_____ _,,g@@@@@@@@@@P,@$@@@@@@@@@@@@@@@@@@@@@@@@@@p,  _ ___ _||____|||||||____                                                                //
//                     ,|||  ___|||||||||____,g@@@@@@@@@@@@ @C]@V@p]@@R@@@@@@@@@@@@@@@@@@@@@@@@@@@g,__|_________||||||___|                                                              //
//                    L__|  __|||||||||||_,g@@@@@@@@@P,g@K_@h,Rg$$g@$$@%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@g __________|||||___                                                              //
//                  |________|||||||||||,@@@@@@@@@@@P]@@P @K g$ @P)@]@@]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,|________||||||___                                                            //
//                | ______ _||||||||||_@@RRNNNR@@@NN_RR@ @P K@ ]@ jg@@Q@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@g_____|___|||||__                                                            //
//               |________||||||||||_g@@@@P  ]@@@@@C,]@@@@ gR@]@$,]M$g@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,_|||_||||||||__|                                                          //
//              _________||||||||'__g@@@@@L  $@@@@`@@@@$NN@$g@$@@@@@****"""*B@g   @Ng `%@@`__$@@@BNNNB@@@@@@@@g__|_||__|||||__                                                          //
//             _________||||||||___@@@@@@@K  $@@P,@@@@@@@@@_  ]@@@@@@  ]@@@  ]@  ]@@@  _@@, ,@  ]@@@N]@@@@@@@@@@__|_____||||||_                                                         //
//            __________|||||||__,@@@@@@@@K  $@`@@@@@@@@@@@]C  @@@@@@  ]@@@_  @  ]@@@  _@Q"""]  ]@@]@W@@@@@@@@@@@_|||_|||||||||_                                                        //
//            ______|___|||||| __@@@@@@@@@P  F,@@@@@@@@@@@ @@  ]@@@@@  ]@@@  g@  ]@@"  @@@[  @P ]NP @@@@@@@@@@@@@@_||_||_|||||||                                                        //
//          |__________||||||___@@@@@@@@@@P    "B@@@@@@@@P]R@P  @@@@@  ]*",g@@@  ]gg'%@@@@K  @L  @g @@@@@@@@@@@@@@r|||||_||||||_L                                                       //
//          ____________||||___#@@@@@@@@@@P  @  _%@@@@@@@j@@@/  ]@@@@  ]@C ]@@@  ]@@  ]@@@K  @K  @@@]@@@@@@@@@@@@@@|||||__||||||_                                                       //
//          ____________||||___@@@@@@@@@@@P  @@_  %@@@@@ @@@@@W  $@@@  ]@@  ]@@  _M@K  @@M^^~,[  $@@@@ $@@@@@@@@@@@|||||___|||||||                                                      //
//          ___________|||||__$@@@@@@@@@@@P  @@@   %@@@ggg@@@@@   @@@  ]@@   @Qg@Ng"%  ] @@@@__  ]*$$,,]@@@@@@@@@@@_||||__|||||||__                                                     //
//          ___________|||||__@@@@@@@@@@@@P  @@@@p  %@@@@@@@@@ggggg@@   @@P  [%@@@@@ \  N`",@@ @@@@@@@@@@@@@@@@@@@@_||||||_||||||_                                                      //
//          __________|||||| j@@@@@@@@@@@[,,,,$@@@g  %@@@@@@@@@@@@@@mggmg@@  ]Nwgg@@ ]@_"B@@@`g@@@@@@@@@@@@@@@@@@@@P|||||___|||||__                                                     //
//          ________||__||||_]@@@@@@@@@@@@@@@@@@@@@@w,`*M@@"""`]`"*@@@@@@@@@, ]@@@@`,@@@@Ngg@@@@@@@@@@@@@@@@@@@@@@@P|||||__||||||__                                                     //
//          ___________||||||]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@K  %@@@@@@@NNNpggg@@P"2"M]@P"$Z%C]@@@@@@@@@@@@@@@@P|||||__||||||___                                                    //
//          __________|||||||]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@@   @@@P ,@@@g "@@@  @@@p]  @@@@ ]@@@@@@@@@@@@@@@@P||||||_||||||___                                                    //
//          _____________'|||]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@@   @@  ,@@@@@C _$@  ]@@@]  ]@@@K]@@@@@@@@@@@@@@@@P|||||_|||||||___                                                    //
//           _____________||_]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@P _@@_  @@@@@@@  ]@N  ]@@@@   B@@@@@@@@@@@@@@@@@@@_|||||_||||||||__                                                    //
//          |______________|_"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  "*`,g@@@_  @@@@@@@   @@@  _%@@@_  ]@@@@@@@@@@@@@@@@@@_|||||||||||||___                                                    //
//           _________________"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]g _%@@@   @@@@@@@  ]@@@@   ]@@@g  "@@@@@@@@@@@@@@@@K||||||||||||||__                                                     //
//           |_________________]@@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@P  %@@K  ]@@@@@C ,@@@@@@g  _B@@N   %@@@@@@@@@@@@@@_||||||||||||||_                                                      //
//            _|________________"@@@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@   $@@@, %@@@" g@@@@@@@@@_  %@@@   ]@@@@@@@@@@@@_||||||_|||||||_L                                                      //
//            '___________________%@@@@@@@@@@@@@@@@@@@@@@@@@  ]@@@   @@@@@@pg@@@@@@@M**MB",,  _""Nw  $@@@@@@@@@@_|'_____|||||||||_                                                      //
//             '_|________________ __"*N@@@@@@@@@@@@@@@@@@@*  _*@@@g _%@@@@@@@@@@@,@@@@Pg]@@p ]@Ng   ]@@@@@@@@@_|______|_|||||_|'                                                       //
//              '|________||_____________'*N@@@@@@@@@@@@@@@@@@@@@@@@@Npg@@@@@@@@@ @@@@@ @@@@@ ]@@@@P __"B@@@N"|||||____`||||__|'                                                        //
//               _|_________|___ ____________ "*N@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@p%@@@@@"B@@@ @@@@P g@@g, `'l||||||||_| ||___|'_                                                        //
//                 !____________ __ ___|_|________ "*N@@@@@@@@@@@@@@@@@@@@@@@@@@@@g"B@@@@N@",**",g@@@M" _lL,  _'*lL!'',l____|`                                                          //
//                  ' _________|_   _ __________________'"M@@@@@@@@@@@@@@@@@@@@@@@@@@gg,gg@@@@@@N*`___||||__||llL;;Ll|___|_'                                                            //
//                   _'__|_|____|||__ _____________||________ ""N@@@@@@@@@@@@@@@@@@@@@@@@@@NM"___|||||||||||||||____|___|'_                                                             //
//                     ' __|____||||_|_______________|_______||||__"*MN@@@@@@@@@@@@@@@N*"__||||||||||_||||||||____|__||'                                                                //
//                      _|___|_|_|||||_||________________|______________   ``````  _|||||||||||||||||||||||||_|||||_|'                                                                  //
//                        _|_____||||||||________________|_______________________|_____||||||||||||||||||___||||||_`                                                                    //
//                          ' ____||||||||_________|____|____________________||___|||__|_|||||||||||||__|__|||||_____                                                                   //
//                            '|____|||||||||_______________________|____ __________|____|||||||||__________|_|______                                                                   //
//                              `|___'|||||||||__________________|_______|||||_|_|___|||||||||_________|_____''__ ___                                                                   //
//                                _'___'||||||____||___________  ____________    ______  __ __    ______ |'                                                                             //
//                                   '!_ 'l!________________|______||||||_____|||_____________________'`                                                                                //
//                                     _     _''|_______________________|_____________________ _  '__                                                                                   //
//                                                _`'''| ______________________________ __ _ ''__                                                                                       //
//                                                        __`'''''         _  _    |''''`__                                                                                             //
//                                                                                                                                                                                      //
//                                                                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract FFDNE is ERC1155Creator {
    constructor() ERC1155Creator("Flying Farting Ducks 'n EGGs by Karrie Ross", "FFDNE") {}
}