// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {GenericErrors} from "./GenericErrors.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {LibSwap} from "./LibSwap.sol";

library LibAsset {
    uint256 private constant MAX_UINT = type(uint256).max;

    address internal constant NULL_ADDRESS = address(0);

    address internal constant NATIVE_ASSETID = NULL_ADDRESS; //address(0)

    /**
     * @notice Refunds any excess native asset sent to the contract after the main function
     * @param _refundReceiver Address to send refunds to
     */
    modifier refundExcessNative(address payable _refundReceiver) {
        uint256 initialBalance = address(this).balance - msg.value;
        _;
        uint256 finalBalance = address(this).balance;
        uint256 excess = finalBalance > initialBalance
            ? finalBalance - initialBalance
            : 0;
        if (excess > 0) {
            transferAsset(LibAsset.NATIVE_ASSETID, _refundReceiver, excess);
        }
    }

    /**
     * @notice Gets the balance of the inheriting contract for the given asset
     * @param assetId The asset identifier to get the balance of
     * @return Balance held by contracts using this library
     */
    function getOwnBalance(address assetId) internal view returns (uint256) {
        return
            assetId == NATIVE_ASSETID
                ? address(this).balance
                : IERC20(assetId).balanceOf(address(this));
    }

    /**
     * @notice Transfers ether from the inheriting contract to a given
     * @param recipient Address to send ether to
     * @param amount Amount to send to given recipient
     */
    function transferNativeAsset(
        address payable recipient,
        uint256 amount
    ) private {
        require(recipient != NULL_ADDRESS, GenericErrors.E09);
        require(amount <= address(this).balance, GenericErrors.E32);
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, ) = recipient.call{value: amount}("");
        require(success, GenericErrors.E10);
    }

    /**
     * @notice If the current allowance is insufficient, the allowance for a given spender
     * is set to MAX_UINT.
     *
     * @param assetId Token address to transfer
     * @param spender Address to give spend approval to
     * @param amount Amount to approve for spending
     */
    function maxApproveERC20(
        IERC20 assetId,
        address spender,
        uint256 amount
    ) internal {
        if (address(assetId) == NATIVE_ASSETID) return;
        require(spender != NULL_ADDRESS, GenericErrors.E07);
        uint256 allowance = assetId.allowance(address(this), spender);

        if (allowance < amount)
            SafeERC20.safeIncreaseAllowance(
                IERC20(assetId),
                spender,
                MAX_UINT - allowance
            );
    }

    /**
     * @notice Transfers tokens from the inheriting contract to a given
     *       recipient
     * @param assetId Token address to transfer
     * @param recipient Address to send token to
     * @param amount Amount to send to given recipient
     */
    function transferERC20(
        address assetId,
        address recipient,
        uint256 amount
    ) private {
        require(!isNativeAsset(assetId), GenericErrors.E08);
        uint256 assetBalance = IERC20(assetId).balanceOf(address(this));
        require(amount <= assetBalance, GenericErrors.E32);
        SafeERC20.safeTransfer(IERC20(assetId), recipient, amount);
    }

    /**
     *  @notice Transfers tokens from a sender to a given recipient
     *  @param assetId Token address to transfer
     *  @param from Address of sender/owner
     *  @param to Address of recipient/spender
     *  @param amount Amount to transfer from owner to spender
     */
    function transferFromERC20(
        address assetId,
        address from,
        address to,
        uint256 amount
    ) internal {
        require(assetId != NATIVE_ASSETID, GenericErrors.E08);
        require(to != NULL_ADDRESS, GenericErrors.E09);

        IERC20 asset = IERC20(assetId);
        uint256 prevBalance = asset.balanceOf(to);
        SafeERC20.safeTransferFrom(asset, from, to, amount);
        require(asset.balanceOf(to) - prevBalance == amount, GenericErrors.E12);
    }

    function depositAsset(address assetId, uint256 amount) internal {
        if (isNativeAsset(assetId)) {
            require(msg.value >= amount, GenericErrors.E12);
        } else {
            require(amount != 0, GenericErrors.E12);
            uint256 balance = IERC20(assetId).balanceOf(msg.sender);
            require(balance >= amount, GenericErrors.E32);
            transferFromERC20(assetId, msg.sender, address(this), amount);
        }
    }

    function depositAssets(LibSwap.SwapData[] calldata swaps) internal {
        for (uint256 i = 0; i < swaps.length; ) {
            LibSwap.SwapData memory swap = swaps[i];
            if (swap.requiresDeposit) {
                depositAsset(swap.sendingAssetId, swap.fromAmount);
            }
            unchecked {
                i++;
            }
        }
    }

    /**
     * @notice Determines whether the given assetId is the native asset
     * @param assetId The asset identifier to evaluate
     * @return Boolean indicating if the asset is the native asset
     */
    function isNativeAsset(address assetId) internal pure returns (bool) {
        return assetId == NATIVE_ASSETID;
    }

    /**
     * @notice Wrapper function to transfer a given asset (native or erc20) to
     *         some recipient. Should handle all non-compliant return value
     *       tokens as well by using the SafeERC20 contract by open zeppelin.
     * @param assetId Asset id for transfer (address(0) for native asset,
     *                token address for erc20s)
     * @param recipient Address to send asset to
     * @param amount Amount to send to given recipient
     */
    function transferAsset(
        address assetId,
        address payable recipient,
        uint256 amount
    ) internal {
        (assetId == NATIVE_ASSETID)
            ? transferNativeAsset(recipient, amount)
            : transferERC20(assetId, recipient, amount);
    }

    /// @dev Checks whether the given address is a contract and contains code
    function isContract(address _contractAddr) internal view returns (bool) {
        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            size := extcodesize(_contractAddr)
        }
        return size > 0;
    }
}