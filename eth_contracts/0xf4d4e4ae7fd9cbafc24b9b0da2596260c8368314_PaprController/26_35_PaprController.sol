//SPDX-License-Identifier: BUSL-1.1
pragma solidity =0.8.17;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {ERC721, ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";
import {INFTEDA, NFTEDAStarterIncentive} from "./NFTEDA/extensions/NFTEDAStarterIncentive.sol";
import {Ownable2Step} from "openzeppelin-contracts/access/Ownable2Step.sol";
import {Multicallable} from "solady/utils/Multicallable.sol";

import {PaprToken} from "./PaprToken.sol";
import {UniswapOracleFundingRateController} from "./UniswapOracleFundingRateController.sol";
import {ReservoirOracleUnderwriter} from "./ReservoirOracleUnderwriter.sol";
import {IPaprController} from "./interfaces/IPaprController.sol";
import {UniswapHelpers} from "./libraries/UniswapHelpers.sol";

contract PaprController is
    IPaprController,
    UniswapOracleFundingRateController,
    ERC721TokenReceiver,
    Multicallable,
    Ownable2Step,
    ReservoirOracleUnderwriter,
    NFTEDAStarterIncentive
{
    using SafeTransferLib for ERC20;

    /// @dev what 1 = 100% is in basis points (bips)
    uint256 public constant BIPS_ONE = 1e4;

    bool public override liquidationsLocked;

    /// @inheritdoc IPaprController
    bool public immutable override token0IsUnderlying;

    /// @inheritdoc IPaprController
    uint256 public immutable override maxLTV;

    /// @inheritdoc IPaprController
    uint256 public immutable override liquidationAuctionMinSpacing = 2 days;

    uint256 private immutable perPeriodAuctionDecayWAD = 0.7e18;

    uint256 private immutable auctionDecayPeriod = 1 days;

    uint256 private immutable auctionStartPriceMultiplier = 3;

    /// @inheritdoc IPaprController
    /// @dev Set to 10%
    uint256 public immutable override liquidationPenaltyBips = 1000;

    /// @inheritdoc IPaprController
    mapping(ERC721 => mapping(uint256 => address)) public override collateralOwner;

    /// @inheritdoc IPaprController
    mapping(ERC721 => bool) public override isAllowed;

    /// @dev account => asset => vaultInfo
    mapping(address => mapping(ERC721 => IPaprController.VaultInfo)) private _vaultInfo;

    /// @dev does not validate args
    /// e.g. does not check whether underlying or oracleSigner are address(0)
    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxLTV,
        uint256 indexMarkRatioMax,
        uint256 indexMarkRatioMin,
        ERC20 underlying,
        address oracleSigner
    )
        NFTEDAStarterIncentive(1e17)
        UniswapOracleFundingRateController(underlying, new PaprToken(name, symbol), indexMarkRatioMax, indexMarkRatioMin)
        ReservoirOracleUnderwriter(oracleSigner, address(underlying))
    {
        maxLTV = _maxLTV;
        token0IsUnderlying = address(underlying) < address(papr);
        uint256 underlyingONE = 10 ** underlying.decimals();
        uint160 initSqrtRatio;

        // initialize the pool at 1:1
        if (token0IsUnderlying) {
            initSqrtRatio = UniswapHelpers.oneToOneSqrtRatio(underlyingONE, 1e18);
        } else {
            initSqrtRatio = UniswapHelpers.oneToOneSqrtRatio(1e18, underlyingONE);
        }

        address _pool = UniswapHelpers.deployAndInitPool(address(underlying), address(papr), 10000, initSqrtRatio);

        _init(underlyingONE, _pool);
    }

    /// @inheritdoc IPaprController
    function addCollateral(IPaprController.Collateral[] calldata collateralArr) external override {
        for (uint256 i = 0; i < collateralArr.length;) {
            _addCollateralToVault(msg.sender, collateralArr[i]);
            collateralArr[i].addr.transferFrom(msg.sender, address(this), collateralArr[i].id);
            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IPaprController
    function removeCollateral(
        address sendTo,
        IPaprController.Collateral[] calldata collateralArr,
        ReservoirOracleUnderwriter.OracleInfo calldata oracleInfo
    ) external override {
        uint256 cachedTarget = updateTarget();
        uint256 oraclePrice;
        ERC721 collateralAddr;

        for (uint256 i = 0; i < collateralArr.length;) {
            if (i == 0) {
                collateralAddr = collateralArr[i].addr;
                oraclePrice = underwritePriceForCollateral(
                    collateralAddr, ReservoirOracleUnderwriter.PriceKind.LOWER, oracleInfo, true
                );
            } else {
                if (collateralAddr != collateralArr[i].addr) {
                    revert CollateralAddressesDoNotMatch();
                }
            }

            _removeCollateral(sendTo, collateralArr[i], oraclePrice, cachedTarget);

            unchecked {
                ++i;
            }
        }
    }

    /// @inheritdoc IPaprController
    function increaseDebt(
        address mintTo,
        ERC721 asset,
        uint256 amount,
        ReservoirOracleUnderwriter.OracleInfo calldata oracleInfo
    ) external override {
        _increaseDebt({account: msg.sender, asset: asset, mintTo: mintTo, amount: amount, oracleInfo: oracleInfo});
    }

    /// @inheritdoc IPaprController
    function reduceDebt(address account, ERC721 asset, uint256 amount) external override {
        uint256 debt = _vaultInfo[account][asset].debt;
        _reduceDebt({
            account: account,
            asset: asset,
            burnFrom: msg.sender,
            accountDebt: debt,
            amountToReduce: amount > debt ? debt : amount
        });
    }

    /// @notice Handler for safeTransferFrom of an NFT
    /// @dev Should be preferred to `addCollateral` if only one NFT is being added
    /// to avoid approval call and save gas
    /// @param from the current owner of the nft
    /// @param _id the id of the NFT
    /// @param data encoded IPaprController.OnERC721ReceivedArgs
    /// @return selector indicating succesful receiving of the NFT
    function onERC721Received(address, address from, uint256 _id, bytes calldata data)
        external
        override
        returns (bytes4)
    {
        IPaprController.OnERC721ReceivedArgs memory request = abi.decode(data, (IPaprController.OnERC721ReceivedArgs));

        IPaprController.Collateral memory collateral = IPaprController.Collateral(ERC721(msg.sender), _id);

        _addCollateralToVault(from, collateral);

        if (request.swapParams.minOut > 0) {
            _increaseDebtAndSell(from, request.proceedsTo, ERC721(msg.sender), request.swapParams, request.oracleInfo);
        } else if (request.debt > 0) {
            _increaseDebt(from, collateral.addr, request.proceedsTo, request.debt, request.oracleInfo);
        }

        return ERC721TokenReceiver.onERC721Received.selector;
    }

    /// CONVENIENCE SWAP FUNCTIONS ///

    /// @inheritdoc IPaprController
    function increaseDebtAndSell(
        address proceedsTo,
        ERC721 collateralAsset,
        IPaprController.SwapParams calldata params,
        ReservoirOracleUnderwriter.OracleInfo calldata oracleInfo
    ) external override returns (uint256 amountOut) {
        bool hasFee = params.swapFeeBips != 0;

        (amountOut,) = UniswapHelpers.swap(
            pool,
            hasFee ? address(this) : proceedsTo,
            !token0IsUnderlying,
            params.amount,
            params.minOut,
            params.sqrtPriceLimitX96,
            params.deadline,
            abi.encode(msg.sender, collateralAsset, oracleInfo)
        );

        if (hasFee) {
            uint256 fee = amountOut * params.swapFeeBips / BIPS_ONE;
            underlying.safeTransfer(params.swapFeeTo, fee);
            underlying.safeTransfer(proceedsTo, amountOut - fee);
        }
    }

    /// @inheritdoc IPaprController
    function buyAndReduceDebt(address account, ERC721 collateralAsset, IPaprController.SwapParams calldata params)
        external
        override
        returns (uint256)
    {
        bool hasFee = params.swapFeeBips != 0;

        (uint256 amountOut, uint256 amountIn) = UniswapHelpers.swap(
            pool,
            msg.sender,
            token0IsUnderlying,
            params.amount,
            params.minOut,
            params.sqrtPriceLimitX96,
            params.deadline,
            abi.encode(msg.sender)
        );

        if (hasFee) {
            underlying.safeTransferFrom(msg.sender, params.swapFeeTo, amountIn * params.swapFeeBips / BIPS_ONE);
        }

        uint256 debt = _vaultInfo[account][collateralAsset].debt;
        _reduceDebt({
            account: account,
            asset: collateralAsset,
            burnFrom: msg.sender,
            accountDebt: debt,
            amountToReduce: amountOut > debt ? debt : amountOut
        });

        return amountOut;
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata _data) external {
        if (msg.sender != address(pool)) {
            revert("wrong caller");
        }

        bool isUnderlyingIn;
        uint256 amountToPay;
        if (amount0Delta > 0) {
            amountToPay = uint256(amount0Delta);
            isUnderlyingIn = token0IsUnderlying;
        } else {
            require(amount1Delta > 0); // swaps entirely within 0-liquidity regions are not supported

            amountToPay = uint256(amount1Delta);
            isUnderlyingIn = !(token0IsUnderlying);
        }

        if (isUnderlyingIn) {
            address payer = abi.decode(_data, (address));
            underlying.safeTransferFrom(payer, msg.sender, amountToPay);
        } else {
            (address account, ERC721 asset, ReservoirOracleUnderwriter.OracleInfo memory oracleInfo) =
                abi.decode(_data, (address, ERC721, ReservoirOracleUnderwriter.OracleInfo));
            _increaseDebt(account, asset, msg.sender, amountToPay, oracleInfo);
        }
    }

    /// LIQUIDATION AUCTION FUNCTIONS ///

    /// @inheritdoc IPaprController
    function purchaseLiquidationAuctionNFT(
        Auction calldata auction,
        uint256 maxPrice,
        address sendTo,
        ReservoirOracleUnderwriter.OracleInfo calldata oracleInfo
    ) external override {
        // This function is almost the same as NFTEDA._purchaseNFT
        // however we inline so we can receive payment first
        // and execute logic before sending NFT
        uint256 id;
        uint256 startTime;
        uint256 price;
        (id, startTime, price) = _checkAuctionAndReturnDetails(auction);

        if (price > maxPrice) {
            revert MaxPriceTooLow(price, maxPrice);
        }

        _clearAuctionState(id);

        if (startTime == _vaultInfo[auction.nftOwner][auction.auctionAssetContract].latestAuctionStartTime) {
            _vaultInfo[auction.nftOwner][auction.auctionAssetContract].latestAuctionStartTime = 0;
        }

        auction.paymentAsset.safeTransferFrom(msg.sender, address(this), price);

        _auctionPurchaseUpdateVault(price, auction.nftOwner, auction.auctionAssetContract, oracleInfo);

        auction.auctionAssetContract.safeTransferFrom(address(this), sendTo, auction.auctionAssetID);

        emit EndAuction(id, price);
    }

    /// @inheritdoc IPaprController
    function startLiquidationAuction(
        address account,
        IPaprController.Collateral calldata collateral,
        ReservoirOracleUnderwriter.OracleInfo calldata oracleInfo
    ) external override returns (INFTEDA.Auction memory auction) {
        if (liquidationsLocked) {
            revert LiquidationsLocked();
        }

        uint256 cachedTarget = updateTarget();

        IPaprController.VaultInfo storage info = _vaultInfo[account][collateral.addr];

        // check collateral belongs to account
        if (collateralOwner[collateral.addr][collateral.id] != account) {
            revert IPaprController.InvalidCollateralAccountPair();
        }

        uint256 oraclePrice =
            underwritePriceForCollateral(collateral.addr, ReservoirOracleUnderwriter.PriceKind.TWAP, oracleInfo, false);
        if (!(info.debt > _maxDebt(oraclePrice * info.count, cachedTarget))) {
            revert IPaprController.NotLiquidatable();
        }

        if (block.timestamp - info.latestAuctionStartTime < liquidationAuctionMinSpacing) {
            revert IPaprController.MinAuctionSpacing();
        }

        info.latestAuctionStartTime = uint40(block.timestamp);
        --info.count;
        ++info.auctionCount;

        emit RemoveCollateral(account, collateral.addr, collateral.id);

        delete collateralOwner[collateral.addr][collateral.id];

        _startAuction(
            auction = Auction({
                nftOwner: account,
                auctionAssetID: collateral.id,
                auctionAssetContract: collateral.addr,
                perPeriodDecayPercentWad: perPeriodAuctionDecayWAD,
                secondsInPeriod: auctionDecayPeriod,
                // start price is frozen price * auctionStartPriceMultiplier,
                // converted to papr value at the current contract price
                startPrice: (oraclePrice * auctionStartPriceMultiplier) * FixedPointMathLib.WAD / cachedTarget,
                paymentAsset: papr
            })
        );
    }

    /// OWNER FUNCTIONS ///

    /// @inheritdoc IPaprController
    function setPool(address _pool) external override onlyOwner {
        _setPool(_pool);
        emit UpdatePool(_pool);
    }

    /// @inheritdoc IPaprController
    function setFundingPeriod(uint256 _fundingPeriod) external override onlyOwner {
        _setFundingPeriod(_fundingPeriod);
        emit UpdateFundingPeriod(_fundingPeriod);
    }

    /// @inheritdoc IPaprController
    function setLiquidationsLocked(bool locked) external override onlyOwner {
        liquidationsLocked = locked;
        emit UpdateLiquidationsLocked(locked);
    }

    /// @inheritdoc IPaprController
    function setAllowedCollateral(IPaprController.CollateralAllowedConfig[] calldata collateralConfigs)
        external
        override
        onlyOwner
    {
        for (uint256 i = 0; i < collateralConfigs.length;) {
            if (address(collateralConfigs[i].collateral) == address(0)) revert IPaprController.InvalidCollateral();

            isAllowed[collateralConfigs[i].collateral] = collateralConfigs[i].allowed;
            emit AllowCollateral(collateralConfigs[i].collateral, collateralConfigs[i].allowed);
            unchecked {
                ++i;
            }
        }
    }

    /// VIEW FUNCTIONS ///

    /// @inheritdoc IPaprController
    function maxDebt(uint256 totalCollateraValue) external view override returns (uint256) {
        if (_lastUpdated == block.timestamp) {
            return _maxDebt(totalCollateraValue, _target);
        }

        return _maxDebt(totalCollateraValue, newTarget());
    }

    /// @inheritdoc IPaprController
    function vaultInfo(address account, ERC721 asset)
        external
        view
        override
        returns (IPaprController.VaultInfo memory)
    {
        return _vaultInfo[account][asset];
    }

    /// INTERNAL NON-VIEW ///

    function _addCollateralToVault(address account, IPaprController.Collateral memory collateral) internal {
        if (!isAllowed[collateral.addr]) {
            revert IPaprController.InvalidCollateral();
        }

        collateralOwner[collateral.addr][collateral.id] = account;
        ++_vaultInfo[account][collateral.addr].count;

        emit AddCollateral(account, collateral.addr, collateral.id);
    }

    function _removeCollateral(
        address sendTo,
        IPaprController.Collateral calldata collateral,
        uint256 oraclePrice,
        uint256 cachedTarget
    ) internal {
        if (collateralOwner[collateral.addr][collateral.id] != msg.sender) {
            revert IPaprController.OnlyCollateralOwner();
        }

        delete collateralOwner[collateral.addr][collateral.id];

        uint16 newCount;
        unchecked {
            newCount = _vaultInfo[msg.sender][collateral.addr].count - 1;
            _vaultInfo[msg.sender][collateral.addr].count = newCount;
        }

        uint256 debt = _vaultInfo[msg.sender][collateral.addr].debt;
        uint256 max = _maxDebt(oraclePrice * newCount, cachedTarget);

        if (debt != 0 && !(debt < max)) {
            revert IPaprController.ExceedsMaxDebt(debt, max);
        }

        collateral.addr.safeTransferFrom(address(this), sendTo, collateral.id);

        emit RemoveCollateral(msg.sender, collateral.addr, collateral.id);
    }

    function _increaseDebt(
        address account,
        ERC721 asset,
        address mintTo,
        uint256 amount,
        ReservoirOracleUnderwriter.OracleInfo memory oracleInfo
    ) internal {
        if (!isAllowed[asset]) {
            revert IPaprController.InvalidCollateral();
        }

        uint256 cachedTarget = updateTarget();

        uint256 newDebt = _vaultInfo[account][asset].debt + amount;
        uint256 oraclePrice =
            underwritePriceForCollateral(asset, ReservoirOracleUnderwriter.PriceKind.LOWER, oracleInfo, true);

        uint256 max = _maxDebt(_vaultInfo[account][asset].count * oraclePrice, cachedTarget);

        if (!(newDebt < max)) revert IPaprController.ExceedsMaxDebt(newDebt, max);

        if (newDebt >= 1 << 184) revert IPaprController.DebtAmountExceedsUint184();

        _vaultInfo[account][asset].debt = uint184(newDebt);
        PaprToken(address(papr)).mint(mintTo, amount);

        emit IncreaseDebt(account, asset, amount);
    }

    function _reduceDebt(address account, ERC721 asset, address burnFrom, uint256 accountDebt, uint256 amountToReduce)
        internal
    {
        _reduceDebtWithoutBurn(account, asset, accountDebt, amountToReduce);
        PaprToken(address(papr)).burn(burnFrom, amountToReduce);
    }

    function _reduceDebtWithoutBurn(address account, ERC721 asset, uint256 accountDebt, uint256 amountToReduce)
        internal
    {
        _vaultInfo[account][asset].debt = uint184(accountDebt - amountToReduce);
        emit ReduceDebt(account, asset, amountToReduce);
    }

    /// same as increaseDebtAndSell but takes args in memory
    /// to work with onERC721Received
    function _increaseDebtAndSell(
        address account,
        address proceedsTo,
        ERC721 collateralAsset,
        IPaprController.SwapParams memory params,
        ReservoirOracleUnderwriter.OracleInfo memory oracleInfo
    ) internal {
        bool hasFee = params.swapFeeBips != 0;

        (uint256 amountOut,) = UniswapHelpers.swap(
            pool,
            hasFee ? address(this) : proceedsTo,
            !token0IsUnderlying,
            params.amount,
            params.minOut,
            params.sqrtPriceLimitX96,
            params.deadline,
            abi.encode(account, collateralAsset, oracleInfo)
        );

        if (hasFee) {
            uint256 fee = amountOut * params.swapFeeBips / BIPS_ONE;
            underlying.safeTransfer(params.swapFeeTo, fee);
            underlying.safeTransfer(proceedsTo, amountOut - fee);
        }
    }

    function _auctionPurchaseUpdateVault(
        uint256 price,
        address account,
        ERC721 asset,
        ReservoirOracleUnderwriter.OracleInfo calldata oracleInfo
    ) internal {
        --_vaultInfo[account][asset].auctionCount;

        uint256 count = _vaultInfo[account][asset].count;
        uint256 collateralValueCached;
        uint256 maxDebtCached;

        if (count != 0) {
            collateralValueCached = underwritePriceForCollateral(
                asset, ReservoirOracleUnderwriter.PriceKind.TWAP, oracleInfo, false
            ) * count;
            maxDebtCached = _maxDebt(collateralValueCached, updateTarget());
        }

        uint256 debtCached = _vaultInfo[account][asset].debt;
        /// anything above what is needed to bring this vault under maxDebt is considered excess
        uint256 neededToSaveVault;
        uint256 excess;
        unchecked {
            neededToSaveVault = maxDebtCached > debtCached ? 0 : debtCached - maxDebtCached;
            excess = price > neededToSaveVault ? price - neededToSaveVault : 0;
        }
        uint256 remaining;

        if (excess > 0) {
            remaining = _handleExcess(excess, neededToSaveVault, debtCached, account, asset);
        } else {
            _reduceDebt(account, asset, address(this), debtCached, price);
            // no excess, so price <= neededToSaveVault, meaning debtCached >= price
            unchecked {
                remaining = debtCached - price;
            }
        }

        if (count == 0 && remaining != 0 && _vaultInfo[account][asset].auctionCount == 0) {
            /// there will be debt left with no NFTs, set it to 0
            _reduceDebtWithoutBurn(account, asset, remaining, remaining);
        }
    }

    function _handleExcess(uint256 excess, uint256 neededToSaveVault, uint256 debtCached, address account, ERC721 asset)
        internal
        returns (uint256 remaining)
    {
        uint256 fee = excess * liquidationPenaltyBips / BIPS_ONE;
        uint256 credit;
        // excess is a % of fee and so is <= fee
        unchecked {
            credit = excess - fee;
        }
        uint256 totalOwed = credit + neededToSaveVault;

        PaprToken(address(papr)).burn(address(this), fee);

        if (totalOwed > debtCached) {
            // we owe them more papr than they have in debt
            // so we pay down debt and send them the rest
            _reduceDebt(account, asset, address(this), debtCached, debtCached);
            // totalOwed > debtCached
            unchecked {
                papr.transfer(account, totalOwed - debtCached);
            }
        } else {
            // reduce vault debt
            _reduceDebt(account, asset, address(this), debtCached, totalOwed);
            // debtCached >= totalOwed
            unchecked {
                remaining = debtCached - totalOwed;
            }
        }
    }

    /// INTERNAL VIEW ///

    function _maxDebt(uint256 totalCollateraValue, uint256 cachedTarget) internal view returns (uint256) {
        uint256 maxLoanUnderlying = totalCollateraValue * maxLTV;
        return maxLoanUnderlying / cachedTarget;
    }
}