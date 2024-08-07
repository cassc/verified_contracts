// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Mid Century Pepes
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                    //
//                                                                                                    //
//      __  __ _     _         _____           _                      _____                           //
//     |  \/  (_)   | |       / ____|         | |                    |  __ \                          //
//     | \  / |_  __| |______| |     ___ _ __ | |_ _   _ _ __ _   _  | |__) |__ _ __   ___  ___       //
//     | |\/| | |/ _` |______| |    / _ \ '_ \| __| | | | '__| | | | |  ___/ _ \ '_ \ / _ \/ __|      //
//     | |  | | | (_| |      | |___|  __/ | | | |_| |_| | |  | |_| | | |  |  __/ |_) |  __/\__ \      //
//     |_|  |_|_|\__,_|       \_____\___|_| |_|\__|\__,_|_|   \__, | |_|   \___| .__/ \___||___/      //
//                                                             __/ |           | |                    //
//                                                            |___/            |_|                    //
//                                                                                                    //
//    ////////////////////////////////////////////////////////////////////////////////////////////    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                     #                                                  //    //
//    //                                %@  ,@*                                                 //    //
//    //                            %   @@@ ,@@                                                 //    //
//    //                            @@  @@@@ @@@(                                               //    //
//    //                        /@  %@@@ [email protected]@@# @@@*                                             //    //
//    //                         @@@  @@@@  @@@@ @@@@                                           //    //
//    //                     @@   @@@@  @@@@@ @@@@ /@@@@          @ @                           //    //
//    //                      @@@@  (@@@@@ &@@@@ @@@@ @@*       *@/@                            //    //
//    //                    @*   @@@@@@  @@@@@ &@@@, @@@       &@@@@@@,                         //    //
//    //                     (@@@@@   %@@@@@@ [email protected]@  @ @%@     (,@@@@@@@@@*                       //    //
//    //                   *.   (@@@@@@@@@@/ /@@@@@ @@@      @ @@@@@@@@@@@@@#                   //    //
//    //                     ,@@@@@@@@@@@@#  ,@@@@@#@@@     @ @@@@@@@@@@@@@@&                   //    //
//    //                           .,..    /.    ,&@@@@      @@@@@@@@                           //    //
//    //                       @@@@@@@@@@@@@ &@.  @&@@@    ( &@@@@@@*@                          //    //
//    //                          @@@@@@@@@@@# @@@[email protected]@@@@@@@@@@@@@@@@@@@                         //    //
//    //                                 @@@@@* @ @ @@@@@@@@@@@@@@@@@@@@%                       //    //
//    //                                     &    #  @ @@@@@@@@@@@@@ @@@                        //    //
//    //                                    @[email protected]@@@@@@@@@@@@@@@@@@@ @@@                        //    //
//    //                               (@  @@@@@@@@@@@@@@@@@ @@@@@@@ @@%                        //    //
//    //                             @@(#*@@@@@@@@@@@@@@@@@@@ @@@@@@#@@                         //    //
//    //                    @      @@@.(@@@@@@@@@,,@ %@/&@ @@@ @(@@@#@@                         //    //
//    //                    /@@@@@@@@ @@@@@@@. @@@@@@@@ ,&  @ @ @@@@ @                          //    //
//    //                      %@@@@@@@@@@@@@  @@@@@@@@        #@ @@@ @                          //    //
//    //                            [email protected]@@@#     @@@@@@          @ @@@ @                          //    //
//    //                           @@@&        @@@#            @@ @@ @                          //    //
//    //                         @@@        @@@&              @@@ @@@                           //    //
//    //                         [email protected]@         &@,                @@ @@                           //    //
//    //                          @@@@&       ,@@@@              @@@@@@@                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    //                                                                                        //    //
//    ////////////////////////////////////////////////////////////////////////////////////////////    //
//                                                                                                    //
//                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////


contract MDCNTRYPPS is ERC1155Creator {
    constructor() ERC1155Creator("Mid Century Pepes", "MDCNTRYPPS") {}
}