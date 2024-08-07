// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import { ERC721PartnerSeaDrop } from "../ERC721PartnerSeaDrop.sol";

/*
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░▓▓▓▓▓▓▓▒░░░░░▒▓▓▓░░░░▒▓▓▓▓▓▓▓▓▒░░░░▓▓▓▓▓░░░▒▓▒░░░░▓▓░░░░░░░░░░
░░░░░░░░░░██▒▒▒▒██▒░░░░████░░░░░▒▒▓██▓▒▒░░░▒▓█▒▒▒█▓░░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░██░░░░▓█▓░░░▓█▓▓█▓░░░░░░░██░░░░░▒▓█▒░░░▒▓░░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░██▒▒▒▒██▒░░░██░░██▒░░░░░░██░░░░░▓██░░░░░░░░▓██▒▒▒▒██░░░░░░░░░░
░░░░░░░░░░██▓▓▓▓▓▒░░░▓██▒▒██▓░░░░░░██░░░░░▓██░░░░░░░░▓██▓▓▓▓██░░░░░░░░░░
░░░░░░░░░░██░░░░░░░░░▓███████░░░░░░██░░░░░▒██░░░░░░░░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░██░░░░░░░░▒██░░░░██▓░░░░░██░░░░░░▒██░░░██▒░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░██░░░░░░░░▒██░░░░██▓░░░░░██░░░░░░░▒█████░░░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░██░▓█░▓█▓░░░▒████▒░░░▒███████▒░░▓██░░░░██▒░░▓██████▒░░░░░░░░░░
░░░░░░░░░░██░▓█░▓█▓░░▓██░░▓█▓░░▒██░░░▒██▒░▓██░░░██▒░░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░██░▓█░▓█▓░▒██░░░░██▓░▒██░░░▒██░░▓██░▒██░░░░▓█▓░░░░░░░░░░░░░░░░
░░░░░░░░░░██░▓█░▓█▓░▒██░░░░██▓░▒██████▒░░░▓████▓░░░░░░▓██████░░░░░░░░░░░
░░░░░░░░░░▒█▒██▓▓█░░▒██░░░░██▓░▒██░░▓█▓░░░▓██░▓██░░░░░░░░░░░██░░░░░░░░░░
░░░░░░░░░░▒██▓▒███░░░▓█▓░░▓██░░▒██░░░██▒░░▓██░░░██▒░░▓█▓░░░░██░░░░░░░░░░
░░░░░░░░░░░██░░▓█▒░░░░▒█▓▓█▓░░░▒██░░░░██▒░▓██░░░▒██░░░▓█▓▓▓▓█▒░░░░░░░░░░
░░░░░░░░░░░▒▒░░░▒░░░░░░▒▒▒▒░░░░░▒▒░░░░▒▒░░░▒▒░░░░▒▒░░░░▒▒▒▒▒▒░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒░░▒▒▒░░░░▒▒░░░░░░░░░░░░░░░░░▒▒░░░░░░░░░░░░
░░░░░░░░░░░▓█▓▓▓▓█▓░░░▓▓▓▓▓███░░▓██▓░░░██░░░░░░░░░░░░░░░▒▓██░░░░░░░░░░░░
░░░░░░░░░░▒██░░░░▓▓▒░░░░░░░▓█▓░░▓███▒░░██░░░░░░░░░░░░░░░▓███░░░░░░░░░░░░
░░░░░░░░░░▒██░░░░░░░░░░░░░▒██░░░▓████░░██░░░░░░░░░░░░░░░░▓██░░░░░░░░░░░░
░░░░░░░░░░░▒██████▒░░░░░░██▒░░░░▓█▓▒██░██░░░░░░░░░░░░░░░░▓██░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░██▒░░░▓█▓░░░░░░▓█▓░▒████░░░░░░░░░░░░░░░░▓██░░░░░░░░░░░░
░░░░░░░░░░▒██░░░░██▒░░██▒░░░░░░░▓█▓░░▒███░░░░░░░░░░░░░░░░▓██░░░░░░░░░░░░
░░░░░░░░░░░▒██████▒░░░███████▓░░▓█▓░░░░██░░░░░░░░░░░░░░▓██████░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░                                                                    .:^~!!!!!!!!!!!!!!!!!!!!~^.                                     
*/

/**
 * @notice This contract uses ERC721PartnerSeaDrop,
 *         an ERC721A token contract that is compatible with SeaDrop.
 */
contract PATCHWORKS is ERC721PartnerSeaDrop {
    /// @notice The address that can burn for claiming.
    address burnableAddress;

    /**
     * @notice A token can only be burned by the set contract address.
     */
    error BurnIncorrectSender();

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
     * @notice Set the address that can burn items on this contract for claiming.
     *
     * @param newAddress The address to set.
     */
    function setBurnableAddress(address newAddress) external onlyOwner {
        burnableAddress = newAddress;
    }

    /**
     * @notice The address that can burn items on this contract for claiming.
     */
    function getBurnableAddress() public view returns (address) {
        return burnableAddress;
    }

    /**
     * @notice Destroys `tokenId`, only callable by the set burnable address.
     *
     * @param tokenId The token id to burn.
     */
    function burn(uint256 tokenId) external {
        if (msg.sender != burnableAddress) {
            revert BurnIncorrectSender();
        }

        _burn(tokenId);
    }
}