// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.18;

interface IAaveLendPool {
    function FLASHLOAN_PREMIUM_TOTAL() external view returns (uint256);

    function flashLoan(
        address receiverAddress,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata modes,
        address onBehalfOf,
        bytes calldata params,
        uint16 referralCode
    ) external;
}