// SPDX-License-Identifier: MIT
pragma solidity 0.6.10;

import {ERC20, IERC20} from "UpgradeableERC20.sol";
import {ITrueLender2, ILoanToken2} from "ITrueLender2.sol";
import {ITrueFiPoolOracle} from "ITrueFiPoolOracle.sol";
import {I1Inch3} from "I1Inch3.sol";
import {ISAFU} from "ISAFU.sol";

interface ITrueFiPool2 is IERC20 {
    function initialize(
        ERC20 _token,
        ITrueLender2 _lender,
        ISAFU safu,
        address __owner
    ) external;

    function singleBorrowerInitialize(
        ERC20 _token,
        ITrueLender2 _lender,
        ISAFU safu,
        address __owner,
        string memory borrowerName,
        string memory borrowerSymbol
    ) external;

    function token() external view returns (ERC20);

    function oracle() external view returns (ITrueFiPoolOracle);

    function poolValue() external view returns (uint256);

    /**
     * @dev Ratio of liquid assets in the pool after lending
     * @param afterAmountLent Amount of asset being lent
     */
    function liquidRatio(uint256 afterAmountLent) external view returns (uint256);

    /**
     * @dev Join the pool by depositing tokens
     * @param amount amount of tokens to deposit
     */
    function join(uint256 amount) external;

    /**
     * @dev borrow from pool
     * 1. Transfer TUSD to sender
     * 2. Only lending pool should be allowed to call this
     */
    function borrow(uint256 amount) external;

    /**
     * @dev pay borrowed money back to pool
     * 1. Transfer TUSD from sender
     * 2. Only lending pool should be allowed to call this
     */
    function repay(uint256 currencyAmount) external;

    /**
     * @dev SAFU buys LoanTokens from the pool
     */
    function liquidate(ILoanToken2 loan) external;
}