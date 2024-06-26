// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The Six
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                     //
//                                                                                                                                                                                     //
//             ,  . .,  °          .·¨'`;        ,.·´¨;\                  _,.,  °                                    ,. -,          ,.-·.                            .,'               //
//       ;'´    ,   ., _';\'       ';   ;'\       ';   ;::\          ,.·'´  ,. ,  `;\ '                            ,.·'´,    ,'\        /    ;'\'        ,.,           ,'´  ;\         //
//       \:´¨¯:;'   `;::'\:'\      ;   ;::'\      ,'   ;::';       .´   ;´:::::\`'´ \'\                        ,·'´ .·´'´-·'´::::\'     ;    ;:::\       \`, '`·.    ,·' ,·´\::'\      //
//         \::::;   ,'::_'\;'      ;  ;::_';,. ,.'   ;:::';°     /   ,'::\::::::\:::\:'                      ;    ';:::\::\::;:'     ';    ;::::;'       \:';  '`·,'´,·´::::'\:;'      //
//             ,'  ,'::;'  ‘      .'     ,. -·~-·,   ;:::'; '    ;   ;:;:-·'~^ª*';\'´                        \·.    `·;:'-·'´         ;   ;::::;         `';'\    ,':::::;·´           //
//             ;  ;:::;  °      ';   ;'\::::::::;  '/::::;      ;  ,.-·:*'´¨'`*´\::\ '                        \:`·.   '`·,  '        ';  ;'::::;            ,·´,   \:;·´    '          //
//             ;  ;::;'  ‘        ;  ';:;\;::-··;  ;::::;      ;   ;\::::::::::::'\;'                           `·:'`·,   \'         ;  ';:::';         .·´ ,·´:\   '\                 //
//             ;  ;::;'‚          ':,.·´\;'    ;' ,' :::/  '     ;  ;'_\_:;:: -·^*';\                            ,.'-:;'  ,·\        ';  ;::::;'     ,·´  .;:::::'\   ';    '          //
//             ',.'\::;'‚           \:::::\    \·.'::::;        ';    ,  ,. -·:*'´:\:'\°                     ,·'´     ,.·´:::'\        \*´\:::;‘    ;    '.·'\::::;'   ,'\'            //
//              \::\:;'‚             \;:·´     \:\::';          \`*´ ¯\:::::::::::\;' '                     \`*'´\::::::::;·'‘        '\::\:;'     ;·-'´:::::\·´ \·:´:::\              //
//               \;:'      ‘                    `·\;'             \:::::\;::-·^*'´                           \::::\:;:·´               `*´‘       \::::;:·'     '\;:·'´                //
//                 °                              '                `*´¯                                      '`*'´‘                               `*'´           ‘                     //
//                                                                                                                                                                                     //
//                                                                                                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract SIX is ERC721Creator {
    constructor() ERC721Creator("The Six", "SIX") {}
}