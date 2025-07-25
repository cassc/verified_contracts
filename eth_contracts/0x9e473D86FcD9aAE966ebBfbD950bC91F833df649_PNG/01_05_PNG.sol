// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Probably nothing girls
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//    ########################################################################################################################################################################################################    //
//    ########################################################################################################################################################################################################    //
//    ########################################################################################################################################################################################################    //
//    #############################################################################################%%%&&&&%%%#################################################################################################    //
//    ###################################################################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#####################################################################################    //
//    #######################################################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###############################################################################    //
//    #################################################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##########################################################################    //
//    #############################################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#####################################################################    //
//    #########################################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##################################################################    //
//    ######################################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@###############################################################    //
//    ###################################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@############################################################    //
//    #################################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#########################################################    //
//    ###############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#######################################################    //
//    #############################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#####################################################    //
//    ############################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###################################################    //
//    ##########################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#################################################    //
//    #########################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@################################################    //
//    #######################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##############################################    //
//    ######################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#############################################    //
//    #####################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@############################################    //
//    ####################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###########################################    //
//    ###################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%##########################################    //
//    ###################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@##########################################    //
//    ##################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#########################################    //
//    #################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#########################################    //
//    #################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@#@@@@@@@@@#########################################    //
//    ################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@*@@@@@@@@@#########################################    //
//    ################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@,@@@@@@@@@#########################################    //
//    ################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@&#########################################    //
//    ###############################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,@@@@@@@@@@@@@/@@@@@@@@@@@@@@@@@@(@@@@@@@@##########################################    //
//    ###############################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@(,@@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@(@@@@@@@@###########################################    //
//    ###############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.,/[email protected]@@@@@@@@@@@@@@@,@@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@@@@@@@@@#%@@@@@@@@@%@@@@@@@@,@@@@@@#############################################    //
//    ###############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&................,/.(&@@@@@@@@@@@@@@,[email protected]@@@@@@,*@@@@@@@@@@@@@@@,@@@@%.,@@@#*,......#@@##############################################    //
//    ###############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/.             ...*@@,(/    [email protected]@*.....&[email protected]@,....*@@@@@%.......     ,@@%##############################################    //
//    ###############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..              &@@&####@@   @@@@@&.                      @@@@/   %@@    ,(   [email protected]@&###############################################    //
//    ###############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&..            @@/ ,@@###&@   @@                        *@@####&@  [email protected]@@@(.    @@&################################################    //
//    ###############################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,..          ,@%    @@###@   @@                       /@@%@@@##@&  %@,      @@&#################################################    //
//    ###############################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...        [email protected]@     @@###@   @@                      [email protected]@   *@@#&@  (@%     @@@@@################################################    //
//    ################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(..        [email protected]@    ,@@##&@  (@%                      &@.   *@@#@%  #@*    &@&.&@@###############################################    //
//    ################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...       *@&   %@@###@   @@.                      @@    @@##@   @@    [email protected]@..&@@###############################################    //
//    ################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/..        @@@@@@###%@   &@/                       @@  %@@##@(  #@#    @@,.*@@################################################    //
//    #################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*@@@@@...       [email protected]@@%#%@@,   @@(                        @@@@%###@#  ,@&    ,@&.(@@#################################################    //
//    ################################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,#@@@@*..         #@@      *@@                          [email protected]@@@@@&   %@(     #@,,@@##################################################    //
//    ################################&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@&...           ,@/ @@*                              [email protected]@@&# *@/       ,@[email protected]@&##################################################    //
//    ################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..*@@@@...                                      [email protected]@@@                     **.,@@###################################################    //
//    ###############################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@*..                                     @.   *@                    /@[email protected]@&###################################################    //
//    ###############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...(@@@%...                                                               *@@@#####################################################    //
//    ##############################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@...,@@@@...                                                               &@@@#####################################################    //
//    #############################%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@...                                         .(@                  (@@@&#####################################################    //
//    ############################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@...                                /@@@@@&#//@,                 @@@@@%#####################################################    //
//    ##########################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%[email protected]@@@...                            [email protected]@((@@%((@@(@&                ,@@@@@@%#####################################################    //
//    ########################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,[email protected]@@@...                           (@(((///((((/%@.              *@@@@@@@@&#####################################################    //
//    ########################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@..                             &@@@@&@@/////#@.          ,@@@@@@@@@@@@#####################################################    //
//    ############################%%%#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,                                    [email protected]#///(@,      ,@@@@@@@@@@@@@@@@#####################################################    //
//    ########################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(                                [email protected]@&@@*   #@@@@@@@@@@@@@@@@@@@@#####################################################    //
//    ##########################################%&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,..,%@@@@@/                              .#@@@@@@@@@@@@@@@@@@@@@@@@@%####################################################    //
//    ##################################################@@@@@@@@@@@@@@@@@@@@@@@@@@@@%.........,&@@@@@&*                 .#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@####################################################    //
//    ####################################################&@@@@@@@@@@@@@@@@@@@@@@@@/,   .............,%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###################################################    //
//    ################################################################@@@@@@@@@@@@@./,       [email protected]@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@####@@@@@@@@###################################################    //
//    ##################################################################&@@@&(@@@  .,(/            [email protected]@@@@@@@@@@@@@@@@%########@@%#################################################################    //
//    ###############################################################@@@@(((/**/@@.   %/*                       @@(###########################################################################################    //
//    ############################################################@@@&(((/*******@@/    %(/.                     /(&@@@%######################################################################################    //
//    #########################################################&@@@(((/***********@@/     .&//.               . ./@@*. /@@%###################################################################################    //
//    #######################################################@@@#(((***************@@,        /&(//*.      %#,##( [email protected]@    %@@#################################################################################    //
//    ####################################################%@@@(((/******************@@.             ./(#%#/, (%*      (#    @@%###############################################################################    //
//    ##################################################%@@%(((/********************(@@                                      ,@@##############################################################################    //
//    ################################################%@@%(((/***********************&@%                                       #@@%###########################################################################    //
//    ###############################################@@&(((/**************************@@.                           (            #@@@#########################################################################    //
//    #############################################@@@(((/****************************/@@                    [email protected]@#.*@&              (@@@#######################################################################    //
//    ############################################@@%(((*******************************%@@                     [email protected]@@@.              (@@@@@%####################################################################    //
//    ##########################################%@@(((**********************************@@%                      [email protected]@@..            (@&***@@@@#################################################################    //
//    #########################################%@@(((************************************@@%                       %@@,.           &@#******/@@@&#############################################################    //
//    #########################################@@((/**************************************&@@                       ,@@*.         [email protected]@***********@@@###########################################################    //
//    #########################################@@@@@@@@#************************************@@&                      [email protected]@...       @@%************(@@%#########################################################    //
//    ############################################@@@@@(&@@@@@(**********/@*******************@@@%.                   /@%..     /@@#                                                                              //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PNG is ERC721Creator {
    constructor() ERC721Creator("Probably nothing girls", "PNG") {}
}