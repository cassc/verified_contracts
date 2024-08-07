// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: Baird vs Baird
/// @author: manifold.xyz

import "./ERC721Creator.sol";

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                                                                            //
//                                                                                                            //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#PP&@@@@@@@@B&&BBG5Y5&@#G&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&[email protected]@@@@@@@@@5!^~~:. .!Y55PPBBB&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&##@@@@@@@&[email protected]&5~^JGY!^.:~~??~:^:~77Y#&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@&#&@@@&#@@@&B??55YY^^5&#?:...^7~.:~^.~..:~7YB&@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@&GJ5J!:~^:JGJ:^::^::...^!:~:.::  :75&@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&#BB#B&#P??7: :!7~^:^~~^..^::::^:.... ....?&@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@&[email protected]&@@@@&@&GJ?!7J!#&#5J^?Y?:^ ::~?^...^^^.:^.::       :[email protected]@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@&&@@&55G5JJ?7:[email protected]@&YJ&@?   .. ::  .:...:: ..         .?&@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@#B&&@PPB#G???YJY#BY5G&#JP7.    ^:^...  :..:. ..   .. .    :[email protected]@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@&#&#&@#G#&&@@&@@@&@&Y#J75#G!^.   ~B#P5?^  :. .: ::    ....     [email protected]@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@BG&B&&B&@@@@@@&YJ5!7J7. ~7:    ~5&@BYJ.     . .:.  ..    .     7&@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@&#&&5?YG#&&&@@@@#5: .^5#5: .:   :?YG#5!^^... . :.:  .. .... .    :^[email protected]@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@&##Y^^7JB&&@@@&@@G^.J#@G: .5J. .?5#@@B?~.    ...         .        [email protected]@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@&GG57!~!~JB&@BYJY##[email protected]@P. ^B&J. ::7GG^.            ..              :[email protected]@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@&BGPJ7J?!~!~7B&&&?   ~!: !&@#~ 7&@P:    7B~                              ?&@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@&J^^^75GGB&&@@@@&PYJP#B! !&@&[email protected]@G^    J&Y.             .:^!!^          :[email protected]@@@@@@@@@@    //
//    @@@@@@@@@@@@@@#!  !G&@@@@@@@@@@@@@@@@B!?&@@&&##@&J:   :P&J.   ^7^7P5YY5B##YP#P!.   ..   7#@@@@@@@@@@    //
//    @@@@@@@@@@@@@@P:^Y#@@@@@@@&&@@&##&@@@@@&@@@@##@&&B5?~. ^B#~ ^Y5G#@@@@@@#Y7.75J!.        .J&@@@@@@@@@    //
//    @@@@@@@@@@@@@[email protected]@@&#BG57^:^:....!P#@@@@@@&GYPG^.   [email protected]@@@@@&GY!~:.     ..     [email protected]@@@@@@@@@    //
//    @@@@@@@@@@@@&J~J&@&5^.:.     .:::::.!#@@@@P^.?#@B?: :..:: .7#@@@&BBY~...          ..  .::7#@@@@@@@@@    //
//    @@@@@@@@@@@@BJY&&P7:^75BBGPB#&@&B#&&&@@@B57^J&@@@#!.~.   ~?5&@###GGPJ7!~^^:...   ...   !?Y&@@@@@@@@@    //
//    @@@@@@@@@@@&5J5?~7PG#@@@@@&G5JJJP&@@@@&#B5J5&@@@##G~     .^^^[email protected]@@@@@##BGBGBB#BY7^.    :^[email protected]@@@@@@@@    //
//    @@@@@@@@@@@BJY55B&@@GJYJ?7~^^[email protected]@&B5!^!P#&@@@&GGY~          .~?PPBGJ~.   :^^~~7#G^     [email protected]@@@@@@@@    //
//    @@@@@@@@@@&J:^5&@&#G5YJJPG#@@@@&&#?!?7:  :[email protected]@@@#B!.             .:~~!~^:^:. ... ^?!.     ?&@@@@@@@@    //
//    @@@@@@@@@#5~:!YBPP##Y7!?P##[email protected]&5!7?5&@@@@&#J^.        ..      ...:^^::J5J^        .?&@@@@@@@@    //
//    @@@@@@@@#?!^^!5&@@@&BG?Y?J!!JJB&@@@@BB#@@&@&@@@@Y:.    :.    .~^.           ..     .:..  :#@@@@@@@@@    //
//    @@@@@@@@##GGBGB&@@@@@@&#BPJYG#&@@@@BY^7GBY~::7J7~. .          :&B!                  .:::  [email protected]@@@@@@@@    //
//    @@@@@@@@G&@5J##[email protected]@@@@@[email protected]@@@@@@P   .?JJY^?&B?:..            [email protected]@P:              :!^::. [email protected]@@@@@@@@    //
//    @@@@@@@@@&@P~PGJG&BBG#[email protected]@@@@@@B  ^P&@&#[email protected]@@@&#?  .^7JYJ!. ^@@@@B~            ..:: :::[email protected]@@@@@@@@    //
//    @@@@@@@@@@@Y7Y!^~?~~~YJYP#&@@@@@@@@J~&@@@@&&@@@@@@?  !GBG#@G. ^[email protected]@@@&?.            ..:^~~^[email protected]@@@@@@@@    //
//    @@@@@@@&&55P7~^:^..~Y55G&@@@@@@@@@@@@@GJ?JB&@@@@B~7^     .^   [email protected]@@#5?:         ....:^^~?P&@@@@@@@    //
//    @@@@@@[email protected]@@@@@@@@5~:[email protected]@5YY5:        .    [email protected]@@@&P^         .  [email protected]@@@@@@@@@    //
//    @@@@@@#B&GYJP##@&##&&B5^  ?&@@@@@@@B555PJ5&B?7JGY!!JP!.^.       :Y&@@@&J:    .:. ..  ...^[email protected]@@@@@@@@@    //
//    @@@@@@&[email protected]@@@@@@#7.  [email protected]@@@@@@@&&@&&#GB?~:[email protected]@@@@@B5BP!.       ?&@@@&7     :.     . .^[email protected]@@@@@@@@@    //
//    @@@@@@[email protected]@@&@@@@B5~   ?&@@@@@@@@@@@@@J:7: J##@@@@BY~7J~::~~7:  [email protected]@@@&!           ...^[email protected]@@@@@@@@@    //
//    @@@@@@&5!?YJ5GB&@@@&G^  ~#@@@@@@@@@@@@@#?.  :Y???7JJ~.  ~: :5J7:.  ^JP#@@B~.         ....J#@@@@@@@@@    //
//    @@@@@@@@@BYJYB&@@@@&P!.^J#@@@&@@&#BGB&&#GJ7J55YJ7!!!7!~!^.   .:      .^[email protected]@@5      ...   . ^&@@@@@@@@    //
//    @@@@@[email protected]&B#&&GB&@@@@[email protected]@@@@P55P:~!J&@@@@@@&###&#P55P&&&G!^   ...   .:[email protected]@#.      :.. .:[email protected]@@@@@@@@    //
//    @@@@@[email protected]#[email protected]&#&&G&@@@B. :&@@@@@Y755^7#@@&BP&5~.   :.    .^[email protected]^   .     ^@@@~     . . ....#@@@@@@@@@    //
//    @@@@@PB&@@@@[email protected]&&@@@@P: ~#&@@@G&@BP#@@@#!  ^                 !JG!..      .P&@#~.        . [email protected]@@@@@@@@    //
//    @@@@@@#Y#@@@@@@@@#&@&Y. !#@@@@@#J5#@B7::^??YY?!7?JY7~~~~?J??J7^J#P.   :. .?&&G~       . :5G&@@@@@@@@    //
//    @@@@@@@&&@@@@@@@@&@@@P. ^&@@@@@5:7YPYJP&@@@@@@@@@@#@@@@@@@@@@@@@@@7  .PJ  ~#@G:    .::. [email protected]@@@@@@@@    //
//    @@@@@@@@&@@@@@@@@@@@@G. [email protected]@@@@? ^#@@@@@@@@@@@@@@@PP#@@@@@@@@@@@@@B:  7#J.!7G?!   ..::7::~&@@@@@@@@@    //
//    @@@@@@@@@##@@@@@@@@@@J   !&@@@B. [email protected]@@@@@@@@@@@@@@&BP#@@@@@@@@@@@@@7   5B..P&~. ..  : ::G#@@@@@@@@@@    //
//    @@@@@@@@@@#[email protected]@@@@@@#Y?. [email protected]@&P!  !#@@@@@BGGBBG5GG&@B5&@@#[email protected]@@@@@&?  ^JB~7&G^..     .!Y&@@@@@@@@@@@    //
//    @@@@@@@@@@@@@#B#&@@&#5:  5&@@@!. ~&@@@@@@&&###GJPG5Y5J5BB5J#@@@@@@J   [email protected]~?:.^..  ~^~&@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@#PG#&@&J ^?B#&@G!^5&@@@@@&GGGBGG575G5?GGY#[email protected]@@@@#Y:  ^PBJ:. ..:^:^?J7?&@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@&P&&@@P~^^?!#@#G~:J&@@@@@@@@@&[email protected]@@@@@#?   .:J&G!.  ..:^^^[email protected]@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@&#@@@&##[email protected]@@#[email protected]@@@@@@@@BGBBP55G5YY#@@@@@@@5     .?G#5..  .^[email protected]@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@&J~ [email protected]@@@@?: ^&&P&@@@@BP&&GG#@&?J#@@@@@@@B:      [email protected]~   ^[email protected]&@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@[email protected]@@@@BJ^ :: [email protected]@@@@@@@&@@@#5#@@@@@@@#:      [email protected]@P. .:5JG#@B&@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@&#&[email protected]@@@@&G?:   [email protected]@@@@@@@@@@@@@@@@@@@P.       :[email protected]@#~ ~P7??#[email protected]@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@#@&&@#Y&G&@@@@&##!?^   [email protected]@@@@@@@@@@@@@@@@@5         ^JG&B!~~PJ^[email protected]@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@&@@#GB^~5#@@@@@#[email protected]! [email protected]@@@@@@@@@@@@@@@#:       [email protected]~!BG#&5&[email protected]@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@G5G&[email protected]@@@@@@&GG?7&@@7.!PG&@@@&##@&@B&#7  .  .  ~BP55! .:G&@&[email protected]@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@[email protected]@@@@@@@@@@#?JGY?&&&5  ..^^^~..?7PYP.   .     !&GJP^ :.:[email protected]@[email protected]@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@G&@@@@@[email protected]@@@@@@P^[email protected]@@BY!7.:^JGP!?P!^  .^~.    .#@#&7: :!..~G&#&@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@#GB#[email protected]@@@@@@&?!P&@@@@@@&B#&@@@GJ!^^ .:::   .:[email protected]@&#J.:..:Y7Y&@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@BG#[email protected]@@@@@@@&&&@@@#&@##@&##5YBP7 .....      [email protected]@&B57:[email protected]@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@&B#@&&&&@@@@@@@&@B&@###P!^:~5G5.:~^...  ^[email protected]~!.?57Y5B#@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@&#&B##Y^7&@@@@@@@@@@@@@@&B77~!?!^!:.    :[email protected]@GJ:^7J7:?YGG&@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@&P?Y?J&G#@@@@@@@@@##@@@BJYY?J??~.    7&@@G: 77 .?GBB#@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@G7Y55&YG&#&#GGGGG#&&&&PJ5!~7Y7:^:.^^JGB&G?~~: .JPY#&@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@##GPBJ5#&#57!G#PBBGGGJJ~!5#J5????~:!G?P#J: :7YJP&@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@BP##5B#G#G?P5JB#GYYBY?:~#@GPYJ^...:^7BBJ:~!YB&@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@#&&@&[email protected]@#P^  ^!~~^YJ^^^77P&@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&@@@@@#[email protected]&@@#&#YJ:.~J&&@#P7^755!7YY7^?5#@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@#[email protected]@@@@@@@@&&Y.7#@@#G&#[email protected]&#@##@#P&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@&@&&@@@@@@[email protected]@@@@@@@@&&#@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@&@@@@@&&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    //
//                                                                                                            //
//                                                                                                            //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


contract BAIRDNAKED is ERC721Creator {
    constructor() ERC721Creator("Baird vs Baird", "BAIRDNAKED") {}
}