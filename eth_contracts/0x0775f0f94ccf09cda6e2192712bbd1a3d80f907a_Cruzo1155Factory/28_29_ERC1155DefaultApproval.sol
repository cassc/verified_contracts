// SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol";

abstract contract ERC1155DefaultApproval is ERC1155Upgradeable {
    mapping(address => bool) private defaultApprovals;

    event DefaultApproval(address indexed operator, bool hasApproval);

    function _setDefaultApproval(address operator, bool hasApproval) internal {
        defaultApprovals[operator] = hasApproval;
        emit DefaultApproval(operator, hasApproval);
    }

    function isApprovedForAll(address _owner, address _operator)
        public
        view
        virtual
        override
        returns (bool)
    {
        return
            defaultApprovals[_operator] ||
            super.isApprovedForAll(_owner, _operator);
    }

    uint256[50] private __gap;
}