// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Amalgamation of Revelations
/// @author: manifold.xyz

import "./ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    **#**###*+==+==+*+#%%%%%%@%%*+=====+++########***++======+==++++**+*****+*****************    //
//    +*##*##*#*++++***%@@%%@@@@%##++++++++*#%%#####**+++++====+==++*++*++**********************    //
//    +**#*###%##*++#%@@@@@@@@@@@%#**#######%%%#%###*+==++===++===++++++++*++*+++***************    //
//    ++*#**##%@@@@%%%@@@@@@@@@@%%%%%%%%%%%%%%%%%###++==+=====+===++***********++***+***********    //
//    ++****##%%@@@%@%%%@@@@@@@@@@@@@@@@@%##%%%%%##++=========+=+=+++***+++*****++**+***********    //
//    ++****##%%%%@@%%%@@@@@@@@@@@@@@@@%@%#%%%%%%**+==+=======+====+++**********+=+*+***********    //
//    *+++**##%%%%%%@%%@%%%%@@@@@@%%%%%%%%%%%%%%**++===========+===+++**********++=++++*********    //
//    *****###%%%%%%@%%%%%%%%%%%@%%%%%%%%%%%%%%#*++==========++===++++**********+==+*++****+****    //
//    +++++*#%%@@%%@@%%%%%%%%%%%%%%%%%%%%%%%%##*+=========++=+=++=++++*********++==++=++**++****    //
//    +*++#%#@@@@@@@@%%%%%%%%%%%%@@@%@%%%%%##**++===========+++=+++++++*********+===-=+=+++=+***    //
//    ++#@%%@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%##**++=====--=======++++++++++++++*+++==+-===+++==+***    //
//    +%@%[email protected]@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%*+====-=-=-----======++++++++++++++===+=====+++===+***    //
//    #@#++%@@@@@@@@@@@%%%%%%%%%%%%%%%%%%+======-=----------=-==+=+++++=++++++=+==+====+++=++***    //
//    ##=+++%@@@@@@@@@@@@@%@%%%@@%%%%@@@-====--------=--=======-=++++++++++++++=+=+===+++++*****    //
//    #*-====%@@@@@@@@@@@@@@@@@%@@@@@@@@:=======+++=============+++++++++*++++*+++=++++++++*****    //
//    *%-=====%@@@@@@@@@@@@@@@@@@@@@@@@#:=======*%######**+++===++++++++++++++**+==++==++++*****    //
//    [email protected]=-===-=#@@@@@@@@@@@@@@@@@@@@@@@+:====+++=#%####%###********+++++++++++***==---++++******    //
//    +#*--==---*@@@@@@@@@@@@@@@@@@@@@@-:-===+++++#####%#####***#%%*+=*+*****+****+--=+*********    //
//    ++%--==----=%@@@@@@@@@@@@@@@@@@@%::-==+=+++==*##%%%#####***#%%#+=*****+**##**===*+*++*****    //
//    ++#+=--------*@@@@@@@@@@@@@@@@@@=:-=+=+++=====+#%@%######**#%%%**=***##*#*#**==+**********    //
//    +++#=----:-:::=%@@@@@@@@@@@@@@@%:-=++++++=+===++%%########*#%%%#*+**##**##*#*==+**********    //
//    +++#+=----::::--*@@@@@@@@@@@@@#-:-*++++++====++++#%#%######*#%%##*=*#***##*##+-==*********    //
//    +++*#==--::::::---*@@@@@@@%*+==--=*++++++=====++++*%%#####*##%###**=##*#######===+********    //
//    ++++%+=---::::::---=*@@@@*==+++==++++++++====+++++*###############*+=**#####**+===***#****    //
//    ++++*#==-::::::::--+%%##*--=+++++*+++++++====+=+++++++##############*=**###**##====#######    //
//    +++++#+=-:::::::-=++*#+=-::-+++=+*++++++++=+++=======+########%%%%%##*=**##***#*+==+######    //
//    ++++++*=-::::::=====++=-:::-=+==++*+++++=+++++=======+##*#############*+*****###*===*#####    //
//    =+++*++*--:::::--===+==:::::-===++++++++++++=+==++===*######*######%%%##+**#**#*#*+==+*###    //
//    ++++*++++---:..::--===-:::::-===+++++++++++++=======+#######*###%###%%%##+**#****##+==+**#    //
//    ++++*++++--:....::----:=*+-:-===+++++++++++++++=====*###########%%%%%%%%#*++*****####*++++    //
//    =+++*++++-:.....::---::*@@-:-==+++++++++++++++==++=+##############%%%%%%%%##*+#***#####*++    //
//    +++++++++=:.....::----:::::::==*++++++++++++++++===################%%%%%%%%##*+***########    //
//    +++++*+++=-....::---=-::::::-=++++++++++++++++++++*###############%%%%%%%%%%###+*#*#%%%%##    //
//    ++++++++++=::::::--:-:::::--==++++++++++++++++++++###############%%%%%%%%%%%%###***#%%%%##    //
//    +++++++++++-:-::::---::::-====+++++++++++++++++++####%%##########%%%%%%%%%%%#%%###*+#%%%%%    //
//    +++++++++++=-----::--::::-===++++++++++=+=++++++#%%%%%%#%########%%%%%%%%%%%#%##%%%#**%%%%    //
//    ++++++++++*+====-:::-:::-====++++++++++++++++++*%%%%%%%##########%%%%%%%%%%%%%%%%%%#%%**%%    //
//    ++++=++++++++====-:.::::-===+++++++++++++++++++#%%%%%#####%%#####%%%%%%%%%%%%%%%%#####%%**    //
//    +++=++++++++++===-::-::-==++++++++++++++++++++##%%%%#####%%%#####%%%%%%%%%%%%%%%%%%%#%%%%#    //
//    ++=+++++++*+++====-:-:-=+++++++++++++++++++++%%%########%%%######%%%%%%%%%%%%%%%%%%%%%%%##    //
//    +===+++++++++++===-----=+++++*++++++++++++++%%%########%%%#######%%%%%%%%%%%%%%%%%%%%%%%#%    //
//    +===++++++++++++=====-=+++++++*++++++++++++%%%#####%%#%%%%#######%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    ++++++++++++++*++===+=++++++++++++++++++++#%%%######%%%%%########%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    ++++++++++++*****+==++++#++++++++++++++++#@%%####%#%%%%%%#######%%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    #++++++++++++****@%*++*%#+++++++++++++++#@%%####%%%%%%%%########%%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    %%*+++++++++++***%@@@@@@++*++++++++++++#@%%######%%%%%%%########%%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    #%%*+++++++++++***@@@@@#+++++++++++++*%@%%#######%%%%%%%%#######%%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    ##%%#+++++++++++**%@@@@+++++++++++*+*%@%%#######%%%@%%%%%%%#####%%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    %%#%%%*++++++++++**@@@#+++++++++*+**%@%%%#######%%@%%%%#%%#%#####%%%%%%%%%%%%%%%%%%%%%%%%%    //
//    %%%%%%%*++++++++++*#@@+++++++*+++**%@%%%##%%###%%%%%%%%##%#######%#%%%%%%%%%%%%%%%%%%%%%%%    //
//    @%%%%#%%#+++++++++**@#+++++++++***%@%%%####%%##%%%%%#%#############%%%%%%%%%%%%%%%%%%%%%%%    //
//    @@@%%##%%%*++++++++*@+++++++++*+*%@%%#########%%%%###################%%%%%%%%%%%%%%%%%%%%%    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract AOR is ERC721Creator {
    constructor() ERC721Creator("Amalgamation of Revelations", "AOR") {}
}