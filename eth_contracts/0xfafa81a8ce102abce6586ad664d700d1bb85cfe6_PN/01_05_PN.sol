// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Papillon - Limited Editions ( Art 4 Art )
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//      ____                                    _   _           _           _             //
//     |  _ \ ___ _   _ _ __ ___   __ _ _ __   | \ | | __ _  __| | ___ _ __(_)            //
//     | |_) / _ \ | | | '_ ` _ \ / _` | '_ \  |  \| |/ _` |/ _` |/ _ \ '__| |            //
//     |  __/  __/ |_| | | | | | | (_| | | | | | |\  | (_| | (_| |  __/ |  | |            //
//     |_|   \___|\__, |_| |_| |_|\__,_|_| |_| |_| \_|\__,_|\__,_|\___|_|  |_|            //
//      ____  _   |___/   _                              _                                //
//     |  _ \| |__   ___ | |_ ___   __ _ _ __ __ _ _ __ | |__  _   _                      //
//     | |_) | '_ \ / _ \| __/ _ \ / _` | '__/ _` | '_ \| '_ \| | | |                     //
//     |  __/| | | | (_) | || (_) | (_| | | | (_| | |_) | | | | |_| |                     //
//     |_|   |_| |_|\___/ \__\___/ \__, |_|  \__,_| .__/|_| |_|\__, |                     //
//                                 |___/          |_|          |___/                      //
//                                                                                        //
//                                                                                        //
//    @@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&@&&&&@@@&&&@@    //
//    @@@@@@@@@&@&@&@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&@@&&&&@@@@@@&@@@&@@@@@@    //
//    @@@@@@@@@@@@&&&&&&&&&&&&&&&&&&(.,&&&&&&&&&&&&&&&&&&&&&&&&&@&&&&&&&@@@@@@&@@@@@&@    //
//    @@@@@@@@@&@@@@@@@&&&&&&&&&&&,%%%@*&&&&&&&&&&&&&&&&&@&&&&@@@@&@@&&@&@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@&&&&@&&&&&&&&&&*/%#***&&&&&&&&&&&&&&&&&&&&&&@@@&&&@@@@@@@&&@@@@@@@@@    //
//    @@@@@@@&@@&@&&&&&&&&&&&&&&&*,(,,*%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@&@@@&&@@@@@@@&&    //
//    @@@@@@@@@@@@@@@&&&&&&&&&&&&#,*(/%&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&&&&@&&@@@@@@    //
//    @@@@@@@@&&@&&&&&&@&&&&&&&&@,,/(%&&&&&&&&&&&&(*(&#&&&&&&&&&&&&&&&&&@@@@&&&@@@@@@@    //
//    @@@@@@&@@&@@&&@&&&&&&&&&&@,,/%&&&&&&&&&&&&&&(/(/*(%&&&&&&&&&&&&&&&@@&&&&&@@&&&&@    //
//    @@@@@@@&&&&&&&&&&&&&&&&&,,,*#&&&&&&&&&&&&&&&/(*/,*(&&&&&&&&&&&&&&@&@@&&&@@@&&&&&    //
//    @&@@@&&@@&&&&&&&&&&&&&&,,,*(&&&&&&&&&&&&&&&&&**(.,#&&&&&&&&&&&&&&@&&&&&&&&@&&&&&    //
//    &@@@@&&&&&&&&&&&&&&&&&,,,,/&&&&&&&&&&&&&&&&&&&&*,,,#&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    @@&@&&&&&&&&&&&&&&&&&,,,,/%&&&&&&&&&&&&&&&&&&&&&/,,*%&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&*,,,*#&&&&&&&&&&&&&&&&&&&&&&&*,,*%&&&&&&&&&@&&&&@@&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&,,,,/&&&&&&&&&&&&&&&&&&&&&&&&&,,,*%&&&&&&&&&&&&&@&&&&&&&@&&&    //
//    &&&&@&&&&&&&&&&&&&&&/*,*/%&&&&&&&&@@&@@@@@&&&&&&&&*,.,*%&&&&&&&&&&&&&&&&&&&&@&&&    //
//    &&&&&&&&&&&&&&&&&&&&/,,,,,**/*.//&&,*/%@@@@@&&&&&&&,.,,/&&&&&&&&&&&&&@&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&&&&&,,,,,,*****.,,,,.*,,#@@@&&&&&&(,.,*(&&&&&&@&@&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&&&/***,,.,,, **.,,,...,,[email protected]%&&&&&&,.,,/&&&&&&&&@&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&&&&/*/*,,....,,,*., ,.,...../(%&&#&&&&&&,,**&&@@&&&@&@@@&@&@@&@&@&&&    //
//    &&&&&&&&&&&&&&&(*,,.....,,,,..,...../(%((#%%@@@&&&&@,**/%@@@&@@@&@@@&@&&&&&@&&&&    //
//    &&&&&&&&&&&&&*/(/*,....,,,.,, .. @#/(%#%(##@@@&&&&&*,*/%&@@@@@@@@@&&@@&&&&&@@@&&    //
//    &&&&&&&&&&&&&,/*/*,...,,,..   *(#%%%@///(&@@@@&&&&@**/(%&@@@@@@@@@&@@@@@@@@@@@&&    //
//    &&&&&&&&&&&&*,((** ..,.,.  .,****(/**,,,((@@@@&&&****/#&@@@@@@@@@@@@@&@@@@@@@@&&    //
//    &&&&&&&&&&&&/.((/,.....  .*/*****,***,,,.......#,*/*/(%&@@@@@@@@@@@@@@@@@@@@@@@@    //
//    &&&&&&&&&&&&*,((,....  .&#%,***,,,,,,.,,,,.,.,,.,,,,(%@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    &&&&&&&&&&&&,,#(....  .&&&&,*/.......... ....,,..,,,,,@@@@@@@@@,,.,@@@@@@@@@@@@@    //
//    &&&&&&&&&&&/*,#(......&&&&*,..     . ...  ........**,(*#@@@@@@..,,*&@@@@@@@@@@@@    //
//    &&&&&&&&&&&&**///( ,..*,%@,..          . .  ....,*,/**#%@@@@@....**/@@@@@@@@@@,,    //
//    ,@&&&&&&&&&//**((((#...,,...              .. ..,**/(%#%@@@@(...,.***@@@@@@@,,.,     //
//    ,,...&&&@&(/..,*(((((........              ...,.,/(%&@@@@@....,,*.*/,&@/,,,,*..,    //
//    ...., . .........,,(*/. ......             . .,.....    .............,,,......,/    //
//    ... .,..         . ....,.......           .................  ... ..  .....,./(#%    //
//    ***.,,,...,,,....,............. .       ......................,.,,,,,*/***/%%%%%    //
//    ,,,,,,...... *,..,,.............,     ... .........,..,..,,.,.,,.,,,****%%%%###(    //
//    ,,,,**//*,,,,.,**,..,,........... .     .......,....,..,,,*.,,,,,**/((#####((((/    //
//    //,,,,**,.,.,**,,,**,........  .       ...........,,,*,,,***/********/(((((//*,,    //
//    ////,,.*,,,,.***,,,**,,,....,....   ............,,,,,*//*,*******,****///*,,,,,*    //
//    **,///,,,,,,,,,**,,.,,,,..........,.,,,........,,,*****/*,,,,,**,,,,,***,,******    //
//    (/*,,,***,,.**,,,*,,...,.,,.,.,.,.,.,.,,,.,,,,,*,*******,,,,,,,,,,./****,*******    //
//    **/((*,,.**,.,***,.,,.....,,,,,,,,,,.,,,,.,*,,,,,*******,,,,,,,,,,,**********///    //
//    #(*,,,***,,,**,,,***..,,,,,,,,,,,*,*,.,,,,..,,.,,,*,,,***,,,,,,,**********//****    //
//    ***((*,,,***,,,/*,,.,,..,,,,**,*,**.*,*,.*..,**,,,*.*****,,,,,,********//*****/(    //
//    ##(*,,,**,,,*/*,,,/*..,,,.,,,,*,*,*,,,,,**.*,.*,*,*********,,*,,****/*****/((*((    //
//    #**,***,,,***,,,***,.,,..,,,,,,,,,,,,,,,,,.,..*/,,*/,/****,//*********/((*/((/((    //
//    **((/,,,,**,,,***,,**,..,,.,.,,,,,,,,,,,,,,,.,,/,*,*,*,****//*******/*/((//((/(#    //
//    ##(,,,,**,,,***,,.**,.,,,.,,,,.,,,,,,,,,,,.,,..*/,**,*,,*********/*////(/((((/((    //
//    #(*,,/**,,,***,,***..,,,......,,.,...,,,,,,.,,,.***,*,*,*****/*****/*/((//((((##    //
//    **,//*,,,*//,,./*/,.,,,.,,...,,,,,.....,,,,,,*,,****,,*,,,*****/(*/((/(/((((((##    //
//                                                                                        //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract PN is ERC1155Creator {
    constructor() ERC1155Creator("Papillon - Limited Editions ( Art 4 Art )", "PN") {}
}