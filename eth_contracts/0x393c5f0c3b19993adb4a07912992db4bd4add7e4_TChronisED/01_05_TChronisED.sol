// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: TheoChron Editions
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                      //
//                                                                                                                                      //
//    [size=9px][font=monospace]│└i #│ "   (~'└"▐/"⌠Γ│∩"∞╚ , "                                                                          //
//    ``∩\"|(⌐     (,≥∩ │∩▄|.|∩,   '        "                                                                                           //
//    ∩└ ∩∩┌* / └   ('  ."  ,∩ `, ',""` /                                                                                               //
//     │,∩      ∩|    `    (     ╙    (╢▓▄    .,e▄▄▒##┐                                                                                 //
//     │'∩"┌∩└  `          ',∩(/   ╓╓▄▄x╫▒▒∩▄█▓█▀▌.║,(▒╓»,                                                                              //
//     |,-y#(|(  `        │,  ∩     ╓M#∩║▓█▒███▀#██▓▄▄"╙└                                                                               //
//    └∩"/"](∩,           ∩∩└'    "ª¼▄║▓▄  ▐█▌▒▒▒M,"▀▀▓▓                                                                                //
//    (|~└`  ,              ` .~*ß▓▓▓▄▄▀▓▓▓▓█▓▒Ñ╠╠Ç░MM ,╔,                                                                              //
//    ╓  "(  ∩(└(   ( ,╓╓▄m╖    ^*½#▒██▓`█▓█▀▀▒║╠║╠▒¼∩└∩ ▓                                                                              //
//        . │       #▓██▒██▓ ▀▒▒▓▒▓▓██▀▓▄,██▓╓▀▒V▒╔▒┤░┘)(▀              "╗ⁿ╓     ,╓..  ,,    .,    .╓▄x╖╗#                              //
//       |,,,(╓▄▄▄▄▒▒▓▒▒█████▄╙▄   ▄║█▓▀█ └██▒▒▀░║╢╙╙╚╙╙∩`                ╙ └▒M╙╙"╚╜╜╜║▀╙╙╙╙║╗▓▀▀▀╝██▓▓▒▒Ñ                              //
//    ▓▓▓▓▓▓█████▓█▓▓▓▒▓██████▌╙▒║▌╠╙"║▒▀▌ ██▀▓▓╙#▐▓▓▓▓▒▒ß     .,,       ╓ ╚ ╞*( | ""└╙"╠░╠Ö⌠╙ └│▒#║║╠Ñ▄▄æ                              //
//    ▓▒▒▓▒▒▒▓▓▒▓▓▓▓▓▒▓▓█▓█████,▀,▀(╘▀▓▓N▀b(█▄╢▒▓╫  ▀▒▒▀  ,x, ,          `  ,║▌             ∩ "╙"""                                     //
//    ▓▓▀▓▒▒▒▒▒▒▀▓▓▓▀▓▓▒▒▓██████ ▓M* (#╫M(▌ ██║╙█▌▀▌ ╓, ▄▓∩   └             ▐└█∞C/ "         , ⌐,        *                              //
//    ▒▒║▒▒║▒▒╙¼▒╢▀│,└╙▒▒║▓▓▓███ █M«Γ└╠▓▌ ▓ ██▒,╫░▒▀ ╠, ╙▒,               | ║M╜ ,#╙", ∩M#M¢    (Mm»*∞ ,                                 //
//    ∩"└ `║║Ñy╙╙╙M╡╔║▒▒▒▒██████∩╫MW║M▐▒▒(▓ ██▒▓▀▀,Q▓▀▒▓,  º"    ▒       , (█ ▒(└▓"   └∩⌠▒# *"`" «yxm∩                                  //
//         ┘│┤╙║▒░▒▒▓██▒████▓███∩╫▒*╢∩║▓▌(▌ ▓▓∩▒Ñ ║▀▒╣╝╝Ñ▒,#,           ,,,╠█ ▌ ,                                                       //
//     ╓y'"░╫▓▓▓▒▒▓█████████████ █▌▒▒╠╫▓▓W▌ ▒ ╓~▄ML '**WW⌐╓  ""          └ ⌠▌(    « ⌂╔ ╓                                                //
//    #╢╢##▒▒▒▒▓▓▓▒▓▓███████████ █∩▒▒╠▓█▒║▌(▌(▓▌║▌~«+         `.,"""     * ╢h╫,"▐▄▄╚╙▓▒#,                                               //
//    ▒╡╠╠║▒▒▒▒▒▒▓▓╫▒▓▀▓███████▌▐█#▒║║██░║∩▐▌ ██ ▒▄       ∩ (▓▓░┌,(      /(█┌▌1,╠╙▒▓▒╚▀▒QN                                              //
//    ▒▒╚╠╙{╙└'""│└│║╚╙╠▒▒▓▓███V█▌╙▒▒▒██▒█ ║█▒▀ ,║█▓▓Ö   #▒▓▓▓▒░.╓╓-    ((╫∩█w   /╙█▓▒▄╙▒░               ╓                              //
//    (╚╙╙     «∩"╚│yMwA╚▒▒███▀▐█░▒▒║▓█▀▓▌┌██▓▓▒░╫███▓▓▓▓▒╫▒█▒▓Q▄▒░)    (▒▀▓   │,⌐╖ ▀▒▓,║▒             ╓╓█                              //
//       ,   ,╠,╓#╢▒▄▒▒M╔▓███▀#▀▒▒▒▒▓▒▌║▀ ▌██▓▒▒▓▓╗▒▀▀▀▀█▓█▀▀▒╙ ║█▒¼   ╔╫▒▀      │└ √▌█▓╙▒ |         #▒▓█▓                              //
//     ⌠ "" "╙│╙"    ▀█████▀▄▓▒▓▓▓█▓▓╚║▀.▓▒ ▓▒▒▒▒░▐║▀▒▓▓▓▓▓▓▀╙  └║░4▒ⁿQ╜╙           `▀║█╜▒,        .▓██▓▓▀                              //
//    `      (*⌠      ∩"╙╙"" / v█▀▒▒▒▓╙╓▓▒║▒▀▓▒╢╠▐▄ └W╙╙▒▒▒▒W▀    ╛             .∩   #╢█░║Γ ,  ∩  #▓▒█▒"                                //
//    , ¡|   │  ⌐    (   (∩ (  ┌│╙▀"╓▄▓▒▓▓▌▒b█▓█▒▓▒▒,┌║m║▒▒██▓xm╓█          (  | ╙░ (╙▒█▒▐h      ┌▐█▒  ╖,╔                              //
//      "   │└||   .     ( │   ╔▒▒▓▓▓█▓▒▒▒Ñ▒▒`█▓█▓▒▒ÑÇ║▓║▓▒▀▀"y╓▌        `  ∩| W∩└╚ (╚║▓█╙∩      ▒╫█ ╔x▐ #                              //
//       `   ' |(My  (│  ∩∩ .╓▒▒▒║▒▓█████▒▓▓▓▌▀██▓▓▓▒▀▓█▓██▀▓╙║▀    ┌ ╓∩   M∩   (╔  ▐░▓██▒▒   │  ┤╫▌ ╙╓▄∞,                              //
//     ╓     `'⌐",∞`,|∩*" ╓#▒▒▓▓╠║╙▒▓██████▒▓█▄████▓╢▒▒▒▒▒▒#╚(▀       └ ∩(|∩( / φ"  ▐▒▓██▒▌  |   ╫▓▓▒#▓▌ |                              //
//      │     │(╚└  ╓╔#▓▓▓▓▒▓▒▒▓█▓▒▒╙▓▓▓███████▒▀████▓▒▓"""",`└ . (, ╚(╚«╚║w∩( |└░  ▐▒▓▓█▒▌ ( ( \`▀▄Ñ∩╠Mß╚                              //
//          1┘  ┌╔▒▒▒▒▒▒▒▒▒▒▒▒▒▓███▓▒▒▒▒█████████▓╢▒▒▄╔▓╠#▓▒╚(M╓,, ┌╔#▓▓███▓▓▒J▒    ║ ▒▓▓▒∩     (   ▓▓▀▒╔(                              //
//            #⌠║╢▒▒▒▓▓▓▓▓▓▒▓▒▓▓▓████▓▓▒▒▒███▒███████▓█▄▒▄▄▒▒║▒▒▓▓▒M║▀▓██▒▀█▒▒▒╠⌠∩  ║ █▓█▒p∩ (∩(( (∩╙▓▒╙╠▒                              //
//          (k#╢▒╠▒╢▒▓▓███████▓▓▓▓█▓██████▓▓▓▒▒└████▓M╙╠╠╢▒▓▓▓▓▒╙║││M∩╚╙╙░╙└║░∩     ▒ ▒██▌"(▐M∩│∩, ∩,╙▒▒╠╠                              //
//          ('∩∞╙╜█▓▓█▓▓▓▒▀▀████████████████▄▀▒M╙▀█▓▒░M ╙╚└∩╙Ñ   `└│╠ "'    └╙       ▐▒█╜╓╡⌐Γ ╙╚∩∩(  , ▀▓▄                              //
//         ("  k╛╙║██████▓▒▒▒▓▒▓▒▒▒▒▒▒║║▒▒▒╢▒ └∩  ╙╚╙           ,,  »                 ║  ▄Ñ, │╚ │░│  ,││ ▀                              //
//         │ \ ┌7m╠▒▒██████▓███▓█▓▓▒▒▒▒▒▒▒║░░║ │"    M    ,y╓#M║W│└«|                  U └  (⌠ ⌠∩)│((("∩,(                              //
//     ,,       *\║▒╫▒▒███████▓████▓▓▓▓▒█▓▒▒║╙N N └  '\(((M│┐╠╠││∩ └ Ç                  ░ )(⌐ #('∩( 7∩∩({∩                              //
//    ▒¼mM       ╙│▒║║▒▒▒▒▓▓▀▒▒▓▒▒▒▓▄Å└╙└╙W│/ ║ └(╓    ⌠#╛∩(,╚#∩└∩|  ,                   ¼`  ,`   [∩╙/(││/                              //
//    ▒║▒MΓ,,|"" '(╠║▒▒▒▒▒▒▒▒▒║▒▒╢║▒║╠#║░∩∩∩,*y"▓M╠╞  └ "V,m▒▒╡│├╔,╓∩              .⌐    ¥░       ( # │╠W∩                              //
//    █▒▒▒▒▒W▒  \√╓/╠║╢▒▒▓▓▒▒▒╢║▒▒║W╙╚╙╙⌠└#M|∩ " ║▒ V    ╓▒╢▓▒╢╠M∩ ▒|              ¢,   +y(        (  7╠░]                              //
//    ╢█▓▓▓▓▒▓║W └└║╡╠╠╠║▒║╠╠║╢║▒▒╠∩│* y '╙╠╙      k,    ║║∩│╚╚⌠┼{#                └∩,«*M╙( ,      ,  ⌠╚╚                               //
//    ╫▒▒▓▓▓▓▓▓▒▒╓⌐ "╚░║░╛╔└└W▒▒╚│║░│,(Ök╓ '╚\∩  ( ▒`     ╠W╓∩'∩║║▒,     ┌          |  (∩╓│∩║M (   ( ║M#╚╔                              //
//    ▒▒▒▒▒▓▓███▒▒║░∩.║└╙░╙M╙▒╢M│Wk║M▒▒(]  y⌂┘╚√, #╢∩      ╚╠║▒▒░▒╠Q╓≈╖m`          (∩Γ∩/, , #⌠y∩ | `#M#║▒╠                              //
//    ▒▒▒▓▓▒▓▓███▓▒▒M|∞└"┘╠M|║╠╙╔|╠Ç▒▒╚│┌╓,╙╠#▄▄#▒▌(╖╓╓,   (▒▒▓▀▀▒Ñ║▄∩╙▓▌{▒ ╓      ▐╡W│k,┘∩ ╙ÖM∩ └µ#╔░╚║╩╠                              //
//    ██▒▒▓▓▒▓████▓▒▒▒▒MQ#│║m║⌐*`y│╔╠▒▒∩#░╢▓▓██▀Ñ▓,▓▌ Ç ╓╔,╘▄╠╙▓ ▐░ █▌ █▌ ▌ ╛      ▒╠▒╠║#╚ m▒╠|   └M╠Ñ(╠▒╓                              //
//    ╢▒▒▒▒▒▒▒▒▒▓▒▓▓▓▒▒║▀gQ#╙░\(∩(▒-WÑ╙╠╠▒▓██▓▀▓▓▓╠▀▒▒(▓█▓▓,║▓▄║▒(▒ ▓▌╓▓▌╫▓#Qt    (╠╚MÑ╚▌∩{▒▒▒∩||, ▒╠ ▒╜▒▓                              //
//    ▒▒▒▒▒▓▓▒▒▒▒▒▒▒▒▒▒▒░░▐║╓|╙k▄Ñ,╙#░Ç▒╢▓▓█▒▀▓▌▀║▓(█▓/█████▓███▓▓▒▓▒▒▒▓▓▒▒░▒     ╢∩WW╙▒ .▒║▒▒▒M⌠∩,║Q╔▒▓██                              //
//    ▒▓▒▒▒▒▓╢▓▒▒▒▒▒║║▒▒▒▒║░╢░MM∩║Mk (┘│║▓▓█▓▒▄▒▐█████████████████▓▒▒▒▒▒▒▒▒░╔#"  │╔∩└∩(▌ ⌠╠║▒▒▒▒▒M╔▒∩║║█▓▒                              //
//                                                                                                                                      //
//                                                                                                                                      //
//    [/font][/size]                                                                                                                    //
//                                                                                                                                      //
//                                                                                                                                      //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract TChronisED is ERC1155Creator {
    constructor() ERC1155Creator("TheoChron Editions", "TChronisED") {}
}