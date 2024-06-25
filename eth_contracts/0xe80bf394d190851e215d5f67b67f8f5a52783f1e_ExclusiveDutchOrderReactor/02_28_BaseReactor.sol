// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity ^0.8.0;

import {SafeTransferLib} from "solmate/src/utils/SafeTransferLib.sol";
import {ReentrancyGuard} from "openzeppelin-contracts/security/ReentrancyGuard.sol";
import {IPermit2} from "permit2/src/interfaces/IPermit2.sol";
import {ERC20} from "solmate/src/tokens/ERC20.sol";
import {ReactorEvents} from "../base/ReactorEvents.sol";
import {ResolvedOrderLib} from "../lib/ResolvedOrderLib.sol";
import {CurrencyLibrary, NATIVE} from "../lib/CurrencyLibrary.sol";
import {ExpectedBalance, ExpectedBalanceLib} from "../lib/ExpectedBalanceLib.sol";
import {IReactorCallback} from "../interfaces/IReactorCallback.sol";
import {IReactor} from "../interfaces/IReactor.sol";
import {ProtocolFees} from "../base/ProtocolFees.sol";
import {SignedOrder, ResolvedOrder, OutputToken} from "../base/ReactorStructs.sol";

/// @notice Generic reactor logic for settling off-chain signed orders
///     using arbitrary fill methods specified by a filler
abstract contract BaseReactor is IReactor, ReactorEvents, ProtocolFees, ReentrancyGuard {
    using SafeTransferLib for ERC20;
    using ResolvedOrderLib for ResolvedOrder;
    using ExpectedBalanceLib for ResolvedOrder[];
    using ExpectedBalanceLib for ExpectedBalance[];
    using CurrencyLibrary for address;

    // Occurs when an output = ETH and the reactor does contain enough ETH but
    // the direct filler did not include enough ETH in their call to execute/executeBatch
    error InsufficientEth();

    /// @notice permit2 address used for token transfers and signature verification
    IPermit2 public immutable permit2;

    /// @notice special fillContract address used to indicate a direct fill
    /// @dev direct fills transfer tokens directly from the filler to the swapper
    IReactorCallback public constant DIRECT_FILL = IReactorCallback(address(1));

    constructor(IPermit2 _permit2, address _protocolFeeOwner) ProtocolFees(_protocolFeeOwner) {
        permit2 = _permit2;
    }

    /// @inheritdoc IReactor
    function execute(SignedOrder calldata order, IReactorCallback fillContract, bytes calldata fillData)
        external
        payable
        override
        nonReentrant
    {
        ResolvedOrder[] memory resolvedOrders = new ResolvedOrder[](1);
        resolvedOrders[0] = resolve(order);

        _fill(resolvedOrders, fillContract, fillData);
    }

    /// @inheritdoc IReactor
    function executeBatch(SignedOrder[] calldata orders, IReactorCallback fillContract, bytes calldata fillData)
        external
        payable
        override
        nonReentrant
    {
        ResolvedOrder[] memory resolvedOrders = new ResolvedOrder[](orders.length);

        unchecked {
            for (uint256 i = 0; i < orders.length; i++) {
                resolvedOrders[i] = resolve(orders[i]);
            }
        }
        _fill(resolvedOrders, fillContract, fillData);
    }

    /// @notice validates and fills a list of orders, marking it as filled
    function _fill(ResolvedOrder[] memory orders, IReactorCallback fillContract, bytes calldata fillData) internal {
        bool directFill = fillContract == DIRECT_FILL;
        unchecked {
            for (uint256 i = 0; i < orders.length; i++) {
                ResolvedOrder memory order = orders[i];
                _injectFees(order);
                order.validate(msg.sender);
                transferInputTokens(order, directFill ? msg.sender : address(fillContract));

                // Batch fills are all-or-nothing so emit fill events now to save a loop
                emit Fill(orders[i].hash, msg.sender, order.info.swapper, order.info.nonce);
            }
        }

        if (directFill) {
            _processDirectFill(orders);
        } else {
            ExpectedBalance[] memory expectedBalances = orders.getExpectedBalances();
            fillContract.reactorCallback(orders, msg.sender, fillData);
            expectedBalances.check();
        }
    }

    /// @notice Process transferring tokens from a direct filler to the recipients
    /// @dev in the case of ETH outputs, ETH should be provided as value in the execute call
    /// @param orders The orders to process
    function _processDirectFill(ResolvedOrder[] memory orders) internal {
        unchecked {
            for (uint256 i = 0; i < orders.length; i++) {
                ResolvedOrder memory order = orders[i];
                for (uint256 j = 0; j < order.outputs.length; j++) {
                    OutputToken memory output = order.outputs[j];
                    output.token.transferFromDirectFiller(output.recipient, output.amount, permit2);
                }
            }

            // refund any remaining ETH to the filler. Only occurs when filler sends more ETH than required to
            // `execute()` or `executeBatch()`, or when there is excess contract balance remaining from others
            // incorrectly calling execute/executeBatch without direct filler method but with a msg.value
            if (address(this).balance > 0) {
                NATIVE.transfer(msg.sender, address(this).balance);
            }
        }
    }

    /// @notice Resolve order-type specific requirements into a generic order with the final inputs and outputs.
    /// @param order The encoded order to resolve
    /// @return resolvedOrder generic resolved order of inputs and outputs
    /// @dev should revert on any order-type-specific validation errors
    function resolve(SignedOrder calldata order) internal view virtual returns (ResolvedOrder memory resolvedOrder);

    /// @notice Transfers tokens to the fillContract
    /// @param order The encoded order to transfer tokens for
    /// @param to The address to transfer tokens to
    function transferInputTokens(ResolvedOrder memory order, address to) internal virtual;
}