//SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.10;

import "../../libraries/LibUnstructuredStorage.sol";

library BalanceToRedeem {
    bytes32 internal constant BALANCE_TO_REDEEM_SLOT = bytes32(uint256(keccak256("river.state.balanceToRedeem")) - 1);

    function get() internal view returns (uint256) {
        return LibUnstructuredStorage.getStorageUint256(BALANCE_TO_REDEEM_SLOT);
    }

    function set(uint256 newValue) internal {
        LibUnstructuredStorage.setStorageUint256(BALANCE_TO_REDEEM_SLOT, newValue);
    }
}