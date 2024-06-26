// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Digital Dankness
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//      __                             __                                           __             __                                                           //
//    |/  | /      / /         /     |/  |           /                            |/  |           /              /               |                              //
//    |   |   ___   (___  ___ (      |   | ___  ___ (     ___  ___  ___  ___      |___|          (     ___  ___ (___  ___        | ___  ___  ___                //
//    |   )| |   )| |    |   )|      |   )|   )|   )|___)|   )|___)|___ |___      |   )\   )     |   )|   )|___ |    |   )       )|   )|___)|   )               //
//    |__/ | |__/ | |__  |__/||      |__/ |__/||  / | \  |  / |__   __/  __/      |__/  \_/      |__/ |__/  __/ |__  |__/|     _/ |__/ |__  |__/                //
//           __/                                                                         /                                        |         __/                 //
//                                                                                                                                                              //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNNNNXXXXXXXXXXXXXXXNNNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNXKK0OOOkkkkxxxxxxxxxxxxxxxxxkkkOO000KXNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNNKK0OkxxxxxxkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxxxkkOO0KNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNK0OkxxxxxkkkkkkkkkkOkOOOOOOOOOOOOOOOOOOOOOkkkkkkkkkxxxxkkO0KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWXK0kkxxxkkkkkkkkOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkxxxkOKXWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNX0kxxxxkkkkkOOOOOOOOO000000KKKKKXXXXXXXXXXXXXKKKKK0000OOOOOOOOkkkkkkkxxxxO0KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkxxxkkkkkOOOOOOO0000KKXXXNNNNNNNWWWWWWWWWWWWWNNNNNNNNXXXKK0000OOOOOOOkkkkkxxxkOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNKOkxxkkkkkkOOOOOO00KKXXNNNNWWNNNNWNNNNNNNNNNNNNNNNNNNNWWNWWNNNNNNXXKK000OOOOOOkkkkkxxkOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kxxkkkkkOOOOOO00KXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXKK00OOOOOOkkkkkxxk0XWWWMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMWNKOxxkkkkkOOOOO00KKXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXKK00OOOOOOkkkxxxOKNMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMWNKkxxkkkkkOOO000KXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXKK00OOOOOkkkkxxkKNWMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMWN0kxxkkkkOOOOO0KKXXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXKK0OOOOOkkkkxxk0NMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMWNKkxxkkkOOOOO000KXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXKK00OOOOOkkkxxkKNWMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMWKkxxkkkOOOOOO0KKXNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNXXK00OOOOOkkkxxOXWMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMWN0xxkkkkOOOO00KKXXNNXXNNXXXXXXXNNNNNNNNNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNNNNNNNNNXXXXXXXXXXXXXXXXXXXXXKK00OOOOOkkkxx0NWMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMWKkxxkkOOOOOO00KXXXXNXXXXXXXXXXXXXXXNXXXXNXXNXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXNXNXXXXXXXXXXXXXXXXXXXXXXXK000OOOOkkkxxkKWMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMWXOxxkkkOOOO000KKXXXXXXXXXXXXXXXXXXXXXXX0xxkKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKkxk0XXXXXXXXXXXXXXXXXXXXXXXXK000OOOOkkkxxONMMMMMMMMMMMMM    //
//    MMMMMMMMMMMWXkxkkkkOOOO000KXXXXXXXXXXXXXXXXXXXXXXXOl,''';dKXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXKd:''',lOXXXXXXXXXXXXXXXXXXXXXXXK000OOOOOkkxxkXWMMMMMMMMMMM    //
//    MMMMMMMMMMWKkxkkkkOOO0000KKXXXXXXXXXXXXXXXXXXXXXXk;'''''''l0XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX0l''''''';kXXXXXXXXXXXXXXXXXXXXXXXK0000OOOOkkkxkKWMMMMMMMMMM    //
//    MMMMMMMMMW0xxkkkkOOO000KKKXXXXXXXXXXXXXXXXXXXXXXk:''',,''''lKXXXXXXXXXXXXXXXXXXXXXXXXXXXXKl'''',,,,';kXXXXXXXXXXXXXXXXXXXXXXXKK000OOOOkkkxx0WMMMMMMMMM    //
//    MMMMMMMMN0xxkkkkOOO0000KXXXXXXXXXXXXXXXXXXXXXKX0c',,,,,,,,',xXXXXXXXXXXXXXXXXXXXXXXXXXXXXx,',,,,,,,''c0XXXXXXXXXXXXXXXXXXXXXXXK00000OOOkkkxx0WMMMMMMMM    //
//    MMMMMMMW0xxkkkOOOO0000KKXXXXXXXXKKKKKKKKKKKXKXXx,',,,;,,,,,'c0XKKKKKKKKKKKKKKKKKKKXXKKXX0c',,,,,,,,,',xKXKKKKKKKKKKKKKKKKKKXXXKK00000OOOkkkxx0WMMMMMMM    //
//    MMMMWMWKxxkkkOOO00000KKKKKKKKKKKKKKKKKKKKKKKKX0l',,;;;;;,;,,;xKKKKKKKKKKKKKKKKKKKKKKKKKXx,',;;;;;;,,,,l0XKKKKKKKKKKKKKKKKKKKKKKKK00000OOOkkkxx0WMMMMMM    //
//    MMMMMWKkxkkkOOO000000KKKKKKKKKKKKKKKKKKKKKKKKXk:,,;;;;;;;;;,,lKKKKKKKKKKKKKKKKKKKKKKKKKKo,,,;;;;;;;;;,:kXKKKKKKKKKKKKKKKKKKKKKKKKK00000OOOkkkxxKWMMMMM    //
//    MMMMMXkxkkkOOO000000KKKKKKKKKKKKKKKKKKKKKKKKKXx;,,;;;:;;;;;;'c0KKKKKKKKKKKKKKKKKKKKKKKK0c';;;;;::;;;;,;xKKKKKKKKKKKKKKKKKKKKKKKKKK000000OOOkkkxkXMMMMM    //
//    MMMMNOxxkkOOOO000000KKKKKKKKKKKKKKKKKKKKKKKKKKd,,;;;:::::;;;':OKKKKKKKKKKKKKKKKKKKKKKKKO:,;;;::::;:;;,,dKKKKKKKKKKKKKKKKKKKKKKKKKK0000000OOOkkkxONMMMM    //
//    MMMWKxxkkkOOO00000000KKKKKKKKKKKKKKKKKKKKKKKKKd,,;;;:::::;;;,:kK0KKKKKKKKKKKKKKKKKKKKKKk:,;;;::::::;;,,d0KKKKKKKKKKKKKKKKKKKKKKKK00000000OOOkkkxx0WMMM    //
//    MWWNkxkkkOOO000000000KK0000000000000000KK0K00Kd,,;;;:::::;;;,:kK000KKKK0000000000KKKK0Kk:,;;;::::::;;,,d0000000000000000000000000000000000OOOkkkxkXMMM    //
//    WWW0xxkkOOOO0000000000KKKKKKKKKKKK00000K00K0KKd,,;;;:::::;;;,:kK0000000000000000000000KO:,;;;:::::;;;,;dKKKKKKKKKKKKK00K00000000KK000000000OOOkkxx0WMM    //
//    MMXkxkkkOOO00000000000KK0000000K0000000000000Kx;,;;;;;;:;;;;'cOK0000000000000000000000KOc';;;;;::;;;;,;xKKKKKKKKK00000000000000000000000000OOOkkkdkNMM    //
//    MWKxxkkkOOO000000000000KKKKKKKK000000000000000k:,,;;;;;;;;;,,l00000000000000000000000000o,,;;;;;;;;;,,:kK0000000000000000000000000000000000OOOOkkxxKWM    //
//    MNOxxkkOOO0000000000000000000000000000000000000l,,,;;;;;;;,';d0000000000000000000000000Kd;,,,,;;;;;,,,lO000000000000000000000000000000000000OOOkkkxONM    //
//    MXkxkkkOOO0000000000000000000000000000000000000d,,,,,,;,,,,'cO00000000000000000000000000kc',,,,,,,,,,;d0000000000000000000000000000000000000OOOkkkxkXM    //
//    MXkxkkkOOO0000000000000000000000000000000000000Oc',,,,,,,,',d0000000000000000000000000000d,',,,,,,,,'cO00000000000000000000000000000000000000OOOkkxxXM    //
//    MKxxkkkOOO00000000000000000000000000000000000000k:',,,,,,''lO00000000000000000000000000000l,,',,'',,;x000000000000000000000000000000000000000OOOkkxxKW    //
//    W0xkkkkOO0000000000000000000000000000000000000000x;'',''''lO000000000000000000000000000000Ol''',''';x0000000000000000000000000000000000000000OOOkkxx0W    //
//    W0xxkkOOO00000000000000000000000000000000000000000kl,'',;oO00000000000000000000000000000000Od;,'',lk00000000000000000000000000000000000000000OOOkkxx0W    //
//    W0xxkkOOO0000000000000000000000000000000000000000000kxdxO000000000000000000000000000000000000Oxdxk0000000000000000000000000000000000000000000OOOkkxx0W    //
//    W0xxkkOOO000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000OOOkkxx0W    //
//    W0xxkkOOO000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000OOOkkxx0W    //
//    MKxxkkkOOO0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000OOOkkkxxKM    //
//    MXkxkkkOOO0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000OOOkkkxxXM    //
//    MNOxkkkOOO0000000000000000kl:::cloxkOO00000000000000000000000000000000000000000000000000000000000000000000000000Okxolcccclx00000000000000000OOOkkkxONM    //
//    MW0xxkkOOO0000000000000000c........',;:cllodxkkOO0000000000000000000000000000000000000000000000000000OOkxdollc:;,.........,x0000000000000000OOOkkxx0WM    //
//    MMXxxkkkOOO000000000000000c...................',;;:ccllooddxxxkkkkkOOOOOOOOOOOOOOkkkkkkxxdddoollcc::;,''..................,x000000000000000OOOOkkxxXMM    //
//    MMNOdkkkOOO000000000000000o......,,;,'........................''''',,,,,,,,,,,,,,'''''...........................',,'.....;O000000000000000OOOkkkdOWMM    //
//    MMMXkxkkkOOO00000000000000x,...,okOOkxxddollc::;;,'''.................................................',,;:cclodxxkOx:....l000000000000000OOOkkkxxKMMM    //
//    MMMWOxxkkkOO00000000000000Ol'..;xOOO000000KKKKK000OOOkkxxdddoooollllccccccc:::::::::ccccclllloooddxxxkOO000KK0000OOOk:''.;k000000000000000OOOkkxxOWMMM    //
//    MMMMXkxxkkOOO00000000000000x;''':xOO0000000KKKKKKKXXXXXXNNNNNNNWWWWWWWWWNNNNNNNNNNNNNNNNNNNNNNXXXXXXKKKKKKKK00000OOd;''',o000000000000000OOOkkkxkXMMMM    //
//    MMMMWKxxkkkOOO0000000000000Oo;,,',lkO000000KKKKKXXXXXXXXXNNNNNNWWWWWWWWMMMMMMMWWWWWWWNNNNNNNNXXXXXXXXKKKKKK00000Od:..,,,lO00000000000000OOOkkkxx0WMMMM    //
//    MMMMMNOxxkkOOOO0000000000000Ol;;;,.';cdk00KKKKKKKXXXXXXXXNNNNNNWWWWWWWWMMMMMMMWWWWWWWNNNNNNNNXXXXXXXXKKKKKKK0koc,..',;;lk00000000000000OOOkkkxx0NMMMMM    //
//    MMMMMMNOxxkkOOO00000000000000kl:::;,'...,:ldxO0KKXXXXXXXXXXNNNNWWWWWWWWWWWWWWWWWWWWWNNNNNNNNNXXXXXXXXK0Okdl:,...',;:::lk00000000000000OOOOOkxxONMMMMMM    //
//    MMMMMMMXkxxkkkOOO0000000000000ko::cc::;,'.....,;:codxkO0KXXNNNNNWWWWWWWWWWWWWWWWWWWWWNNNNNXKK0Okxdolc;,'....',;::ccccok00000000000000OOOkkkxdkXWMMMMMM    //
//    MMMMMMMMXkxxkkOOOO0000000000000Odlclccccccc:;;,'.......',,;;::cccllooooooollllllllllcc:::;;,''.......',,;;:ccccccccldO000000000000000OOOkkxxkXWMMMMMMM    //
//    MMMMMMMMWXkxkkkOOOO0000000000000Oxollllllllllllllccc:::;;,,,,''.....................''''',,,;;;::ccclllllllllllllloxO00000000000000OOOOkkxdkXWMMMMMMMM    //
//    MMMMMMMMMWXOxxkkOOOOO0000000000000kdollllolllllllllllloollllllllllllllllllllllllllllllllllllllllllllllllllllllllodk00000000000000OOOOOkkxxONWMMMMMMMMM    //
//    MMMMMMMMMMWN0xxkkkOOOO00000000000000kdlllllllolllllllllllllllllllllllllllllllllllllllllllllllllllllllllllloollooxO000000000000000OOOkkkxxONMMMMMMMMMMM    //
//    MMMMMMMMMMMMWKkxxkkkOOO00000000000000OkdollllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllodO000000000000000OOOkkkxxxKWMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMWXOxxkkkOOOO000000000000000kdoolllllllllllllllllllllllllllllllllllllllllllllllllllllllllllllloodk000000000000000OOOOOkkxxkXWMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMN0kxxkkkOOOO000000000000000OxoollolllllllllllllllllllllllllllllllllllllllllllllllllllllllodxO000000000000000OOOOkkkxxk0NWMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMWXOxxkkkOOOO0000000000000000OkdoolllllllllllllllllllllllllllllllllllllllllllllloollllodxO00000000000000000OOOOkkkxxOXWMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMWKkxxkkkOOOOO0000000000000000OkdolllllllllllllllllllllllllllllllllllllllllllllloodxO000000000000000000OOOkkkkxxkKWMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMN0kxxkkkOOOOO00000000000000000OkxdooloollllllllllllllllllllllllllllllloollodxkO000000000000000000OOOOOkkkxxk0NWMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMWN0kxxkkkkOOOOO000000000000000000OkxdoooollllllllllllllllllllllllllooddxkO00000000000000000000OOOOOkkkxxk0NWMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMNKkxxkkkkOOOOO000000000000000000000OkkxxddoooooolllllloooooddxxkkO0000000000000000000000OOOOkkkkxxxkKNWMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMWXOxxxkkkOOOOOOO0000000000000000000000000OOOOkkkkkkkOOOO000000000000000000000000000OOOOOkkkkxxxOKNMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMWN0kxxxkkkkOOOOOO000000000000000000000000000000000000000000000000000000000000OOOOOOkkkkxxxk0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kxxxkkkkOOOOOOOO000000000000000000000000000000000000000000000000000OOOOOOOkkkkxxkk0XWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0OxxxxkkkkkOOOOOOOO00000000000000000000000000000000000000000OOOOOOOOkkkkxxxkO0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNK0kxxxxkkkkkOOOOOOOOOOOOO000000000000000000000000OOOOOOOOOOOkkkkkxxxxkOKNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWXK0kkxxxkkkkkkkkkOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOkkkkkkkkxxxkk0KXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OkkxxxxkkkkkkkkkkkkkkkOOOOOOOOkkkkkkkkkkkkkxxxxxkO0KXNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXKK0OOkxxxxxxxxxxkkkkkkkkkkkkxxxxxxxxxkkOO0KKXNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWNXXKK0000OOOOOOOOOOOOO00000KKXXNWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWMMMMMMMMMMMWWWWWWWWWWWWMMMMMMMMMMMWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract DD is ERC721Creator {
    constructor() ERC721Creator("Digital Dankness", "DD") {}
}