// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Memories Of Japan
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#+-.   .-#@@%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%-    .:    :%%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%%##*##%%@@%%%%%%%%%%%%%..:%@%*+--#**#%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%#+::.     -*%@@%%%%%%%%@+.:*@@%*%##%*%*%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%@@*-:*@%=-.-: .:-: -#%%%%%%%@%+==##-**%##%=%*%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%@*:[email protected]%*=+:.-=*-  [email protected]%%%%%%%#++:=*###%#+%*#*%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%%%%%%%@#+##%@@#=-=+*%=. . #%%%%%%%%@=*-=+###%**+#%%%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%%%%%%%%%##%@@@%##%%*:.. :.%@%%%%%%%%@*:+=+**#:- -%%%%%%%%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%%@@%%%@@%**==-:..  [email protected]@@%%%%%%%%@=-**##=.=+#%*%%%%@%%%%%%%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%@@%%%%%*++=::...=%@%%%%%%%%%%@%#*==+*#%%%*#*#%%%%%%%%%%%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%%%+==+*+=:..=%@@%%%%%%%%%%#*##*#%##%*%*##**%%%%%%%%%%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%%%%=**+++=+##*+%@%%%%%%%@%#####*###%*#%+#*#*#####%%@@%%%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%%%%%%*=:. -*#+:+%%%%%%%%%%%%#%#%%#####**%##%#########*#*@@@%%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%%%%*...:-:..=#%*+%%%%%%%@@*#%##%%###*#**%##%@%*#*#*#**#*#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%%%%-......-:: :+%#:*%%%%@@@#####%%###*#**%%#%#%*#*######=#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%@+....:. .:-:. -**:*@@%%@@*##*#%%%##*###%#*#*##########*#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%%:....:+.. .:::..+-:%@@@@@*##*#%%###*###*====++#####**#+#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%%%+:.... +=..  .-::.::[email protected]@@@@*#%##%%##*##*#@%#@#%##*####*#+#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%#--.....-+.... ..::. [email protected]@@@*####%%###*###%##%#%%#*#*##*#+#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%==-......#:...... .::-.*@@@*##*#%%%##*#**%##%*%*#*#*##*#+#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%%-=-......%=....... ..=-:@@@*####%%##**#**%*#%%#*###*##*#+#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%#-=-......%*-::-====:+*.:@@@*##*#%%##**#**%##%*@####%###%*#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%+-=-..... %%**+++++###==#@@@*##*#%%##**###%*#%*%*#*#*##*#+#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%[email protected]%#*****+#*+*%%@@@#####%%%#**###%##@*%*#*#*##*#+#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%%--=-......%#+=-----**-*@@@@%*#%##%%##*###%%*#%#%#########*#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%#--=-:.... =*:......*%[email protected]@@%%*%%*#%%#*#*#*#%*#%#%*###*##*#+#%@@%%%%%%%%%@@@    //
//    @@%%%%%%%%%%%%%+=-=-:...  -#.......*@*.*@@@%#%%##%%%##*##*%##%*%*#*#*#**#*#%@@%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%-=-=-:.... .#.. ... *@* :@@@@#####%%##*##**%##%#%*######*#*%%@%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%@*+==-:.....:#.. ..  *@* .%@@@*##*#%%####%#*%##%%%*######*%+%@@%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%@@%*+++++++-*%:......*@* .#@@@*##*#%%#*###*#%##%*@*######*#+%@@%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%%%%===+=+:. :*.......*@* .*@@@*#%##%%######*%*#%*%+####%#*##%@@%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%%%%-===--.. .+.. .. .*@*  [email protected]@@+##*#%%###*##*%##%*%*#*###**%*@@%%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%%%%-===:-.. :=.......*@* [email protected]@%*##*#%%%#**#**%##%##*####%%*%#@@%%%%%%%%%%%%@@    //
//    @@%%%%%%%%%%%%%%#-=--.:.. :=.......*@* [email protected]@%###*#%%###*#**%##%*%##*####*##%%%%%%%%%%%%%%@@    //
//    @%%%%%%%%%%%%%%%#-=--.:.. +=...... *@* .:@@@%##*#%%###*%##%*#%*@%#***#**#%%%%%%%%%%%%%%%%@    //
//    @%%%%%%%%%%%%%%%%######***##*******%@%**#%%%%%%%%@%%%%%%%%%%%@%@@%%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MEMORIES OF JAPAN %%%%%%%%%%%%%%%%%%%%%%%%@    //
//    @%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PEGASUS_VFX %%%%%%%%%%%@@    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract MOFJ is ERC721Creator {
    constructor() ERC721Creator("Memories Of Japan", "MOFJ") {}
}