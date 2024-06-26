// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Glimpse of US
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    ******+++++++++++++++++***###%%%%%@@@@@@@%%@@@@@@@@@@@@@@@@@%%%%%@@%%%%%%%###******+++++++++++++++++    //
//    ***++++++=======+++++++++**###%%%%%@@@@@@@@%%%%%%@@@@@@@@@@@@@@%@@@@%%%%###**********+++++++++++++++    //
//    ++++++++============++++++***###%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%###********++++++++++++++++++    //
//    +++++++=============+=++++++**###%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%#####*****++++++**************    //
//    +++++++++++++++++++**+***+++****###%%%%@@@@@@@@@@@@@%@@@@@@@@@@@@@%%%%%#######*##*******************    //
//    ++++++***********####*#*###*******##%%%%%@@@@@@@@@@@%%@@@@@@@@@@@%%%%%#################*************    //
//    ************#############***********###%%%%@@@@@@@@@@@%@@@@@@@@@%%%%%##########%%###############****    //
//    *********#####################*******###%%%%%%@@@@@@@@@@@@@@@@@@%%%######**######%%%%%%%%%########**    //
//    *******#######################*****++***##%%%%@@@@@@@@@@@@@@@@%%%%#####********#######%%%%%#########    //
//    ******##########################*********##%%%%@@@@@@@@@@@@@@@%%%%####****+++++***##################    //
//    *****#####################********###****####%%%@@@@@@@@@@@@@@%%%%#####**++++++++***################    //
//    *****#################**+++++++++++***########%%%@@@@@@@@@@@@@%%%%%####****++++++*****##############    //
//    *****################*######***********#######%%%%@@@@@@@@@@@@%%%%%####***+++++*******##############    //
//    ******#############%%%##************#######%%%%%%%@@@@@@@@@@@@%%%%%###**+++++*********########%%####    //
//    ******###########%%%###*****###**+++**##%%%%%%%%%%%@@@@@@@@@@@%%%%%###**++++*****##############%%###    //
//    ++******########%##%%%%%%%%%%%%#%%%%%####%%%%%%%%%%@@@@@@@@@@@%%%%%%##*********#####################    //
//    +++++*******#####%%%%@@%%%@@%%#+++*##%%%%%%%%%%%%%%%%%@@@@@@@@%%%%%%%###****########################    //
//    ++++++*++++++**#%%%%#%@%%%%%%%+==+++++*%%%%%%%%%%%%%%%@@@@@@@@%%%%%%%%###################*******####    //
//    ====+++++++++*######**#%%%%%#+++++++**###%%%%%###%%%%%@@@@@@@@%%%%%%%%%%%##%%%%%%%%%%%%%##*+++******    //
//    =====++++++++****************++++++++**############%%%%@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%######*++******    //
//    ====++++++++++***##############***#########****####%%%@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%##*****++*******    //
//    ====+++++++++++*++***###################*********###%%%@@@@%%%%%%%%%%%%%%%%%%%%###******************    //
//    =====+==+++++++++++++*****#########***++++++++****####%%@@%%#################*****+++***************    //
//    ==========++=====+++++++***+***++++++======++++****####%%%%########*###*******+++++***+++**********+    //
//    ====+=====+++=+======++++++++++++++===========++***####%%%#####***********+++++++**++++++**********+    //
//    ===+++++===+++++==============================+++***####%%####***********+++++++++++++++***********+    //
//    ===+++++++++++++==============================+++****###%%###********+*+++++++++++++++++**********++    //
//    ++++++***+++++++=============================++++****###%%###********++++++++++++++++++*********++++    //
//    ==+++*******++++++===========================++++****##%%%###********+++++++++++++++++*********+++==    //
//    ====+++*********++++==========================+++***###%%%###**********+++++++++++++**********+++===    //
//    =======+++++++*****+++=======================+++++**###%%%####********+*++++++++++++*********+++====    //
//    ===========+++++******+++++============+++++++++++**###%%%####*********+++++++++++**********+++=====    //
//    ++++++++++++++******#****+++++++++++++++++++++++****###%%%#####**********++++++************++++=====    //
//    *****************************++**++*++*************###%%@%#######*********++++*************+++++++++    //
//    *****####%%%%%######*****************************####%%%@%%######***********+******************++++*    //
//    **###%%@@@@@@%%#####***************************#####%%%%%%%%######**********+***********************    //
//    ###%%%%%%%%%%%######************************#######%%%%%#%%%#######****************####%%%%###******    //
//    ######*****#######*+++++++***************#########%%%%%%**%%%#######**********++***###%%%%%%%%##****    //
//    ##%%#*++++++++++++====+++++************##########%%%%%%#*+#%%#######**********++*****###%%##########    //
//    %%##*+++++++======+===+=+++++********###########%%%%%%%*+++#%%#######**********++*******#####**#####    //
//    ****+++++==+============++++++*******##########%%%%%%%#+===+%%%######****************************###    //
//    +++++++++++++++=++++++++++++++******###########%%%%%%%*+====*%%%######************++****************    //
//    +++++++=++++++++++++++++++********###########%%%%%%%%#+======*%%%#####***********************+++++++    //
//    ++++++==++++++++++++++************##########%%%%%%%##*+======+#%%%####************************++++++    //
//    +++++=====+++++++++******###################%%%%%%###+========+#%%%######*#**************+++++++++++    //
//    **###*****++++**********####################%%%#####+==========*#%%##########***************++++=+++    //
//    ################******#############################+===========+##%################************++++*    //
//    #%%%%%#####%%%%###########%%%#####################+=============*###################****************    //
//    %%%%#####%%%%%#####%%%%%%%%#%%###################+===============*%%%#####%%%%###########*##########    //
//    ###%%%%%%%%%%%%######**###*####################*+================+#%%####%%%%%######################    //
//    %%%%%%##********+++****#######################*+==================*#%%###%#*#%####******############    //
//    *****++=========++**##########################*++==================#%#####%#########################    //
//    ===-========-==+***#########################%%##**++===============+#%##########**########%%%%######    //
//    +++++++**++++++***#*#######################%%@@@%##*++==============*###########*****+++****########    //
//    *******************######################%%%%@@@@@%%**++=============############**+++=====++++*****    //
//    *****************#######################%%%%%@@@@@@@%#**++===========+###########***++==============    //
//    ************##########################%%%%%%%@@@@@@@@%%#*+++==========*###########***++++++++++++++=    //
//    #####################################%%%%%%%%@@@@@@@@@%%#*++===========*###########**************+++    //
//    ######%############################%%%%%%%%%%@@@@@@@@@@%%#*++===========###########********####*****    //
//    #####################***##########%%%%%%%%%%@@@@@@@@@@@%%%#*++=========-=############***************    //
//    #####################**#########%%%%%%%%%%%@@@@@@@@@@@@%%%#**+++=========+################**********    //
//    #####################****#####%%%%%%%%%%%%@@@@@@@@@@@@@%%%#**++++++=======*#########################    //
//    ###################*******##%%%%%%%%%%%%%@@@@@@@@@@@@@@%%%#**++++++++++++++*########################    //
//    ################********##%%%%%%%%%%%%%@@@@@@@@@@@@@@@%%%%#**++++++++++++++++#######################    //
//                                                                                                            //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract GoU is ERC721Creator {
    constructor() ERC721Creator("Glimpse of US", "GoU") {}
}