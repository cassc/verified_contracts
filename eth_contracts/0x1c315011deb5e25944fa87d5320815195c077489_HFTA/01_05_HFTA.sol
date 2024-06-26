// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: HERE FOR THE ART
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                      //
//                                                                                                                      //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXOdOXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKxxKXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXo'dXXXXXXXXXXXXXXXXXXXXXXOoodddkkdxxooxKXXXXXXXXXXXXXXXXXXXXXXX0,:KXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXKXklOXXXXXXXXXXXXXXXXXXXXXXx..,.':'.,,.;dKXXXXXXXXXXXXXXXXXXXXXXXKodXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXX0kkOKKk:'o0K0OO0KXXXXXXXXXXXXXXXO',o... .;..o0XXXXXXXXXXXXXXXXXKOkO0K0o':kKK0OOKXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXkc:cxk;  .oOdc:o0XXXXXXXXXXXXXXXd.:c... ';.,d0XXXXXXXXXXXXXXXXX0o::dko.  ;kxl:ckXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXX0o;dKXXXKKXXXXXXXXXXXXXXXK:.l;.:. ,,.kXKXXXXXXXXXXXXXXXXXXXXXXXKx:c0XXXKKXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXxckXXXXXXXXXXXXXXXXXXXXXO,'o.,;.';.;0XXXXXXXXXXXXXXXXXXXXXXXXXX0loKXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXo.oXXXXXXXXXXXXXXXXXXXXXd.:c.;,'l;..o0XXXXXXXXXXXXXXXXXXXXXXXXXO,;KXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXX0xOXXXXXXXXXXXXXXXXXXXXXOokkdkdxOxold0XXXXXXXXXXXXXXXXXXXXXXXXXKkkKXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXKOxxOKXKOxxk0XXKkxxOK0xxxxxxOK0kxxOK0kxkk0KXXXXXX0kxOKXXXXXXXXXX0xodOKXXX0kooox0XXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXO,  :0XO,  .dXXx. .l0:      :Kd. .lXd.  ..':xKXXXd. .'ckKXXXXXKo'   .oKKx,    'kXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXO'  :KXo.  .dXK:  .kO'  .;::xK:  .dK:        :0XKc     .lKXXX0c  ..  .kO'  .clkXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXk.  lX0;   .xXk.  cKd.  cKXXXO,  'OO'   'd;  .dXO,  .,  .dXXKl  .do   ok.  cKXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXx.  oXx... .kXl  .kKc  .lOO0Xx.  :Kx.   :O;  .dXx.  ck'  ;0Xd.  ;0l   ok.  :KXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXd. .dK: '' 'O0,  cKO,    .'xXc  .dXc    ''  .lKXl  .o0,  ,00;  .dXc   oO'  ;0XXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXo  .xk. :' ,Od. .xXx.  .,,c00,  'O0,       ,xKX0;  .k0,  ,0x.  ,0K;  .x0,  ,0XXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXl  .kl 'o' ;O:  :KXl  .dXKKXx.  :Kk.   .   lXKXk.  ;Kk.  :Kc   lXO'  .kK;  'kXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXKc  ,x, cd. :d. .xX0;  'OXKXXl   oXo  .,;.  cKXXo.  oXo  .d0,  .xXd.  ;0K:  .xXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXK:  ;l..xd. :c  :0Xx.  :KXKX0;  .kK;  'lc.  :KXK:  .kO'  ;0k.  'OK:   oXXl  .dXKXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXX0,  ,, ,0l  ;, .dXXl  .oXXKXk.  ;0k'  ;xo'  ;0XO'  ;O:  .xXx.  ;KO'  'OXXo   oXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXO,  '. oKc .'. ;0X0;  .kXKXXo.  lXo.  lOd'  ,0Xd.  cc  .dKXd.  :Kl   lKKXo.  lXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXk.  . 'OK:  . .dXXk.  ;KXXXK:  .xK:  .x0x,  'OK:   .  .dKKXx.  ck.  ;0XXXo   lXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXx.    cKK;    ,0XXo.  .;;cOO'  ,0O'  ,00k,  .kO'    .cOXXKXO'  .'  ,OKo::.  .xXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXd.   'kX0;   .dXXKc      ,Ox. .cKd. .lKKO;  .kx. .,lOKXXXXXKd.   .c0Xx.   .,xKXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXX0kxxxOKXKOxxxkKXXKOxxxxxxOK0kxk0X0kxk0XKKOdxk00xk0KXXXXXXXXXX0dodOKXX0kdddkKXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//    XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX    //
//                                                                                                                      //
//                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract HFTA is ERC721Creator {
    constructor() ERC721Creator("HERE FOR THE ART", "HFTA") {}
}