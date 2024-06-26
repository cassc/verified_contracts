// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: <Art> Club
/// @author: manifold.xyz

import "./manifold/ERC1155Creator.sol";

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                                                               //
//                                                                                                                                               //
//                                  ..  ................ ..             ... ................ ...                                                 //
//                                  ~~~~!~^~^~^~7^~^^^^^~!~~!           :!~~!~^~~^~^~7^^^^~^~!~~~:                                               //
//                        ~^^^^^^^^^~7^7?~^^^^^^!^^^^^^^7J^7!^^^^^^^^^^^~?~!J~^^^^^^^!^^^^^^!?~!!~^^^^^^^^~:                                     //
//                        7~^^^^^^^^^7~77:..............~J^7^^^^^^^^^^^^^!~!J:..............~?~7~^^^^^^^^^!^                                     //
//                        !^^^^^^^^^^^^^^               :~^~^^^^^^^^^^^^^^^^~               .~^^^^^^^^^^^:~^                                     //
//                        ~                   .~!:                                 .^!:                   :^                                     //
//                        ~.                .!7^:~7^                             .!!^:~7^                 :^                                     //
//                        ~.                 ^~~~~!:                              ~~~~~~:                 :^                                     //
//                        ~.         ........ .^!^  ........              ........ .~~:  ........         :^                                     //
//                        ~.        ~7~7^^^^^^^^^^^^^^^^^7~7~           .!7~!^^^^^^^^^^^^^^^^!!!7:        :^                                     //
//                        ~.        !7^7~~~~~~~~~~~~~~~~~7~7~           .!7~7~~~~~~~~~~~~~~~~7~~7^        :^                                     //
//                        ~.        ~~.??~!!!!!7?!!!!!!~J?:~~           .~~:Y7~!!!!!7?!!!!!!~Y^^~^        :^                                     //
//                        ~.        ~~ ?~      ^!.      J?.~~           .~~:5~      ^!.      J^^~^        :^                                     //
//                        ~.        ~~ ?~      ^!.      J?.~~           .~~:5~      ^!.      J^^~^        :^                                     //
//                        ~.        ~~ ?! .... ^!:......J?.~~           .~~:5! .....~!. ...  J^^~^        :^                                     //
//                        ~.        ~~.7~^^^^^^^:~~~~~~~~7.~~           .~~:7~~~~~~~^:~^^^^^^7^^~^        :^                                     //
//                        ~.        ~~ !!......!.~     :^7.^^           .~~:!~ .....~:^.....^7^^~:        :^                                     //
//                        ~.       .?7~J77777777~?7777777?!?!           .!~~!!~~~~~!~^!~~~~~~7~~!~        :^                                     //
//                        ~.       :!~~~~~~~~~~~~~~~~~~~~~~!^            ^::::::::::::::::::::::::        :^                                     //
//                        ~.                                                                              :^                                     //
//                        !7!!!!!!!~~!!!!!!!!!!~!!!!~!!!~~~~~~~!~!!!!~~~~!~~~!!!!!~!!!777!77!7!!!!!~!!!.  ^^                                     //
//                        !?77J!!!~~~~!?!7JY555555555??P5PP5Y55555555555PPPPP?5P5JJJJYJ!!!!!!7!!!!JPPPJ~^^!^                                     //
//                        ~:..7!^^~^^^!!~^P#[email protected]@@@P.:::::::::[email protected]@@@@[email protected]@P ....            [email protected]@@J^..~^                                     //
//                        ~.  !~      :~..PG        [email protected]@@@P           [email protected]@@@@[email protected]@P                 [email protected]@@J.  :^                                     //
//                        ~.7:!~      .77:5B????????PJ?####Y...........?#####7B#5^^^^^^^^^^^!?7??75###?:  :^                                     //
//                        ~.?^!~      :!?:?^:^:!7^^^:~!^?~!~:::::^!~^:::::^77!!.:::::!J^:::::!J~:::..:7:  :^                                     //
//                        ~.  !~      :^~:?.   ~!    ~?:?^!^     .~^:     .7?7!      ~J.     ~J:     .7:  :^                                     //
//                        ~.  !!:^^^^:~^!:?.   ~!    ~?:?~~^^^^^^~:.^^^^^^^~?7!      ~J.     ~J:     .7:  :^                                     //
//                        ~.  !!~:::::7^~:?.   ~!    ~?:?~~^.....^:.~.....^~?7!      ~J.     ~J:     .7:  :^                                     //
//                        ~.  !!^     !^ .?.   ~!    ~?:?~!^     :^.~     ^~?7!      ~J.     ~J:     .7:  :^                                     //
//                       .7~~^J!^     7!..?.   ~!    ~?:?~!^     ^^.~     ^~?7!      ~J.     ~J:     .7:  :^                                     //
//                       ^7 . J!^     ?!^.?.   ~!    ~?:?~!^     ^^.~     ^~?7!      ~J.     ~J:     .7:  :^                                     //
//                       :7^^^J!^     7~ .?.   ~!    ~?:?~!^     ^^.~     ^~?7!      ~J.     ~J:     .7:  :^                                     //
//                        ~.  ~!^     7: .?.   ~!    ~?:?~~~     ^^.~     ^~?7!      ~J: ... ~J:     .7:  :^                                     //
//                        ~:. !!^     7^.^?~^^^!!^^^^!7~?~!^     :^.~     :~?77~~~~~~!7!!!!!!77!~~~~~!J^..^^                                     //
//                        ~:..!!^    .?^..............!. ~J~:^^^:~^:!:::::~!~^ ....... ......  ...... ~^..^^                                     //
//                        ~:..!!~~~~~~!^.:::::::::::::!::^^:::::::.:::::::::!~........................~^..^^                                     //
//                        .....                                              ..............................                                      //
//                                                                                                                                               //
//                                                                                                                                               //
//                            .^:                                                :~~^    .JJ??7              !J!                                 //
//                            [email protected]@!               .PP^                          !B#PP&#!  :JJ&@5             .#@7                                 //
//                  .^!Y5.   [email protected]&#.   .5P7YGB5 :[email protected]@G5P7  Y57^.               [email protected]#:  !GY    :&@~   ^PP.  YG! [email protected]&5PGY:                             //
//               ^YGBGPJ7   ^@#[email protected]   .&@BJ77! .^!&@7^^:  !J5GGG5!           .#@7          [email protected]    [email protected]  ^@@^ [email protected]~^[email protected]                             //
//               ~G##PJ!^  [email protected]#[email protected]@!  .#@7       :&@^     :!J5B#B?           ^@@^  .!!     [email protected]?   [email protected]  [email protected] :&@~  [email protected]                             //
//                 .^!JPG. [email protected]@&: .&@7       .#@P777  PGY7^.             [email protected][email protected]  [email protected]@Y?^ .#@5!J&@7 [email protected]@[email protected]#~                             //
//                        .JY^    ?Y~ .?Y^        :?55Y7                      .!Y5Y?:  .JYYJJYY^  ^J5Y!JJ. 7Y7?55?:                              //
//                                                                                                                                               //
//                                                                                                                                               //
//                                                                                                                                               //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract ARTCLUB is ERC1155Creator {
    constructor() ERC1155Creator("<Art> Club", "ARTCLUB") {}
}