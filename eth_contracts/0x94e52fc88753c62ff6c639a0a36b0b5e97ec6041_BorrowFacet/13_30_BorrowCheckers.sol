// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.18;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

import {IBorrowCheckers} from "../interface/IBorrowCheckers.sol";

import {Signature} from "../Signature.sol";
import {NFTokenUtils} from "../utils/NFTokenUtils.sol";
import {Offer, OfferArg, NFToken} from "../../src/DataStructure/Objects.sol";
import {Protocol} from "../../src/DataStructure/Storage.sol";
import {protocolStorage} from "../../src/DataStructure/Global.sol";
// solhint-disable-next-line max-line-length
import {BadCollateral, OfferHasExpired, RequestedAmountTooHigh, RequestedAmountIsUnderMinimum, CurrencyNotSupported, InvalidTranche} from "../../src/DataStructure/Errors.sol";

/// @notice handles checks to verify validity of a loan request
abstract contract BorrowCheckers is IBorrowCheckers, Signature {
    using NFTokenUtils for NFToken;

    /// @notice checks arguments validity for usage of one Offer
    /// @param arg arguments for the Offer
    /// @return signer computed signer of `arg.signature` according to `arg.offer`
    function checkOfferArg(OfferArg memory arg) internal view returns (address signer) {
        Protocol storage proto = protocolStorage();

        /* it is statistically impossible to forge a signature that would lead to finding a signer that does not aggrees
        to the signed loan offer and that usage wouldn't revert due to the absence of approved funds to mobilize. This
        is how we know the signer address can't be the wrong one without leading to a revert. */
        signer = ECDSA.recover(offerDigest(arg.offer), arg.signature);

        /* we use a lower bound, I.e the actual amount must be strictly higher that this bound as a way to prevent a 0 
        amount to be used even in the case of an uninitialized parameter for a given erc20. This bound set by governance
        is used as an anti-ddos measure to prevent borrowers to spam the creation of supply positions not worth to claim
        by lenders from a gas cost perspective after a liquidation. more info in docs */
        uint256 amountLowerBound = proto.offerBorrowAmountLowerBound[arg.offer.assetToLend];

        // only erc20s for which the governance has set minimum thresholds are safe to use
        if (amountLowerBound == 0 || proto.minOfferCost[arg.offer.assetToLend] == 0) {
            revert CurrencyNotSupported(arg.offer.assetToLend);
        }

        if (!(arg.amount > amountLowerBound)) {
            revert RequestedAmountIsUnderMinimum(arg.offer, arg.amount, amountLowerBound);
        }
        /* the offer expiration date is meant to be used by lenders as a way to manage the evolution of market
        conditions */
        if (block.timestamp > arg.offer.expirationDate) {
            revert OfferHasExpired(arg.offer, arg.offer.expirationDate);
        }

        /* as tranches can't be deactivated, checking the number of tranches allows us to deduce if the tranche id is
        valid */
        if (arg.offer.tranche >= proto.nbOfTranches) {
            revert InvalidTranche(proto.nbOfTranches);
        }
    }

    /// @notice checks collateral validity regarding the offer
    /// @param offer loan offer which validity should be checked for the provided collateral
    /// @param providedNft nft sent to be used as collateral
    function checkCollateral(Offer memory offer, NFToken memory providedNft) internal pure {
        // we check the lender indeed approves the usage of its offer for the collateral used
        if (!offer.collateral.eq(providedNft)) {
            revert BadCollateral(offer, providedNft);
        }
    }
}