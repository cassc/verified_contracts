/**
 * Created by Pragma Labs
 * SPDX-License-Identifier: BUSL-1.1
 */
pragma solidity ^0.8.13;

import { LogExpMath } from "./utils/LogExpMath.sol";
import { IFactory } from "./interfaces/IFactory.sol";
import { ERC20, SafeTransferLib } from "../lib/solmate/src/utils/SafeTransferLib.sol";
import { IVault } from "./interfaces/IVault.sol";
import { ILendingPool } from "./interfaces/ILendingPool.sol";
import { Owned } from "lib/solmate/src/auth/Owned.sol";

/**
 * @title Liquidator
 * @author Pragma Labs
 * @notice The liquidator holds the execution logic and storage of all things related to liquidating Arcadia Vaults.
 * Ensure your total value denomination remains above the liquidation threshold, or risk being liquidated!
 */
contract Liquidator is Owned {
    using SafeTransferLib for ERC20;

    /* //////////////////////////////////////////////////////////////
                                STORAGE
    ////////////////////////////////////////////////////////////// */

    // The contract address of the Factory.
    address public immutable factory;
    // Sets the begin price of the auction.
    // Defined as a percentage of openDebt, 2 decimals precision -> 150 = 150%.
    uint16 public startPriceMultiplier;
    // Sets the minimum price the auction converges to.
    // Defined as a percentage of openDebt, 2 decimals precision -> 60 = 60%.
    uint8 public minPriceMultiplier;
    // The base of the auction price curve (exponential).
    // Determines how fast the auction price drops per second, 18 decimals precision.
    uint64 public base;
    // Maximum time that the auction declines, after which price is equal to the minimum price set by minPriceMultiplier.
    // Time in seconds, with 0 decimals precision.
    uint16 public cutoffTime;
    // Fee paid to the Liquidation Initiator.
    // Defined as a fraction of the openDebt with 2 decimals precision.
    // Absolute fee can be further capped to a max amount by the creditor.
    uint8 public initiatorRewardWeight;
    // Penalty the Vault owner has to pay to the trusted Creditor on top of the open Debt for being liquidated.
    // Defined as a fraction of the openDebt with 2 decimals precision.
    uint8 public penaltyWeight;

    // Map vault => auctionInformation.
    mapping(address => AuctionInformation) public auctionInformation;

    // Struct with additional information about the auction of a specific Vault.
    struct AuctionInformation {
        uint128 openDebt; // The open debt, same decimal precision as baseCurrency.
        uint32 startTime; // The timestamp the auction started.
        bool inAuction; // Flag indicating if the auction is still ongoing.
        uint80 maxInitiatorFee; // The max initiation fee, same decimal precision as baseCurrency.
        address baseCurrency; // The contract address of the baseCurrency.
        uint16 startPriceMultiplier; // 2 decimals precision.
        uint8 minPriceMultiplier; // 2 decimals precision.
        uint8 initiatorRewardWeight; // 2 decimals precision.
        uint8 penaltyWeight; // 2 decimals precision.
        uint16 cutoffTime; // Maximum time that the auction declines.
        address originalOwner; // The original owner of the Vault.
        address trustedCreditor; // The creditor that issued the debt.
        uint64 base; // Determines how fast the auction price drops over time.
    }

    /* //////////////////////////////////////////////////////////////
                                EVENTS
    ////////////////////////////////////////////////////////////// */

    event WeightsSet(uint8 initiatorRewardWeight, uint8 penaltyWeight);
    event AuctionCurveParametersSet(uint64 base, uint16 cutoffTime);
    event StartPriceMultiplierSet(uint16 startPriceMultiplier);
    event MinimumPriceMultiplierSet(uint8 minPriceMultiplier);
    event AuctionStarted(address indexed vault, address indexed creditor, address baseCurrency, uint128 openDebt);
    event AuctionFinished(
        address indexed vault,
        address indexed creditor,
        address baseCurrency,
        uint128 price,
        uint128 badDebt,
        uint128 initiatorReward,
        uint128 liquidationPenalty,
        uint128 remainder
    );

    /* //////////////////////////////////////////////////////////////
                                CONSTRUCTOR
    ////////////////////////////////////////////////////////////// */

    constructor(address factory_) Owned(msg.sender) {
        factory = factory_;
        initiatorRewardWeight = 1;
        penaltyWeight = 5;
        startPriceMultiplier = 150;
        minPriceMultiplier = 60;
        cutoffTime = 14_400; //4 hours
        base = 999_807_477_651_317_446; //3600s halflife, 14_400 cutoff
    }

    /*///////////////////////////////////////////////////////////////
                        MANAGE AUCTION SETTINGS
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Sets the liquidation weights.
     * @param initiatorRewardWeight_ Fee paid to the Liquidation Initiator.
     * @param penaltyWeight_ Penalty paid by the Vault owner to the trusted Creditor.
     * @dev Each weight has 2 decimals precision (50 equals 0,5 or 50%).
     */
    function setWeights(uint256 initiatorRewardWeight_, uint256 penaltyWeight_) external onlyOwner {
        require(initiatorRewardWeight_ + penaltyWeight_ <= 11, "LQ_SW: Weights Too High");

        initiatorRewardWeight = uint8(initiatorRewardWeight_);
        penaltyWeight = uint8(penaltyWeight_);

        emit WeightsSet(uint8(initiatorRewardWeight_), uint8(penaltyWeight_));
    }

    /**
     * @notice Sets the parameters (base and cutOffTime) of the auction price curve (decreasing power function).
     * @param halfLifeTime The base is not set directly, but it's derived from a more intuitive parameter, the halfLifeTime:
     * The time ΔT_hl (in seconds with 0 decimals) it takes for the power function to halve in value.
     * @dev The relation between the base and the halfLife time (ΔT_hl):
     * The power function is defined as: N(t) = N(0) * (1/2)^(t/ΔT_hl).
     * Or simplified: N(t) = N(O) * base^t => base = 1/[2^(1/ΔT_hl)].
     * @param cutoffTime_ The Maximum time that the auction declines,
     * after which price is equal to the minimum price set by minPriceMultiplier.
     * @dev Setting a very short cutoffTime can be used by rogue owners to rug the junior tranche!!
     * Therefore the cutoffTime has hardcoded constraints.
     * @dev All calculations are done with 18 decimals precision.
     */
    function setAuctionCurveParameters(uint16 halfLifeTime, uint16 cutoffTime_) external onlyOwner {
        //Checks that new parameters are within reasonable boundaries.
        require(halfLifeTime > 120, "LQ_SACP: halfLifeTime too low"); // 2 minutes
        require(halfLifeTime < 28_800, "LQ_SACP: halfLifeTime too high"); // 8 hours
        require(cutoffTime_ > 3600, "LQ_SACP: cutoff too low"); // 1 hour
        require(cutoffTime_ < 64_800, "LQ_SACP: cutoff too high"); // 18 hours

        //Derive base from the halfLifeTime.
        uint64 base_ = uint64(1e18 * 1e18 / LogExpMath.pow(2 * 1e18, 1e18 / halfLifeTime));

        //Check that LogExpMath.pow(base, timePassed) does not error at cutoffTime (due to numbers smaller than minimum precision).
        //Since LogExpMath.pow is a strictly decreasing function checking the power function at cutoffTime
        //guarantees that the function does not revert on all timestamps between start of the auction and the cutoffTime.
        LogExpMath.pow(base_, uint256(cutoffTime_) * 1e18);

        //Store the new parameters.
        base = base_;
        cutoffTime = cutoffTime_;

        emit AuctionCurveParametersSet(base_, cutoffTime_);
    }

    /**
     * @notice Sets the start price multiplier for the liquidator.
     * @param startPriceMultiplier_ The new start price multiplier, with 2 decimals precision.
     * @dev The start price multiplier is a multiplier that is used to increase the initial price of the auction.
     * Since the value of all assets are discounted with the liquidation factor, and because pricing modules will take a conservative
     * approach to price assets (eg. floor-prices for NFTs), the actual value of the assets being auctioned might be substantially higher
     * as the open debt. Hence the auction starts at a multiplier of the openDebt, but decreases rapidly (exponential decay).
     */
    function setStartPriceMultiplier(uint16 startPriceMultiplier_) external onlyOwner {
        require(startPriceMultiplier_ > 100, "LQ_SSPM: multiplier too low");
        require(startPriceMultiplier_ < 301, "LQ_SSPM: multiplier too high");
        startPriceMultiplier = startPriceMultiplier_;

        emit StartPriceMultiplierSet(startPriceMultiplier_);
    }

    /**
     * @notice Sets the minimum price multiplier for the liquidator.
     * @param minPriceMultiplier_ The new minimum price multiplier, with 2 decimals precision.
     * @dev The minimum price multiplier sets a lower bound to which the auction price converges.
     */
    function setMinimumPriceMultiplier(uint8 minPriceMultiplier_) external onlyOwner {
        require(minPriceMultiplier_ < 91, "LQ_SMPM: multiplier too high");
        minPriceMultiplier = minPriceMultiplier_;

        emit MinimumPriceMultiplierSet(minPriceMultiplier_);
    }

    /*///////////////////////////////////////////////////////////////
                            AUCTION LOGIC
    ///////////////////////////////////////////////////////////////*/

    /**
     * @notice Called by a Creditor to start an auction to liquidate collateral of a vault.
     * @param vault The contract address of the Vault to liquidate.
     * @param openDebt The open debt taken by `originalOwner`.
     * @param maxInitiatorFee The upper limit for the fee paid to the Liquidation Initiator, set by the trusted Creditor.
     * @dev This function is called by the Creditor who is owed the debt issued against the Vault.
     */
    function startAuction(address vault, uint256 openDebt, uint80 maxInitiatorFee) public {
        require(!auctionInformation[vault].inAuction, "LQ_SA: Auction already ongoing");

        //Avoid possible re-entrance with the same vault address.
        auctionInformation[vault].inAuction = true;

        //A malicious msg.sender can pass a self created contract as vault (not an actual Arcadia-Vault) that returns true on liquidateVault().
        //This would successfully start an auction, but as long as no collision with an actual Arcadia-vault contract address is found, this is not an issue.
        //The malicious non-vault would be in auction indefinitely, but does not block any 'real' auctions of Arcadia-Vaults.
        //One exception is if an attacker finds a pre-image of his custom contract with the same contract address of an Arcadia-Vault (deployed via create2).
        //The attacker could in theory: start auction of malicious contract, self-destruct and create Arcadia-vault with identical contract address.
        //This Vault could never be auctioned since auctionInformation[vault].inAuction would return true.
        //Finding such a collision requires finding a collision of the keccak256 hash function.
        (address originalOwner, address baseCurrency, address trustedCreditor) = IVault(vault).liquidateVault(openDebt);

        //Check that msg.sender is indeed the Creditor of the Vault.
        require(trustedCreditor == msg.sender, "LQ_SA: Unauthorised");

        auctionInformation[vault].openDebt = uint128(openDebt);
        auctionInformation[vault].startTime = uint32(block.timestamp);
        auctionInformation[vault].maxInitiatorFee = maxInitiatorFee;
        auctionInformation[vault].baseCurrency = baseCurrency;
        auctionInformation[vault].startPriceMultiplier = startPriceMultiplier;
        auctionInformation[vault].minPriceMultiplier = minPriceMultiplier;
        auctionInformation[vault].initiatorRewardWeight = initiatorRewardWeight;
        auctionInformation[vault].penaltyWeight = penaltyWeight;
        auctionInformation[vault].cutoffTime = cutoffTime;
        auctionInformation[vault].originalOwner = originalOwner;
        auctionInformation[vault].trustedCreditor = msg.sender;
        auctionInformation[vault].base = base;

        emit AuctionStarted(vault, trustedCreditor, baseCurrency, uint128(openDebt));
    }

    /**
     * @notice Function returns the current auction price of a vault.
     * @param vault The contract address of the vault.
     * @return price the total price for which the vault can be purchased.
     * @return inAuction returns false when the vault is not being auctioned.
     * @dev We use a dutch auction: price constantly decreases and the first bidder buys the vault
     * and immediately ends the auction.
     */
    function getPriceOfVault(address vault) public view returns (uint256 price, bool inAuction) {
        inAuction = auctionInformation[vault].inAuction;

        if (!inAuction) {
            return (0, false);
        }

        price = _calcPriceOfVault(auctionInformation[vault]);
    }

    /**
     * @notice Function returns the current auction price given time passed and the openDebt.
     * @param auctionInfo The auction information.
     * @return price The total price for which the vault can be purchased.
     * @dev We use a dutch auction: price constantly decreases and the first bidder buys the vault and immediately ends the auction.
     * @dev Price P(t) decreases exponentially over time: P(t) = openDebt * [(SPM - MPM) * base^t + MPM]:
     * SPM: The startPriceMultiplier defines the initial price: P(0) = openDebt * SPM (2 decimals precision).
     * MPM: The minPriceMultiplier defines the asymptotic end price for P(∞) = openDebt * MPM (2 decimals precision).
     * base: defines how fast the exponential curve decreases (18 decimals precision).
     * t: time passed since start auction (in seconds, 18 decimals precision).
     * @dev LogExpMath was made in solidity 0.7, where operations were unchecked.
     */
    function _calcPriceOfVault(AuctionInformation memory auctionInfo) internal view returns (uint256 price) {
        //Time passed is a difference of two Uint32 -> can't overflow.
        uint256 timePassed;
        unchecked {
            timePassed = block.timestamp - auctionInfo.startTime; //time duration in seconds.

            if (timePassed > auctionInfo.cutoffTime) {
                //Cut-off time passed -> return the minimal value defined by minPriceMultiplier (2 decimals precision).
                //No overflow possible: uint128 * uint8.
                price = uint256(auctionInfo.openDebt) * auctionInfo.minPriceMultiplier / 1e2;
            } else {
                //Bring to 18 decimals precision for LogExpMath.pow()
                //No overflow possible: uin32 * uint64.
                timePassed = timePassed * 1e18;

                //pow(base, timePassed) has 18 decimals and is strictly smaller than 1 (-> smaller as 1e18).
                //No overflow possible: uint128 * uint64 * uint8.
                //Multipliers have 2 decimals precision and LogExpMath.pow() has 18 decimals precision,
                //hence we need to divide the result by 1e20.
                price = auctionInfo.openDebt
                    * (
                        LogExpMath.pow(auctionInfo.base, timePassed)
                            * (auctionInfo.startPriceMultiplier - auctionInfo.minPriceMultiplier)
                            + 1e18 * uint256(auctionInfo.minPriceMultiplier)
                    ) / 1e20;
            }
        }
    }

    /**
     * @notice Function a user (the bidder) calls to buy the vault and end the auction.
     * @param vault The contract address of the vault.
     * @dev We use a dutch auction: price constantly decreases and the first bidder buys the vault
     * And immediately ends the auction.
     */
    function buyVault(address vault) external {
        AuctionInformation memory auctionInformation_ = auctionInformation[vault];
        require(auctionInformation_.inAuction, "LQ_BV: Not for sale");

        uint256 priceOfVault = _calcPriceOfVault(auctionInformation_);
        //Stop the auction, this will prevent any possible reentrance attacks.
        auctionInformation[vault].inAuction = false;

        //Transfer funds, equal to the current auction price from the bidder to the Creditor contract.
        //The bidder should have approved the Liquidation contract for at least an amount of priceOfVault.
        ERC20(auctionInformation_.baseCurrency).safeTransferFrom(
            msg.sender, auctionInformation_.trustedCreditor, priceOfVault
        );

        (uint256 badDebt, uint256 liquidationInitiatorReward, uint256 liquidationPenalty, uint256 remainder) =
        calcLiquidationSettlementValues(auctionInformation_.openDebt, priceOfVault, auctionInformation_.maxInitiatorFee);

        ILendingPool(auctionInformation_.trustedCreditor).settleLiquidation(
            vault, auctionInformation_.originalOwner, badDebt, liquidationInitiatorReward, liquidationPenalty, remainder
        );

        //Change ownership of the auctioned vault to the bidder.
        IFactory(factory).safeTransferFrom(address(this), msg.sender, vault);

        emit AuctionFinished(
            vault,
            auctionInformation_.trustedCreditor,
            auctionInformation_.baseCurrency,
            uint128(priceOfVault),
            uint128(badDebt),
            uint128(liquidationInitiatorReward),
            uint128(liquidationPenalty),
            uint128(remainder)
        );
    }

    /**
     * @notice End an unsuccessful auction after the cutoffTime has passed.
     * @param vault The contract address of the vault.
     * @param to The address to which the vault will be transferred.
     * @dev This is an emergency process, and can not be triggered under normal operation.
     * The auction will be stopped and the vault will be transferred to the provided address.
     * The junior tranche of the liquidity pool will pay for the bad debt.
     * The protocol will sell/auction the vault in another way to recover the debt.
     * The protocol will later "donate" these proceeds back to the junior tranche and/or other
     * impacted Tranches, this last step is not enforced by the smart contracts.
     * While this process is not fully trustless, it is the only way to solve an extreme unhappy flow,
     * where an auction did not end within cutoffTime (due to market or technical reasons).
     */
    function endAuction(address vault, address to) external onlyOwner {
        AuctionInformation memory auctionInformation_ = auctionInformation[vault];
        require(auctionInformation_.inAuction, "LQ_EA: Not for sale");

        uint256 timePassed;
        unchecked {
            timePassed = block.timestamp - auctionInformation_.startTime;
        }
        require(timePassed > cutoffTime, "LQ_EA: Auction not expired");

        //Stop the auction, this will prevent any possible reentrance attacks.
        auctionInformation[vault].inAuction = false;

        (uint256 badDebt, uint256 liquidationInitiatorReward, uint256 liquidationPenalty, uint256 remainder) =
            calcLiquidationSettlementValues(auctionInformation_.openDebt, 0, auctionInformation_.maxInitiatorFee); //priceOfVault is zero.

        ILendingPool(auctionInformation_.trustedCreditor).settleLiquidation(
            vault, auctionInformation_.originalOwner, badDebt, liquidationInitiatorReward, liquidationPenalty, remainder
        );

        //Change ownership of the auctioned vault to the protocol owner.
        IFactory(factory).safeTransferFrom(address(this), to, vault);

        emit AuctionFinished(
            vault,
            auctionInformation_.trustedCreditor,
            auctionInformation_.baseCurrency,
            0,
            uint128(badDebt),
            uint128(liquidationInitiatorReward),
            uint128(liquidationPenalty),
            uint128(remainder)
        );
    }

    /**
     * @notice Calculates how the liquidation needs to be further settled with the Creditor, Original owner and Service providers.
     * @param openDebt The open debt taken by `originalOwner`.
     * @param priceOfVault The final selling price of the Vault.
     * @return badDebt The amount of liabilities that was not recouped by the auction.
     * @return liquidationInitiatorReward The Reward for the Liquidation Initiator.
     * @return liquidationPenalty The additional penalty the `originalOwner` has to pay to the protocol.
     * @return remainder Any funds remaining after the auction are returned back to the `originalOwner`.
     * @dev All values are denominated in the baseCurrency of the Vault.
     * @dev We use a dutch auction: price constantly decreases and the first bidder buys the vault
     * And immediately ends the auction.
     */
    function calcLiquidationSettlementValues(uint256 openDebt, uint256 priceOfVault, uint88 maxInitiatorFee)
        public
        view
        returns (uint256 badDebt, uint256 liquidationInitiatorReward, uint256 liquidationPenalty, uint256 remainder)
    {
        //openDebt is a uint128 -> all calculations can be unchecked.
        unchecked {
            //Liquidation Initiator Reward is always paid out, independent of the final auction price.
            //The reward is calculated as a fixed percentage of open debt, but capped on the upside (maxInitiatorFee).
            liquidationInitiatorReward = openDebt * initiatorRewardWeight / 100;
            liquidationInitiatorReward =
                liquidationInitiatorReward > maxInitiatorFee ? maxInitiatorFee : liquidationInitiatorReward;

            //Final Auction price should at least cover the original debt and Liquidation Initiator Reward.
            //Otherwise there is bad debt.
            if (priceOfVault < openDebt + liquidationInitiatorReward) {
                badDebt = openDebt + liquidationInitiatorReward - priceOfVault;
            } else {
                liquidationPenalty = openDebt * penaltyWeight / 100;
                remainder = priceOfVault - openDebt - liquidationInitiatorReward;

                //Check if the remainder can cover the full liquidation penalty.
                if (remainder > liquidationPenalty) {
                    //If yes, calculate the final remainder.
                    remainder -= liquidationPenalty;
                } else {
                    //If not, there is no remainder for the originalOwner.
                    liquidationPenalty = remainder;
                    remainder = 0;
                }
            }
        }
    }
}