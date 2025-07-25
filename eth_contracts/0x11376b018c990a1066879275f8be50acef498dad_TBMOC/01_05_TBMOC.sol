// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TheBenMeadows On-Chain
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

/////////////////////////////////////////////////////////////////////////////
//                                                                         //
//                                                                         //
//                                   ,╓╥╗╗φ@@æ@m≡╖╖.__                     //
//                               ▄▓▓█▓╣╢╬╟▓▓▓▓▓▓▓█▓████▓▄╥_                //
//                            ,Φ█▓╢▓▓▓███▓█▓██▓▓╣╫╫╫╬╣▓████▓▄              //
//                          ,▓███▓▓████████▓▓███▓▓╬▓╫▓███████H_            //
//                         ▄█▓███████████▀╩╩╚╙^╙╚╙╩╚╚╩ÖS╙╙╩╙╙▀█▄_          //
//                       ,███▓╬██Ü` `                         '██,         //
//                      ╒███▓▓▓▓Ü »░_                           ▀█▄        //
//                      █████▓▓╬▒░_»»                            ██╥       //
//                     ╫██████▓╬╬░_`»»                            ██       //
//                     ████████▓▓▒H,`»_                           ██▌      //
//                     █████████▓Ñ`:_`_                           ██▌      //
//                    '█████████Ü_:░░»░-                          ██▌      //
//                    ▐████████Ñ`░»ù░░_,φ@▄▄▄▄,__             ___ ██▌      //
//                    ╣▓▓█████▓░ `jÜ]▒▓╩╙^`""▀▀Ñ╬╦,_    _╓▄▓███▓▓▄██M      //
//                    ║╠ÜV╠███▒  !░ ` _,▄▄▓▓█▀▀█▒╠Ü⌐   Φ╬▓▓▄▄╓._`╚╫█       //
//                    ║Ü╓╩╠██▓░∩_:»` ``''``└` _. !,    ░''╙▀▀-╙▀Ö_▐"       //
//                    Ü|░,░╠█Ñ░░,_        ```    »»░_  :_ `"ⁿⁿ^`  j        //
//                    ▒░╩K ╟╬▒░░Ü░_              ` ``             ¡        //
//                    ╚Ü░_∩╟╬╬Ü▒▒░_-         _╓»   »_   ` _                //
//                     '╚≥▄╬▒Ñ╠╠▒Ü»        _. ╙░_  `      `=_     |        //
//                        █╬Ü░╠╠╬Ü░░░_  ,≡"`_,░╠╬▓ß#╦,╓╓▄▓  ╙▓▄__»H        //
//                        ▓╬╬╣╠▒ÜÜ╔»░`╔^┐A╬Ü╚░╠╬╟▀▓▄╬╬╬╬Å▒╣Ü▄▄'█∩╠         //
//                        ▐▒╟▒╠╬ÜÜ_░»   "▀▓▄▄▄▄▄╥,,,'`___,,▄▌╨HÜj╛         //
//                        |╬▒╟▓▓▒φ^!H_   -`╙W,L `   ╙`└  ╣▀"= ;│╬          //
//                        ²╬╬H╫▓▓▒@_╬H⌐ _    `└╙hH÷≡⌂=╓╦ÑÜ_  îÑΦ           //
//                     ▄█M  ╙╬▒╙███▄╦▒,)ç   ░░,_` -»__ _░░  @╣█            //
//                   ╒███H` _  ╙=╙██▓▄╣╬╬L_  ²`^╚K▒▓Φ╩▀╙` ┌╢█▀             //
//                  ┌█████▄  `    `╙█████▓H_             _╠█"              //
//                 ╓████████▓_       `╙████╬@,_¬_      _/╣▀                //
//                ╔████████████▄         ╙▀███▌╡▒▒H▄▄▄▄▌╩                  //
//              ╓████████████████▄           ╙▀███▓█▓╢╣M ▄                 //
//            ▄█████████████████████,     `__░,, ~╓╟╬Ä   ╙█▄_              //
//         ▄██████████████████████████▄      ```,≤&░ì╠╚╩╠W██████▄▄         //
//      ▄███████████████████████████████▌_  ,-^╚└╙^ⁿ]@ÿwφ∩╟█████████▄      //
//    ▄████████████████████████████████████▀▓▒¿___   `:╚▒▒░███████████▌    //
//                                                                         //
//                                                                         //
/////////////////////////////////////////////////////////////////////////////


contract TBMOC is ERC721Creator {
    constructor() ERC721Creator("TheBenMeadows On-Chain", "TBMOC") {}
}