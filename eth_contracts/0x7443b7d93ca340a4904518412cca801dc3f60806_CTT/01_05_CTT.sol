// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Chonker Totem Tribe
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ...........................:-*#+===++**#############**++==+#-.............................    //
//    .......................:-=+--*+#*=====++++*******+++===::+#+=======-..-%%%%%%%%%%%%%%%%%:.    //
//    .................::--=======-..-#*+=================-::=#%%%%%%%%%%+..-%%*+++++++++++%%%:.    //
//    .:----------=============-:..=*%:.-**=---========---=*+=-=#*=-::::::..-%%*==+#####===%%%:.    //
//    ....::---=======----::..:-+**=***====*%%###****###%%#+++*#*++##++++-..-%%*==*%%#**---%%%..    //
//    .:=---..+===----==++*#%%%%#++**#*++*#%%%%%%%%%%%%@@@@%#*==*++#%####+..-%%*==*##+=====%%%..    //
//    .:----.-%%%%%%%%%%%%%##@@*=:-*+++****++#*#%%@####%#*+*##*#***++*#%%=..:##+===========###..    //
//    ........:---==**=-:...%@@@%#%#%##*+*+*+##*#%*#*=-#%++++++*%%#@%%@@%#.....:=:..............    //
//    .............-%%#[email protected]%@@@@%%@**=%@@@#=##%***=+%#-#%@@%*=+%#@@%%@%@-.:=#%%#:.............    //
//    ............-%%%#=*#*=#%%%%@%#@%++%@@@%=+*##%=*%*+-#@@@@#-*%*@@%%%@*=#*+-%#%%:............    //
//    ...........:#%%++##%#%%#=---*@#@%+=*#*+=+#%%+*@@#*+=+**++%##@+-=-=%#%%%%*++%%#:...........    //
//    ..........:#%#+-%#*#%%#+++==-%@@#*#*+**##%%#%#%#%+***++**%@@*-===++%###+#%:=##%:..........    //
//    .........:%%#-===-+##**++++++%@@=***#####@#%%*%#@*#+++***[email protected]%#=++++=#*##=:--=+#%%:.........    //
//    ...........-#%#****##%%#++*#%*@@*+++=-*==*##**##*+=*+=****@%#%*+=+%@@%%#***##*:...........    //
//    ...........:%@@%%%+#%@%@@*##*#[email protected]#%*+-=*=--**-=**==-#---#%%%+###*%@@@@%**@%@@@%............    //
//    ...........-%@%%@%#%%%@%@@++=#:*%%##%#**%#**%##*#%###%*#@@+:#*+#@@%@%*##%@%%%#:...........    //
//    ...........:+#*%@#%#*%@@@@@+#+:-%@%+#:-:#=:=+*---*-:+*+%@#-:*+#@@@@@%*#%%@%##=............    //
//    ...........=%%##%#%@@@@#%%**+-%%%@@@%*+*#*##@@%##%+=*##%@@%#:+++%##@@@%*%%*#%#-...........    //
//    ................:-+*##***+*=%#%@@%##%%%%@@@@@@@@@#%%%%%%@@*%##=*+*+***++-.................    //
//    ..................--*%%%%%@@@%#@%##%#**##%#%%%%##%#***###%@%%%@%#%#%%=-:..................    //
//    .................-+#%#%@@%@@@%%%*%#%+*###*%*=+##*###+*%*%*%%%%%%%@@@%*#+..................    //
//    .................-=#@@@##%#%##@#%**##**########%%#****#**#*@%%%%%%#@%%#=-.................    //
//    .........:--+++=.-:=%@%#%***##%%@@*#**#%%%%%###%%%%#**#*#%%###+*###%@%--..-=++---.........    //
//    ..........=-:-+*#*+-#%#*#**+#*###@%@@@*-#%@*+-##@@+=#@@%@%##**+**#*##*=-+#*+---*..........    //
//    ...........+*=-::*##+*%###++*#*%%*+*%%%+*%##***#%*=#@@+%*%@*#*+=####***#*-:-=+*...........    //
//    ............=+#*+=:==#%####+*#@@#*=+#%***##****%#***##*=+*#%*++#*##@%==-=++%+=............    //
//    ................-+###+#%%#%+%*%%@#%#**#*****##*#**##****@@@%##+%*##%*%#*+=:...............    //
//    .................:++#%%##*%@*++*##*##***#%#*++*%%#*#*##*+%*[email protected]%**#%##*+-.................    //
//    .................:##+%###%@@@@%##*##=**%*+*----*+#%#**##*#*#@@@@###*#=#*=.................    //
//    .................:#%++++##%##%@%*#*#**#+---:..-=-=*@*#*##*%*@@@@**++++%#=.................    //
//    ..................=*##%##%+=+##%@%#%%%#=-::....:[email protected]%@%@%%###*+=%*#%###=:.................    //
//    ..........-=+=++++=+*%*##@+*%%*###@%%@%#--.....:==*%@%%@%*#*%@#[email protected]#**%++=+======-..........    //
//    .......:++:==*##-#****=+%@@%******%%%%%%*=--+=--=*@@%#%%******#@@#+++#*+*+*#*==-+=:.......    //
//    ......-*=-=*#+*%+%#%##%**%@-=*###**#%%@%@@@%%#%%@@%%%%%*##***+*@#**%#%%%%+%++*#=:=+=......    //
//    .........--*+=-+##**##%++*@=-*###########*%%%#%%**#########**=*@*++%##***#:-=+*=-:........    //
//    ...............=*%*###*+*#%-=*#*##*#####*####*########*#*#***+:%#*+++##*##................    //
//    ...............-*%#++#+*#%+-**#*-++*###*#*+*##*++#******=**#**=-%**+#*+*%#................    //
//    ................:-=+#@#%#=**#*--*##*@#%**#+=+===#**##%**##-:*##+:*#*@#+=-.................    //
//    .....................=##**##+=*%%%%@@%@%==***++**=#@%@@%%%%*=*###+#%-.....................    //
//    ....................:*==%%####*+*[email protected]%%%#*+:=:..--==*##@%@#+***###%%#=+:....................    //
//    ....................-*-+%###*-=***++**+++**=+==**++++****++#*##**##-+=....................    //
//    .....................*+:###=-++**##*##+#*=**++**=*#*###***=+######+:*.....................    //
//    ---------------------+#=-++*+*##%%#%%*#%*##%*+%**#%*####+%#**#***=:*+=====================    //
//    +++++++++++++++++++++++####%+*#%#%#%%*#%%%#%++%###%#*###%%###*%#*##*++++++++++++++++++++++    //
//    %%%%%%%%%%%%%%%%%%%%%%%%%%%%@@@@@@@@@@@%%@@%%%%@@@%@@@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract CTT is ERC721Creator {
    constructor() ERC721Creator("Chonker Totem Tribe", "CTT") {}
}