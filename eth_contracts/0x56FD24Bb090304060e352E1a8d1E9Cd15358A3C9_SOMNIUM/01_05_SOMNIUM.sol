// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Heather N. Stout
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    +-+###%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%########**@    //
//    :-.:=*#%%%%@@%@@%@@@@@@@@%%%@@%%#%@@###%@@@%%%%%%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%%%@@    //
//      . ..:+#%%%%%%%%@%@#####***#**++*##+***##*****###%@@@@@@@@@@@@@@@@@@@@%%%%%%%%%%%@@@%%%%%    //
//    =+++++++###%#%%@@@@@%#*****++*+++++++*+++++++****#%%%%%@@@@@@@@@@@@@@@@#########%%@@@%%###    //
//    @@@@@@@@@@@@@@@@@@@@@##########%%%%####**++++********##%%@@@@@@@@@@%%%%@%@%%%%%@%%@@%%#%%%    //
//    @@@@@@@@@@@@@@@@@@@@@###%%%%%%%%%%%%%%%@%%%###*********%@%%%%%%@@%##@@@@@%%@@@@%#@@@@@%##%    //
//    @@@@@@@@@@@@@@@@@@@@@###%%@@@@@@@@@@@@@@@@@@@@@@%#**+++***#####%@@##%##%%%%%%@@#####%%%#*%    //
//    @@@@@@@@@@@@@@@@@@@@@###%%@@@@@@@@@@@@@@@@@@@@@@@@@@#*+++*****#%@@@@@@@@@@@@@@@@@@@@@@%%@@    //
//    @@@@@@@@@@@@@@@@@@@@@###%%@@@@@@@@@@@@%%%@@%%%%%%@@@@%##**++++++#%@@@@@@@%%%%@@@@@@@@@%@@@    //
//    @@@@@@@@@@@@@@@@@@@@@%#*#%@@@=:::::*------#------%@@@+==*###++++++#@@@@@%###%%%%%%@@@@%%%%    //
//    @@@@@@@@@@@@@@@@@@@@@%#*#%@@@=:--:-+=--==-#=====-%@@@+==-++*%*=++++*#@@@@@@%%%@@@@@@@%%%@%    //
//    @@@@@@@@@@@@@@@@@@@@@%**#%@@@=.:::-+=---=-*=====-#@@@+---+*+#*===+**++#@@@@@@@@%%%%%@@@%%@    //
//    @@@@@@@@@@@@@@@@@@@@@@**##@@@+..:::==:----*-====-#@@@===-=+=**+==++++++##%@@@@@@%%%%%%%%%@    //
//    @@@@@@@@@@@@@@@@@@@@@@=+#%@@@+:::::=+::---+=-===-#@@@=--==--**++*##****+++%@@@%@@@@@@@@@@%    //
//    @@@@@@@@@@@@@@@@@@@@@@-=*%@@@*.....:+::::-+=-----#@@@*+++=+=#****+**##+===+#@@@@@%%@%@%%@@    //
//    @@@@@@@@@@@@@@@@@@@@@@--*%@@@%+==-=+#=====+#+++++%@@@+====+%+**+==****#+==+*##%@@%%%%%%%@@    //
//    %+%@@@@@@@@@@@@@@@@@@%=-+%%@@%.   .:#--====*====+#@@@===-==*=++****##*#%#**+++#%@@%%#%%@@@    //
//    =+#@@@@@#@@@@@%@@@@@@@*-=#%@@%.  .:-#--=-=-*[email protected]@@+==+++#+****###*##%@#+**++*%@@@%%@@@%    //
//    +#@@@@%+*%@@%*%@@@@@@@*-+*%@@@-...::#------#[email protected]@@+==+++#*+=+++####*+%@#***+++#@@%@@@#*    //
//    +#%@@%*=+#@*+###%@@@@%*-+*%@@@-.::::#:----:*--:[email protected]@@#**+=+#+**##*%*+++-%@@*++===+#@@@@%**    //
//    +*@%*+++**+*#*%#%@%@@%*=+#%@@@=.:..:#::::::*::::[email protected]@@+---==#+*==+*#++***@@@@*++++++#%%%***    //
//    +**+*+++++***+++++#%##*=+##@@@#=====%======#==-==*@@@*=+==+%*-=++#%*++*#@@@@%#**+=++%%#***    //
//    ++**#+**++++*++++*+++**=*##%@@+.....*:....:*[email protected]@@=.:..:#-=*##**:::+#@@@@***#**#%%%%%##    //
//    #***+*+**++*#******#%##+*##%@@*.:...*-:....*..:.:[email protected]@@=::::-*:::-:=*::+%%@@@%*++#=+%%@@@%#=    //
//    #***=*+***+*##*****####+**##@@*..:::*-:...:#:.:::[email protected]@@=::.:-+:::::=*::=*#@@@%#***=#%%%%%%%*    //
//    ##*++****+*#####%%##%%#=**##@@#.::::*-:::-:#:::::[email protected]@@=::::=+:::::+*[email protected]@@%+=+++##%%%%%%*    //
//    #**-+*******#%%%@@@%#%%+**##@@%=:...*-::::=#::..:[email protected]@@=::::=+:::::*#::::[email protected]@%*=-==++*%@@@%*+    //
//    *#**######%#+*##%@@@@%%+**##@@@@%%%%@%%%#%%@%%%%%@@@@%######***+*%%%%##%@@%*++-=*#%%@@@@%#    //
//    **+**#%%%%::#**##%@@@@%=+*##@@@@@@@%#%****#####%@@@@@@@@@@@@@#***@@@%#@@@@%*++-+**%%%@@@%#    //
//    *##%#%%%@#+%%%@%%@@@@%#=-*##@@@%*+=+++++=--==-=+=+*%@@@@@@@@%*#@@@++##@@@@%++++-==+%@@@@*+    //
//    **####*%@@#@%%#%@@@@@@#==*#%%#=---=+=====+==-:======**#####%**#@@@@@@@@%%%%+-=+*=*%%%%@%%#    //
//    +*#%%%%@@@@@@@@@@@@@@%#+=**#*------=++*+===+==-:-::-+-:----=%@@@@##%%@%#****++*##*#%@@%%%#    //
//    *##%%%@%@@@@@@@@@@@@%%%*+---**=*+::::-:=+:=.:==-=++##--:::::=%@@@#+*#%%%#**+++++=-+###+-.-    //
//    ##%%%%%%@@@@@@@@@@@@*#+---==+###*++=-===##+##**#%%#**#=:::::::=++++=-----------===*%%%%*++    //
//    *##%%%@@@@@%%%@@%@@%-::.::-+#**##%@@@@@@@@@@%%%####*+-:::::.:::::::::::::::::::==+*#%@%%*+    //
//    %%%%%%@@@@%#**%@@@@=......::-=*##%##########%%%##*++======++++++===+++*++++++*+**##%%%%%##    //
//    %@@@@@@@@@%%%%%%@%= -=+++****####%%%%%%%%%%%%%%%%%%%%%#%%%%%%%%%%%###%#%%%%%%%%#%%%%%%%%%%    //
//    @@%@@%#%%%%%%%%##+.=%%#############%%%%%%%%%%%##%%%%%%%%%%%%###%###*###%%%%%%%%#%%%%%%%%%%    //
//    ##*####**********-.*%%##############%%%%%%%%%###%%%##%%%%%%####%#*++**#%%%%#%####%%%%%%%%%    //
//    +**+====++==+++++.:#%%%###############%%%%%%%####%%%%%%@%%%%%%%%##***#%%@@@%@@%@@@@@@@@@@@    //
//    %%@@@@@@@@@@@@@@#:-#%%%%%%%%%@@@@%@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@+-#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@#+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract SOMNIUM is ERC721Creator {
    constructor() ERC721Creator("Heather N. Stout", "SOMNIUM") {}
}