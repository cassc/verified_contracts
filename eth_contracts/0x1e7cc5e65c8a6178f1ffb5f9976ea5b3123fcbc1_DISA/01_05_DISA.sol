// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DISA!
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                       //
//                                                                                                       //
//    01000100 01001001 01010011 01000001 01000100 01001001                                              //
//       ,---,       ,---,  .--.--.      ,---,                                                           //
//      .'  .' `\  ,`--.' | /  /    '.   '  .' \                                                         //
//    ,---.'     \ |   :  :|  :  /`. /  /  ;    '.                                                       //
//    |   |  .`\  |:   |  ';  |  |--`  :  :       \                                                      //
//    :   : |  '  ||   :  ||  :  ;_    :  |   /\   \                                                     //
//    |   ' '  ;  :'   '  ; \  \    `. |  :  ' ;.   :                                                    //
//    '   | ;  .  ||   |  |  `----.   \|  |  ;/  \   \                                                   //
//    |   | :  |  ''   :  ;  __ \  \  |'  :  | \  \ ,'                                                   //
//    '   : | /  ; |   |  ' /  /`--'  /|  |  '  '--'                                                     //
//    |   | '` ,/  '   :  |'--'.     / |  :  :                                                           //
//    ;   :  .'    ;   |.'   `--'---'  |  | ,'                                                           //
//    |   ,.'      '---'               `--''                                                             //
//    '---'                                                                                              //
//    01010011 01000001 01000100 01001001 01010011 01000001                                              //
//                                                                                                       //
//                                                                                                       //
///////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DISA is ERC721Creator {
    constructor() ERC721Creator("DISA!", "DISA") {}
}