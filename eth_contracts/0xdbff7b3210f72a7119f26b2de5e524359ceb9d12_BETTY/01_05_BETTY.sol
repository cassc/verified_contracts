// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Ballpoint Betty
/// @author: manifold.xyz

import "./ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                      .⌐░░░░░░'' ''''"⌐⌐⌐                            //
//                                .⌐░░░░░░░░|░⌐░⌐       .'|░⌐'░⌐⌐                      //
//                               ░░░░░░░░░░░'░⌐░░░|░░░░⌐░░░░░░░░░                      //
//                              '░░░░░░░░░░░⌐░░░░░░░░░░░░░░░░░░░░░                     //
//                             ''░░░░░░░░░░░,░░░░░░░░░░░░░░░░░░░░░░.                   //
//                            -░░░░░░░░░░░░░░░░░░░░╦░░░░░░╠░░░░░░░░ε⌐                  //
//                           ╠╠░╠╠╠▄▄╣╬╣╣╣╣╣╣╫▒▒▒▒▒▒▒▒▒▒▒▒▀▒▒▒▒▒▒▌▒░⌡░                 //
//                          ,░╠╣▀Å╨░░Q░░░░░░░░░░░░░░░░░░╫╬╬▒╬▒╣╬▒▌δ╠ ░░⌐               //
//                         ╔░║╬▒,▄▒▀▀▀▀▌▒▄⌐''░'░⌐░,░╔▒╬▒╣▀▀▀▀▀▀▒▄╫╬░⌐"░░⌐              //
//                        ╔░╠╬╬░▒╬╬╩░░╠▒▒░░░.⌐''.⌐░░╬╣╬╬╬░░░╠╣╬╬░░▒╬░ ░░░░⌐            //
//                       .░░╬╣▒░░╠▄▒▒╬░╠╬╣░░░⌐⌐'.░░╠╠╬╬▄▒▒░░▒▒╬░░░╣╬░░|░░░░'           //
//                       ░░╣╬╬▒░'╫▒╣╩╙╨╬╬▌░░░⌐  '░░░░░▓▒╠╝╙╙▒▒▓▄.░╠▌░░⌐░░░░⌐'⌐         //
//                      ░░╣▒▒▒▌░'▒▒Q   ▐▒▀▌░░⌐   ░░░░░▓▒Q   .▌▌▌'░╠▌░╠░⌐░░░░░ ░        //
//                     φ╣▌▌▌▌▓▌░ ╟▌▌▄╗▄▌▀▌░░░⌐    ░░░╠▀▓╬▒m#▒▀▀C|░░█▒░░░░░░░░░⌐|⌐      //
//                   φ▒▌▌▌▓▓█▄╠░░╙░▀▀▀▀▀▒Ü░|░░╠╠j╦░░░░╙╬Å▀▀▀Å░╩⌐░░░╫▓▓▒╠╠╦░░░░░░░⌐     //
//                  ╣▌▓▓▓█▀░░░░░⌐⌐⌠░░░╫░░'.''░░░░░.''░░░╟░░⌐░Ö||░░░█▌▀▀▓▒╬╬δ░░░░░░⌐    //
//                 ░▒▒▀▓▀ ╔▒▒▄╣▌░.'╙╨╨'⌐'~~.╔╠░░╠╡░░░|░░░╬░╦╬░░'░░╠▓░:▓▓▒▒╬░░░░░░░░    //
//                 ░╟╬╣▌ .▒╠██▌░░⌐⌐'~''',⌐░╩╙░░░░╨╝░░░░░░▒╬╬╬░░░░░╣▓░]▓▓▀░,░░░░░░░░    //
//                 ╗░╣╬▌  ▒╣▌▀▌░▄░░⌐░⌐''░░░░░░╠╬╬╠╠╠╠░░░░╫╬╬▒░░░░╣▓▓▌░▀░░░░░░░░░░░     //
//                 ╚╬░╠╬▌µ ╙▀░░▒▓▌░░⌐⌐|░░░░░░░░░░░░░░░░░░╫╬╬╣╬╠╬▓▓▓▓▀░░░░░░░░░░░░░     //
//                  ╠░░░╣Å▀▒▒▒▀╨╠╬▀▒▄░░░░░░░░░░░░░░░░░░░╠▒╬╠╬▓▓▓▓▓▀░░░░░░░░░░░╬╬╬░     //
//                  ╠▒╬░╬░░░░╦╬╬░░╨╬▒▀▌▀▓▓▓▌▌▌▌▒▒▒▒▒▒▒▒▒▀▌▌▌▓▓▓▓▓╬░░░░░░░░░░░░░Å▒╬Ç    //
//                 .╣╬╬▒▒▒╬░▒╬░░░░░▒▒▒▒░╠╬▀╬▒▀▀▌▌▒╬╣╬▒╣█▓▓▓▓▓▓▓▓▓▒╬╬╠╠╠╠╠╠╬╬╬╬╬░░▒╣    //
//                 ╣▒╬╫░║▒Å░░░░╬╬╬╬╬░░░░╩╩╬▌▒▒▌╬▀▀▒▒╬╬╬▒▓▓▓▓▓▌▓▌▓▓▓▌▌▌▒▒╬╬╠╬╬╬╬╬░░▒    //
//                ╫▌▒▒▀▒╠╬░░░░░░░#╩░░░░░░░░╩╬▒╠░░░╠▒▒▒╬╬╬╬╬▀▓▓▀▌▒╬╫╫▀▓▓▓▓▀▒▒▒╬╬╬╠░╟    //
//                ╙▌▌▀▌╠▒▒▒╣╬╬╬╣╬╬║▒╬▄░░░░▄░░╬▒░░░╙╠▄╠╫╬▒▒▒▒▒Å░▌▀▀█▓▓▌█▓▌▓▌╬╨▀▌▒╢░╩    //
//                  ╙▌▓▌░╗▒▒▒╬╬▒▒╬░░╬Å░░╟▒╬╬╡░░╣░░░░░╬╗ "░;φ╨░''░▒╬╦▄▒▌▀▓▒▀╬░░▀▌▒╩─    //
//                    ▐░░╫╩╠▒▒╣╣╣╣▒▒╣╬░░░╠▒╬░░░Å░░]╬╬░░░╦µ▓▒╤╗██╬░░╠╟▌▓▌▒╬╬╬╣░▒╬w      //
//                    ╞░░░░░░░░╬░╬╬╬▒▒╠░░░░░░░░░░░░╬╬╬▒░╠Q▄▄▄▒▓▌╣╬░░╠▀Å╠╬╬▒▀▌░╨╬       //
//                  .░'░░░╫╬░╩╙░╙░╣╣▒╬▒▒╬▒▒╠░╣╣░░╩░░░░░╩░░Å╬╬╬╣▌╠╬╣╬░░░▄░░▀▌▒░▒▒░      //
//                                                                                     //
//                                                                                     //
//                                                                                     //
//                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////


contract BETTY is ERC721Creator {
    constructor() ERC721Creator("Ballpoint Betty", "BETTY") {}
}