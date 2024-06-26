// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {ERC721} from "../ERC721.sol";

abstract contract ERC721Burnable is ERC721 {

    function burn(uint256[] memory tokenIds) public virtual {
        uint256 n = tokenIds.length;

        for (uint256 i = 0; i < n; i++) {
            _burn(tokenIds[i], true);
        }
    }

    function burn(uint256 tokenId) public virtual {
        _burn(tokenId, true);
    }

    function totalBurned() external view returns (uint256) {
        return _totalBurned();
    }

    function totalBurnedBy(address account) external view returns (uint256) {
        return _numberBurned(account);
    }
}