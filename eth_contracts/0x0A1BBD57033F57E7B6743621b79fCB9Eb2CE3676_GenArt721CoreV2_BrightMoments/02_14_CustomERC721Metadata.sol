// SPDX-License-Identifier: LGPL-3.0-only
// Created By: Art Blocks Inc.

// **Please Note**: This library is not necessary for ^0.8.0 contracts and thus
//                  only exists for posterity reasons for compatibility with
//                  existing already-deployed ^0.5.0 PBAB contracts.

pragma solidity ^0.5.0;

import "@openzeppelin-0.5/contracts/introspection/ERC165.sol";
import "@openzeppelin-0.5/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin-0.5/contracts/token/ERC721/ERC721Enumerable.sol";

/**
 * ERC721 base contract without the concept of tokenUri as this is managed by the parent
 */
contract CustomERC721Metadata is ERC165, ERC721, ERC721Enumerable {
    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;

    /**
     * @dev Constructor function
     */
    constructor(string memory name, string memory symbol) public {
        _name = name;
        _symbol = symbol;

        // register the supported interfaces to conform to ERC721 via ERC165
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
    }

    /**
     * @dev Gets the token name
     * @return string representing the token name
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Gets the token symbol
     * @return string representing the token symbol
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }
}