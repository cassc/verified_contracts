// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Chippy's World Collabs
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                //
//                                                                                                                                //
//    :;;;:;,'..     .....''''.....   ..',;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;'.   ...''',,,,,'''...       //
//    ;::;,.    ..',,;;:::::;;:::;;,,'.. ..,;::::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,. ..',;;:::::;:::::;;:;;'.    //
//    ;;,.  ..',;::;;;:::;;;;;;;;:::::;;,'...,::::::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:,...,;;:::;;;;;:::::;;;;;::;    //
//    ;....,;;::::::;;;;;;;;;;;;:::::;;;::;'',::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;::;;:::;;;;;;;;;;;;:;;;:;    //
//    ..';;::;::;;;;;;;;;;;;;:::::::::;;::;;:::;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::;;;;;;;;;;;;;;;;;;;;;    //
//    ,,::;;;;;;;;;;;;;;;;;;;::::;;;;;;;;;;;;:;;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::::;;;;;;;;;;;;;;;;;;;;;:    //
//    :;;;;;:;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;;;;;;;;;;;;;;;;;;;    //
//    ;::;;:::;;:;:;;:;;;;::::::;;;;:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;;:;;:::;;;;;:::;;;    //
//    ;;;;;;::;;;;::;:;;;,'''''',,;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;,''.......',;;;:    //
//    ;;;;;;:;;;;:::;,...   ....   ..',;::;;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;,'..  ..',,'... ...,    //
//    ;;;;;::::;;;,.. .':oxk000Okdl;.  .,;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:::;;;;:;'.  .;ok0KNWWNXKOd:.      //
//    ;;;;;;:::;,.  'lOXWWMMMMMMMMMWKx;. .';::;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'. .:xKWMMMWMMMMMMMMWXx:    //
//    ;;;;:;;;;.  ,xXWMMMMMMMMMMMMMWWWNO:. .,;:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;'. .cONMWMMMMMMMMMMMMMMWWN    //
//    ;;;;;:;'. .oXMMMMMMMMMWWWWMMMMMMMMNk' ..;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;;;:;;:,.  ;ONWWMMMMMMWWWWWMMWMMMWM    //
//    ;;;:;;'  ,OWMMMMWWXOoc;,,;:lxKWMMWWW0;  .;:;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:,. .lXWWWMMMWKko:;,,;coONMWMM    //
//    ;;:;;.  :KWWWMMNOc.          .:kNMWMMK:  .;:;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;,. .xNWWWMMXx:.         .,oKWM    //
//    ;;:;'  :KWWMWWO:..;cc:'         ;OWWMMK;  '::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;:;;:,. .kWWMWWNx,..;lol;.       .oX    //
//    ;;:,. ,0WWMMNd..oKWWMWXl.        .xWMMWO' .,:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;::;;:,. .xWMMWWXl..oKWWWMNd.        ;    //
//    ;:;. .xWMMMXl.;0WMMMMMMK,         .xWMMWo. .;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::;:;. .oNMMMMK:.:KWMMMMMMK,             //
//    ;;'  cNMMMNl.,KMMMMMMMMK,          .OMMMK, .,:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;:;::'. ;KMMMMXc.cXMMMMMMMM0'             //
//    :,. .kMMMWx..kWMMMMMMMWx.           :NMMNl  ';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;:;. .xWMMMWx.;KMMMMMMMMWo              //
//    :'. :XMMMK, :NMMMMMMMM0,            .OMMWx. .;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::;;;:,. ;KMMMMK,.xWMMMMMMMWO.              //
//    ;'  oWMMMx..dMMMMMMMW0,             .xMMMO. .;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::'  lNWWWMx.'0MMMMMMMWO'               //
//    ;. .xMMMWc .kMMMMMMWO,               oWMM0' .;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;:;. .xWWWMNc .OMMMMMMNd.                //
//    ;. .kMWMN: .dWMMMMNd.                oWMM0' .;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;. .OWMMWX:  :KWMWXx;                  //
//    ;. .kMMMN:  .o0K0d,                 .xMMMO. .;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;. 'OMMMMX:   .;c;.                    //
//    ;. .xMMMWo    ...                   '0MMWx. .;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;. 'OMMMMNl                            //
//    :'  lWMMMk.                         lNMMNl  ':;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;. .kMWMMMx.                           //
//    :,. ;KMMMX;   ..'.                 '0MMM0, .,:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;. .dWMMWMK,    .,'.                   //
//    :;. .kMMMWk. .xXNXOo,.            .xWWMWo. .;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:'. :XMMMMWx.  cKNNKxc.                //
//    ::'. :XMMMNo.'0MMMMWNk,          .dNMMWO' .,:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;;;;,. .kWMMMMNo..xWWWMMWKo.         ,    //
//    ;;;. .dNMWMNo.,OWWWMMMK;        'kWMWWK;  '::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;:;;;'  cXMMMMMNo..lKWMMMMWd.       :K    //
//    ;;:,. .kWWWWWk,.:kXWMMX:      .lKWWMMXc  .;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;:;;:;. .dWMMMMMNk,..ckXWWNo.     'xNM    //
//    ;;;:,. 'kWMMWWXx:'':lc'    .,o0WWMWWK:  .;:;:;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:,. .xWMMMMWWNk:...;:'.   .:xXMMM    //
//    :;;;:,. .dNWMMMMWKxoc;,;:ld0NMMMMWWO,  ';;;;::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;:;;::;;:,. .xNMMMMMMMWXkolccclokKWMWWMM    //
//    ;:;;:;,. .c0WMMMMMMMWWWWMMMMMMMMMXo. .';;;;;;;;;;;;;;;:::;;;;;;;;;;;;;;;;;;;;;;;;;;;;;::::,. .lXWMMMMMMMMMMMMMMMMMMMWWW0    //
//    ;;:;::;;'. .l0WMWWMMMMMMMMMWWMWKd'  .;:;;;;;;;;;;;;::::::::::;;;;;;;;;;;;;;;;;;;;;;;;::;;;;;.  ,kNWMMMMMMMMMMMMMMMMWW0l.    //
//    ;:;;;;;;;,.. .:xKNWMMMMMMMMNKxc.  .,;:;;;;;;;::::::::::::::::::::;;;;;;;;;;;;;;;;;;;;:;;;;;;;'. .;xKWMWMMMMMMMMMMWXkc. .    //
//    ;;:;;;;;;;;;'.  .,codxxxdoc,.  ..,;;:;;:::::::::::::::::::::::::::::;;;;;;;;;;;;;;;;;;;;;;;;::;'.  .:oOKXNWWNXKkd:.  .';    //
//    ;;;'';:;::;;;;,'...       ...',;::;;::;::::::::::::::::::::::::::::::::::::::;;;;;;;;;;:;;;;;:::;,'..  ..,;,,..  ...';:;    //
//    ;'.,;:;,,::;;;;:::;;,,',,;;;:::;;:::::::::::::::::::::::::::::::::::::::::::::::;;;;;;;;;;;;;::::::;;,''......'',;::;;''    //
//    '';:;,.,;:;;;:;;;;;;;:::;;;;;::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;;;;;;;;;;:::;;:;;;::::::::::;;:,'';    //
//    ;;;;;,;;:;;;:;;;;;;:::;;;;::;;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;;::::::::;;;;::;;;;::::::;;::    //
//    :::::::::;;::;;;;;,'.',:;;:::;;::;;;::::;:::;:::::::::::::::::::::::::::::;;;:::::::::::;;;;:::::::::::::;;::;::;:::;:::    //
//    ::::::::::::;;;;:;;;'..';:::;::::::::::;;;;;,,,,,,,,'''''''''''''',,,,,,,,;;;;::::::::::;;;;::::::;:::::::;::;;;::::::::    //
//    ::::::::::::;;;::;;:;. .,:;:;;;,,''........                                ..........'',,,,;;::::::::::::;::,..';:::::::    //
//    :::::::::::::::::::::,. .,'....       ..............................................      ......'',;;:::::;'. .;::::::::    //
//    ::::::::::::::::::::;,.     .....'',,,;;;;;;:::::::::::::::::::::::::::::::::;;;;;;;;,,'''....... .....',;'. .,::;;:::::    //
//    :::::::::::::::::;:::,. ..,,;;:::::::;;::;;;;;::::::::::::::::::::::::::;;;;;:::::::::::::::::;;;,''...  .   '::::::::::    //
//    ::::::::::::::::;;::;. .'::;:::;;;:::::::::::::::::::::::::::::::::::::::::;;;;:::::::::::::::::::::::;,'.   ';:;:::::::    //
//    :::::::::::::::;'......';::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;.  .::;:::::::    //
//    ::::::::::::::;;,'...';;:;:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;:::;;::,....,;:::::::    //
//    ::::::::::::::::::::::;;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;,,,;::::::::    //
//    ::::::::::::::::::;::::::;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::    //
//    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::    //
//    :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;:::::::;:::;;:    //
//    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;::;;:;;    //
//    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;;;    //
//    :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;;;;:;'    //
//    ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::;::;::'.    //
//                                                                                                                                //
//                                                                                                                                //
//                                                                                                                                //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract CWC is ERC721Creator {
    constructor() ERC721Creator("Chippy's World Collabs", "CWC") {}
}