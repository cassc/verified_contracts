// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import "./vendor/@uniswap/v3-core/contracts/interfaces/callback/IUniswapV3FlashCallback.sol";
import "./vendor/@uniswap/v3-periphery/contracts/base/PeripheryPayments.sol";
import "./vendor/@uniswap/v3-periphery/contracts/base/PeripheryImmutableState.sol";
import "./vendor/@uniswap/v3-periphery/contracts/libraries/PoolAddress.sol";
import "./vendor/@uniswap/v3-periphery/contracts/libraries/CallbackValidation.sol";
import "./vendor/@uniswap/v3-periphery/contracts/libraries/TransferHelper.sol";
import "./vendor/@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../CometInterface.sol";
import "../ERC20.sol";

interface IUniswapV2Router {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);
}

/**
 * @title Compound's Example Liquidator Contract
 * @notice An example of liquidation bot, a starting point for further improvements
 * @author Compound
 */
contract Liquidator is IUniswapV3FlashCallback, PeripheryImmutableState, PeripheryPayments {
    /** Errors */
    error InsufficientAmountOut(address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut, uint256 amountOutMin, Exchange exchange, uint24 fee);
    error InsufficientBalance(uint256 available, uint256 required);
    error InvalidExchange();
    error InvalidPoolConfig();
    error Unauthorized();

    /** Events **/
    event Absorb(address indexed initiator, address[] accounts);
    event AbsorbWithoutBuyingCollateral();
    event Pay(address indexed token, address indexed payer, address indexed recipient, uint256 value);
    event Swap(address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut, Exchange exchange, uint24 fee);

    /** Structs needed for Uniswap flash swap **/
    struct FlashParams {
        address[] accounts;
        address pairToken;
        uint24 poolFee;
    }

    struct FlashCallbackData {
        uint256 amount;
        address recipient;
        PoolAddress.PoolKey poolKey;
        address[] assets;
        uint256[] baseAmounts;
    }

    enum Exchange {
        Uniswap,
        SushiSwap
    }

    // XXX make this less gassy; rearrange fields
    struct PoolConfig {
        bool isLowLiquidity;
        uint24 fee;
        Exchange exchange;
        uint256 maxCollateralToPurchase;
        bool isSet;
    }

    /** Liquidator configuration constants **/

    /// @notice The scale for asset price calculations
    uint256 public constant QUOTE_PRICE_SCALE = 1e18;

    /// @notice Uniswap standard pool fee, used if custom fee is not specified for the pool
    uint24 public constant DEFAULT_POOL_FEE = 500;

    /// @notice Address to send liquidation proceeds to
    address public immutable recipient;

    /// @notice Uniswap router used for token exchange
    ISwapRouter public immutable uniswapRouter;

    /// @notice SushiSwap router used for token exchange
    IUniswapV2Router public immutable sushiSwapRouter;

    /// @notice Compound Comet protocol
    CometInterface public immutable comet;

    /// @notice The address of WETH asset
    address public immutable weth;

    /// @notice The admin address
    address public immutable admin;

    /// @notice Minimum available amount for liquidation in USDC (base token)
    uint256 public liquidationThreshold;

    /// @notice The Uniswap asset pool configurations
    mapping(address => PoolConfig) public poolConfigs;

    /**
     * @notice Construct a new liquidator instance
     * @param _recipient The address to send all proceeds to
     * @param _uniswapRouter The Uniswap V3 Swap router address
     * @param _sushiSwapRouter The Sushi Swap router address
     * @param _comet The Compound V3 Comet instance address
     * @param _factory The Uniswap V3 pools factory instance address
     * @param _WETH9 The WETH address
     * @param _liquidationThreshold The min size of asset liquidations measured in base token
     * @param _assets The list of assets for pool configs
     * @param _lowLiquidityPools The list of boolean indicators if pool is low liquidity and requires ETH swap
     * @param _poolFees The list of given poolFees for assets
     * @param _exchanges The list of given exchanges for assets
     * @param _maxCollateralsToPurchase The list of given maxSafeExchanges for assets
     **/
    constructor(
        address _recipient,
        ISwapRouter _uniswapRouter,
        IUniswapV2Router _sushiSwapRouter,
        CometInterface _comet,
        address _factory,
        address _WETH9,
        uint256 _liquidationThreshold,
        address[] memory _assets,
        bool[] memory _lowLiquidityPools,
        uint24[] memory _poolFees,
        Exchange[] memory _exchanges,
        uint256[] memory _maxCollateralsToPurchase
    ) PeripheryImmutableState(_factory, _WETH9) {
        require(_assets.length == _lowLiquidityPools.length, "Wrong data");
        require(_assets.length == _poolFees.length, "Wrong data");

        admin = msg.sender;
        recipient = _recipient;
        uniswapRouter = _uniswapRouter;
        sushiSwapRouter = _sushiSwapRouter;
        comet = _comet;
        weth = _WETH9;
        liquidationThreshold = _liquidationThreshold;

        // Set pool configs for all given assets
        for (uint8 i = 0; i < _assets.length; i++) {
            address asset = _assets[i];
            bool lowLiquidity = _lowLiquidityPools[i];
            uint24 poolFee = _poolFees[i];
            Exchange exchange = _exchanges[i];
            uint256 maxCollateralToPurchase = _maxCollateralsToPurchase[i];
            poolConfigs[asset] = PoolConfig({
                isLowLiquidity: lowLiquidity,
                fee: poolFee,
                exchange: exchange,
                maxCollateralToPurchase: maxCollateralToPurchase,
                isSet: true
            });
        }
    }

    function setLiquidationThreshold(uint256 _liquidationThreshold) external {
        if (msg.sender != admin) revert Unauthorized();

        liquidationThreshold = _liquidationThreshold;
    }

    function setPoolConfigs(
        address[] memory _assets,
        bool[] memory _lowLiquidityPools,
        uint24[] memory _poolFees,
        Exchange[] memory _exchanges,
        uint256[] memory _maxCollateralsToPurchase
    ) external {
        if (msg.sender != admin) revert Unauthorized();

        for (uint8 i = 0; i < _assets.length; i++) {
            address asset = _assets[i];
            bool lowLiquidity = _lowLiquidityPools[i];
            uint24 poolFee = _poolFees[i];
            Exchange exchange = _exchanges[i];
            uint256 maxCollateralToPurchase = _maxCollateralsToPurchase[i];
            poolConfigs[asset] = PoolConfig({
                isLowLiquidity: lowLiquidity,
                fee: poolFee,
                exchange: exchange,
                maxCollateralToPurchase: maxCollateralToPurchase,
                isSet: true
            });
        }
    }

    /**
     * @dev Returns Uniswap pool config for given asset
     */
    function getPoolConfigForAsset(address asset) internal view returns(PoolConfig memory) {
        PoolConfig memory config = poolConfigs[asset];

        if (!config.isSet) {
            revert InvalidPoolConfig();
        }

        return config;
    }

    function swapCollateral(address asset, uint256 amountOutMin) internal returns (uint256) {
        PoolConfig memory poolConfig = getPoolConfigForAsset(asset);

        if (poolConfig.exchange == Exchange.Uniswap) {
            return uniswapCollateral(asset, amountOutMin, poolConfig);
        } else if (poolConfig.exchange == Exchange.SushiSwap) {
            return sushiSwapCollateral(asset, amountOutMin, poolConfig);
        } else {
            revert InvalidExchange();
        }
    }

    /**
     * @dev Swaps the given asset to USDC (base token) using Uniswap pools
     */
    function uniswapCollateral(address asset, uint256 amountOutMin, PoolConfig memory poolConfig) internal returns (uint256) {
        uint256 swapAmount = ERC20(asset).balanceOf(address(this));
        // Safety check, make sure residue balance in protocol is ignored
        if (swapAmount == 0) return 0;

        uint24 poolFee = poolConfig.fee;
        address swapToken = asset;

        address baseToken = comet.baseToken();

        TransferHelper.safeApprove(asset, address(uniswapRouter), swapAmount);
        // For low liquidity asset, swap it to ETH first
        if (poolConfig.isLowLiquidity) {
            uint256 swapAmountNew = uniswapRouter.exactInputSingle(
                ISwapRouter.ExactInputSingleParams({
                    tokenIn: asset,
                    tokenOut: weth,
                    fee: poolFee,
                    recipient: address(this),
                    deadline: block.timestamp,
                    amountIn: swapAmount,
                    amountOutMinimum: 0,
                    sqrtPriceLimitX96: 0
                })
            );
            emit Swap(asset, weth, swapAmount, swapAmountNew, Exchange.Uniswap, poolFee);
            swapAmount = swapAmountNew;
            swapToken = weth;
            poolFee = getPoolConfigForAsset(weth).fee;

            TransferHelper.safeApprove(weth, address(uniswapRouter), swapAmount);
        }

        // Swap asset or received ETH to base asset
        uint256 amountOut = uniswapRouter.exactInputSingle(
            ISwapRouter.ExactInputSingleParams({
                tokenIn: swapToken,
                tokenOut: baseToken,
                fee: poolFee,
                recipient: address(this),
                deadline: block.timestamp,
                amountIn: swapAmount,
                amountOutMinimum: 0,
                sqrtPriceLimitX96: 0
            })
        );

        // we do a manual check against `amountOutMin` (instead of specifying an
        // `amountOutMinimum` in the swap) so we can provide better information
        // in the error message
        if (amountOut < amountOutMin) {
            // XXX test the error messaging on Goerli
            revert InsufficientAmountOut(swapToken, baseToken, swapAmount, amountOut, amountOutMin, Exchange.Uniswap, poolFee);
        }

        emit Swap(swapToken, baseToken, swapAmount, amountOut, Exchange.Uniswap, poolFee);

        return amountOut;
    }

    /**
     * @dev Swaps the given asset to USDC (base token) using Sushi Swap pools
     */
    function sushiSwapCollateral(address asset, uint256 amountOutMin, PoolConfig memory poolConfig) internal returns (uint256) {
        uint256 swapAmount = ERC20(asset).balanceOf(address(this));
        // Safety check, make sure residue balance in protocol is ignored
        if (swapAmount == 0) return 0;

        address swapToken = asset;

        address baseToken = comet.baseToken();

        TransferHelper.safeApprove(asset, address(sushiSwapRouter), swapAmount);

        address[] memory path;
        if (poolConfig.isLowLiquidity) {
            path = new address[](3);
            path[0] = swapToken;
            path[1] = weth;
            path[2] = baseToken;
        } else {
            path = new address[](2);
            path[0] = swapToken;
            path[1] = baseToken;
        }

        uint256[] memory amounts = IUniswapV2Router(sushiSwapRouter).swapExactTokensForTokens(
            swapAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
        uint256 amountOut = amounts[amounts.length - 1];

        // we do a manual check against `amountOutMin` (instead of specifying an
        // `amountOutMinimum` in the swap) so we can provide better information
        // in the error message
        if (amountOut < amountOutMin) {
            // XXX test the error messaging on Goerli
            revert InsufficientAmountOut(swapToken, baseToken, swapAmount, amountOut, amountOutMin, Exchange.SushiSwap, 3000);
        }

        emit Swap(swapToken, baseToken, swapAmount, amountOut, Exchange.SushiSwap, 3000);

        return amountOut;
    }

    /**
     * @notice Uniswap flashloan callback
     * @param fee0 The fee for borrowing token0 from pool
     * @param fee1 The fee for borrowing token1 from pool
     * @param data The encoded data passed from loan initiation function
     */
    function uniswapV3FlashCallback(
        uint256 fee0,
        uint256 fee1,
        bytes calldata data
    ) external override {
        // Verify uniswap callback, recommended security measure
        FlashCallbackData memory decoded = abi.decode(data, (FlashCallbackData));
        CallbackValidation.verifyCallback(factory, decoded.poolKey);

        address[] memory assets = decoded.assets;

        // Allow Comet protocol to withdraw USDC (base token) for collateral purchase
        TransferHelper.safeApprove(comet.baseToken(), address(comet), decoded.amount);

        uint256 totalAmountOut = 0;
        for (uint i = 0; i < assets.length; i++) {
            address asset = assets[i];
            uint256 baseAmount = decoded.baseAmounts[i];

            if (baseAmount == 0) continue;

            comet.buyCollateral(asset, 0, baseAmount, address(this));
            uint256 amountOut = swapCollateral(asset, baseAmount);
            totalAmountOut += amountOut;
        }

        // We borrow only 1 asset, so one of fees will be 0
        uint256 fee = fee0 + fee1;
        // Payback flashloan to Uniswap pool and profit to the caller
        payback(decoded.amount, fee, comet.baseToken(), totalAmountOut);
    }

    /**
     * @dev Returns loan to Uniswap pool and sends USDC (base token) profit to caller
     * @param amount The loan amount that need to be repaid
     * @param fee The fee for taking the loan
     * @param token The base token which was borrowed for successful liquidation
     * @param amountOut The total amount of base token received after liquidation
     */
    function payback(
        uint256 amount,
        uint256 fee,
        address token,
        uint256 amountOut
    ) internal {
        uint256 amountOwed = amount + fee;
        uint256 balance = ERC20(token).balanceOf(address(this));

        if (amountOwed > balance) {
            revert InsufficientBalance(balance, amountOwed);
        }

        TransferHelper.safeApprove(token, address(this), amountOwed);

        // Repay the loan
        if (amountOwed > 0) {
            pay(token, address(this), msg.sender, amountOwed);
            emit Pay(token, address(this), msg.sender, amountOwed);
        }

        // If profitable, pay profits to the caller
        if (amountOut > amountOwed) {
            uint256 profit = amountOut - amountOwed;
            TransferHelper.safeApprove(token, address(this), profit);
            pay(token, address(this), recipient, profit);
            emit Pay(token, address(this), recipient, profit);
        }
    }

    /**
     * @dev Returns lesser of two values
     */
    function min(uint256 a, uint256 b) internal view returns (uint256) {
        return a <= b ? a : b;
    }

    /**
     * @dev Calculates the total amount of base asset needed to buy all the discounted collateral from the protocol
     */
    function calculateTotalBaseAmount() internal view returns (uint256, uint256[] memory, address[] memory) {
        uint256 totalBaseAmount = 0;
        uint8 numAssets = comet.numAssets();
        uint256[] memory assetBaseAmounts = new uint256[](numAssets);
        address[] memory cometAssets = new address[](numAssets);
        for (uint8 i = 0; i < numAssets; i++) {
            address asset = comet.getAssetInfo(i).asset;
            cometAssets[i] = asset;
            PoolConfig memory poolConfig = getPoolConfigForAsset(asset);
            uint256 collateralBalance = min(comet.getCollateralReserves(asset), poolConfig.maxCollateralToPurchase);

            if (collateralBalance == 0) continue;

            // Find the price in asset needed to base QUOTE_PRICE_SCALE of USDC (base token) of collateral
            uint256 quotePrice = comet.quoteCollateral(asset, QUOTE_PRICE_SCALE * comet.baseScale());
            uint256 assetBaseAmount = comet.baseScale() * QUOTE_PRICE_SCALE * collateralBalance / quotePrice;

            // Liquidate only positions with adequate size, no need to collect residue from protocol
            if (assetBaseAmount < liquidationThreshold) continue;

            assetBaseAmounts[i] = assetBaseAmount;
            totalBaseAmount += assetBaseAmount;
        }

        return (totalBaseAmount, assetBaseAmounts, cometAssets);
    }

    /**
     * @notice Calls the pools flash function with data needed in `uniswapV3FlashCallback`
     * @param params The parameters necessary for flash and the callback, passed in as FlashParams
     */
    function initFlash(FlashParams memory params) external {
        // Absorb Comet underwater accounts
        comet.absorb(address(this), params.accounts);
        emit Absorb(msg.sender, params.accounts);

        (uint256 totalBaseAmount, uint256[] memory assetBaseAmounts, address[] memory cometAssets) = calculateTotalBaseAmount();

        // if there is nothing to buy, just absorb the accounts
        if (totalBaseAmount == 0) {
            emit AbsorbWithoutBuyingCollateral();
            return;
        }

        address poolToken0 = params.pairToken;
        address poolToken1 = comet.baseToken();
        bool reversedPair = poolToken0 > poolToken1;
        // Use Uniswap approach to determining order of tokens https://github.com/Uniswap/v3-periphery/blob/main/contracts/libraries/PoolAddress.sol#L20-L27
        if (reversedPair) (poolToken0, poolToken1) = (poolToken1, poolToken0);

        // Find the desired Uniswap pool to borrow base token from, for ex DAI-USDC
        PoolAddress.PoolKey memory poolKey =
            PoolAddress.PoolKey({token0: poolToken0, token1: poolToken1, fee: params.poolFee});
        IUniswapV3Pool pool = IUniswapV3Pool(PoolAddress.computeAddress(factory, poolKey));

        // recipient of borrowed amounts
        // amount of token0 requested to borrow, 0 for non reversed pair
        // amount of token1 requested to borrow, 0 for reversed pair
        // need amount in callback to pay back pool
        // need assets addresses to buy collateral from protocol
        // need baseAmounts to buy collateral from protocol
        // recipient of flash should be THIS contract
        pool.flash(
            address(this),
            reversedPair ? totalBaseAmount : 0,
            reversedPair ? 0 : totalBaseAmount,
            abi.encode(
                FlashCallbackData({
                    amount: totalBaseAmount,
                    recipient: msg.sender,
                    poolKey: poolKey,
                    assets: cometAssets,
                    baseAmounts: assetBaseAmounts
                })
            )
        );
    }
}