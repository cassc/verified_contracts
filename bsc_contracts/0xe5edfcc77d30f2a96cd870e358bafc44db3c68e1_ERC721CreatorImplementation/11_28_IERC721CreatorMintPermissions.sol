// SPDX-License-Identifier: MIT

pragma solidity ^0.8.15;

import "openzeppelin-contracts/contracts/utils/introspection/IERC165.sol";

/**
 * @dev Required interface of an ERC721Creator compliant extension contracts.
 */
interface IERC721CreatorMintPermissions is IERC165 {
    /**
     * @dev get approval to mint
     */
    function approveMint(
        address extension,
        address to,
        uint256 tokenId
    ) external;
}