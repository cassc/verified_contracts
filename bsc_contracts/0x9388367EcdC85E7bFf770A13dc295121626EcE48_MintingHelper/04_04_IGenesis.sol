// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20Upgradeable } from "../../node_modules/@openzeppelin/contracts-upgradeable/interfaces/IERC20Upgradeable.sol";


interface IGenesis {
    /**
    * @notice Initializer (constructor pendant for a proxy)
    * @param defaultAdmin will get MASTER_TOKEN_ZERO minted 
    * @param mintingManager gets assigned the MINTING_MANAGER_ROLE role
    * @param metadataManager gets assigned the MINTING_MANAGER_ROLE role
    * @param whitelistSignerWallet gets assigned the WHITELIST_SIGNER_ROLE role
    * @param props initial values for the volumeProps
    */
    function initialize(
        address defaultAdmin,
        address mintingManager,
		address metadataManager,
		address whitelistSignerWallet,
        VolumeProps calldata props
	) external;

   // EVENTS
    event MetadataChanged(string unrevealed, string revealed, uint256 revealedUntil);
    event MetadataFrozen();
	event MintingStatusChanged(bool isOpen);
    event TransferStatusChanged(bool transfersPaused);
    event VolumeBonusStatusChanged(bool volumeBonusEnabled);
    event NewMaxSupply(uint256 maxSupply);
    event RequestByToken(uint256 tokenId, bytes32[] key, bytes[] value);
    event Minted(address recipient, uint256 firstToBeMinted, uint256 amount, uint256 totalFeeInUSDC, uint256 referrerToken);
    event Placed(uint256 placedToken, uint256 upperToken, bool rightSide);
    event CustomerRegistered(address customer, uint256 tokenId);
    event VolumeGenerated(address customer, address seller, uint256 sellerCutBasisPoints, uint256 USDCAmount);
    event VolumeBonusClaimed(address tokenOwner, uint256 tokenId, uint256 earned, uint256 cycles, bool rightSideBase);
    event TokenRenewed(uint256 token, uint256 validUntil);
    event Exploited(address exploiter, uint256 token, uint256 earned);
    event NewVolumeProps(VolumeProps newVolumeProps);
    event VolumesUpdated(uint256[] tokenIds);
    event NewRoyaltyInfo(address recipient, uint256 basisPoints);


   // ERRORS
    error ZeroParameter(string parameterName);
    error MintNotOpen();
    error SupplyCapExceeded(uint256 tried, uint256 maxSupply);
    error InvalidCurrency(address USDT, address USDC, address BUSD);
    error TransfersPaused();
    error NotAuthorized();
    error InvalidReferral(address caller, uint256 tokenId, bytes sig);
    error TokenDoesntExist(uint256 tokenId);
    error ValueWasAlreadySet(string name, bytes valueRepresentationInBytes);
    error CustomerNotRegistered(address user);
    error InsufficientVolume(uint256 have, uint256 want);
    error VolumeBonusDisabled();
    error EarnedMoreThanMaximumPerEpoche();
    error TokenStillActive(uint256 activeUntil);
    error TokenNotActive();

   // Structures

    struct VolumeProps {
        bool enabled;
        uint48 epoche;
        uint16 basisPointsPayout;
        uint16 volumeBaseAmount;
        uint24 maximumPerEpocheInDollar;
        uint8 otherTeamMultiplier;
        uint16 renewalFeeInDollar;
    }

    struct Customer {
        uint24 referrerToken;
        bool isRegistered;
    }

    struct Token {
        /// token that referred this token when minting
        uint24 referrerToken;

        // volume bonus parent
        uint24 up;
        // volume child left
        uint24 downL;
        // volume child right
        uint24 downR;

        uint32 totalVolLeft;
        uint32 totalVolRight;
        uint32 volumeGenerated;
        uint64 nextActivityCheck;
        // packed in the next slot, because users pay most willingly to claim
        uint32 usedLeft;
        uint32 usedRight;

        mapping(uint256 => uint256) bonusPaidByVolumeEpoche;
    }

    struct Referral {
        uint256 tokenId;
        bytes sig;
    }

   // USER FUNCTIONS
    /**
    * @notice mints `amount` NFTs to `receivingWallet`, 
    *         for a certain number of tokens of `currency`, 
    *         given the whitelist `sig` is valid.
    * @param currency the address of either the USDC token or USDT token contract, reverts on other input 
    * @param amount amount of NFTs to mint
    * @param recipient receives the NFTs
    * @param referral contains the referrer´s Token Id and the signature that was generated for the invitee and the tokenId
    */
	function mint(
		address currency,
		uint256 amount,
		address recipient,
        Referral calldata referral
	) external;

    /**
    * @param parentTokenId must be referrer token of `childTokenId`
    * @param childTokenId must not have been placed yet (childToken.up == 0 has to be true)
    * @param rightSide true if the childToken should be placed on the right side beneath the parent token
    */
	function placeForVolumeBonus(
        uint256 parentTokenId, 
        uint256 childTokenId, 
        bool rightSide
    ) external;

    /**
    * @param tokenIds array of tokens to have their `totalVolLeft` and `totalVolRight` updated
             based on the `volumeGenerated`, `totalVolLeft` and `totalVolRight` of their respective volumeChildren
    */
	function updateVolumesForToken(uint256[] calldata tokenIds) external;

    /**
    * @dev there is no guarantee that this contract holds enough funds in `currency` to pay out the token owner
    * @notice the user claims volume bonus for `cycles` and receives payout in `currency`
    * @param rightSideIsBase if true, the right side will be used as base volume and 
             left side volume will be multiplied by `volumeProps.otherSideMultiplier`
    */
    function claimVolumeBonus(
		uint256 tokenId, 
		uint256 cycles, 
		bool rightSideIsBase,
		IERC20Upgradeable currency
	) external;

    /// @notice used to pay a subscription fee for staying eligible for claiming volume bonus
    ///         and not getting "exploited" from `exploitActivity` 
    function renew(uint256[] calldata tokenIds, IERC20Upgradeable currency) external;

    /// @notice has to be called once by a user of strive contracts to establish a customer > referrer connection
    /// @dev is called automatically when minting
    function registerAsCustomer(Referral calldata referral) external;

    /// @notice destroys existing volume for `tokenId` if `token.nextActivityCheck` < block.timestamp
    /// @notice the exploiter gets rewarded with `EXPLOTER_BASIS_POINTS` basis points of the usual payout
    function exploitActivity(uint256 tokenId, IERC20Upgradeable currency) external;


   // VIEW EXTERNAL

    /// @return transfersPaused true if nft transfers (including mint and burn) are paused at the moment, false otherwise
    function transfersPaused() external view returns(bool);

    /// @return mintingEnabled true if minting is possible at the moment, false otherwise
	function mintingEnabled() external view returns(bool);

    /// @return signatureValid true if `referral.sig` is valid for `invitee` and `referral.tokenId`
    ///         and can be used for minting, false otherwise
    function verifyReferralSignature(address invitee, Referral calldata referral) external view returns(bool);

    /// @dev this method might be gas intensive and should not be called onchain
    /// @dev the only cyclic referral is (0 -> 0), every "referralRoute" ends there
    /// @return route the referrer tokenIds, starting with referrer token of `tokenId`
    function getReferralRoute(uint256 tokenId, uint256 length) external view returns(uint256[] memory);

    function getTokenInfo(uint256 tokenId) 
        external view 
        returns(
            address _owner, 
            string memory _tokenURI,
            uint256 _referrerTokenId
        );
    
    /// @dev max amount of token holders getting rewarded for a purchase 
    function REFERRAL_LAYERS() external pure returns(uint256);
    /// @dev how long a token is active, once it got `renewed`
    function VALIDITY_LENGTH() external pure returns(uint256);
    /// @dev basis points of how much payout an exploiter gets relative to the exploited volume
    function EXPLOTER_BASIS_POINTS() external pure returns(uint256);
    /// @dev calculates the total minting fee for minting `amount` of tokens starting with `firstTokenId`
	function totalMintingFee(uint256 firstTokenId, uint256 amount) external pure returns(uint256 totalFeeInUSDC);
    /// @dev calculates the minting fee for a single token with `tokenId`
    function mintingFee(uint256 tokenId) external pure returns(uint256 feeInUSDC);

    function USDC() external view returns(IERC20Upgradeable);
    function USDT() external view returns(IERC20Upgradeable);
    function BUSD() external view returns(IERC20Upgradeable);
    /// @dev current max supply, can be changed by a default Admin
    function maxSupply() external view returns(uint256);
    /// @dev current supply
    function totalSupply() external view returns(uint256);

  // Access Control Functions: 
    // custom roles:
    function METADATA_MANAGER_ROLE() external pure returns(bytes32 roleId);
	function WHITELIST_SIGNER_ROLE() external pure returns(bytes32 roleId);
	function MINTING_MANAGER_ROLE () external pure returns(bytes32 roleId);
    function DEFAULT_APPROVED_ROLE() external pure returns(bytes32 roleId);
    function STRIVE_CONTRACT_ROLE () external pure returns(bytes32 roleId);

   // DEFAULT ADMIN:
    /// @dev mint NFTs for free at any time
    function allocate(address recipient, uint256 amount, uint256 referrerToken) external;

    /// @dev retrieve any funds from the contract, address(0) = ETH
	function retrieve(IERC20Upgradeable currency, address recipient, uint256 amount) external;

    /// @dev set a new max supply for this collection
    function setMaxSupply(uint24 maxSupply_) external;

    /// @dev true => enable transfers; false => disable transfers
	function setTransfersPaused(bool transfersPaused_) external;

    /// @param volumeBonusEnabled_ true => volume bonus related functions are enabled
    function setVolumeBonusStatus(bool volumeBonusEnabled_) external;

    function setRoyaltyInfo(address recipient, uint256 feeBasisPoints) external;

   // METADATA MANAGER:
    /// @dev set the base strings for the unrevealed and the revealed metadata
	function setMetadata(string calldata unrevealedData, string calldata revealedData) external;

    /// @dev set the index until which metadata is revealed
	function revealMetadata(uint256 revealedUntil) external;

    /// @dev disable `setMetadata()` and `revealMetadata()` thus freezing the metadata
    ///      with the exception of proxy upgrades.
    /// @param magicValue since this action might be irreversible, 
    ///        the caller has to provide the magic value `0x29794306`
	function freezeMetadata(bytes4 magicValue) external;


   // MINTING_MANAGER:
    /// @param mintingEnabled_ true => minting is enabled; false => minting is disabled
	function setMintingStatus(bool mintingEnabled_) external;

   // STRIVE_CONTRACT:

    /**
    * @dev this method is intended to be used by other Strive Ecosystem contracts to facilitate
           payment from the customerAddress to the respective referrers and update volume bonus data 
    */
   function registerPurchase(
		address customerAddress,
		IERC20Upgradeable currency,
		address seller,
		uint256 sellerCutBasisPoints,
		uint256 feeInUSDC
	) external;
}