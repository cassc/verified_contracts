// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Innocence by QuietStar
/// @author: manifold.xyz

import "./manifold/ERC721Creator.sol";

//////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                  //
//                                                                                                  //
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    //
//    ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++++++++++++==+++++++++++++++++++++==+++++++++++++++++++++++++++++++++=++++++    //
//    ++=+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++=++++++=-=++++++++++++++++++    //
//    +++++++++++++++++++++++++++++++++++++++++=++**++++++++++++=+=========+++++++++++++++++++++    //
//    ++++++++++++++++++++++++++++++++++++++++++++#*+++**+++++++=================+++++++++++++++    //
//    +++++++++++++=++++++++++++++++++++*++++*#+++++++****++++*+========+++=======++=+++=+++++++    //
//    ++++++++++++==++++++++++++++**++++#*++++*+++++++++**+=++++==+*+===+*+=======++==++++++++++    //
//    ++++++++++++++++++++++++++++**+++*+++*#*+++++++++++++++**++++*+==+++=========+====++++++++    //
//    ++++++++++++++++++++++**++++**++*++++**+=***++**+====+*+++*#+=*+++==++============++++++++    //
//    +++++++++++++++++++++++*++++#*+*##*++*++=+#*++#*++====*+++++==+*+=+**+===========+=+==++++    //
//    +++++++++++++++++==+*+++***+++++++++*#*+==*+*+++**==*+++===+===*++++=================+++++    //
//    +++++++++++++++++=+=*+*+**+=+*+===+++*+===**+===+*++#*+===**===+*+++**====++===+====++++++    //
//    +++++++++++++++*+===+*#+++==+*++++==+++++++===+**+**#+====*+==++**+**+==+*#+==**+==+++++++    //
//    +++++++++++++++**++++***++**+=+***+=**==++===+**+=+*++====+=+++=====*+=++++++=*+==+**+++++    //
//    +++==+++++++===++*+**++++*#+=+*++*=++====*==+++++==+*+====*+++*+====+***++**==++++*+++++++    //
//    ++++++++++++++=+=+*#***+=+*+=*+==+*+=====+**+=**+===+*==++===+*+====+++==+*===+*++==++++++    //
//    ++++++++++++++++==*+++===++*+**+==+*+=*+=*+===+======+*+==++===++=+*++===+*=++**+=====++++    //
//    +++++++++++==+**+*****===**+***+==*++***+==*++=------=+==**=====+****+====*++++=======++++    //
//    ++++++++++++==+*+**++====**++**+=+++++*+=--=*+=*=---===--*======++*=====+**+=+*+====++++++    //
//    +++++++++++==++=+*+=====++==++++**#*+=++-----+*+-+++*+=:-+--==+*+=*+===+**+==**+===+++++++    //
//    ++++++++++++++===**++*++++*+====*++===-+=::-=::==*+-::::-=-==+**+++*++**====+*+==++*++++++    //
//    +++++++++++**+===*+****==+**++=++===---=+-+=-::-=*-:::::+==---=*++****+=====++++++++++++++    //
//    +++++++++=++**+=++=+#*==*+==++**+===----**+=-::-=++:+=-=-::::--+*++=+*==++=+**+++++++++=++    //
//    +++=++++=++==++**=++***++*+===++*+=----=-::-+:::::=**+-:-+-::--+=====*++*****+++++++++++++    //
//    +++++++++====++*+=***=+==+*+=+**=++++**-:::+*:::::-*=:::-#+-:-=+=====+***+++++**++++++++++    //
//    +++++++**+===***===+*=====+**+*+====+*=::::-+-::::+-:::::++++=+=++===+*+=====+*+++++++++++    //
//    ++++++++**++=+*+++******===+*==*+==-+=+-:==:-+-::++::-*=--+--=*+*+==+*+====+++*+++++*#++++    //
//    +++++=+===+*++*=====++*+===+====++++=--+-**=-:==+#+::-*-=+=---=**+==*++==+++++*++++**+++++    //
//    ++++++=====++**++===++++++++=====++===+++*===::-++-:--+::-+--===+*+**#++++++#****+++++++++    //
//    +++++=======****+===+*+==++*+++=+*+===**+==*+::::==-**----*====+*++*+++++++++*++++++++++++    //
//    +++===+======+*+++==+*=====**+++*#+===*#==-+=----+*+*=---=+*+++#*==*++=++++*++++++++++++++    //
//    ++===+**++====*#*+===*=====*+==+*+====++==+=+=--=++=======*+==*+=+++*+++++*#*+++++++++++++    //
//    +++===+**+*+++***++++*+++++*+===+**+=+*===#+=*=++====++***+==*#+++++#+++++**+++++++*#*++++    //
//    +++===+===========+*+++**++**+*++*+++*+==**==+****====*#*====*+++++*++++++#*++++++**++++++    //
//    +++++=====+========+*++==+#*++*#+=====*****++***+=====+*++=++*++++*++++++*++++++++++++++++    //
//    ++++====+============*+==+#+==+*+*+===+*+*#++*+==++=+++#+++*#++++#++++++*+++++++++++++++++    //
//    ++++====+=====++===+*+*+++*+**+##*==+***+++*#+++===++#*#+++##*++#*+++*+**+++++++++++++++++    //
//    +++=++===+===+***++++*#+*####**#+++==*#*===+****+=+=+##**+++#**#*+++#**##*++++++++++++++++    //
//    +++++=========++++++++*+++++==++***+++**+++++*#+++++**+++++++*#*****++++++++*##*++++++++++    //
//    +++++===========+=================+*#*##*+++++*+##*++++++++**#*##**+++++++++++++++++++++++    //
//    ++++=+=============================+++#*++++*++#**+++==++*#*++++**++++++++++++++++++++++++    //
//    ++++++========+=++===============++++++#++++#***+++++++*#*+++++++++++++++++++=++++++++++++    //
//    ++++++=====+=++++====+============++++++#*++*##++++++##*++++++++++++++++++++++++++++++++++    //
//    ++++++++++++++++++++==========+++++++++++##++*###++##*++++++++++++++++++++++++++++++++++++    //
//    +++++++=++++++==+=+=======+===++++++++++++##+#**+##*++++++++++++++++++++++++++++++++++++++    //
//    +++++++++=++++=+++=++===++++=++++++++=+++++###+##*++++++++++++++++++++++++++++++++++++++++    //
//    ++++++++++++++++++++======++=++++++++=+++++*%##*++++++++++++++++++++++++++++++++++++++++++    //
//    ++++++++++++++=++++++++++++++++++++++++++++*##*+++++++++++++++++++++++++++++++++++++++++++    //
//    +++=+++++++++++++++++++++++++++++++++++++++###++++++++++++++++++++++++++++++++++++++=+++++    //
//    ++++++++++++++++++++++++++++++++++++++++++*##+=+++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++==++++++++++++++++++++++++*##*+++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++++++++++++++++++++++++++++###++++++++++++++++++++++++++++++++++++++++++++++    //
//    ++++++++++++++++++++++++++++++++++++++++*#%*++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++++++++++++++=++++++++++++###*++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++++++++++++++=+++++++++++*###+++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++++++++++++++++++++++++++####+++++++++++++++++++++++++++++++++++++++++++++++    //
//    ++++++++++++++++++++++++++++++++++++++*###*+++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++=++++++++++++++++++++++++++++++#%%#*+++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++==++++++++++++++++++++++++++++*%%%#++++++++++++++++++++++++++++++++++++++++++++++++    //
//    +++++++++++++++++++++++++++++++++++++*%%%#+++++++=++++++++++++++++++++++++++++++++++++*++*    //
//    +++++++++++++++++++++++++++++++++++++*%%%*+++++++++++++++++++++++++++++++++++++++++++*****    //
//    +++++++++++++++++++++++++++++++++++++*%%#++++++++++++++++++++++++++++++**+****************    //
//    +++++++++++++++++++++++++++++++++++++*%%#+++++++++++++++++++++++*++***********************    //
//    +++++++++++++++++++++++++++++++++++++*%%#++++++++++++++++++**+****************************    //
//                                                                                                  //
//                                                                                                  //
//                                                                                                  //
//////////////////////////////////////////////////////////////////////////////////////////////////////


contract INCN is ERC721Creator {
    constructor() ERC721Creator("Innocence by QuietStar", "INCN") {}
}