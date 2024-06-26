// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: ROOTS
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMKxxxxxdddddddddxkOKWMMMMMMMMMMMMMMWK0kxxxk0XWMMMMMMMMMMMMMMMMMMWKOOkxxxk0XWMMMMMMNOdddddddddddddddddddddddxKMMMMMNKOxxxk0XWMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMWl                 .,lOWMMMMMMMWXxc,.       .,lkXMMMMMMMMMMMWXxc,.        .,lkXMMMK,                        dMWKd:'.      .,lONMMMMMMMMMMMMMMM    //
//    MMMMMMMMWl                    .:0MMMMWOc.               'lKWMMMMMMWOc.                'lKWK,                        dKc.              ,xNMMMMMMMMMMMMM    //
//    MMMMMMMMWl      .'''''''..      '0MMKc.       .....       .oXMMMMKc.       ......       .o0l''''''''.      .''''''',;.      .....       cXMMMMMMMMMMMM    //
//    MMMMMMMMWl     '0NNNNNNNNXk'     cNk'     .:d0XXNXKOo,      ;KMWk'     .:dO0KXNXKOo,      ;0NNNNNNNNl     'ONNNNNNNk.     ,xKXNNX0l.     lWMMMMMMMMMMM    //
//    MMMMMMMMWl     ,KMMMMMMMMMN:     ,d.     ;0WMMMMMMMMMNk'     ;Kk.     ;0WMMMMMMMMMMNx'     ;KMMMMMMMo     '0MMMMMMMd.    .oWMMMMMMNc     ;XMMMMMMMMMMM    //
//    MMMMMMMMWl     'kKKKKKK0ko,      ;'     :XMMMMMMMMMMMMMO'     ,'     :XMMMMMMMMMMMMMMO'     lNMMMMMMo     '0MMMMMMM0'     .,cdkKNWWo.....:XMMMMMMMMMMM    //
//    MMMMMMMMWl      ........       .do.    .kMMMMMMMMMMMMMMWo           .kMMMMMMMMMMMMMMMWo     '0MMMMMMo     '0MMMMMMMWk'         .';lodO000XWMMMMMMMMMMM    //
//    MMMMMMMMWl                   'lKWl     ,0MMMMMMMMMMMMMMMx.          ,KMMMMMMMMMMMMMMMMx.    .kMMMMMMo     '0MMMMMMMMMXd,.           .,lOWMMMMMMMMMMMMM    //
//    MMMMMMMMWl                .cONMMMo     .OMMMMMMMMMMMMMMMd           .OMMMMMMMMMMMMMMMMd     .OMMMMMMo     '0MMMMMMMMMMMN0dc,.          .:0WMMMMMMMMMMM    //
//    MMMMMMMMWl     .dx:.       ;OWMMMO.     oWMMMMMMMMMMMMMX;     ..     oWMMMMMMMMMMMMMMX;     :XMMMMMMo     '0MMMMMMKl;;;;:0MWKOdl;'.      '0MMMMMMMMMMM    //
//    MMMMMMMMWl     ,KMNk;       .oNMMWo     .dNMMMMMMMMMMMXc     .ko     .dNMMMMMMMMMMMMX:     .OMMMMMMMo     '0MMMMMMO.    .xMMMMMMMN0l.     oWMMMMMMMMMM    //
//    MMMMMMMMWl     ,KMMMNk,       :KMMNl.     ;xKWMMMMMN0o'     .xWNl.     ;xKWMMMMMMN0d'     .xWMMMMMMMo     '0MMMMMM0,     ;0WMMMMMWXd.     dWMMMMMMMMMM    //
//    MMMMMMMMWl     ,KMMMMMNx,      ,0MMNx.      .,:ccc:'.      ;OWMMNx.      .,;:ccc;'.      ;OWMMMMMMMMo     '0MMMMMMWx.     .,:cccc;.      :XMMMMMMMMMMM    //
//    MMMMMMMMWl     ,KMMMMMMMXl.     .kWMMKl.                 ,xNMMMMMMKl.                  ,xNMMMMMMMMMMo     '0MMMMMMMWO;                 .dXMMMMMMMMMMMM    //
//    MMMMMMMMWl     ,KMMMMMMMMWx.     .xWMMMXx:.          .'ckNMMMMMMMMMMXx:.           .'ckNMMMMMMMMMMMMo     '0MMMMMMMMMNOl'.          .;dXMMMMMMMMMMMMMM    //
//    MMMMMMMMWk:::::dNMMMMMMMMMWOc;::::oKMMMMMWXOdlc:::cox0NMMMMMMMMMMMMMMMWXOdllc:::cox0NMMMMMMMMMMMMMMMOc::::dXMMMMMMMMMMMMN0xoc:::cldOXWMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMOc::l0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWMMMMMMMMMMMMMMMMMMMMMWk:c:oKMMMMMMMMMMMMMMM0l::cOWMMMMMMWNXXNMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMo    dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWO;,,oNMMMMMMMMMMMMMMMMMMMN:   .OMMMMMMMMMMMMMMMx.   lWMMNOo:,...lNMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMo    dMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMO'   .oNMMMMMMMMMMMMMMMMMMN:   .OMMMMMMMMMMMMMMMx.   lWWO;       ;XMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMo    cxocccokXWXocc:oKMMMMMWkccccOMMMMMMMMMMMMK,     .dWMMMMMMMMW0xolcccox,   .OMWXkoccclx0WMMMx.   lWO.   .clookWMWKxocccokKWMMMMMMMMMMMMMMMM    //
//    MMMMMMMMo            .ckl    cNMMMWx.   ,0MMMMMMMMMMMK;       .xWMMMMMNx;.            .OKl.       .;xNMx.   .;.    .;;;dNNk:.       .:OWMMMMMMMMMMMMMM    //
//    MMMMMMMMo      .','.   .c,   .dWMM0'   .kMMMMMMMMMMMXc    '.   .kWMMM0;     .',.      .;.    .,'.    ;0x.              ;Oc    .','.   .lXMMMMMMMMMMMMM    //
//    MMMMMMMMo    .oKWWN0:    ,.   .kWX:   .dWMMMMMMMMMMNl    :Kx.   '0MMK,   .d0KWWNO;         ;ONWWXd.   ,l.   .;.    .;;;l;   .lKNWN0c.   lNMMMMMMMMMMMM    //
//    MMMMMMMMo    lWMMMMMX;   .c.   ,Ol    cNMMMMMMMMMMNo.   ;KMWo.   ,KWo    oWMMMMMMK,       '0MMMMMWo    ..   lWo    dMMMx.   cNMMMMMX:   .OMMMMMMMMMMMM    //
//    MMMMMMMMo    oMMMMMMN:   .xo    ..   ,KMMMMMMMMMMWd.    .:::,.    :Kl   .xMMMMMMMX;       ;XMMMMMMx.   .    lWo    dMMMd    oWMMMMMWc   .xMMMMMMMMMMMM    //
//    MMMMMMMMo    ,0MMMMWk.   ;KX:       .OMMMMMMMMMMWk.                cd.   ;XMMMMMWx.       .xWMMMMX:   .,.   lWo    dMMM0'   ,0MMMMWO'   ,KMMMMMMMMMMMM    //
//    MMMMMMMMo     .cdxd:.   'OWM0,     .dWMMMMMMMMMMO.   .,;;;;;;;;.   .lo.   ':ldxo:.     .   .:oxdl'   .od.   lWo    dMMMWx.   .cdxdc.   .kWMMMMMMMMMMMM    //
//    MMMMMMMMo             .cKMMMMx.    lNMMMMMMMMMM0,   .dWMMMMMMMMK,   .ox,              .do.          ,kNx.   lWo    dMMMMWO;          .:0WMMMMMMMMMMMMM    //
//    MMMMMMMMd....,,.....;o0WMMMXx,    ;KMMMMMMMMMMXc....dNMMMMMMMMMM0,...'kNkc,......,....,OWKd;.....'ckNMMk....oWd....xMMMMMMNOl,.....,lOWMMMMMMMMMMMMMMM    //
//    MMMMMMMMN0000NWX00KXWMMMWOc.    .cKMMMMMMMMMMMNK000KWMMMMMMMMMMMMX0000XMMMWNX00KNWX000KNMMMWNK00XWMMMMMNK000XMN0000NMMMMMMMMMWXK0KXWMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMK,    .cOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMM0, 'cxXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMNkONMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMWXXXXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMK:...cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMWWNWMMMMMK,   ,KWNNWMMMMMMMMMMMMWNWWMMWNNNNNNWMMMMMMMMWWNNNWWMMMMMWNWMMMMMMMWNNNNNNNNNNNNNNNNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMWKxc;'',;lxKWK,   .;;'',cdKWMMMMW0o:,'',cl;'''''';OMMMMMMWd,'',dNMNkl;,'';lxXMMKc''''''''''''''',dXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMKc.         .lx,           .cKWWO;.                ,0MMMMWx.   ,kd:'         .oX0'              .dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMWk.   .,cc:'    .     .;cc;.   'xo.   .:cc;.          ;XMMWk.   .o:     ':cc;.   ,xdllllll:.     :0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMO'   'OWMMMNd'...    .xWMMWk.        :KWMMWK;    ';    cXM0'   .o;     ,xkkOkl.   ,KMMMMWk,    'xNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMWo    dMMMMMMWNXXO'   ,KMMMMX;       '0MMMMMMk.   :0:    o0;   .dx.                .dMMMKc.   .lKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMWo    dMMMMMMWXKKk'   ,KMMMMX;       '0MMMMMMk.   ;X0,   ..    cNx.                .dMNx'    ,OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMM0'   'OWMMMXo....    ,KMMMMX;        :KWMMW0;    ;XMO.       :XMX:     'okOOOkl;;;l00;    .dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMWk'   .,cc:.    ..   ,KMMMMX;   .,.   .;cc;.     ;XMWx.     ,KMMMXc     .,cll,.   :l.     'ccccccccOWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMKl.         'ok,   ,KMMMMX;   .kO;.            ;XMMWo.   'OMMMMMNxc,          ';'                lWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMWKxc;'',:oOXMXl'''lXMMMMNo'''cKMW0d:,'',cl;'''oNMMMNo'';kWMMMMMMMMNOo:,'';cokx:'''''''''''''''''xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMWWWWMMMMMMWWWWWMMMMMMWNNNWWMMMMMWWWWMMWWWWWMMMMMWWNWMMMMMMMMMMMMMMWNWMMMWWNNWNWWWWNWWWWWWWWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ACS is ERC721Creator {
    constructor() ERC721Creator("ROOTS", "ACS") {}
}