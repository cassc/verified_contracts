// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

abstract contract Soulbound is ERC721Enumerable
{
    error TokenIsSoulbound();

    /**
     * Disallows approval setting for soulbound functionality
     */
    function approve(address, uint256)
        public
        pure
        override(ERC721,IERC721)
    {
        revert TokenIsSoulbound();
    }

    /**
     * Disallows transfer for soulbound functionality
     */
    function safeTransferFrom(address, address, uint256)
        public
        pure
        override(ERC721,IERC721)
    {
        revert TokenIsSoulbound();
    }

    /**
     * Disallows transfer for soulbound functionality
     */
    function safeTransferFrom(address, address, uint256, bytes memory)
        public
        pure
        override(ERC721,IERC721)
    {
        revert TokenIsSoulbound();
    }

    /**
     * Disallows approval setting for soulbound functionality
     */
    function setApprovalForAll(address, bool)
        public
        pure
        override(ERC721,IERC721)
    {
        revert TokenIsSoulbound();
    }

    /**
     * Disallows transfer for soulbound functionality
     */
    function transferFrom(address, address, uint256)
        public
        pure
        override(ERC721,IERC721)
    {
        revert TokenIsSoulbound();
    }
}
// [email protected]_ved