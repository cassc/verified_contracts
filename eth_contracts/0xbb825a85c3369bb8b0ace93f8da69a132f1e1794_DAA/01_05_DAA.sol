// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Dark Abstract Art by Nev.
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                        //
//                                                                                        //
//     └ └ ,═Σ═ ╙,▄▄██████████▀▀' ⌐^ , ' ▄ⁿ▄∞ ╜  ,∞▀▀▄▄███████████████████████████████    //
//                                                                                        //
//    ╛,═"-∞ ▀ç▄██████████▀▀" `  . ╙    ¬ⁿ▄▀-,▄P▀▄▄██████████████████████████████████▀    //
//                                                                                        //
//    ⌐ ` ╗▄██████████▀▀',  ¬   \ ` ═▄▀  ,▄Æ▓Z▄██████████████████████████████████▀⌐'.     //
//                                                                                        //
//    ;▄██████████▀▀^    └▀▄'     . " ▄Æ▀▌▄██████████████████████████████████▀<`  ▄═ '    //
//                                                                                        //
//    ████████▀▀^  ▐"└ ▐▌   ¬═¬   ▄▀▌▐▄█████████████████████████████████▀▀^  ,  .  O^     //
//                                                                                        //
//    ████▀▀    /",   ,  ▌  ▀ ▄═█J▄█████████████████████████████████▀▀  ▀\   ▌   ', ,Ç    //
//                                                                                        //
//    █▀─"▄  ▀ ,   ╕ '   ,▄ⁿ▀▐▄█████████████████████████████████▀▀'   ∞  J▌"  ▀    ' ²    //
//                                                                                        //
//      ▄  ⁿ    ⌐0   ,▄═▌▐▄██████████████████Ç██████████████▀▀" ∞     ▄    \   ═^`   ▄    //
//                                                                                        //
//       ╕   N ╙",▄4▀▌▄████████████████████████████████████  ▀7  '▄    ▀   ⌐ .⌐',⌐&▀▄"    //
//                                                                                        //
//        ▀  ,█P▌▄▄█████████████████████████████████████████▄▄Ç`   ",   ' ═`,═T▀,.ç▄Æ█    //
//                                                                                        //
//    ▀▀ ,▄$▌▄▄████████████████████████████████████████████████▄╚    *  ,═P^."▄▄B▓████    //
//                                                                                        //
//    ▄Φ▀▄██████████████████████████████████████████████████████▌Ç  .═▀S═^▄██▀████████    //
//                                                                                        //
//    ████████████████████████████████████████████████████████████▀C.⌐▄╤▓▓████████████    //
//                                                                                        //
//    ███████████████████████████████████████████████▀▀▀▀▀████████▌▄██████████████████    //
//                                                                                        //
//    ████████████████████████████████▀▀▀▀▀▀█▀█▀▀▀` ▄,  `" ▀████▌█████████████████████    //
//                                                                                        //
//    ███████████████████████████████▀    ▌▀▄████, ▀████▄▄▄∞▐█████████████████████████    //
//                                                                                        //
//    █████████████████████▌▌█████-    ▌▄▓▄███▀,,,▀█;▀▀█▀█████████████████████████████    //
//                                                                                        //
//    █████████████▀██████████████   █¢▄███▀▀▄⌐^"`-`⌐     '"═█████████████████████████    //
//                                                                                        //
//    ████████▀▀" ⌐ █████████████▌<█,▄██▀⌐"    ███▄▄▐▄██▌    ▐████████████████████▀▀▄     //
//                                                                                        //
//    ████▀▀'    ,  █████████████ ^"  ▌'       ▐███▀████U  ,██████████████████▀═`    ▀    //
//                                                                                        //
//    ▀▀   [ Å   .┘  ▌███████████▌   ▐▌         ╓▄██▄▄▄▄▄▄▄███████████████▀╛`             //
//                                                                                        //
//        .       .⌐.███████████▌  ,, V▄ .▄∞ⁿ"`-   ▄▀▄▄▀▀▄▄█▀▀███████▀▀^     ▄Æ▀▀▀ ▀▀▀    //
//                                                                                        //
//          ⌐,    S;⌐"██████████▌   ▐   ▀`       ╓▀,█▀,▄▀▀▄▄█▀▀▀"`▀▀+     ,█▀,▄███` ▄▀    //
//                                                                                        //
//     ,   ▌"     .pP1"█████████▌  ' ⌐▄          `ƒ ▄█▀ ▄▀▀           +   ▀ ▄▄▄▄▄▄^ .,    //
//                                                                                        //
//      \    ,⌐S▀⌐⌐ç▄Q▀█████████▌Z▄` ▀           " █",█▀               ▀         ▀═.▀╛    //
//                                                                                        //
//    ▄P ▐═F╜,═▄╦É▀▄█████████████,                ┘ █▀                  ▐         ▀       //
//                                                                                        //
//    ═P'¿ ▄▄▀▓██████████████████▄                ,▀                    ▐`        ▄▄█▀    //
//                                                                                        //
//    Ç▄▀▓▓███████████████████████      Γ ¬                             █  \  ▄▄▀▀▀`'     //
//                                                                                        //
//    ████████████████████████████▌     "ⁿ▀▀W                          ▄`▄▄█▀█' '  ═`     //
//                                                                                        //
//    ████████████████████████████▀$▐   ,⌐s7▀▀▀▄                     ,██▀▀'   '      Y    //
//                                                                                        //
//    █████████████████████████▀"▀▄▌ .∞"   ▐    `▀▄,              ,▄▀^          \ ╙▌,▄    //
//                                                                                        //
//    ████████████████████▀▀`     ▐⌐ ▐▐   ,▄▄▄▄▄^ⁿ▌ `██▄∞▄ww▄▄▄D▀`    '\    ¥,    . ▀     //
//                                                                                        //
//    ███████████████▀▀"     ╕   ▌ █╙  ████████▌   ▀, ²`▄▄▀▀▀    ▌  █⌐r▄     ▀     ' '    //
//                                                                                        //
//    ███████████▀▀' ,       ,⌐' ▄  █ ▌▐███████▌   ,▄█▀▀'         ═ⁿ▄█▀▄'▄                //
//                                                                                        //
//    ███████▀        \     `   ▐▄" ▐▄▐ ███████▄▄█▀▀` ▀▄            V`╘"▄▐▄       ,▄▄█    //
//                                                                                        //
//    ███▀'            '      ⁿ ⌐"⌐  █LL▐██████▀ ,▄▄    ▀     ╙,     `▐╧∞▀    ▄▄██████    //
//                                                                                        //
//    `        ¬▄        ╕    ^▀`    ▐⌐  ██████  ███▌    ╙▄           ⁿ  ,▄███████████    //
//                                                                                        //
//         "*  ╒          \       ▄▄█▀█     ███▄    ∞^",▀  ▀,        ▄▄███████████████    //
//                                                                                        //
//     .▐> , ' [       ..  '  ▄▄▀▀"  Ω█X └     `═."═,⌐"  .* ╙▄  ▄▄████████████████████    //
//                                                                                        //
//           'ç▄▄⌐     '",▄Æ▀█'   ⁿⁿ¬ ▐-' ' ⌐╥^^^^Γ``  ▌   ,▄█████████████████████████    //
//                                                                                        //
//            ▀-     ▄▄▀▀▀]   \  `  ▄ ▐   :¬"^─^^^,1⌂Æ▀███████████████████████████████    //
//                                                                                        //
//               ▄▄▀▀   F .═¬  ',   ▐█▐▀█▄^`"▀ⁿ*▌"▄███████████████████████████████████    //
//                                                                                        //
//          ,▄A▀▀`      ` .^     Y  ▀▀▀█═▄▐   ╔^██████████████████████████████████████    //
//                                                                                        //
//    \',▄▀▀▀   ▐ '═.    ▄.⌐"` `  ╘    █▌'      ▐█████████████████████████████████████    //
//                                                                                        //
//    ▀▀"  ╕    [   Ç▐      ." ▐-▌═"▄▄▄▌ '  '/-√▄█████████████████████████████████████    //
//                                                                                        //
//     ') J▐'   ═▐▀█▄      ─    ▄▄██████▄▌  ,'▀▀ ▓████████████████████████████████████    //
//                                                                                        //
//    █  ' ▀L      `        ▄▄██████████      ..,█████████████████████████████████████    //
//                                                                                        //
//    ⌐   ^ ╘\         ,▄██████████████▄▀▀█  ▀▄▄██████████████████████████████████████    //
//                                                                                        //
//    ▌    Ç  A    ▄▄██████████████████▌▌∞█▄    `¬███████████████████████████████▀▀═`     //
//                                                                                        //
//    ▌     Ç ▄▄████████████████████▀▌▄█╙▐▄   ╓ⁿ▀  ▀█████████████████████████▀▄Ç   ╗ ▄    //
//                                                                                        //
//    ▀∞ ,▄▄███████████████████████▄▄▄▄⌐    `     ^═÷▄█▀▀▀▀█████████████▀▀═` ▄ '▌   ▀     //
//                                                                                        //
//    ▄███████████████████████▀¬█           "K         ╩▄V▀   ▐▀███▀▀═"        ⌐ ╚▄ ,ⁿ    //
//                                                                                        //
//    ███████████████████▀█▀▐███▄   ,   ▐     ,▄▄▄ m           /Σ▀▌  ▀'A∞,▀"═.     ▀      //
//                                                                                        //
//    █████████████████ `██▌Å▓██ ▀  ⌠   '▌▄▀▐"  ▀▄.▓              ▀█"▀▄.    "S¥▄▄▄╤∞╙▄    //
//                                                                                        //
//    ███████████████▀    ▀████▌▀  ( L ¬┌▐▄ ▀    /▄▀     [J'   ▌"*  █^   ▀P▄Ç⌐▄═" ▄▄█▀    //
//                                                                                        //
//    ███████████████▄       `▀          ▀██Ç▀  ▄╒*      ╙██▄⌐,'▀    █▀▀7;▄═`,▄Æ▀▀'▄,▄    //
//                                                                                        //
//    ████████████████r  u"Σ     ▐7    ,. ,"▀à▌ █    ╔▄▄,▄█▌   µ    æ█▄ⁿ`▄▄▀▀▀`-r$ⁿ" ▄    //
//                                                                                        //
//    █████████████▌ ▀█ '╤▀▄    ▄J'▄^,▄▄▄█     ▀ ┌▀⌐╓▌ ,  ▀▄▄,¬` ▄D▄Å██▀▀` -▄L   ▄▄▀      //
//                                                                                        //
//    █████████████▌▄  ▀.   "    æ,Æ▀`▀▀ █▐▐     ▀▀ ▄▀ ▌ ' ,▀▄▀  ▐▄  ▐█   ▀▀,▄∞▀,,.▄-     //
//                                                                                        //
//    ██████████████       ▄   ╒`P     `═▐▐▌█∞    ╒▌▀,▀  ,Ç▐^═█   ▀█▀ⁿ▀▌,▄▀▀ ▌^ [ ▄▄▀▀    //
//                                                                                        //
//    █████████████.╛ ███  ▐   ▄▀ C▐=     ▀▄▄` "═▄▀,═  .▄█▌ ╤. ▀▄▄ ╒$▄ █ Ç╕α ,▄▄▀▀═`      //
//                                                                                        //
//    █████████████▀  ▀▀█' ▐ ╛4¬X  -=▐7≈       `` ▀    ▀▀▀      ▀▀  "` -▀=∞▀▀▀^    ▀▀²    //
//                                                                                        //
//                                                                                        //
////////////////////////////////////////////////////////////////////////////////////////////


contract DAA is ERC1155Creator {
    constructor() ERC1155Creator("Dark Abstract Art by Nev.", "DAA") {}
}