// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: FarmCats
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    %%%%%++===#@::::-%@%%@%*%#%@%%@@%+:........ :+#%#%*                        .    .*-  ..---    //
//    ##%@#**++=+%-.::-%@@@@@%%@@@%%#@%--:::.  ..  -*#%%%-                       .    :+-  ..---    //
//    @@@%**#%#%@@-.::-#%##%%#@@@@@++*=::=::..:..  .*#%%##.            ..::.          -+:  . ---    //
//    %%@@@%%@%%@@+..:+*##%%@%%%%%%###*+++*+==+*===+######=--===++++**##%###%*.       =+:  ..++*    //
//    %%%@@@@@@@@@+..:+#%#%%%@@%%%%%%%%%%%%%%%%%######################%%%%%%%@:  ...  :=:  ..-::    //
//    %%@%%%@@@@@%*=#+-%%#%%%%@%%%%%%%%%%%%%%%%%%#####################%%%%%@@#      .:--.  ..:::    //
//    #%%%%%%%%%%%#+%@%%%%%%%%%%%%%%%%%%#%%#%#%#%%###################%%#%%%@@=---------------:::    //
//    ##%@@@@%%@%@%.-%@%%%%%%%%%%%%%%%%##############################%#%%%@@#=======++++++++=--=    //
//    @@@##%%*%@%%*[email protected]@@%%%#%%%%%%%%%%%##########################**####%%@@@-----:::------::::--    //
//    ###=+++=+==-+==#@@%%%###%%%%%%%%#####################*##**######%%%@@*...:=====+******+:..    //
//    *-=++==+==::+=###%%%%###%%%%%%%%###################**#****#####%%%@@%:=+*##*=---******#=-:    //
//    +=+++==+==--=#%%%%%%##%##**#%%%%%###+*#############*#**#######%%#@@%###*##%%*===+**####*-:    //
//    =+=**+++++==*#%%%%%%%%%#*=:-*%%%%%+::+##############*##*#######*#%#%%%###%%##++*#######*-=    //
//    +**##***###*+#%%%%%%@@@@%*=--=+===--++###############%##########%@%%%%%##%%##*#%%%%##%%=..    //
//    *#%%%%%%%%##*##%%@@@@@@@@@=:::---::.:+%##############%@@%%%%%%@@@@@%%%###%%#*#%%%@@@@%+...    //
//    **%%@@%%%%%#**%%@@@@@@@@@@=:=*-  =*--+%#%%%#%########%@@@@@@@@@@@@@%%%%%%%#*#%%%%@@@@#:...    //
//    %%%%%%%%%%%%#*#%@@@@@@@@@@+++::  :.=++%%%%%%%%%#####%@@@@%=#@@@@@@@%%%%%%%#*#%%%%%%%%=----    //
//    @@@@%@%%%%#%#**%%@@@@@@@@%=--.:=+:::-+%%%%%%%%%%%@%*[email protected]@@%- .#@@@@@@@%%@@@%*#%%%%%%%%+.....    //
//    %%@@%%@%%%%%%%*#%%@@@@@@@+: :-+++=-:==*%%%%%%%%@%*:  +*+     :*+%@@@@@@@@%*%%%%%%%%%--::..    //
//    #**#%%@@%%%%%%##%%@@@@@@#=:  .:-:.  --=*%%%%#:*-.    ..::-+-::[email protected]@@@@@@%##%%%%%%%%#*#+#*=    //
//    ***%@*%%%%%%%%%##%@@@@@*+===. .. .:=++-++%@#: .   ...  :-==-:. [email protected]@@@@@@%##%%%%%%%%###****    //
//    #*%##+#%%%%%%%%%##%@@@%=--+*+-:.:--=+**+*@%=+++====+===--====++=-#@@@@@@%#%%%%%%%%%@@@@@#%    //
//    +++*#**%%%%%%%%%%#%@@@@+...+%%#- ...+%%%%%%#%%%%%###########***#####%%@@%%%%%%%%%%@@@@@@@@    //
//    ##*##*##%%%%%%%%%%%@%%%=   :%%=   .#############*##*********++*++++++++*%%#%%%%##%@@@@@@@@    //
//    ####*###%%%%%%%%%@%****=. .=###**##********+***+++++++++++++++=========+*%#######%@@@@@@@%    //
//    %%#***#%%%%%%%%%%%++****#*##############################***********++++++%%%#%###@@@@@@@%@    //
//    ##*#%##%@%%%%%%%@@#######%#%%%%%%%%%%%%%%%%%%%%%%%%%%############*******#%%%####%@@@@@@@@%    //
//    ***##%@@@%%%%%%%@@%%##%%%%%%%%%%@@@@@@@@@@%@@@@@@%@%%%%%%%%%%%%%%%#######%%%%##%%@@@%%@@@@    //
//    #%%%@@@%@@%%%%%%%@%%%%##%%%%%%@@@@@@@@@@@@@@%%%@@@@@@%%%%%%%%%%%%%%%##%#%%%%%#%%@@@@%@@@@@    //
//    @@@@@@@@@@%%%%%%%@@%%%%%%%%%%%%@@@@@@@@@@@@@@%%%%@@@@%%%%%%%%@@%%%%%%%%%%@%%###%@@@@@@@@@@    //
//    @@@@@@@@@@%%%%%%%@@@%%%%%%%%%%@@@@@@@@@@@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###%@@@@@@@%@@    //
//    @@@@@@@@%%*%%%%%%@@@%@%%%%%%%%@@@@@%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%#####%@@@@@@@@%@    //
//    @@@@@@@@%%%%%%%%%@@%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%######%#%##%@@@@@@@@@@@    //
//    @@@@%%@###@*%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%###%%%#%#%@@@@@@@@@@@    //
//    @#*@%%###**+%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%##%%####%@@@@@@@@%@@    //
//    *[email protected]@@%#*-==*%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%#%%#####%@@@@%##*++=    //
//    ==*@@%%%=--**%%%%%%@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%####@@%#+*=====-    //
//    +*#@@@@@==#*+%%%%%%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%######%##%%%%%%%%%%%%%%%#%%*[email protected]@@@%#@@%*    //
//    **-#@++---=-=*#@%#%@@%@@%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%@%@@@@%%@%%%%%+#%%%%%%@@@#    //
//    %###*---=+=+%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#@@@#+#%%@@%#%@@*@    //
//    #===--+*#++%%#%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%@@@@@#%%@@@@@@%@##@    //
//    +=+**##+*#%#+-==*%@@@@@@@%#%%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%#%%%%%%%+**###%*%*%@    //
//    ##+***--+-=+#%%+*%%%%%%%%+=+*+++#@%%@@@@@@%@@%%@%@@@@@@%%%@%%%%@@%@@%*%%##%%++*==#%##*##%@    //
//    #%%%%**+=*%%@@@@%**++*++=+++=-+*+#%##%%##%##%%%%@%%%@%##*###%%####+++#@%@%++%@##+++*#**#%%    //
//    *#%%%#%%##%%%#@%******#++=++*+*+**##***%%####%#%%%%%***++**#####***+*%@%#***++++*#*=++=*%%    //
//    ######%##%%%+*%%*++++++++=+++*++****%%%@%%##%%*#%%%%***++#*+#*****###%#*%#*###%%%*%%#+#+*#    //
//    ***##*#*###%%#***+===+*+===+=++++######**+#%###%%##*==+++*++***+*#%%%##%**+#%*#%#*###+###*    //
//    #%#+***########*+++++*==*#++==+*+**=+=***+**#%#**++**+++*+*#+++*%%#####****###%##%##++%##%    //
//    #%%#+#%%####*=*****+*#*=+=+=:*=+*+=*+++=++****+++++*+=+****+=+***#*#:-+====**####*++**%#%#    //
//    *****#####**=+*#**+*##***+++-++=+=++++++**+*##****###****+++==#%#***:+#%###+=-+*#%*##+#%#%    //
//    *+++*#%%***+-=***#*##*#*##+++#*+==+=+*=*******+-===*#=--=++#++*+-=%%=%##=*%@@%*+=+*##+%%#%    //
//    +++#***#%#*=+=-=#+=--=+***+***%#*****++**++=-==+#*****:++=#%@@%*:[email protected]@+#*+**##%@@#***%@#%    //
//    ++#***=+**=#*====**+++++++*#*********++*==-===-=++==+=++##%@@%@**%#--%%###*+***#*#%@###%%%    //
//    #**+*++*##*#%*+===*+#%####+=*+**#+*=**=++**=-=+=##*+**+***#@@@@[email protected]@@%[email protected]#++==++*+***%#++++    //
//    #*+**++*#*+%%%#*****##+--=--##%%#%=+#*+==*#%#=-=====+#%###%%%%##%%@@#[email protected]@%**-=++=+*+*+##+*    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract FarmCats is ERC1155Creator {
    constructor() ERC1155Creator("FarmCats", "FarmCats") {}
}