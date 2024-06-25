// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

/**

██╗  ██╗██╗████████╗███████╗
██║ ██╔╝██║╚══██╔══╝██╔════╝
█████╔╝ ██║   ██║   ███████╗
██╔═██╗ ██║   ██║   ╚════██║
██║  ██╗██║   ██║   ███████║
╚═╝  ╚═╝╚═╝   ╚═╝   ╚══════╝

Forked from Zora Drop by [email protected]

 */

import {ERC721AUpgradeable} from "erc721a-upgradeable/contracts/ERC721AUpgradeable.sol";
import {IERC721AUpgradeable} from "erc721a-upgradeable/contracts/IERC721AUpgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from "@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol";
import {AccessControlUpgradeable} from "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {MerkleProofUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/cryptography/MerkleProofUpgradeable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {IKitsFeeManager} from "../interfaces/IKitsFeeManager.sol";
import {IMetadataRenderer} from "../interfaces/IMetadataRenderer.sol";
import {IOperatorFilterRegistry} from "../interfaces/IOperatorFilterRegistry.sol";
import {IKitsERC721Drop} from "../interfaces/IKitsERC721Drop.sol";
import {IOwnable} from "../interfaces/IOwnable.sol";
import {IFactoryUpgradeGate} from "../interfaces/IFactoryUpgradeGate.sol";

import {OwnableSkeleton} from "./utils/OwnableSkeleton.sol";
import {FundsReceiver} from "./utils/FundsReceiver.sol";
import {Version} from "./utils/Version.sol";
import {ERC721DropStorageV1} from "./storage/ERC721DropStorageV1.sol";

/**
 * @notice Kits NFT Base contract for Drops and Editions. Forked from Zora's ERC721Drop contract by [email protected]
 *
 * Ownership of tokens in this contract entitles the owner to commercial use rights of sounds as specified in the
 * following Terms:
 *   ar://Pxi9M882YT8P68p6e2Lzl_McvgbdzfO5brVRgZlLaEc.
 *
 * Terms are also available at:
 *   https://h4ml2m6pgzqt6d7lzj5hwyxts7zrzpqg3xg7holowviydgklnbdq.arweave.net/Pxi9M882YT8P68p6e2Lzl_McvgbdzfO5brVRgZlLaEc
 *
 * @author [email protected], [email protected]
 *
 */
contract KitsERC721Drop is
    ERC721AUpgradeable,
    UUPSUpgradeable,
    IERC2981Upgradeable,
    ReentrancyGuardUpgradeable,
    AccessControlUpgradeable,
    IKitsERC721Drop,
    OwnableSkeleton,
    FundsReceiver,
    Version(9001),
    ERC721DropStorageV1
{
    /// @dev This is the max mint batch size for the optimized ERC721A mint contract
    uint256 internal immutable MAX_MINT_BATCH_SIZE = 8;

    /// @dev This is the magic number that means this is an open edition. formerly type(uint64).max
    uint64 internal immutable OPEN_EDITION_VOLUME_MAGIC_NUMBER = 99999999;

    /// @dev Gas limit to send funds
    uint256 internal immutable FUNDS_SEND_GAS_LIMIT = 210_000;

    /// @notice Access control roles
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
    bytes32 public immutable SALES_MANAGER_ROLE = keccak256("SALES_MANAGER");

    /// @dev KITS V3 transfer helper address for auto-approval
    address internal immutable kitsERC721TransferHelper;

    /// @dev Factory upgrade gate
    IFactoryUpgradeGate internal immutable factoryUpgradeGate;

    /// @dev Kits Fee Manager address
    IKitsFeeManager public immutable kitsFeeManager;

    /// @notice Max royalty BPS
    uint16 constant MAX_ROYALTY_BPS = 50_00;

    address immutable marketFilterDAOAddress;

    IOperatorFilterRegistry immutable operatorFilterRegistry =
        IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);

    /// @notice Only allow for users with admin access
    modifier onlyAdmin() {
        if (!hasRole(DEFAULT_ADMIN_ROLE, _msgSender())) {
            revert Access_OnlyAdmin();
        }

        _;
    }

    /// @notice Only a given role has access or admin
    /// @param role role to check for alongside the admin role
    modifier onlyRoleOrAdmin(bytes32 role) {
        if (
            !hasRole(DEFAULT_ADMIN_ROLE, _msgSender()) &&
            !hasRole(role, _msgSender())
        ) {
            revert Access_MissingRoleOrAdmin(role);
        }

        _;
    }

    /// @notice Allows user to mint tokens at a quantity
    modifier canMintPublicSaleTokens(uint256 quantity) {
        if (quantity + (_totalMinted()) > config.totalEditionSize) {
            revert Mint_SoldOut();
        }

        _;
    }

    /// @notice Allows user to mint presale tokens at a quantity
    modifier canMintPresaleTokens(uint256 quantity) {
        if (quantity + presaleMints > config.presaleEditionSize) {
            revert Mint_Presale_SoldOut();
        }

        _;
    }

    modifier senderHoldsAllowlistToken() {
        uint balance = IERC721AUpgradeable(salesConfig.allowlistContractAddress)
            .balanceOf(_msgSender());
        if (balance < 1) {
            revert Presale_UserNotAllowlist();
        }

        _;
    }

    function _presaleActive() internal view returns (bool) {
        return
            salesConfig.presaleStart <= block.timestamp &&
            salesConfig.presaleEnd > block.timestamp;
    }

    function _publicSaleActive() internal view returns (bool) {
        return
            salesConfig.publicSaleStart <= block.timestamp &&
            salesConfig.publicSaleEnd > block.timestamp;
    }

    /// @notice Presale active
    modifier onlyPresaleActive() {
        if (!_presaleActive()) {
            revert Presale_Inactive();
        }

        _;
    }

    /// @notice Public sale active
    modifier onlyPublicSaleActive() {
        if (!_publicSaleActive()) {
            revert Sale_Inactive();
        }

        _;
    }

    /// @notice Getter for last minted token ID (gets next token id and subtracts 1)
    function _lastMintedTokenId() internal view returns (uint256) {
        return _currentIndex - 1;
    }

    /// @notice Start token ID for minting (1-100 vs 0-99)
    function _startTokenId() internal pure override returns (uint256) {
        return 1;
    }

    /// @notice Global constructor – these variables will not change with further proxy deploys
    /// @dev Marked as an initializer to prevent storage being used of base implementation. Can only be init'd by a proxy.
    /// @param _kitsFeeManager Kits Fee Manager
    /// @param _kitsERC721TransferHelper Transfer helper
    constructor(
        IKitsFeeManager _kitsFeeManager,
        address _kitsERC721TransferHelper,
        IFactoryUpgradeGate _factoryUpgradeGate,
        address _marketFilterDAOAddress
    ) initializer {
        kitsFeeManager = _kitsFeeManager;
        kitsERC721TransferHelper = _kitsERC721TransferHelper;
        factoryUpgradeGate = _factoryUpgradeGate;
        marketFilterDAOAddress = _marketFilterDAOAddress;
    }

    ///  @dev Create a new drop contract
    ///  @param _contractName Contract name
    ///  @param _contractSymbol Contract symbol
    ///  @param _initialOwner User that owns and can mint the edition, gets royalty and sales payouts and can update the base url if needed.
    ///  @param _fundsRecipient Wallet/user that receives funds from sale
    ///  @param _totalEditionSize Number of editions that can be minted during public and presale. If OPEN_EDITION_VOLUME_MAGIC_NUMBER, unlimited editions can be minted as an open edition.
    ///  @param _presaleEditionSize Number of editions that can be minted during presale. If OPEN_EDITION_VOLUME_MAGIC_NUMBER, unlimited editions can be minted during presale.
    ///  @param _royaltyBPS BPS of the royalty set on the contract. Can be 0 for no royalty.
    ///  @param _salesConfig New sales config to set upon init
    ///  @param _metadataRenderer Renderer contract to use
    ///  @param _baseURI HTTP URI, up to but not including, the contract address. eg: https://arpeggi.io/api/v2/kits-metadata
    function initialize(
        string memory _contractName,
        string memory _contractSymbol,
        address _initialOwner,
        address payable _fundsRecipient,
        uint64 _totalEditionSize,
        uint64 _presaleEditionSize,
        uint16 _royaltyBPS,
        SalesConfiguration memory _salesConfig,
        IMetadataRenderer _metadataRenderer,
        string memory _baseURI
    ) public initializer {
        // Setup ERC721A
        __ERC721A_init(_contractName, _contractSymbol);
        // Setup access control
        __AccessControl_init();
        // Setup re-entracy guard
        __ReentrancyGuard_init();
        // Setup the owner role
        _setupRole(DEFAULT_ADMIN_ROLE, _initialOwner);
        // Set ownership to original sender of contract call
        _setOwner(_initialOwner);

        if (config.royaltyBPS > MAX_ROYALTY_BPS) {
            revert Setup_RoyaltyPercentageTooHigh(MAX_ROYALTY_BPS);
        }

        // Update salesConfig
        salesConfig = _salesConfig;

        // Setup config variables
        config.totalEditionSize = _totalEditionSize;
        config.presaleEditionSize = _presaleEditionSize;
        config.metadataRenderer = _metadataRenderer;
        config.royaltyBPS = _royaltyBPS;
        config.fundsRecipient = _fundsRecipient;

        baseURI = _baseURI;
    }

    /// @dev Getter for admin role associated with the contract to handle metadata
    /// @return boolean if address is admin
    function isAdmin(address user) external view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, user);
    }

    /// @dev Update the baseURI used by tokenURI
    function setBaseUri(string calldata baseUri_) public onlyAdmin {
        baseURI = baseUri_;
        emit UpdateBaseUri(msg.sender, baseUri_);
    }

    /// @notice Connects this contract to the factory upgrade gate
    /// @param newImplementation proposed new upgrade implementation
    /// @dev Only can be called by admin
    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyAdmin {
        if (
            !factoryUpgradeGate.isValidUpgradePath({
                _newImpl: newImplementation,
                _currentImpl: _getImplementation()
            })
        ) {
            revert Admin_InvalidUpgradeAddress(newImplementation);
        }
    }

    function getRarityTierId(uint256 tokenId) internal returns (uint256) {
        // iterate over the tiers to see if we have any open
        AvailableTiers[NUMBER_OF_RARITY_CONFIGS] memory tiersWithAvailability;
        uint256 numTiersWithAvailability = 0;

        for (uint i = 0; i < NUMBER_OF_RARITY_CONFIGS; i++) {
            uint tierMintsRemaining = rarityConfigs[i].tierVolume -
                rarityConfigs[i].volumeMinted;
            if (tierMintsRemaining > 0) {
                tiersWithAvailability[numTiersWithAvailability].rarityId = i;
                tiersWithAvailability[numTiersWithAvailability]
                    .tierMintsRemaining = tierMintsRemaining;
                numTiersWithAvailability++;
            }
        }

        uint256 totalMintsRemaining = config.totalEditionSize -
            _totalMinted() +
            1;

        uint256 random = uint256(
            keccak256(abi.encode(currentRandom, tokenId, block.timestamp))
        );

        uint256 roll = random % TARGET_RARITY_MOD;
        uint currentLowerBound = 0;

        for (uint i = 0; i < numTiersWithAvailability; i++) {
            // get percentage chance of minting at this tier
            uint chanceOutOfTargetMod = ((tiersWithAvailability[i]
                .tierMintsRemaining * TARGET_RARITY_MOD) /
                (totalMintsRemaining));

            if (
                roll >= currentLowerBound &&
                roll < (currentLowerBound + chanceOutOfTargetMod)
            ) {
                return tiersWithAvailability[i].rarityId;
            }

            currentLowerBound += chanceOutOfTargetMod;
        }
    }

    //        ,-.
    //        `-'
    //        /|\
    //         |             ,----------.
    //        / \            |KitsERC721Drop|
    //      Caller           `----+-----'
    //        |       burn()      |
    //        | ------------------>
    //        |                   |
    //        |                   |----.
    //        |                   |    | burn token
    //        |                   |<---'
    //      Caller           ,----+-----.
    //        ,-.            |KitsERC721Drop|
    //        `-'            `----------'
    //        /|\
    //         |
    //        / \
    /// @param tokenId Token ID to burn
    /// @notice User burn function for token id
    function burn(uint256 tokenId) public {
        _burn(tokenId, true);
    }

    /// @dev Get royalty information for token
    /// @param _salePrice Sale price for the token
    function royaltyInfo(
        uint256,
        uint256 _salePrice
    ) external view override returns (address receiver, uint256 royaltyAmount) {
        if (config.fundsRecipient == address(0)) {
            return (config.fundsRecipient, 0);
        }
        return (
            config.fundsRecipient,
            (_salePrice * config.royaltyBPS) / 10_000
        );
    }

    /// @notice Sale details
    /// @return IKitsERC721Drop.SaleDetails sale information details
    function saleDetails()
        external
        view
        returns (IKitsERC721Drop.SaleDetails memory)
    {
        return
            IKitsERC721Drop.SaleDetails({
                publicSaleActive: _publicSaleActive(),
                presaleActive: _presaleActive(),
                publicSalePrice: salesConfig.publicSalePrice,
                publicSaleStart: salesConfig.publicSaleStart,
                publicSaleEnd: salesConfig.publicSaleEnd,
                presaleStart: salesConfig.presaleStart,
                presaleEnd: salesConfig.presaleEnd,
                presaleMerkleRoot: salesConfig.presaleMerkleRoot,
                totalMinted: _totalMinted(),
                totalPreSaleMinted: presaleMints,
                maxSupply: config.totalEditionSize,
                maxSalePurchasePerAddress: salesConfig.maxSalePurchasePerAddress
            });
    }

    /// @dev Number of NFTs the user has minted per address
    /// @param minter to get counts for
    function mintedPerAddress(
        address minter
    )
        external
        view
        override
        returns (IKitsERC721Drop.AddressMintDetails memory)
    {
        return
            IKitsERC721Drop.AddressMintDetails({
                presaleMints: presaleMintsByAddress[minter],
                publicMints: _numberMinted(minter) -
                    presaleMintsByAddress[minter],
                totalMints: _numberMinted(minter)
            });
    }

    /// @dev Setup auto-approval for Kits v3 access to sell NFT
    ///      Still requires approval for module
    /// @param nftOwner owner of the nft
    /// @param operator operator wishing to transfer/burn/etc the NFTs
    function isApprovedForAll(
        address nftOwner,
        address operator
    ) public view override(ERC721AUpgradeable) returns (bool) {
        if (operator == kitsERC721TransferHelper) {
            return true;
        }
        return super.isApprovedForAll(nftOwner, operator);
    }

    /**
     *** ---------------------------------- ***
     ***                                    ***
     ***     PUBLIC MINTING FUNCTIONS       ***
     ***                                    ***
     *** ---------------------------------- ***
     ***/

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                       ,----------.
    //                       / \                      |KitsERC721Drop|
    //                     Caller                     `----+-----'
    //                       |          purchase()         |
    //                       | ---------------------------->
    //                       |                             |
    //                       |                             |
    //          ___________________________________________________________
    //          ! ALT  /  drop has no tokens left for caller to mint?      !
    //          !_____/      |                             |               !
    //          !            |    revert Mint_SoldOut()    |               !
    //          !            | <----------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                             |
    //                       |                             |
    //          ___________________________________________________________
    //          ! ALT  /  public sale isn't active?        |               !
    //          !_____/      |                             |               !
    //          !            |    revert Sale_Inactive()   |               !
    //          !            | <----------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                             |
    //                       |                             |
    //          ___________________________________________________________
    //          ! ALT  /  inadequate funds sent?           |               !
    //          !_____/      |                             |               !
    //          !            | revert Purchase_WrongPrice()|               !
    //          !            | <----------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                             |
    //                       |                             |----.
    //                       |                             |    | mint tokens
    //                       |                             |<---'
    //                       |                             |
    //                       |                             |----.
    //                       |                             |    | emit IKitsERC721Drop.Sale()
    //                       |                             |<---'
    //                       |                             |
    //                       | return first minted token ID|
    //                       | <----------------------------
    //                     Caller                     ,----+-----.
    //                       ,-.                      |KitsERC721Drop|
    //                       `-'                      `----------'
    //                       /|\
    //                        |
    //                       / \
    /**
      @dev This allows the user to purchase a edition edition
           at the given price in the contract.
     */
    function purchase(
        uint256 quantity
    )
        external
        payable
        nonReentrant
        canMintPublicSaleTokens(quantity)
        onlyPublicSaleActive
        returns (uint256)
    {
        uint256 salePrice = salesConfig.publicSalePrice;

        if (msg.value != salePrice * quantity) {
            revert Purchase_WrongPrice(salePrice * quantity);
        }

        // If max purchase per address == 0 there is no limit.
        // Any other number, the per address mint limit is that.
        if (
            salesConfig.maxSalePurchasePerAddress != 0 &&
            _numberMinted(_msgSender()) +
                quantity -
                presaleMintsByAddress[_msgSender()] >
            salesConfig.maxSalePurchasePerAddress
        ) {
            revert Purchase_TooManyForAddress();
        }

        _mintNFTs(_msgSender(), quantity);
        uint256 firstMintedTokenId = _lastMintedTokenId() - quantity;

        postMintRarityUpdate(firstMintedTokenId, _lastMintedTokenId());

        emit IKitsERC721Drop.Sale({
            to: _msgSender(),
            quantity: quantity,
            pricePerToken: salePrice,
            firstPurchasedTokenId: firstMintedTokenId
        });
        return firstMintedTokenId;
    }

    /// @notice Function to mint NFTs
    /// @dev (important: Does not enforce max supply limit, enforce that limit earlier)
    /// @dev This batches in size of 8 as per recommended by ERC721A creators
    /// @param to address to mint NFTs to
    /// @param quantity number of NFTs to mint
    function _mintNFTs(address to, uint256 quantity) internal {
        do {
            uint256 toMint = quantity > MAX_MINT_BATCH_SIZE
                ? MAX_MINT_BATCH_SIZE
                : quantity;
            _mint({to: to, quantity: toMint});
            quantity -= toMint;
        } while (quantity > 0);
    }

    function setRandom(uint256 newRandom) external onlyAdmin {
        currentRandom = newRandom;
    }

    function postMintRarityUpdate(
        uint256 firstMintedTokenId,
        uint256 lastMintedTokenId
    ) internal {
        for (
            uint i = firstMintedTokenId + 1;
            i < _lastMintedTokenId() + 1;
            i++
        ) {
            uint256 rarityTierId = getRarityTierId(i);
            rarityConfigs[rarityTierId].volumeMinted++;
            rarityMapping[i] = rarityTierId;
        }
    }

    /**
     * Get the presale edition size only if the presale is active
     * If the presale has expired, then return 0.
     *
     * This is used to determine rarity on token mint.
     */
    function getContextualPresaleEditionSize() internal view returns (uint256) {
        if (_presaleActive()) {
            return config.presaleEditionSize;
        }

        // if the presale is not active, set the presale volume to 0 for calulating rarity
        return 0;
    }

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                             ,----------.
    //                       / \                            |KitsERC721Drop|
    //                     Caller                           `----+-----'
    //                       |         purchasePresale()         |
    //                       | ---------------------------------->
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  drop has no tokens left for caller to mint?            !
    //          !_____/      |                                   |               !
    //          !            |       revert Mint_SoldOut()       |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  presale sale isn't active?             |               !
    //          !_____/      |                                   |               !
    //          !            |     revert Presale_Inactive()     |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  merkle proof unapproved for caller?    |               !
    //          !_____/      |                                   |               !
    //          !            | revert Presale_MerkleNotApproved()|               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  inadequate funds sent?                 |               !
    //          !_____/      |                                   |               !
    //          !            |    revert Purchase_WrongPrice()   |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | mint tokens
    //                       |                                   |<---'
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | emit IKitsERC721Drop.Sale()
    //                       |                                   |<---'
    //                       |                                   |
    //                       |    return first minted token ID   |
    //                       | <----------------------------------
    //                     Caller                           ,----+-----.
    //                       ,-.                            |KitsERC721Drop|
    //                       `-'                            `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @notice Merkle-tree based presale purchase function
    /// @param quantity quantity to purchase
    /// @param maxQuantity max quantity that can be purchased via merkle proof #
    /// @param pricePerToken price that each token is purchased at
    /// @param merkleProof proof for presale mint
    function purchasePresale(
        uint256 quantity,
        uint256 maxQuantity,
        uint256 pricePerToken,
        bytes32[] calldata merkleProof
    )
        external
        payable
        nonReentrant
        canMintPresaleTokens(quantity)
        onlyPresaleActive
        returns (uint256)
    {
        if (
            !MerkleProofUpgradeable.verify(
                merkleProof,
                salesConfig.presaleMerkleRoot,
                keccak256(
                    // address, uint256, uint256
                    abi.encode(_msgSender(), maxQuantity, pricePerToken)
                )
            )
        ) {
            revert Presale_MerkleNotApproved();
        }

        if (msg.value != pricePerToken * quantity) {
            revert Purchase_WrongPrice(pricePerToken * quantity);
        }

        presaleMintsByAddress[_msgSender()] += quantity;
        if (presaleMintsByAddress[_msgSender()] > maxQuantity) {
            revert Presale_TooManyForAddress();
        }

        // canMintPresaleTokens modifier checks that we can
        // mint `quantity` and remain under `config.presaleEditionSize`
        unchecked {
            presaleMints += quantity;
        }

        _mintNFTs(_msgSender(), quantity);
        uint256 firstMintedTokenId = _lastMintedTokenId() - quantity;

        postMintRarityUpdate(firstMintedTokenId, _lastMintedTokenId());

        emit IKitsERC721Drop.Sale({
            to: _msgSender(),
            quantity: quantity,
            pricePerToken: pricePerToken,
            firstPurchasedTokenId: firstMintedTokenId
        });

        return firstMintedTokenId;
    }

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                             ,----------.
    //                       / \                            |KitsERC721Drop|
    //                     Caller                           `----+-----'
    //                       |         purchaseAllowlist()         |
    //                       | ---------------------------------->
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  drop has no tokens left for caller to mint?            !
    //          !_____/      |                                   |               !
    //          !            |       revert Mint_SoldOut()       |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  presale sale isn't active?             |               !
    //          !_____/      |                                   |               !
    //          !            |     revert Presale_Inactive()     |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  caller does not own allowlist token?   |               !
    //          !_____/      |                                   |               !
    //          !            | revert Presale_UserNotAllowlist() |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  inadequate funds sent?                 |               !
    //          !_____/      |                                   |               !
    //          !            |    revert Purchase_WrongPrice()   |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | mint tokens
    //                       |                                   |<---'
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | emit IKitsERC721Drop.Sale()
    //                       |                                   |<---'
    //                       |                                   |
    //                       |    return first minted token ID   |
    //                       | <----------------------------------
    //                     Caller                           ,----+-----.
    //                       ,-.                            |KitsERC721Drop|
    //                       `-'                            `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @notice External contract token holder-based presale purchase function
    /// @param quantity quantity to purchase
    function purchaseAllowlist(
        uint256 quantity
    )
        external
        payable
        nonReentrant
        canMintPresaleTokens(quantity)
        onlyPresaleActive
        senderHoldsAllowlistToken
        returns (uint256)
    {
        uint256 salePrice = salesConfig.allowlistSalePrice;
        if (msg.value != salePrice * quantity) {
            revert Purchase_WrongPrice(salePrice);
        }

        // If max purchase per address == 0 there is no limit.
        // Any other number, the per address mint limit is that.
        if (
            salesConfig.maxSalePurchasePerAddress != 0 &&
            _numberMinted(_msgSender()) +
                quantity -
                presaleMintsByAddress[_msgSender()] >
            salesConfig.maxSalePurchasePerAddress
        ) {
            revert Purchase_TooManyForAddress();
        }

        // canMintPresaleTokens modifier checks that we can
        // mint `quantity` and remain under `config.presaleEditionSize`
        unchecked {
            presaleMints += quantity;
        }

        _mintNFTs(_msgSender(), quantity);
        uint256 firstMintedTokenId = _lastMintedTokenId() - quantity;

        postMintRarityUpdate(firstMintedTokenId, _lastMintedTokenId());

        emit IKitsERC721Drop.Sale({
            to: _msgSender(),
            quantity: quantity,
            pricePerToken: salePrice,
            firstPurchasedTokenId: firstMintedTokenId
        });

        return firstMintedTokenId;
    }

    /**
     *** ---------------------------------- ***
     ***                                    ***
     ***     ADMIN OPERATOR FILTERING       ***
     ***                                    ***
     *** ---------------------------------- ***
     ***/

    /// @notice Proxy to update market filter settings in the main registry contracts
    /// @notice Requires admin permissions
    /// @param args Calldata args to pass to the registry
    function updateMarketFilterSettings(
        bytes calldata args
    ) external onlyAdmin returns (bytes memory) {
        (bool success, bytes memory ret) = address(operatorFilterRegistry).call(
            args
        );
        if (!success) {
            revert RemoteOperatorFilterRegistryCallFailed();
        }
        return ret;
    }

    /// @notice Manage subscription to the DAO for marketplace filtering based off royalty payouts.
    /// @param enable Enable filtering to non-royalty payout marketplaces
    function manageMarketFilterDAOSubscription(bool enable) external onlyAdmin {
        address self = address(this);
        if (marketFilterDAOAddress == address(0x0)) {
            revert MarketFilterDAOAddressNotSupportedForChain();
        }
        if (!operatorFilterRegistry.isRegistered(self) && enable) {
            operatorFilterRegistry.registerAndSubscribe(
                self,
                marketFilterDAOAddress
            );
        } else if (enable) {
            operatorFilterRegistry.subscribe(self, marketFilterDAOAddress);
        } else {
            operatorFilterRegistry.unsubscribe(self, false);
            operatorFilterRegistry.unregister(self);
        }
    }

    /// @notice Configure rarities for this edition
    /// @param _rarityConfigs to set for the edition
    function updateRarities(
        IKitsERC721Drop.RarityConfiguration[NUMBER_OF_RARITY_CONFIGS]
            memory _rarityConfigs
    ) external onlyAdmin {
        for (uint i = 0; i < _rarityConfigs.length; i++) {
            rarityConfigs[i] = _rarityConfigs[i];
        }

        emit UpdatedRarities(msg.sender, _rarityConfigs);
    }

    /// @notice Hook to filter operators (no-op if no filters are registered)
    /// @dev Part of ERC721A token hooks
    /// @param from Transfer from user
    /// @param to Transfer to user
    /// @param startTokenId Token ID to start with
    /// @param quantity Quantity of token being transferred
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual override {
        if (
            from != msg.sender &&
            address(operatorFilterRegistry).code.length > 0
        ) {
            if (
                !operatorFilterRegistry.isOperatorAllowed(
                    address(this),
                    msg.sender
                )
            ) {
                revert OperatorNotAllowed(msg.sender);
            }
        }
    }

    /**
     *** ---------------------------------- ***
     ***                                    ***
     ***     ADMIN MINTING FUNCTIONS        ***
     ***                                    ***
     *** ---------------------------------- ***
     ***/

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                             ,----------.
    //                       / \                            |KitsERC721Drop|
    //                     Caller                           `----+-----'
    //                       |            adminMint()            |
    //                       | ---------------------------------->
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  caller is not admin or minter role?    |               !
    //          !_____/      |                                   |               !
    //          !            | revert Access_MissingRoleOrAdmin()|               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  drop has no tokens left for caller to mint?            !
    //          !_____/      |                                   |               !
    //          !            |       revert Mint_SoldOut()       |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | mint tokens
    //                       |                                   |<---'
    //                       |                                   |
    //                       |    return last minted token ID    |
    //                       | <----------------------------------
    //                     Caller                           ,----+-----.
    //                       ,-.                            |KitsERC721Drop|
    //                       `-'                            `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @notice Mint admin
    /// @param recipient recipient to mint to
    /// @param quantity quantity to mint
    function adminMint(
        address recipient,
        uint256 quantity
    )
        external
        onlyRoleOrAdmin(MINTER_ROLE)
        canMintPublicSaleTokens(quantity)
        returns (uint256)
    {
        _mintNFTs(recipient, quantity);

        return _lastMintedTokenId();
    }

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                             ,----------.
    //                       / \                            |KitsERC721Drop|
    //                     Caller                           `----+-----'
    //                       |         adminMintAirdrop()        |
    //                       | ---------------------------------->
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  caller is not admin or minter role?    |               !
    //          !_____/      |                                   |               !
    //          !            | revert Access_MissingRoleOrAdmin()|               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  drop has no tokens left for recipients to mint?        !
    //          !_____/      |                                   |               !
    //          !            |       revert Mint_SoldOut()       |               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |
    //                       |                    _____________________________________
    //                       |                    ! LOOP  /  for all recipients        !
    //                       |                    !______/       |                     !
    //                       |                    !              |----.                !
    //                       |                    !              |    | mint tokens    !
    //                       |                    !              |<---'                !
    //                       |                    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |    return last minted token ID    |
    //                       | <----------------------------------
    //                     Caller                           ,----+-----.
    //                       ,-.                            |KitsERC721Drop|
    //                       `-'                            `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @dev This mints multiple editions to the given list of addresses.
    /// @param recipients list of addresses to send the newly minted editions to
    function adminMintAirdrop(
        address[] calldata recipients
    )
        external
        override
        onlyRoleOrAdmin(MINTER_ROLE)
        canMintPublicSaleTokens(recipients.length)
        returns (uint256)
    {
        uint256 atId = _currentIndex;
        uint256 startAt = atId;

        unchecked {
            for (
                uint256 endAt = atId + recipients.length;
                atId < endAt;
                atId++
            ) {
                _mintNFTs(recipients[atId - startAt], 1);
            }
        }
        return _lastMintedTokenId();
    }

    /**
     *** ---------------------------------- ***
     ***                                    ***
     ***  ADMIN CONFIGURATION FUNCTIONS     ***
     ***                                    ***
     *** ---------------------------------- ***
     ***/

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                    ,----------.
    //                       / \                   |KitsERC721Drop|
    //                     Caller                  `----+-----'
    //                       |        setOwner()        |
    //                       | ------------------------->
    //                       |                          |
    //                       |                          |
    //          ________________________________________________________
    //          ! ALT  /  caller is not admin?          |               !
    //          !_____/      |                          |               !
    //          !            | revert Access_OnlyAdmin()|               !
    //          !            | <-------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                          |
    //                       |                          |----.
    //                       |                          |    | set owner
    //                       |                          |<---'
    //                     Caller                  ,----+-----.
    //                       ,-.                   |KitsERC721Drop|
    //                       `-'                   `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @dev Set new owner for royalties / opensea
    /// @param newOwner new owner to set
    function setOwner(address newOwner) public onlyAdmin {
        _setOwner(newOwner);
    }

    /// @notice Set a new metadata renderer
    /// @param newRenderer new renderer address to use
    /// @param setupRenderer data to setup new renderer with
    function setMetadataRenderer(
        IMetadataRenderer newRenderer,
        bytes memory setupRenderer
    ) external onlyAdmin {
        config.metadataRenderer = newRenderer;

        if (setupRenderer.length > 0) {
            newRenderer.initializeWithData(setupRenderer);
        }

        emit UpdatedMetadataRenderer({
            sender: _msgSender(),
            renderer: newRenderer
        });
    }

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                             ,----------.
    //                       / \                            |KitsERC721Drop|
    //                     Caller                           `----+-----'
    //                       |      setSalesConfiguration()      |
    //                       | ---------------------------------->
    //                       |                                   |
    //                       |                                   |
    //          _________________________________________________________________
    //          ! ALT  /  caller is not admin?                   |               !
    //          !_____/      |                                   |               !
    //          !            | revert Access_MissingRoleOrAdmin()|               !
    //          !            | <----------------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | set funds recipient
    //                       |                                   |<---'
    //                       |                                   |
    //                       |                                   |----.
    //                       |                                   |    | emit FundsRecipientChanged()
    //                       |                                   |<---'
    //                     Caller                           ,----+-----.
    //                       ,-.                            |KitsERC721Drop|
    //                       `-'                            `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @dev This sets the sales configuration
    // / @param publicSalePrice New public sale price
    function setSaleConfiguration(
        uint104 publicSalePrice,
        uint32 maxSalePurchasePerAddress,
        uint64 publicSaleStart,
        uint64 publicSaleEnd,
        uint64 presaleStart,
        uint64 presaleEnd,
        uint104 allowlistSalePrice,
        address allowlistContractAddress,
        bytes32 presaleMerkleRoot
    ) external onlyRoleOrAdmin(SALES_MANAGER_ROLE) {
        // SalesConfiguration storage newConfig = SalesConfiguration({
        //     publicSaleStart: publicSaleStart,
        //     publicSaleEnd: publicSaleEnd,
        //     presaleStart: presaleStart,
        //     presaleEnd: presaleEnd,
        //     publicSalePrice: publicSalePrice,
        //     maxSalePurchasePerAddress: maxSalePurchasePerAddress,
        //     presaleMerkleRoot: presaleMerkleRoot
        // });
        salesConfig.publicSalePrice = publicSalePrice;
        salesConfig.maxSalePurchasePerAddress = maxSalePurchasePerAddress;
        salesConfig.publicSaleStart = publicSaleStart;
        salesConfig.publicSaleEnd = publicSaleEnd;
        salesConfig.presaleStart = presaleStart;
        salesConfig.presaleEnd = presaleEnd;
        salesConfig.presaleMerkleRoot = presaleMerkleRoot;
        salesConfig.allowlistSalePrice = allowlistSalePrice;
        salesConfig.allowlistContractAddress = allowlistContractAddress;

        emit SalesConfigChanged(_msgSender());
    }

    //                       ,-.
    //                       `-'
    //                       /|\
    //                        |                    ,----------.
    //                       / \                   |KitsERC721Drop|
    //                     Caller                  `----+-----'
    //                       |        setOwner()        |
    //                       | ------------------------->
    //                       |                          |
    //                       |                          |
    //          ________________________________________________________
    //          ! ALT  /  caller is not admin or SALES_MANAGER_ROLE?    !
    //          !_____/      |                          |               !
    //          !            | revert Access_OnlyAdmin()|               !
    //          !            | <-------------------------               !
    //          !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //          !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                          |
    //                       |                          |----.
    //                       |                          |    | set sales configuration
    //                       |                          |<---'
    //                       |                          |
    //                       |                          |----.
    //                       |                          |    | emit SalesConfigChanged()
    //                       |                          |<---'
    //                     Caller                  ,----+-----.
    //                       ,-.                   |KitsERC721Drop|
    //                       `-'                   `----------'
    //                       /|\
    //                        |
    //                       / \
    /// @notice Set a different funds recipient
    /// @param newRecipientAddress new funds recipient address
    function setFundsRecipient(
        address payable newRecipientAddress
    ) external onlyRoleOrAdmin(SALES_MANAGER_ROLE) {
        // TODO(iain): funds recipient cannot be 0?
        config.fundsRecipient = newRecipientAddress;
        emit FundsRecipientChanged(newRecipientAddress, _msgSender());
    }

    //                       ,-.                  ,-.                      ,-.
    //                       `-'                  `-'                      `-'
    //                       /|\                  /|\                      /|\
    //                        |                    |                        |                      ,----------.
    //                       / \                  / \                      / \                     |KitsERC721Drop|
    //                     Caller            FeeRecipient            FundsRecipient                `----+-----'
    //                       |                    |           withdraw()   |                            |
    //                       | ------------------------------------------------------------------------->
    //                       |                    |                        |                            |
    //                       |                    |                        |                            |
    //                       |                    |                        |                            |
    //                       |                    |                        |                            |
    //                       |                    |                        |                            |
    //                       |                    |                        |             ____________________________________________________________
    //                       |                    |                        |             ! ALT  /  send unsuccesful?                                 !
    //                       |                    |                        |             !_____/        |                                            !
    //                       |                    |                        |             !              |----.                                       !
    //                       |                    |                        |             !              |    | revert Withdraw_FundsSendFailure()    !
    //                       |                    |                        |             !              |<---'                                       !
    //                       |                    |                        |             !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                    |                        |             !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                    |                        |                            |
    //                       |                    |                        | send remaining funds amount|
    //                       |                    |                        | <---------------------------
    //                       |                    |                        |                            |
    //                       |                    |                        |                            |
    //                       |                    |                        |             ____________________________________________________________
    //                       |                    |                        |             ! ALT  /  send unsuccesful?                                 !
    //                       |                    |                        |             !_____/        |                                            !
    //                       |                    |                        |             !              |----.                                       !
    //                       |                    |                        |             !              |    | revert Withdraw_FundsSendFailure()    !
    //                       |                    |                        |             !              |<---'                                       !
    //                       |                    |                        |             !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                       |                    |                        |             !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //                     Caller            FeeRecipient            FundsRecipient                ,----+-----.
    //                       ,-.                  ,-.                      ,-.                     |KitsERC721Drop|
    //                       `-'                  `-'                      `-'                     `----------'
    //                       /|\                  /|\                      /|\
    //                        |                    |                        |
    //                       / \                  / \                      / \
    /// @notice This withdraws ETH from the contract to the contract owner. Anyone can call this.
    function withdraw() external nonReentrant {
        // Get fee amount
        uint256 funds = address(this).balance;

        // Payout recipient
        (bool successFunds, ) = config.fundsRecipient.call{
            value: funds,
            gas: FUNDS_SEND_GAS_LIMIT
        }("");
        if (!successFunds) {
            revert Withdraw_FundsSendFailure();
        }

        // Emit event for indexing
        emit FundsWithdrawn(
            _msgSender(),
            config.fundsRecipient,
            funds,
            address(0x0), // formerly feeRecipient. we are not collecting a fee
            0 // formerly kitsFee. we are not collecting a fee
        );
    }

    /**
     *** ---------------------------------- ***
     ***                                    ***
     ***      GENERAL GETTER FUNCTIONS      ***
     ***                                    ***
     *** ---------------------------------- ***
     ***/

    /// @notice Simple override for owner interface.
    /// @return user owner address
    function owner()
        public
        view
        override(OwnableSkeleton, IKitsERC721Drop)
        returns (address)
    {
        return super.owner();
    }

    /// @notice Contract URI Getter, proxies to metadataRenderer
    /// @return Contract URI
    function contractURI() external view returns (string memory) {
        return config.metadataRenderer.contractURI();
    }

    /// @notice Getter for metadataRenderer contract
    function metadataRenderer() external view returns (IMetadataRenderer) {
        return IMetadataRenderer(config.metadataRenderer);
    }

    /// @notice Token URI Getter, proxies to metadataRenderer
    /// @param tokenId id of token to get URI for
    /// @return Token URI
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        if (!_exists(tokenId)) {
            revert IERC721AUpgradeable.URIQueryForNonexistentToken();
        }

        return
            string.concat(
                baseURI,
                "/",
                Strings.toHexString(uint256(uint160(address(this))), 20),
                "/",
                Strings.toString(tokenId)
            );
    }

    /// @notice ERC165 supports interface
    /// @param interfaceId interface id to check if supported
    function supportsInterface(
        bytes4 interfaceId
    )
        public
        view
        override(
            IERC165Upgradeable,
            ERC721AUpgradeable,
            AccessControlUpgradeable
        )
        returns (bool)
    {
        return
            super.supportsInterface(interfaceId) ||
            type(IOwnable).interfaceId == interfaceId ||
            type(IERC2981Upgradeable).interfaceId == interfaceId ||
            type(IKitsERC721Drop).interfaceId == interfaceId;
    }
}