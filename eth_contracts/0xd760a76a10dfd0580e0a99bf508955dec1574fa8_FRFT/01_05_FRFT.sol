// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: FORFEIT
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                      [email protected]@@@                                                                                                     //
//                                                                                                   (@@@@@@@@@@/                                                                                                 //
//                                                                                               *@@@@@@@@*@@@@@@@@@(                                                                                             //
//                                                                                           @@@@@@@@@@       &@@@@@@@@@@*                                                                                        //
//                                                                                     &@@@@@@@@@@@               %@@@@@@@@@@@@(                                                                                  //
//                                                                            /&@@@@@@@@@@@@@@                         &@@@@@@@@@@@@@@@&*                                                                         //
//                             ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#                                     (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%                            //
//                             %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(                                                       (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                            //
//                             @@@@@@                                                                                                                    ..,,,,,,,,..           *@@@@@                            //
//                             @@@@@%                                                                                                                                           [email protected]@@@@                            //
//                             @@@@@,               @@@@@@@@(            @@@@@@.         @@@@@      @@@@@@@%          @@@@@@@@@%     %@@@@@@@@,           @@@@@@@                @@@@@                            //
//                             @@@@@               [email protected]@@@@@@@@@@,        #@@@@@@@         @@@@@      @@@@@@@@@@@@      @@@@@@@@@%     %@@@@@@@@@@@       @@@@@@@@@,               @@@@@.                           //
//                             @@@@@               [email protected]@@@%  @@@@#       *@@@@(@@@@        @@@@@      @@@@   @@@@@@     @@@@@%%&&      %@@@@, [email protected]@@@(     #@@@@@@&,                 @@@@@.                           //
//                             @@@@@               [email protected]@@@@@@@@@,       [email protected]@@@# @@@@@       @@@@@      @@@@   %@@@@@     @@@@@@@@@      %@@@@@@@@@@         @@@@@@@@@               @@@@@.                           //
//                             @@@@@               [email protected]@@@%@@@@@.       @@@@@@@@@@@@@      @@@@@      @@@@@@@@@@@@/     @@@@@%%%%%     %@@@@,@@@@@        @@@(#@@@@@               @@@@@.                           //
//                             @@@@@               [email protected]@@@% %@@@@@     @@@@@    &@@@@@     @@@@@      @@@@@@@@@@        @@@@@@@@@@     %@@@@, @@@@@@     @@@@@@@@@@                @@@@@.                           //
//                             @@@@@.                                                                                                                                            @@@@@                            //
//                             @@@@@(                                                                                                                                           [email protected]@@@@                            //
//                             @@@@@&                                                                                                                                           /@@@@@                            //
//                             &@@@@@                      /@&@.                               .#%%%%%        %%%%#(.                              . @@@                        %@@@@@                            //
//                             (@@@@@                      &@,@@@%                       .%%%%%%%%%%%%        %%%%%%%%%%%%/                      ,@@@@@                         @@@@@&                            //
//                             [email protected]@@@@                      @@@@@@@@@                   %%%%%%%%%%%%%%%        %%%%%%%%%%%%%%%                   @@@@@.%@@                       @@@@@*                            //
//                              @@@@@.                   @@.  @@@@@@@@                %%%%%%%%%%%%%%%#        %%%%%%%%%%%%%%%%(               @@@@@@@    @@                     @@@@@                             //
//                              @@@@@&                 [email protected]@        @@@@@&       .,    %%%%%%%%%%%%%%%%#        %%%%%%%%%%%%%%%%              @@@@@&       [email protected]@                   #@@@@@                             //
//                              /@@@@@                 @@@        @@@@@@@%   @@@    /%%%%%%%%%%%%%%%%/        %%%%%%%%%%%%%%%%% %  @@@    @@@@@@@/       &@@                   @@@@@%                             //
//                               @@@@@                 %@@@         (@@@@@%@@/      %%%%%%%%%%%%%%%%%,        ,%%%%%%%%%%%%%%%% /*   #@@&[email protected]@@@@         @@@@                   @@@@@.                             //
//                               @@@@@@                 %@@@@#         %@@& #&     %%%%%%%%%%%%%%%%%%         .%%%%%%%%%%%%%%%%% %      #@@@         ,@@@@@                   &@@@@@                              //
//                               ,@@@@@                   ,@@@@@@@@@@@@@  @@@@@@   %%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%.#%  @@@@@ /@@@@@@@@@@@@&                     @@@@@%                              //
//                                @@@@@(                        ,/,       [email protected]@@@@/ %%%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%%,%  @@@@@%     *%%,                         #@@@@@                               //
//                                /@@@@@                                    &# .%%%%%%%%%%%%%%%%%%%%%          %%%%%%%%%%%%%%%%%% %%% ,@@(                                   @@@@@&                               //
//                                 @@@@@#                                     %%%%%%%%%%%%%%%%%%%%%%%(((((((###%%%%%%%%%%%%%%%%%% %%.. @.                                   %@@@@@                                //
//                                 *@@@@@                                    /%%%%%%%%%%.                             *(%%%%%%%%% %% #                                      @@@@@%                                //
//                                  @@@@@&                                   #%%%%%%%%.*@@@@@@@@@@@@@@@@@@@@@   (@@@@@@@@@( #%%%% /%                                       @@@@@@                                 //
//                                   @@@@@.                                  #%%%%%%% %@@@@@@@@@@@@@@@@@(  [email protected]@@@@@@@@@@@@@@@ %%%% ,%,                                     [email protected]@@@@*                                 //
//                                   #@@@@@                                   %%%%%%(                 /@@@@@@       @(  (@@@/.%%%  %* #                                   @@@@@@                                  //
//                                    @@@@@@                                  %%%%%% *@              [email protected] @@@@ @@@&. /&@@@@@@@* %%%  %/ #                                  @@@@@@                                   //
//                                     @@@@@&                                  %%%%% @@              /@ @@@@@@ ,@@@@@@@@@@@@( %%%  %/%                                  &@@@@@                                    //
//                                      @@@@@*                                 (%%%% #@(             @  @@@#@@@@@@@@@@@@@@@@# %%% #%,#                                 (@@@@@(                                    //
//                                      ,@@@@@.                                 %%%%  @@@@@@@@@@@@@@@@  @@@,@@@@@@@@@@@@@@@@. %%( %%%                                 ,@@@@@%                                     //
//                                       /@@@@@                                 .%%%/   @@@@@@@@@@@@@@ #@@@@@@@@@@@@@@@@@@%   %%./%%                                 [email protected]@@@@@                                      //
//                                        #@@@@@                                 %%%%   @@@@@@@@@@@    @@   ,.%@@@@@@@@@&&@@ #%% %%                                 [email protected]@@@@@                                       //
//                                         %@@@@@                                 %%%*  @@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@# %%%%,                                 (@@@@@@                                        //
//                                          /@@@@@/                                %%%   @@ @@@@ &@@@@@@@@@@@@@@@@@@@@@%@@@ *%%%                                  %@@@@@&                                         //
//                                           [email protected]@@@@@                                 *%   @ @@@@@@@@@@@@@@@@@@@@@@@@@@@ @@  %%                                   @@@@@@%                                          //
//                                             @@@@@@                                 %%    @@@@@@@     .*((  @@@@@@@@@    #%*                                  @@@@@@*                                           //
//                                              @@@@@@.                               %%%   ,@@@@@@@@@@@@@@@@@@@@@@@@@  @ .%% ,@@                             (@@@@@@                                             //
//                                               (@@@@@@                         @@@@@  /. @@ (@@@@@@@@@@@@@@@@@@@@@  .  %%# @@@@@@@@                        @@@@@@@                                              //
//                                                 @@@@@@                   &@@@@@@@@@@/ %       @@@@@@@@@@@@@@@@@    %%%%%%  @@@@@@@@@@@/                 (@@@@@@*                                               //
//                                                  %@@@@@@           [email protected]@@@@@@@@@@@@@@@  %                          %%%%% #%#   %@@@@@@@@@@@@@,           @@@@@@@                                                 //
//                                                    @@@@@@&     *&@@@@@@@@@@@%*         %                       (%%%(   #%/        ,%@@@@@@&#,        @@@@@@@                                                   //
//                                                     [email protected]@@@@@#                             %%%/              #%%%%%% /@@ %#                          @@@@@@@#                                                    //
//                                                       *@@@@@@#                             %%%%%%.    %%%%%%#  @.#%/,%                           @@@@@@@&                                                      //
//                                                         *@@@@@@@                                     %%%%%% ,. *%%                             @@@@@@@&                                                        //
//                                                           ,@@@@@@@                                 %%%                                      *@@@@@@@&                                                          //
//                                                              @@@@@@@&                                                                     @@@@@@@@*                                                            //
//                                                                &@@@@@@@,                                                               @@@@@@@@@                                                               //
//                                                                   @@@@@@@@/                                                         @@@@@@@@@*                                                                 //
//                                                                      @@@@@@@@@                                                  [email protected]@@@@@@@@/                                                                    //
//                                                                         @@@@@@@@@%                                           @@@@@@@@@@,                                                                       //
//                                                                            (@@@@@@@@@@.                                 #@@@@@@@@@@&                                                                           //
//                                                                                (@@@@@@@@@@@/                       @@@@@@@@@@@@&                                                                               //
//                                                                                     &@@@@@@@@@@@@@          #@@@@@@@@@@@@@@.                                                                                   //
//                                                                                          ,@@@@@@@@@@@@@@@@@@@@@@@@@@@*                                                                                         //
//                                                                                                 ,&@@@@@@@@@@@%.                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
//                                                                                                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract FRFT is ERC721Creator {
    constructor() ERC721Creator("FORFEIT", "FRFT") {}
}