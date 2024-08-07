// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @author: manifold.xyz

import "./ILazyPayableClaim.sol";

/**
 * Lazy Payable Claim interface
 */
interface IERC721LazyPayableClaim is ILazyPayableClaim {
    enum TokenUriStyle { INVALID, TOKEN_ID, MINT_ORDER, COMBINATION_ID }
    enum ReservationState { RESERVATION_CLOSED, RESERVATION_OPEN }

    struct ClaimParameters {
        uint32 totalMax;
        uint32 combinationMax;
        uint48 startDate;
        uint48 endDate;
        TokenUriStyle tokenUriStyle;
        ReservationState reservationState;
        string location;
        string extension;
        uint256 cost;
        address payable paymentReceiver;
        address erc20;
    }

    struct Claim {
        uint32 total;
        uint32 totalMax;
        uint32 combinationMax;
        uint48 startDate;
        uint48 endDate;
        uint8 contractVersion;
        TokenUriStyle tokenUriStyle;
        ReservationState reservationState;
        string location;
        string extension;
        uint256 cost;
        address payable paymentReceiver;
        address erc20;
    }

    /**
     * @notice initialize a new claim, emit initialize event
     * @param creatorContractAddress    the creator contract the claim will mint tokens for
     * @param instanceId                the claim instanceId for the creator contract
     * @param claimParameters           the parameters which will affect the minting behavior of the claim
     */
    function initializeClaim(address creatorContractAddress, uint256 instanceId, ClaimParameters calldata claimParameters) external;

    /**
     * @notice update an existing claim at instanceId
     * @param creatorContractAddress    the creator contract corresponding to the claim
     * @param instanceId                the claim instanceId for the creator contract
     * @param claimParameters           the parameters which will affect the minting behavior of the claim
     */
    function updateClaim(address creatorContractAddress, uint256 instanceId, ClaimParameters calldata claimParameters) external;

    /**
     * @notice update tokenURI parameters for an existing claim at instanceId
     * @param creatorContractAddress    the creator contract corresponding to the claim
     * @param instanceId                the claim instanceId for the creator contract
     * @param tokenUriStyle             the style of tokenURI
     * @param reservationState          the reservationState
     * @param location                  the new location
     * @param extension                 the new extension
     */
    function updateTokenURIParams(address creatorContractAddress, uint256 instanceId, TokenUriStyle tokenUriStyle, ReservationState reservationState, string calldata location, string calldata extension) external;


    /**
     * @notice extend tokenURI parameters for an existing claim at instanceId.  Must have NONE StorageProtocol
     * @param creatorContractAddress    the creator contract corresponding to the claim
     * @param instanceId                the claim instanceId for the creator contract
     * @param locationChunk             the additional location chunk
     */
    //function extendTokenURI(address creatorContractAddress, uint256 instanceId, string calldata locationChunk) external;

    /**
     * @notice get a claim corresponding to a creator contract and instanceId
     * @param creatorContractAddress    the address of the creator contract
     * @param instanceId                the claim instanceId for the creator contract
     * @return                          the claim object
     */
    function getClaim(address creatorContractAddress, uint256 instanceId) external view returns(Claim memory);

    /**
     * @notice get a claim corresponding to a token
     * @param creatorContractAddress    the address of the creator contract
     * @param tokenId                   the tokenId of the claim
     * @return                          the claim instanceId and claim object
     */
    function getClaimForToken(address creatorContractAddress, uint256 tokenId) external view returns(uint256, Claim memory);

    /**
     * @notice allow admin to airdrop arbitrary tokens 
     * @param creatorContractAddress    the creator contract the claim will mint tokens for
     * @param instanceId                the claim instanceId for the creator contract
     * @param recipients                addresses to airdrop to
     * @param amounts                   number of tokens to airdrop to each address in addresses
     */
    function airdrop(address creatorContractAddress, uint256 instanceId, address[] calldata recipients, uint16[] calldata amounts) external;
}