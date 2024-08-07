// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
/// @title Interface for Token

pragma solidity ^0.8.15;

abstract contract IToken {

    function setProvenanceHash(string memory _provenanceHash) virtual external;

    function mint(uint256 _count, address _recipient) virtual external;

    function setBaseURI(string memory baseURI) virtual external;

    function updateMinter(address _minter) virtual external;

    function lockMinter() virtual external;

    function tokenCount() virtual external returns (uint256);
}