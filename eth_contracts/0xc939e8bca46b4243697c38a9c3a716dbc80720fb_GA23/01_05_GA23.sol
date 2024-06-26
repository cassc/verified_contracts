// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Grape Art
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                         //
//                                                                                         //
//                                                                                         //
//                                           .(,                                           //
//                                            %                                            //
//                                  ,#.    @,                                              //
//                                   *#(@@&                                                //
//                          %        (@@                                                   //
//                         .(%    &/@&@@                                                   //
//                          @&   #@/&@@    ,                                               //
//                        ,&(.  //#%@@@,   #% &                   & ,,                     //
//                         %%@/&#%/&@@@&@& (%#@%#&.      &      .&(                        //
//                             .   .#%(*(@@@&@@@         &%    *&&*                        //
//                        *           @@&##/@%(%@         @%@&@@@&.       *                //
//                 ,   @@#           &&//@@(&@@%        &%(@@*@@@@,   /@&@.                //
//                 ,@# #@@.      #&*.#@&@@@@&(         ,@@/%@@@@(@@@@@                     //
//          %.&,   [email protected]@&,          ,&@&&@@%&@@           #@@@@&@@&(                         //
//             #%  *(@%             %/,&%#%       %&. ((%#%@@#                             //
//             &/&%%@@%(&#*&,&.     @@@((@        @%%@/%%@#                                //
//              #,(, *#(#,*%(/%.,/%@*,##@@      /@%(&%@@       /(                          //
//              @@@@%*#@@/(%&(#*#(,%#/#*#%((   &#@@#@@%       [email protected]@.                         //
//                %@#         /%*/**%/%%#(/&(@#%%&@@#*      [email protected]@.                           //
//                            ,@&%.#((&%#@#&@%%&@%@@@/     @&/                             //
//                              [email protected]@@@@@@@@@%#@&@@@@@.      *%@                             //
//                                 .  @&&@@%&%@@&&&#%#@%@@%@&@                             //
//                                     @##%/&##@@@&@@@    /%                               //
//                                     [email protected]&(&@&@@&@%%(                                      //
//                                        @@&@%&#&@@,                         #.(#@        //
//                                       (/#,(#%#@@*                    . (@/((*           //
//                                     .#/*(%/&@@&               */,../&#/##* .            //
//                                  /@@@,#%@*%%@     /   . *@/(#(  ,%& . ,.                //
//                                 @@#@@@@@&&@&@  ..%(/.*%%% /(#*//,  .*                   //
//                                &@&@&@#@@##%@@/@@@*&@@, %@(                              //
//                         ,,*/((&@@@@@@@&@[email protected]@%/ .%@@/(**# /.                              //
//                        *,#(#&@%..,*( ,/.  ,&&(/                                         //
//                  ,*(%*. ,.(,                                                            //
//             ,.****.%                                                                    //
//        (,/.*.                                                                           //
//                                                                                         //
//                                                                                         //
//                                                                                         //
/////////////////////////////////////////////////////////////////////////////////////////////


contract GA23 is ERC1155Creator {
    constructor() ERC1155Creator("Grape Art", "GA23") {}
}