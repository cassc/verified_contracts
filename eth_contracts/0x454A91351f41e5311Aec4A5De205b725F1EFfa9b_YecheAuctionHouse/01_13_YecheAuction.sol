// SPDX-License-Identifier: GPL-3.0
// Forked from Zora Auction House: https://github.com/ourzora/auction-house

pragma solidity ^0.8.11;  
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import { IERC721, IERC165 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { ReentrancyGuard } from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import { IYecheAuctionHouse } from "./IYecheAuction.sol";

interface IWETH {
    function deposit() external payable;
    function withdraw(uint wad) external;

    function transfer(address to, uint256 value) external returns (bool);
}

/**
 * @title Yeche Lange auction contract
 */
contract YecheAuctionHouse is IYecheAuctionHouse, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using Counters for Counters.Counter;

    //Bid history
    mapping (uint256 => mapping (uint256 => IYecheAuctionHouse.Bid)) public bidHistory;

    //Did this user place a bid on this auction? 
    mapping (uint256 => mapping (address => bool)) public userBid;

    mapping (uint256 => uint256) public numBids;

    // The minimum amount of time left in an auction after a new bid is created
    uint256 public timeBuffer;

    // The minimum percentage difference between the last bid amount and the current bid.
    uint8 public minBidIncrementPercentage;

    // / The address of the WETH contract, so that any ETH transferred can be handled as an ERC-20
    address public wethAddress;

    // A mapping of all of the auctions currently running.
    mapping(uint256 => IYecheAuctionHouse.Auction) public auctions;

    bytes4 constant interfaceId = 0x80ac58cd; // 721 interface id

    Counters.Counter private _auctionIdTracker;

    /**
     * @notice Require that the specified auction exists
     */
    modifier auctionExists(uint256 auctionId) {
        require(_exists(auctionId), "Auction doesn't exist");
        _;
    }

    /*
     * Constructor
     */
    constructor(address _weth) {
        wethAddress = _weth;
        timeBuffer = 15 * 60; // extend 15 minutes after every bid made in last 15 minutes
        minBidIncrementPercentage = 5; // 5%
    }

    /**
     * @notice Create an auction.
     * @dev Store the auction details in the auctions mapping and emit an AuctionCreated event.
     */
    function createAuction(
        uint256 tokenId,
        address tokenContract,
        uint256 duration,
        uint256 reservePrice,
        address payable splitAddress,
        address auctionCurrency
    ) public override nonReentrant onlyOwner returns (uint256) {

        require(
            IERC165(tokenContract).supportsInterface(interfaceId),
            "tokenContract does not support ERC721 interface"
        );

        address tokenOwner = IERC721(tokenContract).ownerOf(tokenId);

        require(msg.sender == IERC721(tokenContract).getApproved(tokenId) || msg.sender == tokenOwner, "Caller must be approved or owner for token id");
        
        uint256 auctionId = _auctionIdTracker.current();

        auctions[auctionId] = Auction({
            tokenId: tokenId,
            tokenContract: tokenContract,
            approved: false,
            amount: 0,
            duration: duration,
            firstBidTime: 0,
            reservePrice: reservePrice,
            tokenOwner: tokenOwner,
            bidder: payable(address(0)),
            splitAddress: splitAddress,
            auctionCurrency: auctionCurrency
        });

        IERC721(tokenContract).transferFrom(tokenOwner, address(this), tokenId);

        _auctionIdTracker.increment();

        emit AuctionCreated(auctionId, tokenId, tokenContract, duration, reservePrice, tokenOwner, splitAddress, auctionCurrency);

        return auctionId;
    }

    function getBidHistory(uint256 auctionId) external view returns (Bid[] memory) {
        IYecheAuctionHouse.Bid[] memory bids = new IYecheAuctionHouse.Bid[](numBids[auctionId]);

        for (uint i = 0; i < numBids[auctionId]; i++) {
            bids[i] = bidHistory[auctionId][i];
        }
        return bids;
    }

    function getUserBid(address user, uint256 minAuctionId, uint256 maxAuctionId) external view returns (bool) {
        for (uint i = minAuctionId; i <= maxAuctionId; i++) {
            if (userBid[i][user]) {
                return true;
            }
        }
        return false;
    }

    /**
     * @notice Approve an auction, opening up the auction for bids.
     * @dev Only callable by the owner. Cannot be called if the auction has already started.
     */
    function setAuctionApproval(uint256 auctionId, bool approved) external override onlyOwner auctionExists(auctionId) {
        require(auctions[auctionId].firstBidTime == 0, "Auction has already started");
        _approveAuction(auctionId, approved);
    }

    function setAuctionReservePrice(uint256 auctionId, uint256 reservePrice) external override onlyOwner auctionExists(auctionId) {
        require(auctions[auctionId].firstBidTime == 0, "Auction has already started");

        auctions[auctionId].reservePrice = reservePrice;

        emit AuctionReservePriceUpdated(auctionId, auctions[auctionId].tokenId, auctions[auctionId].tokenContract, reservePrice);
    }

    /**
     * @notice Create a bid on a token, with a given amount.
     * @dev If provided a valid bid, transfers the provided amount to this contract.
     * If the auction is run in native ETH, the ETH is wrapped so it can be identically to other
     * auction currencies in this contract.
     */
    function createBid(uint256 auctionId, uint256 amount)
    external
    override
    payable
    auctionExists(auctionId)
    nonReentrant
    {
        address payable lastBidder = auctions[auctionId].bidder;
        require(auctions[auctionId].approved, "Auction must be approved by contract owner");
        require(
            auctions[auctionId].firstBidTime == 0 ||
            block.timestamp <
            auctions[auctionId].firstBidTime.add(auctions[auctionId].duration),
            "Auction expired"
        );
        require(
            amount >= auctions[auctionId].reservePrice,
                "Must send at least reservePrice"
        );
        require(
            amount >= auctions[auctionId].amount.add(
                auctions[auctionId].amount.mul(minBidIncrementPercentage).div(100)
            ),
            "Must send more than last bid by minBidIncrementPercentage amount"
        );

        // If this is the first valid bid, we should set the starting time now.
        // If it's not, then we should refund the last bidder
        if(auctions[auctionId].firstBidTime == 0) {
            auctions[auctionId].firstBidTime = block.timestamp;
        } else if(lastBidder != address(0)) {
            _handleOutgoingBid(lastBidder, auctions[auctionId].amount, auctions[auctionId].auctionCurrency);
        }

        _handleIncomingBid(amount, auctions[auctionId].auctionCurrency);

        auctions[auctionId].amount = amount;
        auctions[auctionId].bidder = payable(msg.sender);

        //update userBid 
        userBid[auctionId][msg.sender] = true;

        //add bid to bid history
        bidHistory[auctionId][numBids[auctionId]] = Bid({
            bidder: payable(msg.sender),
            amount: amount,
            timestamp: block.timestamp
        });
        numBids[auctionId]++;

        bool extended = false;
        // at this point we know that the timestamp is less than start + duration (since the auction would be over, otherwise)
        // we want to know by how much the timestamp is less than start + duration
        // if the difference is less than the timeBuffer, increase the duration by the timeBuffer
        if (
            auctions[auctionId].firstBidTime.add(auctions[auctionId].duration).sub(
                block.timestamp
            ) < timeBuffer
        ) {
            // Playing code golf for gas optimization:
            // uint256 expectedEnd = auctions[auctionId].firstBidTime.add(auctions[auctionId].duration);
            // uint256 timeRemaining = expectedEnd.sub(block.timestamp);
            // uint256 timeToAdd = timeBuffer.sub(timeRemaining);
            // uint256 newDuration = auctions[auctionId].duration.add(timeToAdd);
            uint256 oldDuration = auctions[auctionId].duration;
            auctions[auctionId].duration =
                oldDuration.add(timeBuffer.sub(auctions[auctionId].firstBidTime.add(oldDuration).sub(block.timestamp)));
            extended = true;
        }

        emit AuctionBid(
            auctionId,
            auctions[auctionId].tokenId,
            auctions[auctionId].tokenContract,
            msg.sender,
            amount,
            lastBidder == address(0), // firstBid boolean
            extended
        );

        if (extended) {
            emit AuctionDurationExtended(
                auctionId,
                auctions[auctionId].tokenId,
                auctions[auctionId].tokenContract,
                auctions[auctionId].duration
            );
        }
    }

    /**
     * @notice End an auction, finalizing the bid on Zora if applicable and paying out the respective parties.
     * @dev If for some reason the auction cannot be finalized (invalid token recipient, for example),
     * The auction is reset and the NFT is transferred back to the auction creator.
     */
    function endAuction(uint256 auctionId) external override auctionExists(auctionId) nonReentrant onlyOwner {
        require(
            uint256(auctions[auctionId].firstBidTime) != 0,
            "Auction hasn't begun"
        );
        require(
            block.timestamp >=
            auctions[auctionId].firstBidTime.add(auctions[auctionId].duration),
            "Auction hasn't completed"
        );

        address currency = auctions[auctionId].auctionCurrency == address(0) ? wethAddress : auctions[auctionId].auctionCurrency;

        uint256 tokenOwnerProfit = auctions[auctionId].amount;

        // transfer the token to the winner and pay out the participants below
        try IERC721(auctions[auctionId].tokenContract).safeTransferFrom(address(this), auctions[auctionId].bidder, auctions[auctionId].tokenId) {} catch {
            _handleOutgoingBid(auctions[auctionId].bidder, auctions[auctionId].amount, auctions[auctionId].auctionCurrency);
            _cancelAuction(auctionId);
            return;
        }

        _handleOutgoingBid(auctions[auctionId].splitAddress, tokenOwnerProfit, auctions[auctionId].auctionCurrency);

        emit AuctionEnded(
            auctionId,
            auctions[auctionId].tokenId,
            auctions[auctionId].tokenContract,
            auctions[auctionId].tokenOwner,
            auctions[auctionId].splitAddress,
            auctions[auctionId].bidder,
            tokenOwnerProfit,
            currency
        );
        delete auctions[auctionId];
    }

    /**
     * @notice Cancel an auction.
     * @dev Transfers the NFT back to the auction creator and emits an AuctionCanceled event
     */
    function cancelAuction(uint256 auctionId) external override nonReentrant onlyOwner auctionExists(auctionId) {
        require(
            uint256(auctions[auctionId].firstBidTime) == 0,
            "Can't cancel an auction once it's begun"
        );
        _cancelAuction(auctionId);
    }

    /**
     * @dev Given an amount and a currency, transfer the currency to this contract.
     * If the currency is ETH (0x0), attempt to wrap the amount as WETH
     */
    function _handleIncomingBid(uint256 amount, address currency) internal {
        // If this is an ETH bid, ensure they sent enough and convert it to WETH under the hood
        if(currency == address(0)) {
            require(msg.value == amount, "Sent ETH Value does not match specified bid amount");
            IWETH(wethAddress).deposit{value: amount}();
        } else {
            // We must check the balance that was actually transferred to the auction,
            // as some tokens impose a transfer fee and would not actually transfer the
            // full amount to the market, resulting in potentally locked funds
            IERC20 token = IERC20(currency);
            uint256 beforeBalance = token.balanceOf(address(this));
            token.safeTransferFrom(msg.sender, address(this), amount);
            uint256 afterBalance = token.balanceOf(address(this));
            require(beforeBalance.add(amount) == afterBalance, "Token transfer call did not transfer expected amount");
        }
    }

    function _handleOutgoingBid(address to, uint256 amount, address currency) internal {
        // If the auction is in ETH, unwrap it from its underlying WETH and try to send it to the recipient.
        if(currency == address(0)) {
            IWETH(wethAddress).withdraw(amount);

            // If the ETH transfer fails (sigh), rewrap the ETH and try send it as WETH.
            if(!_safeTransferETH(to, amount)) {
                IWETH(wethAddress).deposit{value: amount}();
                IERC20(wethAddress).safeTransfer(to, amount);
            }
        } else {
            IERC20(currency).safeTransfer(to, amount);
        }
    }

    function _safeTransferETH(address to, uint256 value) internal returns (bool) {
        (bool success, ) = to.call{value: value}(new bytes(0));
        return success;
    }

    function _cancelAuction(uint256 auctionId) internal {
        address tokenOwner = auctions[auctionId].tokenOwner;
        IERC721(auctions[auctionId].tokenContract).safeTransferFrom(address(this), tokenOwner, auctions[auctionId].tokenId);

        emit AuctionCanceled(auctionId, auctions[auctionId].tokenId, auctions[auctionId].tokenContract, tokenOwner);
        delete auctions[auctionId];
    }

    function _approveAuction(uint256 auctionId, bool approved) internal {
        auctions[auctionId].approved = approved;
        emit AuctionApprovalUpdated(auctionId, auctions[auctionId].tokenId, auctions[auctionId].tokenContract, approved);
    }

    function _exists(uint256 auctionId) internal view returns(bool) {
        return auctions[auctionId].tokenOwner != address(0);
    }

    // TODO: consider reverting if the message sender is not WETH
    receive() external payable {}
    fallback() external payable {}
}