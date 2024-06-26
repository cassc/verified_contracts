// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: D2 Memes
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

/////////////////////////////////////////////////////////////////////////////////
//                                                                             //
//                                                                             //
//                                                                             //
//             *%%%%%%%###**++=-:                      :##*=:.                 //
//            [email protected]@@@@@@@@@@@@@@@@@@@#+-.               [email protected]@@@@@@%*-              //
//            %@@@@@@@@@@@@@@@@@@@@@@@@%*-           .%@@@@@@@@@@@=            //
//           [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@%:         =#@@@@@@@@@@@@%.          //
//           @@@@@@@@:     ...:-+*@@@@@@@@@@:            -+%@@@@@@@@%          //
//          [email protected]@@@@@@+              [email protected]@@@@@@@@               .#@@@@@@@=         //
//          @@@@@@@@      .::       [email protected]@@@@@@@=      .         @@@@@@@+         //
//         [email protected]@@@@@@-    .%@@@@-      @@@@@@@@+   :%@@@#.     :@@@@@@@=         //
//         %@@@@@@%     [email protected]@@@@=     [email protected]@@@@@@@:   @@@@@@-    :@@@@@@@%          //
//        [email protected]@@@@@@:      -+*+:     [email protected]@@@@@@@%    [email protected]@@@=   :*@@@@@@@#.          //
//        %@@@@@@#               .*@@@@@@@@@.          .=#@@@@@@@@=            //
//       :@@@@@@@:            .-#@@@@@@@@@@:      .:=*@@@@@@@@@%=              //
//       *@@@@@@@.     .:-=+#%@@@@@@@@@@@*. -%%%@@@@@@@@@@@@#=.                //
//      [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*.  [email protected]@@@@@@@@@@@@@%+--:.               //
//      [email protected]@@@@@@@@@@@@@@@@@@@@@@@@@@#=    #@@@@@@@@@@@@@@@@@@@@@@@%#*+=-:.     //
//      %@@@@@@@@@@@@@@@@@@@@@@@@*=.     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%     //
//     .*#%%%@@@@@@@@@@@@%#*+=:.          ..:-==+*#%@@@@@@@@@@@@@@@@@@@@@:     //
//                  .                                  .:--=+*#%%@@@@@@@+      //
//                                                                 ..::-       //
//           ____   ____    __  __  _____  __  __  _____  ____                 //
//          |  _ \ |___ \  |  \/  || ____||  \/  || ____|/ ___|                //
//          | | | |  __) | | |\/| ||  _|  | |\/| ||  _|  \___ \                //
//          | |_| | / __/  | |  | || |___ | |  | || |___  ___) |               //
//          |____/ |_____| |_|  |_||_____||_|  |_||_____||____/                //
//                                                                             //
//                                                                             //
//                                                                             //
//                                                                             //
/////////////////////////////////////////////////////////////////////////////////


contract D2MEM is ERC1155Creator {
    constructor() ERC1155Creator("D2 Memes", "D2MEM") {}
}