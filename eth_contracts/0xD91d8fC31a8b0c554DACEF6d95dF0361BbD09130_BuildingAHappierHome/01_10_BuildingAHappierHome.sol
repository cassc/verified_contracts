// SPDX-License-Identifier: MIT

/// @title Building a Happier Home
/// @author transientlabs.xyz

/*??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????
??                                                                                                                            ??
??    .---.  .---.     ,-----.    ,---.    ,---.    .-''-.          .-./`)    .-'''-.                                         ??
??    |   |  |_ _|   .'  .-,  '.  |    \  /    |  .'_ _   \         \ .-.')  / _     \                                        ??
??    |   |  ( ' )  / ,-.|  \ _ \ |  ,  \/  ,  | / ( ` )   '        / `-' \ (`' )/`--'                                        ??
??    |   '-(_{;}_);  \  '_ /  | :|  |\_   /|  |. (_ o _)  |         `-'`"`(_ o _).                                           ??
??    |      (_,_) |  _`,/ \ _/  ||  _( )_/ |  ||  (_,_)___|         .---.  (_,_). '.                                         ??
??    | _ _--.   | : (  '\_/ \   ;| (_ o _) |  |'  \   .---.         |   | .---.  \  :                                        ??
??    |( ' ) |   |  \ `"/  \  ) / |  (_,_)  |  | \  `-'    /         |   | \    `-'  |                                        ??
??    (_{;}_)|   |   '. \_/``".'  |  |      |  |  \       /          |   |  \       /                                         ??
??    '(_,_) '---'     '-----'    '--'      '--'   `'-..-'           '---'   `-...-'                                          ??
??    .--.      .--..---.  .---.     .-''-.  .-------.        .-''-.          ,---------. .---.  .---.     .-''-.             ??
??    |  |_     |  ||   |  |_ _|   .'_ _   \ |  _ _   \     .'_ _   \         \          \|   |  |_ _|   .'_ _   \            ??
??    | _( )_   |  ||   |  ( ' )  / ( ` )   '| ( ' )  |    / ( ` )   '         `--.  ,---'|   |  ( ' )  / ( ` )   '           ??
??    |(_ o _)  |  ||   '-(_{;}_). (_ o _)  ||(_ o _) /   . (_ o _)  |            |   \   |   '-(_{;}_). (_ o _)  |           ??
??    | (_,_) \ |  ||      (_,_) |  (_,_)___|| (_,_).' __ |  (_,_)___|            :_ _:   |      (_,_) |  (_,_)___|           ??
??    |  |/    \|  || _ _--.   | '  \   .---.|  |\ \  |  |'  \   .---.            (_I_)   | _ _--.   | '  \   .---.           ??
??    |  '  /\  `  ||( ' ) |   |  \  `-'    /|  | \ `'   / \  `-'    /           (_(=)_)  |( ' ) |   |  \  `-'    /           ??
??    |    /  \    |(_{;}_)|   |   \       / |  |  \    /   \       /             (_I_)   (_{;}_)|   |   \       /            ??
??    `---'    `---`'(_,_) '---'    `'-..-'  ''-'   `'-'     `'-..-'              '---'   '(_,_) '---'    `'-..-'             ??
??    .---.  .---.     .-''-.     ____    .-------. ,---------.         .-./`)    .-'''-.                                     ??
??    |   |  |_ _|   .'_ _   \  .'  __ `. |  _ _   \\          \        \ .-.')  / _     \                                    ??
??    |   |  ( ' )  / ( ` )   '/   '  \  \| ( ' )  | `--.  ,---'        / `-' \ (`' )/`--'                                    ??
??    |   '-(_{;}_). (_ o _)  ||___|  /  ||(_ o _) /    |   \            `-'`"`(_ o _).                                       ??
??    |      (_,_) |  (_,_)___|   _.-`   || (_,_).' __  :_ _:            .---.  (_,_). '.                                     ??
??    | _ _--.   | '  \   .---..'   _    ||  |\ \  |  | (_I_)            |   | .---.  \  : _ _                                ??
??    |( ' ) |   |  \  `-'    /|  _( )_  ||  | \ `'   /(_(=)_)           |   | \    `-'  |(_I_)                               ??
??    (_{;}_)|   |   \       / \ (_ o _) /|  |  \    /  (_I_)            |   |  \       /(_(=)_)                              ??
??    '(_,_) '---'    `'-..-'   '.(_,_).' ''-'   `'-'   '---'            '---'   `-...-'  (_I_)                               ??
??    .-./`)           .-_'''-.     ___    _     .-''-.     .-'''-.    .-'''-.  ,---.                                         ??
??    \ .-.')         '_( )_   \  .'   |  | |  .'_ _   \   / _     \  / _     \(     \                                        ??
??    / `-' \        |(_ o _)|  ' |   .'  | | / ( ` )   ' (`' )/`--' (`' )/`--' `-`.  \                                       ??
??     `-'`"`        . (_,_)/___| .'  '_  | |. (_ o _)  |(_ o _).   (_ o _).      (   /                                       ??
??     .---.         |  |  .-----.'   ( \.-.||  (_,_)___| (_,_). '.  (_,_). '.     `-'                                        ??
??     |   |         '  \  '-   .'' (`. _` /|'  \   .---..---.  \  :.---.  \  :    _ _                                        ??
??     |   |          \  `-'`   | | (_ (_) _) \  `-'    /\    `-'  |\    `-'  |   ( ' )                                       ??
??     |   |           \        /  \ /  . \ /  \       /  \       /  \       /   (_{;}_)                                      ??
??     '---'            `'-...-'    ``-'`-''    `'-..-'    `-...-'    `-...-'     (_,_)                                       ??
??                                                                                                                            ??
??????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????????*/

pragma solidity 0.8.19;

import {TLCreator} from "tl-creator-contracts/TLCreator.sol";

contract BuildingAHappierHome is TLCreator {
    constructor(
        address defaultRoyaltyRecipient,
        uint256 defaultRoyaltyPercentage,
        address[] memory admins,
        bool enableStory,
        address blockListRegistry
    )
    TLCreator(
        0x154DAc76755d2A372804a9C409683F2eeFa9e5e9,
        "Building a Happier Home",
        "BAHH",
        defaultRoyaltyRecipient,
        defaultRoyaltyPercentage,
        msg.sender,
        admins,
        enableStory,
        blockListRegistry
    )
    {}
}