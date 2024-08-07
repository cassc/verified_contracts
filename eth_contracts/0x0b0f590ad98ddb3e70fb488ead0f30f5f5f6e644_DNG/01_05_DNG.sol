// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: DREAMING NIGHTMARES
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                        //
//                                                                                                                        //
//                                                                    '::::;;,...                                         //
//                                                  .......',,,'...d00000OOkxdl:,..                                       //
//                                              ....',,;;::clll;'..oXXXXXXXXKK0kxoc;'..                                   //
//                                           ......',;:lddddooo:'..oXNNNNNNXXXXXKOkdlc;'..                                //
//                                         .......''',,cll:;;;;;,..lXNNNNNNNNXNXXKK0Oxol:,'.                              //
//                                      ......'',,,,,,,'''',,,,;,..;kXNNNXKOKX0o:;:lxOOkdl:;'.                            //
//                                   ......''...'',,,,,,,,,,,,,,'...'lONX0c.;c:''....,lxOkdl:,..                          //
//                                ......'''.........',,,,,,,,'''''...'dKKOc...',,,'.....:okkdc;'.                         //
//                             .......'''''',,,,,'...',,,,,,,,'',,,'..',,lxl,,,,,,;::;'...,lxxl:,.                        //
//                            .....''''',,:cooddool;..',,,,,,'. .',,'..  .ckl,,,,,;cc;,',:,.,ldo:'.                       //
//                           .''...''',,,',,;::cclllc,.',,,,..   .',,''.  .lkl,,,,'''...oKKx;.,cc;..                      //
//                          .','..''''''''''''',,;;;,'.',,,.      .,,,'.   .okl;;,'.....'cd00d,.,;'..                     //
//                         ..,:,''''''''',,,;::clc;'.'',,,.       .,,''.    .d0Okdl:;,'...,;lxkl.....                     //
//                        . .;;'';,''''',:codxxd:'..',,,'.      ..,,,'...    'kX0kxdol:;'',;;:col'....                    //
//                       .. .;;;c:'''',:oxxxxdo;...',,,'..    ..',,,,'.,:.    lKxccd0K0Okdoc:cccc:'...                    //
//                      ..  'loc;'''',cdxxxxdc,.. .',,,''....',,,,,,,'.;xd:...dXKo..'lOXNNXK0kxdl:,...                    //
//                     ..  .;oc''''''cdxxxdl:'.. ....',,,,,,,,,'''',,,',lxdllkKNXx,...'oKNNNNNX0xl;'..                    //
//                     ..  .c:...''',cxxdoc,... ........'''''''''',,'...:ddc:lkOxc,'....:OXNNNNKOd:,..                    //
//                    ..  .::....'''';ldl:'.....,,;;;;,,,''''',;;:;;,...'lO0xc,;,,,,,'...,OXNNXx,';,...                   //
//                    .  .;c'....''''',;,'....,cooolcc:;,'..'''...........,lkOo:,,,,,;,...;ONNXx'......                   //
//                   .  .,l;..''..''.........;oxoc;''.......................'cxd:,,,,:l:...;OXNO;.  ....                  //
//                  .  .'cc'..,,............;ddc,.............................,lo:,,,;ldc...'cxd:..  ...                  //
//                    .':l:. .,;'..........;dd:'..............',;:::;,'.........;;,,,,:xx:.....,,'.  ...                  //
//                    .,cc,...,:;'........'oxc'..........';ldxxkO00Okkxo:,'.......',,,;okd,....','..  ...                 //
//       ';;;'...      .::....'::;'.. ....;do,........'cdddddo::clc::colclo:'......',,,:xx:....',,'.   ..                 //
//     .col:;'..'.......;;... .:c:,.. ....cdc........,clo:...            .,::,.....',,,;okc'...',,'..  ..                 //
//    .loc;'...';;,.....;,... .;c:;.......lo;..........           ......    .;;.....',,,cxo,...',,,'.                     //
//    co:'....,:;,;,.'..;,... .,::,.. ...'ll'.....        ..      ..'cc,..   .',....',,,:dd;...',,,'..                    //
//    c:'....,lc,';,.'..,'... .'::,.. ...'l:.....      ...''..     ..,;:,..    ......',,;od;...',,,'.....                 //
//    ;,.....:;...,;'...''... .,::,.. ...,c;.....      .......      ...,:,...     ....,,,ld:....'''''....                 //
//    .'....,,....,:;,....... .,c;'......,c'....    ..',,,'..      .....:oc;'..    ...',,co:....'''''....                 //
//     ... ......':::;....... .;:;'......,:'...    ..;::;;'...   ....;:':kdlol;.   ...',,co:.....''''...                  //
//     ...........;::;'........::,.......,;....   ..':c::;.......',,'ckxdxc;cdxl.  ....,,co:......'''...                  //
//      ...........,::,.......'::,.......,,...    ..',::;,....',,;;:::ldo:,,;:od;.  ...',co:.......'...                   //
//       ...........';,...   ..::,.......,'...   ...'......',,,,;;:;,,,:lc,,;,;c,.  ...',co:...........                   //
//        ...........';'..    .;:,.......,'..    .........,,,:ccclllc,'';:,,;,'..   ...',cd:...........                   //
//         .......',,''..     .;:,.......,...  . .......','....    ...',,;;,,;'..   ...',ld:..............                //
//           ......''','.     .,;,......',..  .. ......,,'.        ..  .',;,,;'..    ...,ld:.........',',,                //
//             ..........      ';,......''..  ........''..   ..   .....  .,,,,'...   ...,ld:.........;;;;;                //
//               ......        .;;'.....''...........''.   .... ...,;;'...',,,'...   ...;od:......  .,;;'.                //
//                             .,;'..................'.   ......',,,;,,....,,'....   ...;lo;.....    ...                  //
//                             .';,....................   .....',,,..',.  .,,'..... ....;ll,....                          //
//                              .;,.........  .........  ......,......'.. .','..........;lc,...                           //
//                              .,;........   ........  ......''..,,.......','..  .. ...;c:'...                           //
//                              .';........   ......'.  .......   .........','..     ...;c;....                           //
//                              ..,'.......    ....,,. .......     .....  .;;'..     ..'cl;....                           //
//                             . .'........    ....::. .......    ...''.  ,ol'..     ..,ll,....                           //
//                             .........''..   ....cl'  ...'.... ....;'  .lOo'..    ...:dl'...                            //
//                              ........''..    ...:d:.....';;,'';:,';'..:d0x,.     ..'oOo'...                            //
//                              ........','..   ...;oolodl,...''''',:oc;lloxc.     ...;xXO;...                            //
//                              .. ......,,'.     ..;odddxxoc::;;:lddooooc:;''.   ..''c0XO:...                            //
//                              .    ....,,'.. .,....':llodddddddddddoc:;'..cxl. ..',;dX0d,...                            //
//                               .    . .',,'..lkd,.. ...',;:ccllc::,.....;cdko...',,:OXOc'...                            //
//                                ..  . ..,,,'.;dkxoc,.  ...........  .',lkkdd:..',,,dKXk:....                            //
//                             .  .....  .',,,'.,lxkOko;,,'..........;okxxOxc,''',,,l0XKo,....                            //
//                             ..  .....  ..',,,'';cdxkkkkkdoxkdloxxddkkdlc;''',,,;d0XXO:..... .                          //
//                              ..  ....  ....',,,'',,;;::cccclc::::;,;;,'''',,,,:kXNNKd'.... .......                     //
//                              .................'',,,,,''''''''''''''',,,,,''''lOXNNXk;..... ............                //
//                  .'..         ..........''..........'''',,,,,,,,,,''''.....'l0NNNNKl...'..............'                //
//              ....:c,.    .     ...'.....';;,,'.............................cOXNNNXk;.,::'.............,                //
//           ......:xl'.   ..       .',,,'..':c::;'...................'''...';kXNNNNKd:llc,.............,:                //
//    ............'o0o'.. ...        .',;:;'.',,...................;lkOOkkxxx0XNNNNXOxdoc;.............,:l                //
//    ............'dKd'.....'.        .';:cc;,......',,,,,,,''....l0KXNNNNNNNNNNNXKOxxdl:...'........',:ld                //
//    .............l0x,'...';'.        ..;:cllcc::ccllccccllllc:,.,cx0XNNNNNNNNNX0kxxdo:'.'''.......',;cox                //
//    ..........''.,xk:''...;:;..       ..,:ccoddxxxdddddddxxxxxoc;,,:ldxkO0KK00Okxxdoc'.',''''''''',;coxk                //
//    ..........''.'o0o,'''.':c;'.        .;::cldxxxxxxxxxxxxxxxxddoolcccllddxxxxxxxdl,.,,,,''''''',;:ldxO                //
//                                                                                                                        //
//                                                                                                                        //
//                                                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DNG is ERC721Creator {
    constructor() ERC721Creator("DREAMING NIGHTMARES", "DNG") {}
}