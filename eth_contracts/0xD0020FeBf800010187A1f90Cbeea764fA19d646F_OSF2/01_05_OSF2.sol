// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: OSF2
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////
//                                                                                       //
//                                                                                       //
//                                                                                       //
//                                                                                       //
//           , ·. ,.-·~·.,   ‘                 ,. -,             ,.-·~ ^~, ‘             //
//          /  ·'´,.-·-.,   `,'‚           ,.·'´,    ,'\         .'´  ,.-·~-.,':\        //
//         /  .'´\:::::::'\   '\ °     ,·'´ .·´'´-·'´::::\'      ;   ,':\::::::'\::\     //
//      ,·'  ,'::::\:;:-·-:';  ';\‚    ;    ';:::\::\::;:'      ;'   ;:::'_-·~-\;' ‘     //
//     ;.   ';:::;´       ,'  ,':'\‚   \·.    `·;:'-·'´       ,.'    'ª*'´ __'`;\ °      //
//      ';   ;::;       ,'´ .'´\::';‚   \:`·.   '`·,  '       `',   ;\¯::::::::\:\‘      //
//      ';   ':;:   ,.·´,.·´::::\;'°     `·:'`·,   \'         ;   ;::\;::_:_::\;'        //
//       \·,   `*´,.·'´::::::;·´         ,.'-:;'  ,·\        ;  ';:::;        '          //
//        \\:¯::\:::::::;:·´       ,·'´     ,.·´:::'\       ';  ;::';                    //
//         `\:::::\;::·'´  °         \`*'´\::::::::;·'‘       \*´\:';        '‚          //
//             ¯                     \::::\:;:·´             '\::\;     '                //
//              ‘                       '`*'´‘                   `*´‘                    //
//                                                                                       //
//                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////


contract OSF2 is ERC1155Creator {
    constructor() ERC1155Creator("OSF2", "OSF2") {}
}