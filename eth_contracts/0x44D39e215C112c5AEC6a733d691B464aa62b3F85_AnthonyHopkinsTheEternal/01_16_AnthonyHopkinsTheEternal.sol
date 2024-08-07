// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { ERC721PartnerSeaDrop } from "../ERC721PartnerSeaDrop.sol";

//       @@@@@@@@@@@ @@@@   @@@@  @@@@@@@@     @@@@@@@@@@@@@@@@@@ @@@@@@@@ @@@@@@@@    @@@@     @     @@@     @@@@
//           @@@@    @@@@   @@@@  @@@@         @@@@       @@@@    @@@@     @@@@  @@@@  @@@@@    @     @@@@    @@@@
//           @@@@    @@@@   @@@@  @@@@         @@@@       @@@@    @@@@     @@@@  @@@@  @ @@@@   @    @ @@@@   @@@@
//           @@@@    @@@@@@@@@@@  @@@@@@@      @@@@@@@    @@@@    @@@@@@@  @@@@  @@@@  @  @@@@  @   @  @@@@   @@@@
//           @@@@    @@@@   @@@@  @@@@         @@@@       @@@@    @@@@     @@@@ @@@@   @   @@@@@@   @   @@@@  @@@@
//           @@@@    @@@@   @@@@  @@@@         @@@@       @@@@    @@@@     @@@@  @@@@  @    @@@@@  @    @@@@  @@@@
//           @@@@    @@@@   @@@@  @@@@@@@@     @@@@@@@@   @@@@    @@@@@@@@ @@@@   @@@@ @@     @@@ @@     @@@@ @@@@@@@@
//
//
//
//
//                                                                                                @@@@@@@
//                     @@@@@@@@@                        @%#          &&                      @@@@@@@@@@
//                   [email protected]@@  &@@@@@@@@                            (/                         [email protected]@@@@@@@@@@@@@@@@@@@@@@,
//          @@@@@@@@@@@@@@@@@@@@@@@@@@                        &%@@#                      ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@
//     @%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      /  @                      &@@@,@&@@@@@@@@@@@@@@@@@@@@@@@@@  @
// @@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&&               (@   #@&(    &#&             (@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@
//  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(           ,   . ##@ %#  & %&           &((@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@
// @@@@@@@@@@%@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@(@@         ,@@@@@@@@@@@@@@%        &*&@@*@@@@@@@@@@@@@@@*@@@@@@@@@@@@@@@@@@ @@
//  &@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@#@#&@&@@ (/@% (&@&@@@@@@ (@@#@/,&#@@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@
// @@@ @@@@@@@@@@@&@@@%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@.%&@@@@@&@@@@@@@@@@*(@@*&@@@*@@@@@@@@@@@@@@@@@@@@@@@@@@@%&&@@@@@# @@@
//   &@@@@ @@@@@@&#&@%@@@@@@@&@@@@@@@@@@@@@@@@#@@@% (#@@@@@@/@&@@@@@@@@@@.&@ @@.&@@@&@@@@@@@&@@@@@@&&@@@@@@# @@@@& @@@@@#
// @@@@@  @@@@@@@&%@&@@@@@@@%&@@@@(&&@@@@@@@@@@@@@ @*@@@@@@&@@@@@@@@@@@@@@@[email protected] ( @@&@@@@@@@@@@&@@%@@ ,(((@@@@@% @@&@& @@@@@.
// @@@  /@@@@,@&@& &@@@@@@@&@@@@@@&&@@@@@@@@@@@@&@@@@@@@@@@@#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%%@&@&@%&%#@@@@@@@&  @@@@  @@@@
// @   @@@@@*@@@& %&@@@@@@@@&@@@@%@@@@@@@@@@@@@@@@@@@@@@@@@%&@@@@@@@@@@@@@@@@@@@@&[email protected]@@@@@@@@&@@@@@@@#@(&@@@@@@@@   @@@@   @
//    /@@@ @@@@   @@@@@@@@@ @&& @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&@@@@@@@@@@@@@@@@@@@@@@ @&@ @@* @@@ @@@    @@@
//   (@,  *@@%   @@@&@##@   @#  @@@@@@@@@@@@@@@@@@@@@@&#&@@@@@@@@@@@@@@@& @@@@@@@@@@@@@@@@@@*@@@@  #@   /  @&  %@@
//        @      @&             &@ @@@@@@@@@@@@@@@@@@@@@&@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @
//                                  @ @@@%&@%@@@@@@@&%@@@@@@@@@ @@@@,&@@&@@@/@@@@@@@@@@@@@@ &
//                                      .%(@@@@@@@@@ @@@@@@ @@@ &(@   #@@@@@@@@@@@@@@*%@
//                                           / @@@&@ #@&    &@@&@@%         #&/@@@
//                                                           @@&@.
//                                                           &@@@
//                                                           (@@&
//                                                           @@@&
//                                                           @@@

/**
 * @notice This contract uses ERC721PartnerSeaDrop,
 *         an ERC721A token contract that is compatible with SeaDrop.
 */
contract AnthonyHopkinsTheEternal is ERC721PartnerSeaDrop {
    /// @notice An event emitted when the terms URI is updated.
    event TermsURIUpdated(string newTermsURI);

    /// @notice Store the Terms of Service URI.
    string _termsURI;

    /**
     * @notice Deploy the token contract with its name, symbol,
     *         administrator, and allowed SeaDrop addresses.
     */
    constructor(
        string memory name,
        string memory symbol,
        address administrator,
        address[] memory allowedSeaDrop
    ) ERC721PartnerSeaDrop(name, symbol, administrator, allowedSeaDrop) {}

    /**
     * @notice Returns the Terms of Service URI.
     */
    function termsURI() external view returns (string memory) {
        return _termsURI;
    }

    /**
     * @notice Sets the Terms of Service URI.
     *         Only callable by the owner of the contract.
     *
     * @param newTermsURI The new terms URI.
     */
    function setTermsURI(string calldata newTermsURI) external onlyOwner {
        // Set the new terms URI.
        _termsURI = newTermsURI;

        // Emit an event with the update.
        emit TermsURIUpdated(newTermsURI);
    }
}