// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Pepe Art Gallery
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                                              //
//                                                                                                                                                              //
//    MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWWW    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXXKKKKKKKXXNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKOxdocccccccccccccccccccccccloxk0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKkoc:cc:codxkO0KNNWNXNX0XNXNX0OOOkxolcccccox0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXkoc::coxOKKK0XWXxxONMMMNxxd:dkOW0ox0NMMMWXXK0kdc:::lxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo:::okKXK0KWWxlodXKld0XWMMMOlxKooXWdckKWMMMWkoONWXKNXOdc::lxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXxc;:lkKX00NXolOXW0lkXWW0k0XWMMMWXNMXXMWKO0XWMMMNxxWMOldx0MWWN0dc;:o0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxc;:dKWMMXdlokW0lx0XWXNMMMMMMMMMMMMMMMMMMMMMMMMMMMWXNMXxkdoKXxONXNWXkl;:o0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOl;:dKWXXWMMWOlkWMWXXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWWKKWxd0xxNX0XWNkc;:xXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMNk:,l0WW0kkdkNMMWXNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKOkOXXxokKMMWXd:;oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMNx;;dXMN0X0ldkd0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOxdOWW0kXMNk:,l0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMNx;;xNMMMW0xOK0XMMMMMMMMMMMMMMMWNK0OkkkkkkkOO0XNWMMMMMMMWXKK00KKXNWMMMMMMMMWXKWNOdx0WMMWOc,lKMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMWk;,xNMMMMMMMN0NMMMMMMMMMMMMMMN0kxxxxkkkOOOOkkxxxxxxk0XKOkOOkOOOOkkkOkOKWMMMMMMMMX0XMMMMMMMWO:,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMKc'lXMMMMMMMMMMMMMMMMMMMMMMMMNkodk0000000KXNWWWWWWNNKOkdcoKWMMMMMMMMMWX0kxONMMMMMMMMMMMMMMMMMMNk;;kWMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMWk,;OWMMMMMMMMMMMMMMMMMMMMMMMWOooO000KXNWMMMMMMMWXKKKKKKXNKkxONMMNK0OOOOOO0kdokNMMMMMMMMMMMMMMMMMMXl'lXMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMXl'oXMMMMMMMMMMMMMMMMMMMMMMMMNdlxOOKNMMMMMMMWKOOOOOOOOOOOOOOOkxdxkkkO0KKKK00OOx:ckXNWWMMMMMMMMMMMMMMWk,;OWMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMM0;'kWMMMMMMMMMMMMMMMMMMMMMWKkkddkkONMMMMMMWKkkk0XWMMMMMMWNKK0xdko;o00XWMMWX0OOOOkddkOOOkkOKNMMMMMMMMMMMK:'xWMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMO,,0MMMMMMMMMMMMMMMMMMMMMMXdoxO000XWMMMMMMNOx0WMMMMWX0OkkOOOOO000K000OOkkKN00KXNNNXXXXXXKK0OxOWMMMMMMMMMMNl.oNMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMO';KMMMMMMMMMMMMMMMMMMMMMMKod0000KNMMMMMMMMXXWMWX0OkkkO00KK0OOkkkkkOOOO0Olo0OkOOOkkxddoodxkkkllXMMMMMMMMMMMNo.oNMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMO';KMMMMMMMMMMMMMMMMMMMMMMXoo0000KNMMMMMMMMMXOOOOkOOOOkkOkkxdolloooooooooddl:cllcc:;,'.,dOOkxddldNMMMMMMMMMMMWd.oNMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMM0,;KMMMMMMMMMMMMMMMMMMMMMNOodO000XWMMMMMMMMMWKOOOkkkkxdoolc:;'.. 'xKKK00Okkkd'      .';..;KMWN0kldNMMMMMMMMMMMMNo.dWMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMX;'0MMMMMMMMMMMMMMMMMMMNOxddk000KNMMMMMMMMMMMWOclllcc:;..    .:o:. 'kWMMMMMMNx,.......;do' ;KMMMMXdkWMMMMMMMMMMMMNc.kMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMWl.xWMMMMMMMMMMMMMMMMMWOodk0000KXWMMMMMMMMMMMMMNKx:.   ........,cc.  '0MMMMMMMWk............ lWMMMMOoKMMMMMMMMMMMMMK,,0MMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMk.cNMMMMMMMMMMMMMMMMMNxlk00000KNMMMMMMMMMMMMMMMMMMN0xl:,...... .,l;.  lWMMMMWX0d;;;,''..,oo,.'x000OxOWMMMMMMMMMMMMMMk.cNMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMX;'0MMMMMMMMMMMMMMMMMMOlkK00000XMMMMMMMMMMMMMMMMMMMMMMMWXKOkxddook0kl:;lkOOO0OOdckWNNXXKK000OOOOOocONMMMMMMMMMMMMMMMMNc.kMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMx.oWMMMMMMMMMMMMMMMMMWxo000000XWMMMMMMMMMMMMMMMMWKKWMMWXKKKKXXXXNNNXXKKK0000OOkkKWMNOOKKKKKKXX0OOkKWMMMMMMMMMMMMMMMMMMO':NMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMN:'0MMMMMMMMMMMMMMMMMMWxo00000KNMMMMMMMMMMMMMMWNXNXNMMMMMWK0KKKKKKKKKKKK0OddO0KNMMMMMNKXNWWWWXdoONMMMMMMMMMMMMMMMMMMMMMWc.OMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMO.cWMMMMMMMMMMMMMMMMMMMklO0000XWMMMMMMMMMMMNKKKKXXWMMMMMMWXKKKKKKKKKKKKKK0KNMMMMMMMMMMMWWWMMMWKOOk0WMMMMMMMMMMMMMMMMMMMMx.lWMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMd.dMMMMMMMMMMMMMMMMMMMWxlO000KNMMMMMMMMMMWWXXNNK000KXWMMMMMMMMMWNNNXXNNWMMMMMMMMMMMMMMMMMMMMMMMMWKxxXMMMMMMMMMMMMMMMMMMMK,;XMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMWc.OMMMMMMMMMMMMMMMMMMM0ld0000XWMMMMMMMMMX0NMXxdddddddxxOXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOdKMMMMMMMMMMMMMMMMMMN:'0MMMMMMMMMMMMM    //
//    MMMWMMMMMMMMN:,KMMMMMMMMMMMMMMMMMWOld0000KNMMMMMMMMMMXOXMklOK0kxO00kddxkOKNWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWxxWMMMMMMMMMMMMMMMMMMl.kMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMX;;XMMMMMMMMMMMMMMMMWklk00000XWMMMMMMMMMMW0OWKod00kdoodk00OxdddxxkkkO0KXXNWMMMMMMMMMMMMMMMMMMMMMMMWX0lckkKWMMMMMMMMMMMMMMMo.xMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMK,;XMMMMMMMMMMMMMMMMKoxK0000KNMMMMMMMMMMMMWKXWKdok000kdoodxO0KK00OkxxdddxxxxkkkkkkkkkkkkOOO0000OkkxxdxkkloXMMMMMMMMMMMMMMMo.xMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMX;;XMMMMMMMMMMMMMMMMOlkK0000KNMMMMMMMMMMMMMMMMMWOdodO000OxooooddxkO00KKKK000OOOkkkkkkkxxxxxdddxxxO0K0kxdd0WMMMMMMMMMMMMMMMo.xMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMN:,KMMMMMMMMMMMMMMMMKod00000KNMMMMMMMMMMMMMMMMMMMNOdodxO0000OkdddoodddddddxxxxxkkOOOO0000000OOkkxddoclx0NMMMMMMMMMMMMMMMMMl.kMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMWc.OMMMMMMMMMMMMMMMMWOok00000XWMMMMMMMMMMMMMMMMMMMWN0xddodxO00000000OkxxxxxddddddddddddddddddddddxkOxokNMMMMMMMMMMMMMMMMMN:'0MMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMd.dMMMMMMMMMMMMMMMMMWOdO00000XWMMMMMMMMMMMMMMMMMMMMWNK0OxdodooddxkO000000000KKKKK000000000000KKK0000ooNMMMMMMMMMMMMMMMMMK,;XMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMO.cWMMMMMMMMMMMMMMMMMW0okK000KXWMMMMMMMMMMMMMMMMMMMMMWNXK00OkxxddodddddddddddddddddddddddxdddddoodxxkXMMMMMMMMMMMMMMMMMMx.oWMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMN:'0MMMMMMMMMMMMMMMMMMW0odOK000XNMMMMMMMMMMMMMMMMMMMMMMMWNXXKK0000000OOOOOOOOOkkkxxxxxxxddddxkOllKNWMMMMMMMMMMMMMMMMMMMWc.OMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMx.oWMMMMMMMMMMMMMMMMMMMXkddxO00KXNWMMMMMMMMMMMMMMMMMMMMMMMMWWWWNNNNNNNNNNNNNNNNNNNXXXKKXXXXX0kkXMMMMMMMMMMMMMMMMMMMMMMO':NMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMX;'0MMMMMMMMMMMMMMMMMMMMMWKkkkkkO0KXNWMMMMWXKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKOOOOOKWMMMMMMMMMMMMMMMMMMMMMMNc.kMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMk.cNMMMMMMMMMMMMMMMMMMMMMMMMXkoloooxOKNWWMWXKKKXWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXkx0XWMMMMMMMMMMMMMMMMMMMMMMMMMMk.cNMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMWl.xWMMMMMMMMMMMMMMMMMMMMWKOxdkOkxdoooodxOXNMMWWWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx:dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMK,,0MMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMX;'0MMMMMMMMMMMMMMMMMMXkddxOOOOOOOOOOkdoooloxkO0KNWMMMMMMMMMMMMMMMMMMMMMMMMMMMN0kxc;lxXMMMMMMMMMMMMMMMMMMMMMMMMMMNc.kMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMM0,;KMMMMMMMMMMMMMMW0dclxOOOOOOOOOOOOOOOOOxolccoxkOOkOO0KXNNWWMMMMMMMMMMWNX0OOkxk0xcddlkXMMMMMMMMMMMMMMMMMMMMMMMNo.dWMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMO';KMMMMMMMMMMMMKdclodkOOOOOOOOOOOOOOOOOOOOkdododxkxxxkkkkkOOOOOOkOOOxc;,,ckKK000ooOkc;dXWMMMMMMMMMMMMMMMMMMMWd.oNMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMO';KMMMMMMMMMMO:;ccccooooodxkOOOOOOOOOOOOOOOOkdcclxkkOOOOOOOOOOO00Kkc'....,lkKKKklxOx:,lxXMMMMMMMMMMMMMMMMMNo.oNMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMO,,0MMMMMMWXkc:lloodkkkxdoooooxOOOOOOOOOOOOOOOOxoox0K0000000000KKk:'''.....'ckKKdokOkccooxXMMMMMMMMMMMMMMNl.oNMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMM0;'kWMMWKxlloddddxkOOOOOOOOkdolokOOOOOOOOOOOOOOOkxddkKXKKKKKKKK0dddc,'....'lxxO0odOOkccxdoONMMMMMMMMMMMK:'xWMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMXl'oXNxllodddddkOOOxooodxOOOOkoloxOOOOOOOOOOOOOOOOxolldOKKKKKXOdkX0kl,...;OKOxxdlxOOx:lOkoo0WMMMMMMMWk,;OWMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMWk,,:codddddxkOOOOkxxdooooxOOOkdlokOOOOOOOOOOOOOOOOkdl:lkKKKXOoOXKKKOc'.,d000Od:lOOOd:oOOdlkNMMMMMXl'lXMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMKc.'lddddxkOOOOOOOOOOOkdolokOOkocdkOOOOOOOOOOOOOOOOOxc;ok0XOoOXKKKXO:'.'lO00KklxOOOo:xOOkldXMMNk;;kWMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMWk;.;odxkOOOOOOOOOOOOOOOxoldOOOxllxOOOOOOOOOOOOOOOOOOdlcokdoOXKKKKKo,..':kKKKdoOOOOlckOOkloKO:,dXMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMNx,.:xOOOOOOOOOOOOOOOOOOxllxOOOdcokOOOOOOOOOOOOOOOOOOdllokKKKKKKKx,....;dKXkoxOOOk:lOOOk:',lKMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMNx;'cxOOOOOOOOOOOOOOOOOOdcoOOOxllxOOOOOOOOOOOOOOOOOOkdox0KKKKKXO:.....'l00ldOOOOd:dOo,'l0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx:';okOOOOOOOOOOOOOOOOxllkOOkocdOOOOOOOOOOOOOOOOOOOkookKKKKX0c'.....':xooOOOOOc',,oKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWOl,,cdOOOOOOOOOOOOOOOklcxOOOdcokOOOOOOOOOOOOOOOOOOOxodOKKKKo'.......,,cOOkl;':xXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXxc,,cdOOOOOOOOOOOOOOdcdOOOkllkOOOOOOOOOOOOOOOOOOOOdlx0KKd,.........,c;,;o0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXxc;,:lxOOOOOOOOOOOxclkOOkc:xOOOOOOOOOOOOOOOOOOOOkolkXk;..........:o0WMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNOo:;,:lx0KKKK00KOccOKK0l:xKKKKKKKKKKKKKKKKKKKK0xcod,,,....,cxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWXkoc::coxOKNWMNdoKWMWxcOWMMMMMMMMWWWWMMMMMMWXx'..';:lxKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKkoc:ccccoo;,xKXXxckWWWWWWWWNXK0Okxolcccccox0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNKOxdoc::cccc,,ccccccccccccccloxk0XWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWWNXXKKKKKKKXXNNWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//    MMMWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM    //
//                                                                                                                                                              //
//                                                                                                                                                              //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract PAG is ERC1155Creator {
    constructor() ERC1155Creator("Pepe Art Gallery", "PAG") {}
}