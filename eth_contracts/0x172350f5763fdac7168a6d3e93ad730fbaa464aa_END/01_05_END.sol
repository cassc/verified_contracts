// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: The End of Open
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

////////////////////////////////////////////////////
//                                                //
//                                                //
//       ('-.       .-') _  _ .-') _              //
//     _(  OO)     ( OO ) )( (  OO) )             //
//    (,------.,--./ ,--,'  \     .'_             //
//     |  .---'|   \ |  |\  ,`'--..._)            //
//     |  |    |    \|  | ) |  |  \  '            //
//    (|  '--. |  .     |/  |  |   ' |            //
//     |  .--' |  |\    |   |  |   / :            //
//     |  `---.|  | \   |   |  '--'  /            //
//     `------'`--'  `--'   `-------'             //
//               .-')                             //
//              ( OO ).                           //
//      ,-.-') (_)---\_)                          //
//      |  |OO)/    _ |                           //
//      |  |  \\  :` `.                           //
//      |  |(_/ '..`''.)                          //
//     ,|  |_.'.-._)   \                          //
//    (_|  |   \       /                          //
//      `--'    `-----'                           //
//         .-') _   ('-.   ('-.     _  .-')       //
//        ( OO ) )_(  OO) ( OO ).-.( \( -O )      //
//    ,--./ ,--,'(,------./ . --. / ,------.      //
//    |   \ |  |\ |  .---'| \-.  \  |   /`. '     //
//    |    \|  | )|  |  .-'-'  |  | |  /  | |     //
//    |  .     |/(|  '--.\| |_.'  | |  |_.' |     //
//    |  |\    |  |  .--' |  .-.  | |  .  '.'     //
//    |  | \   |  |  `---.|  | |  | |  |\  \      //
//    `--'  `--'  `------'`--' `--' `--' '--'     //
//                                                //
//                                                //
////////////////////////////////////////////////////


contract END is ERC1155Creator {
    constructor() ERC1155Creator("The End of Open", "END") {}
}