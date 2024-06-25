// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;

// Copyright 2020 Venus Labs, Inc.

// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

// 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


import "./VToken.sol";



/**
 *
  *** MODIFICATIONS ***
 * redeem(), mintBehalf(), _addReserves() removed 
 *
 *** ADDITIONS ***
 * swapExactTokenForToken() to support selling dToken's Underlying
 *
 */

contract VBep20 is VToken, VBep20Interface {
    /**
     * @notice Initialize the new money market
     * @param underlying_ The address of the underlying asset
     * @param comptroller_ The address of the Comptroller
     * @param interestRateModel_ The address of the interest rate model
     * @param initialExchangeRateMantissa_ The initial exchange rate, scaled by 1e18
     * @param name_ BEP-20 name of this token
     * @param symbol_ BEP-20 symbol of this token
     * @param decimals_ BEP-20 decimal precision of this token
     */
    function initialize(
        address underlying_,
        ComptrollerInterface comptroller_,
        InterestRateModel interestRateModel_,
        ITradeModel tradeModel_,
        uint256 initialExchangeRateMantissa_,
        string memory name_,
        string memory symbol_,
        uint8 decimals_
    ) public {
        // VToken initialize does the bulk of the work
        super.initialize(
            comptroller_,
            interestRateModel_,
            tradeModel_,
            initialExchangeRateMantissa_,
            name_,
            symbol_,
            decimals_
        );

        // Set underlying and sanity check it
        underlying = underlying_;
        EIP20Interface(underlying).totalSupply();

    }

    /*** User Interface ***/

    /**
     * @notice Sender supplies assets into the market and receives vTokens in exchange
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param mintAmount The amount of the underlying asset to supply
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function mint(uint256 mintAmount) external returns (uint256) {
        (uint256 err, ) = mintInternal(mintAmount);
        return err;
    }


    /**
     * @notice Sender redeems vTokens in exchange for a specified amount of underlying asset
     * @dev Accrues interest whether or not the operation succeeds, unless reverted
     * @param redeemAmount The amount of underlying to redeem
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function redeemUnderlying(uint256 redeemAmount) external returns (uint256 success) {
        success = redeemUnderlyingInternal(redeemAmount);
        iUSDrateLimits();
    }

    /**
     * @notice Sender borrows assets from the protocol to their own address
     * @param borrowAmount The amount of the underlying asset to borrow
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function borrow(uint256 borrowAmount) external returns (uint256 success) {
        success = borrowInternal(borrowAmount);
        iUSDrateLimits();
    }

    /**
     * @notice Sender repays their own borrow
     * @param repayAmount The amount to repay
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function repayBorrow(uint256 repayAmount) external returns (uint256) {
        (uint256 err, ) = repayBorrowInternal(repayAmount);
        return err;
    }

    /**
     * @notice Sender repays a borrow belonging to borrower
     * @param borrower the account with the debt being payed off
     * @param repayAmount The amount to repay
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function repayBorrowBehalf(address borrower, uint repayAmount) external returns (uint) {
        (uint err,) = repayBorrowBehalfInternal(borrower, repayAmount);
        return err;
    }

    /**
     * @notice The sender liquidates the borrowers collateral.
     *  The collateral seized is transferred to the liquidator.
     * @param borrower The borrower of this vToken to be liquidated
     * @param repayAmount The amount of the underlying borrowed asset to repay
     * @param vTokenCollateral The market in which to seize collateral from the borrower
     * @return uint 0=success, otherwise a failure (see ErrorReporter.sol for details)
     */
    function liquidateBorrow(
        address borrower,
        uint256 repayAmount,
        VTokenInterface vTokenCollateral
    ) external returns (uint256) {
        (uint256 err, ) = liquidateBorrowInternal(
            borrower,
            repayAmount,
            vTokenCollateral
        );
        return err;
    }

  

    /*** Safe Token ***/

    /**
     * @notice Gets balance of this contract in terms of the underlying
     * @dev This excludes the value of the current message, if any
     * @return The quantity of underlying tokens owned by this contract
     */
    function getCashPrior() internal view returns (uint256) {
        EIP20Interface token = EIP20Interface(underlying);
        return token.balanceOf(address(this));
    }


    /**
     * @dev Similar to EIP20 transfer, except it handles a False result from `transferFrom` and reverts in that case.
     *      This will revert due to insufficient balance or insufficient allowance.
     *      This function returns the actual amount received,
     *      which may be less than `amount` if there is a fee attached to the transfer.
     *
     *      Note: This wrapper safely handles non-standard BEP-20 tokens that do not return a value.
     *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
     */
    function doTransferIn(address from, uint256 amount)
        internal
        returns (uint256)
    {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        uint256 balanceBefore = EIP20Interface(underlying).balanceOf(
            address(this)
        );
        token.transferFrom(from, address(this), amount);

        bool success;
        assembly {
            switch returndatasize()
            case 0 {
                // This is a non-standard BEP-20
                success := not(0) // set success to true
            }
            case 32 {
                // This is a compliant BEP-20
                returndatacopy(0, 0, 32)
                success := mload(0) // Set `success = returndata` of external call
            }
            default {
                // This is an excessively non-compliant BEP-20, revert.
                revert(0, 0)
            }
        }
        require(success, "TOKEN_TRANSFER_IN_FAILED");

        // Calculate the amount that was *actually* transferred
        uint256 balanceAfter = EIP20Interface(underlying).balanceOf(
            address(this)
        );
        require(balanceAfter >= balanceBefore, "TOKEN_TRANSFER_IN_OVERFLOW");
        return balanceAfter - balanceBefore; // underflow already checked above, just subtract
    }

    /**
     * @dev Similar to EIP20 transfer, except it handles a False success from `transfer` and returns an explanatory
     *      error code rather than reverting. If caller has not called checked protocol's balance, this may revert due to
     *      insufficient cash held in this contract. If caller has checked protocol's balance prior to this call, and verified
     *      it is >= amount, this should not revert in normal conditions.
     *
     *      Note: This wrapper safely handles non-standard BEP-20 tokens that do not return a value.
     *            See here: https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
     */
    function doTransferOut(address payable to, uint256 amount) internal {
        EIP20NonStandardInterface token = EIP20NonStandardInterface(underlying);
        token.transfer(to, amount);

        bool success;
        assembly {
            switch returndatasize()
            case 0 {
                // This is a non-standard BEP-20
                success := not(0) // set success to true
            }
            case 32 {
                // This is a complaint BEP-20
                returndatacopy(0, 0, 32)
                success := mload(0) // Set `success = returndata` of external call
            }
            default {
                // This is an excessively non-compliant BEP-20, revert.
                revert(0, 0)
            }
        }
        require(success, "TOKEN_TRANSFER_OUT_FAILED");
    }


    // ---------------- ADDITIONS FOR TRADING  -------------------- //


    function getCashCurrent() internal view returns(uint) {
        return getCashPrior();
    }

    /**
     * @notice Allows user to sell (deposit) an underyling token to get underlying from another dual pool
     * @dev Signal is sent (with valueUSD) to approved dTokens to send out its underlying token to _sendTo
     * @param _amountTokenIn The amount of dTokens underlying sent in
     * @param _minOut The minimum amount of dTokenOut's underlying out or it fails
     * @param dTokenOut_referrer An array of format [dTokenOut, referrer], if no referrer then zero address 
     *        used because swapExactTokensForTokens method of this format is registered on Metamask
     * @param _sendTo The address to send this dTokens underlying
     * @param _deadline Trade must be completed before this deadline (in block.timestamp)
     */
    //function swapExactTokensForTokens(uint amountIn,uint amountOutMin,address[] memory dTokenOut_referrer,address payable to,uint deadline) public {}
    function swapExactTokensForTokens(uint256 _amountTokenIn, uint256 _minOut, address[] calldata dTokenOut_referrer, address payable _sendTo, uint256 _deadline) external nonReentrant {
        
        // accepts token transfer in
        address dTokenOut = dTokenOut_referrer[0]; 
        address payable referrer = address(uint160(dTokenOut_referrer[1]));
        require(dTokenOut_referrer.length == 2 && dTokenOut != address(this) && comptroller.dTokenApproved(dTokenOut),"!dTokenOut_referrer"); 

        // accepts BEP20 transfer and gets actual amount received
        uint actualAmountIn = doTransferIn(msg.sender, _amountTokenIn);

        // calculates valueOut and updates balances
        (uint256 valueUSD, uint256 reserveTradeFee,) = amountsOut(address(this), address(0), actualAmountIn, msg.sender, referrer); // amountOut USD
        iUSDbalance = subINT(iUSDbalance,int256(valueUSD)); // updates global variables

        // sends fee to referrer (if one exists), otherwise add to totalReserves
        if (referrer != address(0)) {
            doTransferOut(referrer,reserveTradeFee);
        } else {
            totalReserves = addUINT(totalReserves,reserveTradeFee); // trading fee in underlying
        }
        
        // ensures tokenOut is an approved dToken, and sends signal
        VTokenInterface(dTokenOut).sendTokenOut(valueUSD, _minOut, _sendTo, _deadline); 
        require(iUSDrate() > int(-iUSDlimit),"!iUSDrate.");

        emit SwapExactTokensForTokens(dTokenOut, _amountTokenIn, valueUSD);
    }


}
