// SPDX-License-Identifier:UNLICENSED
pragma solidity ^0.7.6;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "../utils/AuthorizationBitmap.sol";
import "../utils/Types.sol";
import "../interfaces/ITransferProxy.sol";
import "../interfaces/IRoyaltyAwareNFT.sol";
import "../utils/BlockchainUtils.sol";
import "./utils/PlatformFees.sol";

/// @title TradeV4
///
/// @dev This contract is a Transparent Upgradable based in openZeppelin v3.4.0.
///         Be careful when upgrade, you must respect the same storage.

abstract contract TradeV4 is ReentrancyGuardUpgradeable, OwnableUpgradeable {
    using SafeMathUpgradeable for uint256;

    enum AssetType { ERC1155, ERC721 }

    event SellerFee(uint8 sellerFee);
    event BuyerFee(uint8 buyerFee);
    event CustodialAddressChanged(address prevAddress, address newAddress);
    event BuyAsset(address indexed assetOwner, uint256 indexed tokenId, uint256 quantity, address indexed buyer);
    event ExecuteBid(address indexed assetOwner, uint256 indexed tokenId, uint256 quantity, address indexed buyer);
    event TokenWithdraw(address indexed assetOwner, uint256 indexed authId, uint256 indexed tokenId, uint256 quantity);

    /// @dev deprecated
    uint8 internal _buyerFeePermille;
    /// @dev deprecated
    uint8 internal _sellerFeePermille;
    ITransferProxy public transferProxy;
    address public enigmaNFT721Address;
    address public enigmaNFT1155Address;
    // Address that acts as custodial for platform hold NFTs,
    address public custodialAddress;

    // This is a packed array of booleans, to track processed authorizations
    mapping(uint256 => uint256) internal processedAuthorizationsBitMap;

    struct Fee {
        uint256 platformFee;
        uint256 assetFee;
        uint256 royaltyFee;
        uint256 price;
        address tokenCreator;
    }

    struct Order {
        address seller;
        address buyer;
        address erc20Address;
        address nftAddress;
        AssetType nftType;
        uint256 unitPrice;
        uint256 amount;
        uint256 tokenId;
        uint256 qty;
    }

    struct WithdrawRequest {
        uint256 authId; // Unique id for this withdraw authorization
        address assetAddress;
        AssetType assetType;
        uint256 tokenId;
        uint256 qty;
    }

    function initializeTradeV4(
        ITransferProxy _transferProxy,
        address _enigmaNFT721Address,
        address _enigmaNFT1155Address,
        address _custodialAddress
    ) internal initializer {
        transferProxy = _transferProxy;
        enigmaNFT721Address = _enigmaNFT721Address;
        enigmaNFT1155Address = _enigmaNFT1155Address;
        custodialAddress = _custodialAddress;
        __Ownable_init();
        __ReentrancyGuard_init();
    }

    function setCustodialAddress(address _custodialAddress) external onlyOwner returns (bool) {
        emit CustodialAddressChanged(custodialAddress, _custodialAddress);
        custodialAddress = _custodialAddress;
        return true;
    }

    function verifySellerSignature(
        address seller,
        uint256 tokenId,
        uint256 amount,
        address paymentAssetAddress,
        address assetAddress,
        uint8 sellerFeePermile,
        Signature memory signature
    ) internal pure {
        bytes32 hash =
            keccak256(
                abi.encodePacked(
                    BlockchainUtils.getChainID(),
                    assetAddress,
                    tokenId,
                    paymentAssetAddress,
                    amount,
                    sellerFeePermile
                )
            );
        require(seller == BlockchainUtils.getSigner(hash, signature), "seller sign verification failed");
    }

    /**
     * @notice Verifies the custodial authorization for this withdraw for this assetOwner
     * @param assetCustodial current asset holder
     * @param assetOwner real asset owner address
     * @param wr struct with the withdraw information. What asset and how much of it
     * @param signature struct combination of uint8, bytes32, bytes32 are v, r, s.
     */
    function verifyWithdrawSignature(
        address assetCustodial,
        address assetOwner,
        WithdrawRequest memory wr,
        Signature memory signature
    ) internal pure {
        bytes32 hash =
            keccak256(
                abi.encodePacked(
                    BlockchainUtils.getChainID(),
                    assetOwner,
                    wr.authId,
                    wr.tokenId,
                    wr.assetAddress,
                    wr.qty
                )
            );
        require(assetCustodial == BlockchainUtils.getSigner(hash, signature), "withdraw sign verification failed");
    }

    function getFees(
        uint256 paymentAmt,
        address buyingAssetAddress,
        uint256 tokenId,
        uint256 sellerFeePermille,
        uint256 buyerFeePermille
    ) internal view returns (Fee memory) {
        address tokenCreator;
        uint256 platformFee;
        uint256 royaltyFee;
        uint256 royaltyPermille;
        uint256 price;
        uint256 sellerFee = paymentAmt.mul(sellerFeePermille).div((1000 + buyerFeePermille));
        if (buyerFeePermille != 0) {
            price = paymentAmt.mul(1000).div((1000 + buyerFeePermille));
            uint256 buyerFee = paymentAmt.sub(price);
            platformFee = buyerFee.add(sellerFee);
        } else {
            price = paymentAmt;
            platformFee = sellerFee;
        }

        // If trade with no enigma NFT royalty fee is 0
        if (buyingAssetAddress == enigmaNFT721Address || buyingAssetAddress == enigmaNFT1155Address) {
            royaltyPermille = ((IRoyaltyAwareNFT(buyingAssetAddress).royaltyFee(tokenId)));
            tokenCreator = ((IRoyaltyAwareNFT(buyingAssetAddress).getCreator(tokenId)));
            royaltyFee = paymentAmt.mul(royaltyPermille).div((1000 + buyerFeePermille));
        } else {
            tokenCreator = address(0);
            royaltyFee = 0;
        }
        return Fee(platformFee, price.sub(royaltyFee).sub(sellerFee), royaltyFee, price, tokenCreator);
    }

    function getFees(
        uint256 paymentAmt,
        address buyingAssetAddress,
        uint256 tokenId,
        PlatformFees calldata platformFees
    ) internal returns (Fee memory) {
        require(tokenId == platformFees.tokenId, "TokenId mismatch");
        require(buyingAssetAddress == platformFees.assetAddress, "Asset address mismatch");
        PlatformFeesFunctions.checkValidPlatformFees(platformFees, owner());

        return
            getFees(
                paymentAmt,
                buyingAssetAddress,
                tokenId,
                platformFees.sellerFeePermille,
                platformFees.buyerFeePermille
            );
    }

    function tradeNFT(Order memory order) internal virtual {
        safeTransferFrom(order.nftType, order.seller, order.buyer, order.nftAddress, order.tokenId, order.qty);
    }

    function safeTransferFrom(
        AssetType nftType,
        address from,
        address to,
        address nftAddress,
        uint256 tokenId,
        uint256 qty
    ) internal virtual {
        nftType == AssetType.ERC721
            ? transferProxy.erc721safeTransferFrom(nftAddress, from, to, tokenId)
            : transferProxy.erc1155safeTransferFrom(nftAddress, from, to, tokenId, qty, "");
    }

    /**
     * @dev Disable slither warning because there is a nonReentrant check and the address are known
     * https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations
     */
    function tradeAssetWithETH(Order memory order, Fee memory fee) internal virtual {
        tradeNFT(order);
        if (fee.platformFee > 0) {
            // TODO: review if we don't need a new field for collecting fees
            // slither-disable-next-line arbitrary-send
            (bool platformSuccess, ) = owner().call{ value: fee.platformFee }("");
            require(platformSuccess, "sending ETH to owner failed");
        }
        if (fee.royaltyFee > 0) {
            // slither-disable-next-line arbitrary-send
            (bool royaltySuccess, ) = fee.tokenCreator.call{ value: fee.royaltyFee }("");
            require(royaltySuccess, "sending ETH to creator failed");
        }
        // slither-disable-next-line arbitrary-send
        (bool sellerSuccess, ) = order.seller.call{ value: fee.assetFee }("");
        require(sellerSuccess, "sending ETH to seller failed");
    }

    /*********************
     ** PUBLIC FUNCTIONS *
     *********************/

    function buyAssetWithETH(
        Order memory order,
        Signature memory signature,
        PlatformFees calldata platformFees
    ) public payable nonReentrant returns (bool) {
        require(order.amount == msg.value, "Paid invalid ETH amount");
        Fee memory fee = getFees(order.amount, order.nftAddress, order.tokenId, platformFees);
        require((fee.price >= order.unitPrice * order.qty), "Paid invalid amount");
        // Using the one sent here saves some checks as we need to make sure the same seller fees
        // where included in both singatures, no need for an extra param or assertion
        verifySellerSignature(
            order.seller,
            order.tokenId,
            order.unitPrice,
            address(0),
            order.nftAddress,
            platformFees.sellerFeePermille,
            signature
        );
        order.buyer = msg.sender;
        emit BuyAsset(order.seller, order.tokenId, order.qty, msg.sender);
        tradeAssetWithETH(order, fee);
        return true;
    }

    /**
     * @notice Verifies and executes a safe Token withdraw for this sender, if authorized by the custodial
     * @param wr struct with the withdraw information. What asset and how much of it
     * @param signature asset custodial authorization signature
     */
    function withdrawToken(WithdrawRequest memory wr, Signature memory signature) external returns (bool) {
        address assetOwner = msg.sender;
        require(
            !AuthorizationBitmap.isAuthProcessed(processedAuthorizationsBitMap, wr.authId),
            "Authorization signature already processed"
        );
        // Verifies that this asset custodial, is actually authorizing this user withdraw
        verifyWithdrawSignature(custodialAddress, assetOwner, wr, signature);
        AuthorizationBitmap.setAuthProcessed(processedAuthorizationsBitMap, wr.authId);
        safeTransferFrom(wr.assetType, custodialAddress, assetOwner, wr.assetAddress, wr.tokenId, wr.qty);
        emit TokenWithdraw(assetOwner, wr.authId, wr.tokenId, wr.qty);
        return true;
    }

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain.
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[1000] private __gap;
}