// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract OperatorRole is OwnableUpgradeable {
    mapping(address => bool) public operators;

    function __OperatorRole_init() external initializer {
        __Context_init_unchained();
        __Ownable_init_unchained();
    }

    function addOperator(address operator) external onlyOwner {
        operators[operator] = true;
    }

    function removeOperator(address operator) external onlyOwner {
        operators[operator] = false;
    }

    modifier onlyOperator() {
        require(operators[_msgSender()], "OperatorRole: caller is not the operator");
        _;
    }
}