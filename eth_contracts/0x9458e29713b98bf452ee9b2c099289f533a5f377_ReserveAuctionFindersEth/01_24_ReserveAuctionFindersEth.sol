// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.10;

import {ReentrancyGuard} from "@rari-capital/solmate/src/utils/ReentrancyGuard.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import {ERC721TransferHelper} from "../../../../transferHelpers/ERC721TransferHelper.sol";
import {FeePayoutSupportV1} from "../../../../common/FeePayoutSupport/FeePayoutSupportV1.sol";
import {ModuleNamingSupportV1} from "../../../../common/ModuleNamingSupport/ModuleNamingSupportV1.sol";
import {IReserveAuctionFindersEth} from "./IReserveAuctionFindersEth.sol";

/// @title Reserve Auction Finders ETH
/// @author kulkarohan
/// @notice Module adding Finders Fee to Reserve Auction Core ETH
contract ReserveAuctionFindersEth is IReserveAuctionFindersEth, ReentrancyGuard, FeePayoutSupportV1, ModuleNamingSupportV1 {
    /// @notice The minimum amount of time left in an auction after a new bid is created
    uint16 constant TIME_BUFFER = 15 minutes;

    /// @notice The minimum percentage difference between two bids
    uint8 constant MIN_BID_INCREMENT_PERCENTAGE = 10;

    /// @notice The ZORA ERC-721 Transfer Helper
    ERC721TransferHelper public immutable erc721TransferHelper;

    /// @notice The auction for a given NFT, if one exists
    /// @dev ERC-721 token contract => ERC-721 token id => Auction
    mapping(address => mapping(uint256 => Auction)) public auctionForNFT;

    /// @notice The metadata for a given auction
    /// @param seller The address of the seller
    /// @param reservePrice The reserve price to start the auction
    /// @param sellerFundsRecipient The address where funds are sent after the auction
    /// @param highestBid The highest bid of the auction
    /// @param highestBidder The address of the highest bidder
    /// @param duration The length of time that the auction runs after the first bid is placed
    /// @param startTime The time that the first bid can be placed
    /// @param finder The address that referred the highest bid
    /// @param firstBidTime The time that the first bid is placed
    /// @param findersFeeBps The fee that is sent to the referrer of the highest bid
    struct Auction {
        address seller;
        uint96 reservePrice;
        address sellerFundsRecipient;
        uint96 highestBid;
        address highestBidder;
        uint48 duration;
        uint48 startTime;
        address finder;
        uint80 firstBidTime;
        uint16 findersFeeBps;
    }

    /// @notice Emitted when an auction is created
    /// @param tokenContract The ERC-721 token address of the created auction
    /// @param tokenId The ERC-721 token id of the created auction
    /// @param auction The metadata of the created auction
    event AuctionCreated(address indexed tokenContract, uint256 indexed tokenId, Auction auction);

    /// @notice Emitted when a reserve price is updated
    /// @param tokenContract The ERC-721 token address of the updated auction
    /// @param tokenId The ERC-721 token id of the updated auction
    /// @param auction The metadata of the updated auction
    event AuctionReservePriceUpdated(address indexed tokenContract, uint256 indexed tokenId, Auction auction);

    /// @notice Emitted when an auction is canceled
    /// @param tokenContract The ERC-721 token address of the canceled auction
    /// @param tokenId The ERC-721 token id of the canceled auction
    /// @param auction The metadata of the canceled auction
    event AuctionCanceled(address indexed tokenContract, uint256 indexed tokenId, Auction auction);

    /// @notice Emitted when a bid is placed
    /// @param tokenContract The ERC-721 token address of the auction
    /// @param tokenId The ERC-721 token id of the auction
    /// @param firstBid If the bid started the auction
    /// @param extended If the bid extended the auction
    /// @param auction The metadata of the auction
    event AuctionBid(address indexed tokenContract, uint256 indexed tokenId, bool firstBid, bool extended, Auction auction);

    /// @notice Emitted when an auction has ended
    /// @param tokenContract The ERC-721 token address of the auction
    /// @param tokenId The ERC-721 token id of the auction
    /// @param auction The metadata of the settled auction
    event AuctionEnded(address indexed tokenContract, uint256 indexed tokenId, Auction auction);

    /// @param _erc721TransferHelper The ZORA ERC-721 Transfer Helper address
    /// @param _royaltyEngine The Manifold Royalty Engine address
    /// @param _protocolFeeSettings The ZORA Protocol Fee Settings address
    /// @param _weth The WETH token address
    constructor(
        address _erc721TransferHelper,
        address _royaltyEngine,
        address _protocolFeeSettings,
        address _weth
    )
        FeePayoutSupportV1(_royaltyEngine, _protocolFeeSettings, _weth, ERC721TransferHelper(_erc721TransferHelper).ZMM().registrar())
        ModuleNamingSupportV1("Reserve Auction Finders ETH")
    {
        erc721TransferHelper = ERC721TransferHelper(_erc721TransferHelper);
    }

    /// @notice Implements EIP-165 for standard interface detection
    /// @dev `0x01ffc9a7` is the IERC165 interface id
    /// @param _interfaceId The identifier of a given interface
    /// @return If the given interface is supported
    function supportsInterface(bytes4 _interfaceId) external pure returns (bool) {
        return _interfaceId == type(IReserveAuctionFindersEth).interfaceId || _interfaceId == 0x01ffc9a7;
    }

    //     ,-.
    //     `-'
    //     /|\
    //      |             ,------------------------.
    //     / \            |ReserveAuctionFindersEth|
    //   Caller           `-----------+------------'
    //     |      createAuction()     |
    //     | ------------------------->
    //     |                          |
    //     |                          |----.
    //     |                          |    | store auction metadata
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | emit AuctionCreated()
    //     |                          |<---'
    //   Caller           ,-----------+------------.
    //     ,-.            |ReserveAuctionFindersEth|
    //     `-'            `------------------------'
    //     /|\
    //      |
    //     / \
    /// @notice Creates an auction for a given NFT
    /// @param _tokenContract The address of the ERC-721 token
    /// @param _tokenId The id of the ERC-721 token
    /// @param _duration The length of time the auction should run after the first bid
    /// @param _reservePrice The minimum bid amount to start the auction
    /// @param _sellerFundsRecipient The address to send funds to once the auction is complete
    /// @param _startTime The time that users can begin placing bids
    /// @param _findersFeeBps The fee to send to the referrer of the winning bid
    function createAuction(
        address _tokenContract,
        uint256 _tokenId,
        uint256 _duration,
        uint256 _reservePrice,
        address _sellerFundsRecipient,
        uint256 _startTime,
        uint256 _findersFeeBps
    ) external nonReentrant {
        // Get the owner of the specified token
        address tokenOwner = IERC721(_tokenContract).ownerOf(_tokenId);

        // Ensure the caller is the owner or an approved operator
        require(msg.sender == tokenOwner || IERC721(_tokenContract).isApprovedForAll(tokenOwner, msg.sender), "ONLY_TOKEN_OWNER_OR_OPERATOR");

        // Ensure the funds recipient is specified
        require(_sellerFundsRecipient != address(0), "INVALID_FUNDS_RECIPIENT");

        // Ensure the finders fee does not exceed 10,000 basis points
        require(_findersFeeBps <= 10000, "INVALID_FINDERS_FEE");

        // Store the auction metadata
        auctionForNFT[_tokenContract][_tokenId].seller = tokenOwner;
        auctionForNFT[_tokenContract][_tokenId].reservePrice = uint96(_reservePrice);
        auctionForNFT[_tokenContract][_tokenId].sellerFundsRecipient = _sellerFundsRecipient;
        auctionForNFT[_tokenContract][_tokenId].duration = uint48(_duration);
        auctionForNFT[_tokenContract][_tokenId].startTime = uint48(_startTime);
        auctionForNFT[_tokenContract][_tokenId].findersFeeBps = uint16(_findersFeeBps);

        emit AuctionCreated(_tokenContract, _tokenId, auctionForNFT[_tokenContract][_tokenId]);
    }

    //     ,-.
    //     `-'
    //     /|\
    //      |             ,------------------------.
    //     / \            |ReserveAuctionFindersEth|
    //   Caller           `-----------+------------'
    //     | setAuctionReservePrice() |
    //     | ------------------------->
    //     |                          |
    //     |                          |----.
    //     |                          |    | update reserve price
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | emit AuctionReservePriceUpdated()
    //     |                          |<---'
    //   Caller           ,-----------+------------.
    //     ,-.            |ReserveAuctionFindersEth|
    //     `-'            `------------------------'
    //     /|\
    //      |
    //     / \
    /// @notice Updates the reserve price for a given auction
    /// @param _tokenContract The address of the ERC-721 token
    /// @param _tokenId The id of the ERC-721 token
    /// @param _reservePrice The new reserve price
    function setAuctionReservePrice(
        address _tokenContract,
        uint256 _tokenId,
        uint256 _reservePrice
    ) external nonReentrant {
        // Get the auction for the specified token
        Auction storage auction = auctionForNFT[_tokenContract][_tokenId];

        // Ensure the auction has not started
        require(auction.firstBidTime == 0, "AUCTION_STARTED");

        // Ensure the caller is the seller
        require(msg.sender == auction.seller, "ONLY_SELLER");

        // Update the reserve price
        auction.reservePrice = uint96(_reservePrice);

        emit AuctionReservePriceUpdated(_tokenContract, _tokenId, auction);
    }

    //     ,-.
    //     `-'
    //     /|\
    //      |             ,------------------------.
    //     / \            |ReserveAuctionFindersEth|
    //   Caller           `-----------+------------'
    //     |      cancelAuction()     |
    //     | ------------------------->
    //     |                          |
    //     |                          |----.
    //     |                          |    | emit AuctionCanceled()
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | delete auction
    //     |                          |<---'
    //   Caller           ,-----------+------------.
    //     ,-.            |ReserveAuctionFindersEth|
    //     `-'            `------------------------'
    //     /|\
    //      |
    //     / \
    /// @notice Cancels the auction for a given NFT
    /// @param _tokenContract The address of the ERC-721 token
    /// @param _tokenId The id of the ERC-721 token
    function cancelAuction(address _tokenContract, uint256 _tokenId) external nonReentrant {
        // Get the auction for the specified token
        Auction memory auction = auctionForNFT[_tokenContract][_tokenId];

        // Ensure the auction has not started
        require(auction.firstBidTime == 0, "AUCTION_STARTED");

        // Ensure the caller is the seller or a new owner of the token
        require(msg.sender == auction.seller || msg.sender == IERC721(_tokenContract).ownerOf(_tokenId), "ONLY_SELLER_OR_TOKEN_OWNER");

        emit AuctionCanceled(_tokenContract, _tokenId, auction);

        // Remove the auction from storage
        delete auctionForNFT[_tokenContract][_tokenId];
    }

    //     ,-.
    //     `-'
    //     /|\
    //      |             ,------------------------.                ,--------------------.
    //     / \            |ReserveAuctionFindersEth|                |ERC721TransferHelper|
    //   Caller           `-----------+------------'                `---------+----------'
    //     |        createBid()       |                                       |
    //     | ------------------------->                                       |
    //     |                          |                                       |
    //     |                          |                                       |
    //     |    ___________________________________________________________________
    //     |    ! ALT  /  First bid?  |                                       |    !
    //     |    !_____/               |                                       |    !
    //     |    !                     |----.                                  |    !
    //     |    !                     |    | start auction                    |    !
    //     |    !                     |<---'                                  |    !
    //     |    !                     |                                       |    !
    //     |    !                     |----.                                  |    !
    //     |    !                     |    | transferFrom()                   |    !
    //     |    !                     |<---'                                  |    !
    //     |    !                     |                                       |    !
    //     |    !                     |----.                                       !
    //     |    !                     |    | transfer NFT from seller to escrow    !
    //     |    !                     |<---'                                       !
    //     |    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //     |    ! [refund previous bidder]                                    |    !
    //     |    !                     |----.                                  |    !
    //     |    !                     |    | transfer ETH to bidder           |    !
    //     |    !                     |<---'                                  |    !
    //     |    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //     |                          |                                       |
    //     |                          |                                       |
    //     |    _______________________________________________               |
    //     |    ! ALT  /  Bid placed within 15 min of end?     !              |
    //     |    !_____/               |                        !              |
    //     |    !                     |----.                   !              |
    //     |    !                     |    | extend auction    !              |
    //     |    !                     |<---'                   !              |
    //     |    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!              |
    //     |    !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!              |
    //     |                          |                                       |
    //     |                          |----.                                  |
    //     |                          |    | emit AuctionBid()                |
    //     |                          |<---'                                  |
    //   Caller           ,-----------+------------.                ,---------+----------.
    //     ,-.            |ReserveAuctionFindersEth|                |ERC721TransferHelper|
    //     `-'            `------------------------'                `--------------------'
    //     /|\
    //      |
    //     / \
    /// @notice Places a bid on the auction for a given NFT
    /// @param _tokenContract The address of the ERC-721 token
    /// @param _tokenId The id of the ERC-721 token
    /// @param _finder The referrer of the bid
    function createBid(
        address _tokenContract,
        uint256 _tokenId,
        address _finder
    ) external payable nonReentrant {
        // Get the auction for the specified token
        Auction storage auction = auctionForNFT[_tokenContract][_tokenId];

        // Cache the seller
        address seller = auction.seller;

        // Ensure the auction exists
        require(seller != address(0), "AUCTION_DOES_NOT_EXIST");

        // Ensure the auction has started or is valid to start
        require(block.timestamp >= auction.startTime, "AUCTION_NOT_STARTED");

        // Cache more auction metadata
        uint256 firstBidTime = auction.firstBidTime;
        uint256 duration = auction.duration;

        // Used to emit whether the bid started the auction
        bool firstBid;

        // If this is the first bid, start the auction
        if (firstBidTime == 0) {
            // Ensure the bid meets the reserve price
            require(msg.value >= auction.reservePrice, "RESERVE_PRICE_NOT_MET");

            // Store the current time as the first bid time
            auction.firstBidTime = uint80(block.timestamp);

            // Mark this bid as the first
            firstBid = true;

            // Transfer the NFT from the seller into escrow for the duration of the auction
            // Reverts if the seller did not approve the ERC721TransferHelper or no longer owns the token
            erc721TransferHelper.transferFrom(_tokenContract, seller, address(this), _tokenId);

            // Else this is a subsequent bid, so refund the previous bidder
        } else {
            // Ensure the auction has not ended
            require(block.timestamp < (firstBidTime + duration), "AUCTION_OVER");

            // Cache the highest bid
            uint256 highestBid = auction.highestBid;

            // Used to store the minimum bid required to outbid the highest bidder
            uint256 minValidBid;

            // Calculate the minimum bid required (10% higher than the highest bid)
            // Cannot overflow as the highest bid would have to be magnitudes higher than the total supply of ETH
            unchecked {
                minValidBid = highestBid + ((highestBid * MIN_BID_INCREMENT_PERCENTAGE) / 100);
            }

            // Ensure the incoming bid meets the minimum
            require(msg.value >= minValidBid, "MINIMUM_BID_NOT_MET");

            // Refund the previous bidder
            _handleOutgoingTransfer(auction.highestBidder, highestBid, address(0), 50000);
        }

        // Store the attached ETH as the highest bid
        auction.highestBid = uint96(msg.value);

        // Store the caller as the highest bidder
        auction.highestBidder = msg.sender;

        // Store the finder of the bid
        auction.finder = _finder;

        // Used to emit whether the bid extended the auction
        bool extended;

        // Used to store the auction time remaining
        uint256 timeRemaining;

        // Get the auction time remaining
        // Cannot underflow as `firstBidTime + duration` is ensured to be greater than `block.timestamp`
        unchecked {
            timeRemaining = firstBidTime + duration - block.timestamp;
        }

        // If the bid is placed within 15 minutes of the auction end, extend the auction
        if (timeRemaining < TIME_BUFFER) {
            // Add (15 minutes - remaining time) to the duration so that 15 minutes remain
            // Cannot underflow as `timeRemaining` is ensured to be less than `TIME_BUFFER`
            unchecked {
                auction.duration += uint48(TIME_BUFFER - timeRemaining);
            }

            // Mark the bid as one that extended the auction
            extended = true;
        }

        emit AuctionBid(_tokenContract, _tokenId, firstBid, extended, auction);
    }

    //     ,-.
    //     `-'
    //     /|\
    //      |             ,------------------------.
    //     / \            |ReserveAuctionFindersEth|
    //   Caller           `-----------+------------'
    //     |      settleAuction()     |
    //     | ------------------------->
    //     |                          |
    //     |                          |----.
    //     |                          |    | validate auction ended
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | handle royalty payouts
    //     |                          |<---'
    //     |                          |
    //     |                          |
    //     |    __________________________________________________________
    //     |    ! ALT  /  finders fee configured for this auction?        !
    //     |    !_____/               |                                   !
    //     |    !                     |----.                              !
    //     |    !                     |    | handle finders fee payout    !
    //     |    !                     |<---'                              !
    //     |    !~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //     |    !~[noop]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~!
    //     |                          |
    //     |                          |----.
    //     |                          |    | handle seller funds recipient payout
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | transfer NFT from escrow to winning bidder
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | emit AuctionEnded()
    //     |                          |<---'
    //     |                          |
    //     |                          |----.
    //     |                          |    | delete auction from contract
    //     |                          |<---'
    //   Caller           ,-----------+------------.
    //     ,-.            |ReserveAuctionFindersEth|
    //     `-'            `------------------------'
    //     /|\
    //      |
    //     / \
    /// @notice Ends the auction for a given NFT
    /// @param _tokenContract The address of the ERC-721 token
    /// @param _tokenId The id of the ERC-721 token
    function settleAuction(address _tokenContract, uint256 _tokenId) external nonReentrant {
        // Get the auction for the specified token
        Auction memory auction = auctionForNFT[_tokenContract][_tokenId];

        // Cache the time of the first bid
        uint256 firstBidTime = auction.firstBidTime;

        // Ensure the auction had started
        require(firstBidTime != 0, "AUCTION_NOT_STARTED");

        // Ensure the auction has ended
        require(block.timestamp >= (firstBidTime + auction.duration), "AUCTION_NOT_OVER");

        // Payout associated token royalties, if any
        (uint256 remainingProfit, ) = _handleRoyaltyPayout(_tokenContract, _tokenId, auction.highestBid, address(0), 300000);

        // Payout the module fee, if configured by the owner
        remainingProfit = _handleProtocolFeePayout(remainingProfit, address(0));

        // Cache the finder of the winning bid
        address finder = auction.finder;

        // Payout the finder, if referred
        if (finder != address(0)) {
            // Get the fee from the remaining profit
            uint256 finderFee = (remainingProfit * auction.findersFeeBps) / 10000;

            // Transfer the amount to the finder
            _handleOutgoingTransfer(finder, finderFee, address(0), 50000);

            // Update the remaining profit
            remainingProfit -= finderFee;
        }

        // Transfer the remaining profit to the funds recipient
        _handleOutgoingTransfer(auction.sellerFundsRecipient, remainingProfit, address(0), 50000);

        // Transfer the NFT to the winning bidder
        IERC721(_tokenContract).transferFrom(address(this), auction.highestBidder, _tokenId);

        emit AuctionEnded(_tokenContract, _tokenId, auction);

        // Remove the auction from storage
        delete auctionForNFT[_tokenContract][_tokenId];
    }
}