// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

string constant OFFER_TYPESTRING = "Offer(address taker,address maker,address takerToken,uint256 takerTokenAmount,address makerToken,uint256 makerTokenAmount,uint256 minMakerTokenAmount,bool allowContractSender,uint256 expiry,uint256 salt)";

bytes32 constant OFFER_DATA_TYPEHASH = 0x69e58a4016a20956db5b73db5ade4616f6b0ffc09022f3bb6a8c25b3b02e510c;
// keccak256(OFFER_TYPESTRING);

struct Offer {
    address taker;
    address payable maker;
    address takerToken;
    uint256 takerTokenAmount;
    address makerToken;
    uint256 makerTokenAmount;
    uint256 minMakerTokenAmount;
    bool allowContractSender;
    uint256 expiry;
    uint256 salt;
}

// solhint-disable-next-line func-visibility
function getOfferHash(Offer memory offer) pure returns (bytes32) {
    return
        keccak256(
            abi.encode(
                OFFER_DATA_TYPEHASH,
                offer.taker,
                offer.maker,
                offer.takerToken,
                offer.takerTokenAmount,
                offer.makerToken,
                offer.makerTokenAmount,
                offer.minMakerTokenAmount,
                offer.allowContractSender,
                offer.expiry,
                offer.salt
            )
        );
}