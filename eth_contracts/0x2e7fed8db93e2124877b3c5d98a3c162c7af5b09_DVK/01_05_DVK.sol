// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: INTERNALIZED
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//                            .#%&&&%/&(@&&&&&%&&&%   .,*,#&&&&&&&&&&&&&&&&&&. .    %&&&&&&&&&&&&&&&&&&&%%  %&&&&&& (  .,&&&&&    //
//      .&(                         ,&%&&&&(               ,%%&&&&&&&&&&&&&&&&&&%*  ,%&%%(/%&&&&&&&&&&&&  (%&&&&&&&&%   &%&&&%    //
//      ,##           ,%&.                 .                       ,%&&&&&&&&&&&&&&&&     ..#&&&&&&&&&&  (%&&&&&&#   . ( &%       //
//                      , &%%&%     ,.,        %#(%&#%%&&%&&&&%        (*%&&&&&&&&&&&&%*.   .(%&&&&&&&&#%  *.&&&%(    ,%%         //
//    #   ,      %&&%* . %%&&%/ ,     ....,#&&&&&%&&&&&&&&&&&&&&&&%      .%%&&&&&&&&&&&&%*.. ,/%&&&&&&&&&%/..%%&%&.  #&%    %(    //
//    &*          %%&#&&&&&&&&&&&&&&&&&&&&&&&&#&&&&&%&&&&&&&&&&&&&&&&%   .%#%&&&&&&&&&&&&&% .%&&&&&&&&&&&&#.,%%&%%%,      %%&&    //
//           ,   &&&&&&&&%#/%,/&&&&&&&&&&&#.%#/%/   .. . /%&&&%&&&&&&&&%,%%&&&&&&&&&&&&&&&&%(#%&&&&&&&&&&&%  ,  #*,    (*/,/      //
//    * .     *&&%%&&&&&&%&&&%#&&&&&&&%#/ ,            (,    *  .//&&&&&&&%&&&&&&&&&&&&&&&&#.. &&&&&&&&&&&&%/.,*,.    #%#         //
//    %  #  #&%&&&&. ./#%&&&&&&%.#%(/,      .         /#(%/(     ,//(&&%&&.%&%&&&&&&&&&&&&&&*%  &&&&&&&&&&&&(. . .  .#&/          //
//      &&&&&/&#/%%#. .,,(//#(/.            #%%&&%##%%%%* (#%%#* (*(/%%&%%&  %&&&&&&&&&&&&&# ,#&&&&&&&&&&&&(  */  . %#       .    //
//     (%%*/##%%&&       .*                .%&&&%%&#%%&%&#(,%///&%.   ,%..#%( %&&&&&&&&&&&&&&&&&&&&&&&&&&&%    .         *,       //
//    %%. *(%%%%/*            ../%&&&&&&&%&&&&&&&&% ,%%%&&&&&%%(&&&&&%&&&%((/%(%%&&&&&&&&&&&&&&&&&&&&&&&&&&*      %%&&& ...,*,    //
//       ##*&%(/*/***      . ((,/,%&&&&..&&&%%%&%&% *  %%&&&&&&&&&&&&&&%&&%%%%%%&%&&&&&&&&&&&&&&&&&&&&&&&&&& (%. (%#     .        //
//    ( *%#/#%  ./*./, .   ,   / *%&&&&/&%%&&&%##(,               %           %%(%&&&&&&&&&&&&&&&&&&&&&&&&&%      .     ..        //
//    *( %%#%%#.   *        ,##.(&&%&%&%%%&%%%,                                      ,&&&&&&&&&&&&&&&&&&&&            ,,..,,      //
//       *.,(##/             %#/ %#&&&&&%%/,   .     ,*// . /. ** .%##(%&%...           %&&&&&&&&&&&&&&%&        (  ,.,...*(*     //
//          ,/#          (/%%&&&&&&...           ( ((%%%&&&&&&&&&&&&&&&&&&&&&&&%%%#%#(#%&&&&&&&&&&&&&      /        .**,*  .*.    //
//    #     *.,          /(  &&&& *    . .     ./#(##(%%&&&&&&/ .*,%/(/  .#%#&&&%%(*#/##(&&&&&&&&&&    #%%##  .      */,/.,./#    //
//    .%, .%#*, .  . ,  %%&&&&      /*  ,.    *%*%##%&&&&&   (%%#,(/,%&&%&    #%%#/ .   *&&&&&&&&&%                ,.,,,, .  .    //
//     //%%#,     .  %&&&&&&&&#(/. ,//,. . . . .#%%&&&&% ..%%&&&%  &&&&%%&&   /#(/      .#&&&&&&&,         %* #         ./,,.     //
//         .       #&&&&&&%%*. .##/,,,/##%(#(%,*%*&&(  ,(/  (,#&*#%.  %,%&&#&%&%#,      .*%&&&&&&&           .         .,*.*/*    //
//    %&##,(. . *&&&&&&&&   . /##%* .*(.#%%%%#%%&&&#.* ,#   *  .,% #.,/(&%%**%%##.      ,%#&&&&&&&&        %#         . * #/ .    //
//    &&&&&&&%*.   ##&&%   .  (/#.*,((%%%%%&%%&#&%%%&.(*#%%%%,%%(%%#%#/%%##(###/.      .,#%%&&&&&&&&.     (                 %#    //
//    &&%&%&&//&%*.%&%% .%%*,(*(*, .#%#%&&&&&&&&&%&%*.   ,..*/%(((%%%&&%%#,//*/%/       ,#%&&&&&&&&&&(     (.                     //
//     .,  ,%&&&&.      ..#%%#/%#####%.&&&&&&&&&&&&&&&&&&%###*.,,#(%%%%%%&%%#*(,.      ,./%&&&&&&&&&&&*  * .((##&&                //
//          %&&&%#.&&&%. .%#  ./       #%%&&&&&&&&&&&&&&&&&&&%&&&%#&&&&&&&%%%%###... ...  ,%&&&&&&&&&&&%      .%%%,               //
//         #%&&&&%%&&&&%#. /  ,        *./&&&&&&&&&&&&&&&&&&&%&&&&&&&&&&&&%%%%%%%///,.,.,*. /.(&&&&&&&&&&,     .*%%%#%/%%#   #    //
//    /&&.   &&&%&%%&&&%*   ,/*       ,(*(%&%&&&&&&&&&&&&&&&&#%&&&&&&&&&&&&&&&&%%%%#/. *... ..,*%&&&&&&&&&&             .         //
//    &&&&&     **...(%# .  ,           ,..(#%&%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%&%&%#(##*#/,,,. ,/#%%&&&&&&&&&&     ..  #(/, ,      //
//    &&&#,   .  /#%%%%%(//*,,*  .  ,/ *...*(##%%&%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%%%. ,.. .    .**(%%&&&&&&&&&&&&   *(,.(.*.(%#    //
//    &&&&&../(/#((%%%#/(#%%%%%(   %##%#((##%%&&%%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%*(           .  /%%%,&&&&&&&&&&&&    %.,          //
//    &&&&.    ,.*%%&&&&%&&&&&&&&%% ,*/%%%%%&&&&%%#&&&&&&&&&&&&&&&&&&&&&&&&&&&&%*.          .*  #%&%%%&&&&&&&&&&&*     ,  *       //
//    &&,      .%%%%&&&,./*#(&&&&&&%,   ,%%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&*.        .(#%&&&&&&&# .%%%%&&&&&&&,      ,*        //
//    .%,    ,, %&%%/*  . *,(#%%%&#%%   . (%%%%%&%&&&&&&&&&&&&&%&&&&&&&&&&&&%,**.       &&&%&%     #%( .%%%&&&&&                  //
//          #                %%%%&%%      . (%#%%&&&&&&&&&&&&&&%.,%%%%&%&&&%%&%...        %&&*    .,/%%  % /       . *            //
//    .  /(#%%#               .#%//%/      ./,*/(* #%&&&%&#%%#%%%#%%%%%%%(#%%%/**       . .%# /.*%%&&&&           *.         (    //
//    .    *(,  *     #...%     ,(##%%          ,*(/(%%&%%%#*,##/((//(/%#(/(%%#,#       /. /  *,#&&&&*         , ..    ./    *    //
//           .% *   ,    .##,,.  *#(%*   %%%.     .. . ,%#(,/(/(//**/((/(/###%%%%&%%/.. * %%.. .&&&&&&        .             .     //
//         .&&#&&&#./#**..,,,,,.(//%%(. ,%#%%%%#           ,  .,***#/(//#%%%%%%&&&&&&%&%/#%%%&&&&%%&&&,                           //
//         /%&&&&&&&&&&%%%#*  .,../##.    .#%%(%%%             .. ./(###%%%%((#%%&&&&&&&&&%%%%&&&&&&&&&&                          //
//           .(&.*,..,#%/(#,      */*.     .(#%%,#%%%             .(%(#%#%##(%&&&&%%&&&&&&&&&&&%%&&&&&&&                          //
//                   .  ...#/.            (,,#%(.,%%%%%%,        *(##%#/, &&&&&&&% %&&&%%%,#&&&&%&#(%%&&                          //
//        .,   /        ,,**//##%%#           %,  , .#(##,#.*  . .. /#%&&&&&&&&&#            /%/ ,%%/           ,*    .           //
//          ( .#           .   ,(/##          /###(*...  ..  /*..    #%&&&&&&&&#.         /&&&/                ..  ..             //
//    *&#*%.#/&&(,*.              , %%            /###.. .,./,/##* %&& %&&&&&&&&&&&&&&&&&&&&&&&&&&       (,   ..,.,/   .          //
//    **##&&%                       /%%/           ##  ,,...*..#&%&&&&&&&&&&&%&%&&&&&%%%&#&&%&&&&&       ,((   ....   .           //
//    ,*,#&&%          .*/            ..          &&(       #%%&&&&&&&&&%&%###%%&#####,/#%&.,/&&%&%                ..  ..*.       //
//     .  .*     *.   ..#&%**        * ,        ,  %(,  *   (%,%.&%&&&&&,.#*,#%%##,%%* * /##&              .   ..       ...(.     //
//      /,#%        .   .#&&##.   .,/, .,*           # ,.*/ . /#%/%&%%#..  #,#&&%#%%(,*/#&&&@               ..  ,,.....,. ./      //
//     **.&&.              ((&/     .#*. .       ,%#. *(%%    .((#   %&%&&    #%%&&&&&&&&&&&                                      //
//                          .        %(           %#,.//#%%*        ..(%&%%(/ &&&&&&&&&&&&&&                                      //
//                          .,*    ##&/              , *((*  .      .*&(%&&&&&&&&&&&&&&&&&@&&                                     //
//                          **,     #*, ...  .*         #/  ..    .   *  (/,*%&&&&&&&&&&&&&&%,                                    //
//                       / /    .     .  ..                 (#,  (,.     .%#%%/&&%&#(%%%%&&&&&                             . .    //
//                     ,##.       /,..                         , ../(#/.(%%..#(/(##,,/.*%&&&                      #@  . ,, **.    //
//                  %&/&,,      (  (#,/* .. .                  .. #.*%(#%((%%,/.. .,,#%%(,,/#           .,      @,.*. ,@ *   %    //
//      *        (#/@  ., ,    .# ,,  ,.*                                .  .  ,/(                            .  *(%/(,%, #*@     //
//           #(       ..            .                                           .                              . ....*.&, . ,     //
//     DVK  #*,,   . .    ,..&(/  ., .*                        .                                             ,/& ,.     */..      //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DVK is ERC721Creator {
    constructor() ERC721Creator("INTERNALIZED", "DVK") {}
}