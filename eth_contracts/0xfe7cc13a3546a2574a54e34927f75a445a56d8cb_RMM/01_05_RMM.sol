// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Red Mada Mon
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    &&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##&&&&&&&&&&&&&&&&&&&##&&&&&&&&&###########BBBBB########&    //
//    &&&&&###&#B#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&###&&&&&&&&&&&&&&&&&&##&&&&&&&&&###BB######B#BB##########    //
//    #BBBBBBB#GPG#####&&&&&&&&&&&&&&&&&&&&&&&&&&###&&&&&&&&&&&&&&&&&&##&&&&&&&&##########################    //
//    #######&&###&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&##&&&&&&&&&&&&&&&&&&&##&&&&&&&&&&&&&&&&##################    //
//    &&&&&&&&&&##&&&&###&&&##&&&&&&&&&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&###&&&&&&&&&&&&&&&##################    //
//    &&&&&&&&&&##&&&&###&&###&&&&&&&&&@@&&&#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&#################&    //
//    &&&&&&&&&&&&&&&####&&###&&&&&@@@@@@@@&###&&&&&&&&&&&&&&&&&&&&@@@@@@@@@&&&&&&&&&&################&&&&    //
//    &&&&&&&&&&&&&&&###&&&###&&&&@@@@@@@@@@@##&&&&&&&&&&&&&&&&#&@@@@@@@@@@@@&&&&&&&&#######&&###&&&&&&&&&    //
//    &&&&&&&####&&&####&&&###&&&@@@@@@@@@@@@&#&&&&&&&&&#&&&&#&&&@@@@@@@@@@@@&&&&&&&&######&##GGB##&&&&###    //
//    &&&&&&######&#####&&&###&&&&@@@@@@@@@@@&&&&&&&&&&&#&&&&&&&#@@@@@@@@@@@@&&&&&&&##########B###&&&&&#B#    //
//    &&&&&######&&####&&&&###&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@@@@@@@@&&&&&&&##########&&&&&&&&####    //
//    &&&&&######&&####&&&###&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&##########&&&&&&&&&&&&    //
//    &&&&&############&&&###&&##&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&##########&&&&&&##&&&&    //
//    &&&&&############&&&#######@@@@@@@@@@@@&@&@@@@@@@@@@@@@@@@&@@@@@@@@@@@@&&&&&&&&########&&&&&&&###&&&    //
//    &&&&&##B###################@@@@@@@@&G#JJP!#[email protected]@@@@@@@@&&&#[email protected]&BP^[email protected]@@@@@&&&&&&&&#######&&&&&&&####&&&    //
//    &&&&&######################@@@@@@@@5   ..    [email protected]@@@@@@@.... :    [email protected]@@@@@&&&&&&#######&&&&&&&&&####&&&    //
//    &&&&&&#########&###########@@@@@@@@!         [email protected]@@@@@@@          [email protected]@@@@@&###########&&&&&&&&&####&&&&    //
//    &&&&&&##B#######BB#########@@@@@@@@^         :@@@@@@@B          :@@@@@@&###########&&&&&&&&####&&&&&    //
//    &&&&&&&####################@@@@@@@@.         [email protected]@@@@@@G          ^@@@@@@&#&&&&&#&&&&&&&&&&&&####&&&&&    //
//    &&&&&&&&&##################@@@@@@@@          [email protected]@@@@@@G          ^@@@@@@&&&&&&&#&&&&&&&&&&&&####&&&&&    //
//    &&&&&&&&&&&###&&########&##@@@@@@@&          [email protected]@@@@@@B          :@@@@@@&&&&&&&&&&&&&&&&&&&#####&&&&&    //
//    &&&&##&&&&&####&###&&&&&###@@@@@@@B          :@@@@@@@&          :@@@@@@&##&&&#&&&&&&&&&&&&####&&&&&&    //
//    &&&&&&&&&&&#########&&&&&&&@@@@@@@#          ^@@@@@@@&          :@@@@@@&####&##&&&&&&&&&&#####&&&&&&    //
//    &&&&&&&&&&&&###&##&&&&&&&#&@@@@@@@&          [email protected]@@@@@@@          :@@@@@@&####&##&###&&&&&######&&&&&&    //
//    &&&&&&&&&&&#######&&&&####&@@@@@@@&          [email protected]@@@@@@@.         [email protected]@@@@@&####&##&####&&&&&#####&&&&&&    //
//    &&&&&&&&&&&#####&#&&&&###&&@@@@@@@@:         ^@@@@@@@@.         :@@@@@@&####&########&&&######&&&&&&    //
//    &&&&&&&&&&&#######&&&####&&@@@@@@@@7         :@@@@@@@@:         [email protected]@@@@@&####&B#######&&&###&&##&#&&&    //
//    &&&&&&&&&##&######&&&#####&@@@@@@@@?..^. 7   ^@@@@@@@@~5:! !~^ [email protected]@@@@@&###&&B#&#######&###&&&&&&&&&    //
//    &&&&&&&&##&&&#####&&&####&&@@@@@@@@G?J#&~#[email protected]@@@@@@@#&J&[email protected]@@G#@@@@@@@&###&&##&###########&&&&&&&&&    //
//    &&&&&&##&&&&&####&&&&####&&@@@@@@@@@#@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###&&&##&&&#&&&####&&&&&&&&&    //
//    &&&###&&&&&&&&###&&&&&####&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&###&&&######&&############&&    //
//    &&##&&&&&&&&&&&##&&&&&####&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&###&#############G#######&&    //
//    ##&&&&##&&&&&&&#GB&&&&###&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&########################&&&    //
//    &&&&&&##&&&&&&&#&&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&######################&&&&&    //
//    &&&&&&#&&&&&&&#&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&########&&&#&&&&&#####&&&&&&    //
//    #&&&#B&&&#&&&#&&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    ##&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&&@@@@@@@@@@@@@@@@@@&@@&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&&&&&&#&##&&########################&&&&&&#&&##&&&&&&&&&&&&&&&&&&&&&&##&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    ##########B#BB#############################&########&&#&##&&&&&&&&&&&&&&&##&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    ##########B#B#############################################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    ########BBB##################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@@&&&&&&&#&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&###BBBBBBBBB#############&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&&&@&&&B#&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    &&&&&###########B###################&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    #######################BBB##########BBBB###################BBBBBB##&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    //
//    ##BB##BBBB#########################BGG#B###B##BB##BBBB####BBBB########&&####&#####&&&&&&&&&&&&&&&&&&    //
//    B########################BBBB#####BBBB#B############B#BBBBB##&&&&&&&&&&&&&&&&&#&&########&&&&&&&&&&&    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract RMM is ERC721Creator {
    constructor() ERC721Creator("Red Mada Mon", "RMM") {}
}