// SPDX-License-Identifier: UNLICENSED
// !! THIS FILE WAS AUTOGENERATED BY abi-to-sol v0.5.3. SEE SOURCE BELOW. !!
pragma solidity >=0.7.0 <0.9.0;

interface IOldPerpTEL2 {
    function L2CrossDomainMessenger() external view returns (address);

    function MAX_BPS() external view returns (uint256);

    function accountBalance() external view returns (address);

    function baseToken() external view returns (address);

    function clearingHouse() external view returns (address);

    function clearingHouseConfig() external view returns (address);

    function closePosition(uint24 slippage) external;

    function exchange() external view returns (address);

    function formatSqrtPriceX96(uint160 sqrtPriceX96)
        external
        view
        returns (uint256 price);

    function getFreeCollateral() external view returns (uint256);

    function getIndexTwapPrice() external view returns (uint256);

    function getMarkTwapPrice() external view returns (uint160);

    function getTotalPerpPositionSize() external view returns (int256);

    function keeper() external view returns (address);

    function messageSender() external view returns (address);

    function openPosition(
        bool isShort,
        uint256 amountIn,
        uint24 slippage
    ) external;

    function optimismMessenger() external view returns (address);

    function orderBook() external view returns (address);

    function perpPosition()
        external
        view
        returns (
            uint256 entryMarkPrice,
            uint256 entryIndexPrice,
            uint256 entryAmount,
            bool isShort,
            bool isActive
        );

    function perpVault() external view returns (address);

    function positionHandlerL1() external view returns (address);

    function positionInUSDC() external view returns (uint256);

    function quoteTokenvUSDC() external view returns (address);

    function referralCode() external view returns (bytes32);

    function setReferralCode(bytes32 _referralCode) external;

    function setSocketRegistry(address _socketRegistry) external;

    function socketRegistry() external view returns (address);

    function sweep(address _token) external;

    function wantTokenL1() external view returns (address);

    function wantTokenL2() external view returns (address);

    function withdraw(
        uint256 amountOut,
        address allowanceTarget,
        address _socketRegistry,
        bytes memory socketData
    ) external;
}

// THIS FILE WAS AUTOGENERATED FROM THE FOLLOWING ABI JSON:
/*
[{"inputs":[{"internalType":"address","name":"_wantTokenL1","type":"address"},{"internalType":"address","name":"_wantTokenL2","type":"address"},{"internalType":"address","name":"_positionHandlerL1","type":"address"},{"internalType":"address","name":"_perpVault","type":"address"},{"internalType":"address","name":"_clearingHouse","type":"address"},{"internalType":"address","name":"_clearingHouseConfig","type":"address"},{"internalType":"address","name":"_accountBalance","type":"address"},{"internalType":"address","name":"_orderBook","type":"address"},{"internalType":"address","name":"_exchange","type":"address"},{"internalType":"address","name":"_baseToken","type":"address"},{"internalType":"address","name":"_quoteTokenvUSDC","type":"address"},{"internalType":"address","name":"_keeper","type":"address"},{"internalType":"address","name":"_socketRegistry","type":"address"}],"stateMutability":"nonpayable","type":"constructor"},{"inputs":[],"name":"L2CrossDomainMessenger","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"MAX_BPS","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"accountBalance","outputs":[{"internalType":"contract IAccountBalance","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"baseToken","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"clearingHouse","outputs":[{"internalType":"contract IClearingHouse","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"clearingHouseConfig","outputs":[{"internalType":"contract IClearingHouseConfig","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint24","name":"slippage","type":"uint24"}],"name":"closePosition","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"exchange","outputs":[{"internalType":"contract IExchange","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint160","name":"sqrtPriceX96","type":"uint160"}],"name":"formatSqrtPriceX96","outputs":[{"internalType":"uint256","name":"price","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getFreeCollateral","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getIndexTwapPrice","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getMarkTwapPrice","outputs":[{"internalType":"uint160","name":"","type":"uint160"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getTotalPerpPositionSize","outputs":[{"internalType":"int256","name":"","type":"int256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"keeper","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"messageSender","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bool","name":"isShort","type":"bool"},{"internalType":"uint256","name":"amountIn","type":"uint256"},{"internalType":"uint24","name":"slippage","type":"uint24"}],"name":"openPosition","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"optimismMessenger","outputs":[{"internalType":"contract ICrossDomainMessenger","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"orderBook","outputs":[{"internalType":"contract IOrderBook","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"perpPosition","outputs":[{"internalType":"uint256","name":"entryMarkPrice","type":"uint256"},{"internalType":"uint256","name":"entryIndexPrice","type":"uint256"},{"internalType":"uint256","name":"entryAmount","type":"uint256"},{"internalType":"bool","name":"isShort","type":"bool"},{"internalType":"bool","name":"isActive","type":"bool"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"perpVault","outputs":[{"internalType":"contract IVault","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"positionHandlerL1","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"positionInUSDC","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"quoteTokenvUSDC","outputs":[{"internalType":"contract IERC20","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"referralCode","outputs":[{"internalType":"bytes32","name":"","type":"bytes32"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"bytes32","name":"_referralCode","type":"bytes32"}],"name":"setReferralCode","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"_socketRegistry","type":"address"}],"name":"setSocketRegistry","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"socketRegistry","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"_token","type":"address"}],"name":"sweep","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[],"name":"wantTokenL1","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"wantTokenL2","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"amountOut","type":"uint256"},{"internalType":"address","name":"allowanceTarget","type":"address"},{"internalType":"address","name":"_socketRegistry","type":"address"},{"internalType":"bytes","name":"socketData","type":"bytes"}],"name":"withdraw","outputs":[],"stateMutability":"nonpayable","type":"function"}]
*/