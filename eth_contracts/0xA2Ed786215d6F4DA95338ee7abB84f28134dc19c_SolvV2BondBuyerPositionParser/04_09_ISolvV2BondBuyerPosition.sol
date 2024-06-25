// SPDX-License-Identifier: GPL-3.0

/*
    This file is part of the Enzyme Protocol.
    (c) Enzyme Council <[email protected]>
    For the full license information, please view the LICENSE
    file that was distributed with this source code.
*/

import "../../../../../persistent/external-positions/IExternalPosition.sol";

pragma solidity 0.6.12;
pragma experimental ABIEncoderV2;

/// @title ISolvV2BondBuyerPosition Interface
/// @author Enzyme Council <[email protected]>
interface ISolvV2BondBuyerPosition is IExternalPosition {
    enum Actions {
        BuyOffering,
        Claim
    }
}