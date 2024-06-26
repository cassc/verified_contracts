// SPDX-FileCopyrightText: 2021 Tenderize <[email protected]>

// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

struct DelegatorUnbond {
    uint256 shares;
    uint256 withdrawEpoch;
}

// note this contract interface is only for stakeManager use
interface IMatic {
    function owner() external view returns (address);

    function restake() external;

    function buyVoucher(uint256 _amount, uint256 _minSharesToMint) external;

    function sellVoucher_new(uint256 claimAmount, uint256 maximumSharesToBurn) external;

    function unstakeClaimTokens_new(uint256 unbondNonce) external;

    function exchangeRate() external view returns (uint256);

    function validatorId() external view returns (uint256);

    function balanceOf(address) external view returns (uint256);

    function unbondNonces(address) external view returns (uint256);

    function withdrawExchangeRate() external view returns (uint256);

    function unbonds_new(address, uint256) external view returns (DelegatorUnbond memory);
}