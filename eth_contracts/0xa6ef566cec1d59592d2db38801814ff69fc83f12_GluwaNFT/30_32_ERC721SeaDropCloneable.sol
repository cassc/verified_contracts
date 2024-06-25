// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { ERC721ContractMetadataCloneable, ISeaDropTokenContractMetadata } from './ERC721ContractMetadataCloneable.sol';
import { INonFungibleSeaDropToken } from '../interfaces/INonFungibleSeaDropToken.sol';
import { ISeaDrop } from '../interfaces/ISeaDrop.sol';
import { AllowListData, PublicDrop, TokenGatedDropStage, SignedMintValidationParams } from '../lib/SeaDropStructs.sol';
import { ERC721SeaDropStructsErrorsAndEvents } from '../lib/ERC721SeaDropStructsErrorsAndEvents.sol';
import { ERC721ACloneable } from './ERC721ACloneable.sol';
import { ReentrancyGuardUpgradeable } from '@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol';
import { IERC165 } from '@openzeppelin/contracts/utils/introspection/IERC165.sol';
import { DefaultOperatorFiltererUpgradeable } from './DefaultOperatorFiltererUpgradeable.sol';

/**
 * @title  ERC721SeaDrop
 * @author James Wenzel (emo.eth)
 * @author Ryan Ghods (ralxz.eth)
 * @author Stephan Min (stephanm.eth)
 * @notice ERC721SeaDrop is a token contract that contains methods
 *         to properly interact with SeaDrop.
 */
contract ERC721SeaDropCloneable is
    ERC721ContractMetadataCloneable,
    INonFungibleSeaDropToken,
    ERC721SeaDropStructsErrorsAndEvents,
    ReentrancyGuardUpgradeable,
    DefaultOperatorFiltererUpgradeable
{
    /// @notice Track the allowed SeaDrop addresses.
    mapping(address => bool) internal _whitelist;

    /// @notice Track the enumerated allowed SeaDrop addresses.
    address[] internal _enumeratedAllowedSeaDrop;

    /// @notice Return if a address is whitelisted
    /// @param account The address to verify
    /// @return True if the address is whitelisted, false if not
    function isWhitelist(address account) public view returns (bool) {
        return _whitelist[account];
    }

    /// @notice Whitelisting function
    /// @param listAddress The addresses that will be whitelisted
    /// @dev Caller must be an admin
    function whitelist(address[] calldata listAddress) public virtual hasAdminRole {
        uint256 length = listAddress.length;
        for (uint256 i; i < length; ) {
            _whitelist[listAddress[i]] = true;
            unchecked {
                ++i;
            }
        }
        // Emit an event for the update.
        emit AllowedSeaDropUpdated(listAddress);
    }

    /// @notice Unwhitelisting function
    /// @param listAddress The addresses that will be unwhitelisted
    /// @dev Caller must be an admin
    function unwhitelist(address[] calldata listAddress) external virtual hasAdminRole {
        uint256 length = listAddress.length;
        for (uint256 i; i < length; ) {
            _whitelist[listAddress[i]] = false;
            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Deploy the token contract with its name, symbol,
     *         and allowed SeaDrop addresses.
     */
    function initialize(string calldata __name, string calldata __symbol, address[] calldata __whiteList, address initialOwner) public initializer {
        __ERC721ACloneable__init(__name, __symbol);
        __ReentrancyGuard_init();
        __DefaultOperatorFilterer_init();
        _transferOwnership(initialOwner);
        _setupRole(DEFAULT_ADMIN_ROLE, initialOwner);
        whitelist(__whiteList);
        emit SeaDropTokenDeployed();
    }

    /**
     * @notice Update the allowed SeaDrop contracts.
     *         Only the owner or administrator can use this function.
     *
     * @param __whiteList The allowed SeaDrop addresses.
     */
    function updateAllowedSeaDrop(address[] calldata __whiteList) external virtual override onlyOwner {
        whitelist(__whiteList);
    }

    /**
     * @dev Overrides the `tokenURI()` function from ERC721A
     *      to return just the base URI if it is implied to not be a directory.
     *
     *      This is to help with ERC721 contracts in which the same token URI
     *      is desired for each token, such as when the tokenURI is 'unrevealed'.
     */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        if (!_exists(tokenId)) revert URIQueryForNonexistentToken();

        string memory baseURI = _baseURI();

        // Exit early if the baseURI is empty.
        if (bytes(baseURI).length == 0) {
            return '';
        }

        // Check if the last character in baseURI is a slash.
        if (bytes(baseURI)[bytes(baseURI).length - 1] != bytes('/')[0]) {
            return baseURI;
        }

        return string(abi.encodePacked(baseURI, _toString(tokenId)));
    }

    /**
     * @notice Mint tokens, restricted to the SeaDrop contract.
     *
     * @dev    NOTE: If a token registers itself with multiple SeaDrop
     *         contracts, the implementation of this function should guard
     *         against reentrancy. If the implementing token uses
     *         _safeMint(), or a feeRecipient with a malicious receive() hook
     *         is specified, the token or fee recipients may be able to execute
     *         another mint in the same transaction via a separate SeaDrop
     *         contract.
     *         This is dangerous if an implementing token does not correctly
     *         update the minterNumMinted and currentTotalSupply values before
     *         transferring minted tokens, as SeaDrop references these values
     *         to enforce token limits on a per-wallet and per-stage basis.
     *
     *         ERC721A tracks these values automatically, but this note and
     *         nonReentrant modifier are left here to encourage best-practices
     *         when referencing this contract.
     *
     * @param minter   The address to mint to.
     * @param quantity The number of tokens to mint.
     */
    function mintSeaDrop(address minter, uint256 quantity) external virtual override nonReentrant {
        // Ensure the SeaDrop is allowed.
        require(isWhitelist(msg.sender), 'SeaDrop not whitelisted');

        // Extra safety check to ensure the max supply is not exceeded.
        if (_totalMinted() + quantity > maxSupply()) {
            revert MintQuantityExceedsMaxSupply(_totalMinted() + quantity, maxSupply());
        }

        // Mint the quantity of tokens to the minter.
        _safeMint(minter, quantity);
    }

    /**
     * @notice Update the public drop data for this nft contract on SeaDrop.
     *         Only the owner can use this function.
     *
     * @param seaDropImpl The allowed SeaDrop contract.
     * @param publicDrop  The public drop data.
     */
    function updatePublicDrop(address seaDropImpl, PublicDrop calldata publicDrop) external virtual override {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the public drop data on SeaDrop.
        ISeaDrop(seaDropImpl).updatePublicDrop(publicDrop);
    }

    /**
     * @notice Update the allow list data for this nft contract on SeaDrop.
     *         Only the owner can use this function.
     *
     * @param seaDropImpl   The allowed SeaDrop contract.
     * @param allowListData The allow list data.
     */
    function updateAllowList(address seaDropImpl, AllowListData calldata allowListData) external virtual override {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the allow list on SeaDrop.
        ISeaDrop(seaDropImpl).updateAllowList(allowListData);
    }

    /**
     * @notice Update the token gated drop stage data for this nft contract
     *         on SeaDrop.
     *         Only the owner can use this function.
     *
     *         Note: If two INonFungibleSeaDropToken tokens are doing
     *         simultaneous token gated drop promotions for each other,
     *         they can be minted by the same actor until
     *         `maxTokenSupplyForStage` is reached. Please ensure the
     *         `allowedNftToken` is not running an active drop during the
     *         `dropStage` time period.
     *
     * @param seaDropImpl     The allowed SeaDrop contract.
     * @param allowedNftToken The allowed nft token.
     * @param dropStage       The token gated drop stage data.
     */
    function updateTokenGatedDrop(address seaDropImpl, address allowedNftToken, TokenGatedDropStage calldata dropStage) external virtual override {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the token gated drop stage.
        ISeaDrop(seaDropImpl).updateTokenGatedDrop(allowedNftToken, dropStage);
    }

    /**
     * @notice Update the drop URI for this nft contract on SeaDrop.
     *         Only the owner can use this function.
     *
     * @param seaDropImpl The allowed SeaDrop contract.
     * @param dropURI     The new drop URI.
     */
    function updateDropURI(address seaDropImpl, string calldata dropURI) external virtual override {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the drop URI.
        ISeaDrop(seaDropImpl).updateDropURI(dropURI);
    }

    /**
     * @notice Update the creator payout address for this nft contract on
     *         SeaDrop.
     *         Only the owner can set the creator payout address.
     *
     * @param seaDropImpl   The allowed SeaDrop contract.
     * @param payoutAddress The new payout address.
     */
    function updateCreatorPayoutAddress(address seaDropImpl, address payoutAddress) external {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the creator payout address.
        ISeaDrop(seaDropImpl).updateCreatorPayoutAddress(payoutAddress);
    }

    /**
     * @notice Update the allowed fee recipient for this nft contract
     *         on SeaDrop.
     *         Only the owner can set the allowed fee recipient.
     *
     * @param seaDropImpl  The allowed SeaDrop contract.
     * @param feeRecipient The new fee recipient.
     * @param allowed      If the fee recipient is allowed.
     */
    function updateAllowedFeeRecipient(address seaDropImpl, address feeRecipient, bool allowed) external virtual {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the allowed fee recipient.
        ISeaDrop(seaDropImpl).updateAllowedFeeRecipient(feeRecipient, allowed);
    }

    /**
     * @notice Update the server-side signers for this nft contract
     *         on SeaDrop.
     *         Only the owner can use this function.
     *
     * @param seaDropImpl                The allowed SeaDrop contract.
     * @param signer                     The signer to update.
     * @param signedMintValidationParams Minimum and maximum parameters to
     *                                   enforce for signed mints.
     */
    function updateSignedMintValidationParams(
        address seaDropImpl,
        address signer,
        SignedMintValidationParams memory signedMintValidationParams
    ) external virtual override {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the signer.
        ISeaDrop(seaDropImpl).updateSignedMintValidationParams(signer, signedMintValidationParams);
    }

    /**
     * @notice Update the allowed payers for this nft contract on SeaDrop.
     *         Only the owner can use this function.
     *
     * @param seaDropImpl The allowed SeaDrop contract.
     * @param payer       The payer to update.
     * @param allowed     Whether the payer is allowed.
     */
    function updatePayer(address seaDropImpl, address payer, bool allowed) external virtual override {
        // Ensure the sender is only the owner or contract itself.
        _onlyOwnerOrSelf();

        require(isWhitelist(seaDropImpl), 'SeaDrop not whitelisted');

        // Update the payer.
        ISeaDrop(seaDropImpl).updatePayer(payer, allowed);
    }

    /**
     * @notice Returns a set of mint stats for the address.
     *         This assists SeaDrop in enforcing maxSupply,
     *         maxTotalMintableByWallet, and maxTokenSupplyForStage checks.
     *
     * @dev    NOTE: Implementing contracts should always update these numbers
     *         before transferring any tokens with _safeMint() to mitigate
     *         consequences of malicious onERC721Received() hooks.
     *
     * @param minter The minter address.
     */
    function getMintStats(address minter) external view override returns (uint256 minterNumMinted, uint256 currentTotalSupply, uint256 maxSupply) {
        minterNumMinted = _numberMinted(minter);
        currentTotalSupply = _totalMinted();
        maxSupply = _maxSupply;
    }

    /**
     * @notice Returns whether the interface is supported.
     *
     * @param interfaceId The interface id to check against.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721ContractMetadataCloneable) returns (bool) {
        return
            interfaceId == type(INonFungibleSeaDropToken).interfaceId ||
            interfaceId == type(ISeaDropTokenContractMetadata).interfaceId ||
            // ERC721ContractMetadata returns supportsInterface true for
            //     EIP-2981
            // ERC721A returns supportsInterface true for
            //     ERC165, ERC721, ERC721Metadata
            super.supportsInterface(interfaceId);
    }

    /**
     * @notice Configure multiple properties at a time.
     *
     *         Note: The individual configure methods should be used
     *         to unset or reset any properties to zero, as this method
     *         will ignore zero-value properties in the config struct.
     *
     * @param config The configuration struct.
     */
    function multiConfigure(MultiConfigureStruct calldata config) external onlyOwner {
        if (config.maxSupply > 0) {
            this.setMaxSupply(config.maxSupply);
        }
        if (bytes(config.baseURI).length != 0) {
            this.setBaseURI(config.baseURI);
        }
        if (bytes(config.contractURI).length != 0) {
            this.setContractURI(config.contractURI);
        }
        if (_cast(config.publicDrop.startTime != 0) | _cast(config.publicDrop.endTime != 0) == 1) {
            this.updatePublicDrop(config.seaDropImpl, config.publicDrop);
        }
        if (bytes(config.dropURI).length != 0) {
            this.updateDropURI(config.seaDropImpl, config.dropURI);
        }
        if (config.allowListData.merkleRoot != bytes32(0)) {
            this.updateAllowList(config.seaDropImpl, config.allowListData);
        }
        if (config.creatorPayoutAddress != address(0)) {
            this.updateCreatorPayoutAddress(config.seaDropImpl, config.creatorPayoutAddress);
        }
        if (config.provenanceHash != bytes32(0)) {
            this.setProvenanceHash(config.provenanceHash);
        }
        if (config.allowedFeeRecipients.length > 0) {
            for (uint256 i; i < config.allowedFeeRecipients.length; ) {
                this.updateAllowedFeeRecipient(config.seaDropImpl, config.allowedFeeRecipients[i], true);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.disallowedFeeRecipients.length > 0) {
            for (uint256 i; i < config.disallowedFeeRecipients.length; ) {
                this.updateAllowedFeeRecipient(config.seaDropImpl, config.disallowedFeeRecipients[i], false);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.allowedPayers.length > 0) {
            for (uint256 i; i < config.allowedPayers.length; ) {
                this.updatePayer(config.seaDropImpl, config.allowedPayers[i], true);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.disallowedPayers.length > 0) {
            for (uint256 i; i < config.disallowedPayers.length; ) {
                this.updatePayer(config.seaDropImpl, config.disallowedPayers[i], false);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.tokenGatedDropStages.length > 0) {
            if (config.tokenGatedDropStages.length != config.tokenGatedAllowedNftTokens.length) {
                revert TokenGatedMismatch();
            }
            for (uint256 i; i < config.tokenGatedDropStages.length; ) {
                this.updateTokenGatedDrop(config.seaDropImpl, config.tokenGatedAllowedNftTokens[i], config.tokenGatedDropStages[i]);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.disallowedTokenGatedAllowedNftTokens.length > 0) {
            for (uint256 i; i < config.disallowedTokenGatedAllowedNftTokens.length; ) {
                TokenGatedDropStage memory emptyStage;
                this.updateTokenGatedDrop(config.seaDropImpl, config.disallowedTokenGatedAllowedNftTokens[i], emptyStage);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.signedMintValidationParams.length > 0) {
            if (config.signedMintValidationParams.length != config.signers.length) {
                revert SignersMismatch();
            }
            for (uint256 i; i < config.signedMintValidationParams.length; ) {
                this.updateSignedMintValidationParams(config.seaDropImpl, config.signers[i], config.signedMintValidationParams[i]);
                unchecked {
                    ++i;
                }
            }
        }
        if (config.disallowedSigners.length > 0) {
            for (uint256 i; i < config.disallowedSigners.length; ) {
                SignedMintValidationParams memory emptyParams;
                this.updateSignedMintValidationParams(config.seaDropImpl, config.disallowedSigners[i], emptyParams);
                unchecked {
                    ++i;
                }
            }
        }
    }
}