// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

/*
“Copyright (c) 2023 Lyfebloc
Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions: 
The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software. 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE”.
*/

import './draft-EIP712.sol';
import './SignatureChecker.sol';
import './SafeERC20.sol';

import './AmountCalculator.sol';
import './Permitable.sol';

/// @title RFQ Limit Order mixin
abstract contract OrderRFQMixin is EIP712, AmountCalculator, Permitable {
  using SafeERC20 for IERC20;

  /// @notice Emitted when RFQ gets filled
  event OrderFilledRFQ(
    address indexed taker,
    bytes32 indexed orderHash,
    uint256 makingAmount,
    uint256 takingAmount
  );

  struct OrderRFQ {
    uint256 info; // lowest 64 bits is the order id, next 64 bits is the expiration timestamp
    IERC20 makerAsset;
    IERC20 takerAsset;
    address maker;
    address allowedSender; // equals to Zero address on public orders
    uint256 makingAmount;
    uint256 takingAmount;
    uint256 makingAmountThreshold;
  }

  bytes32 public constant LIMIT_ORDER_RFQ_TYPEHASH =
    keccak256(
      'OrderRFQ(uint256 info,address makerAsset,address takerAsset,address maker,address allowedSender,uint256 makingAmount,uint256 takingAmount)'
    );

  mapping(address => mapping(uint256 => uint256)) private _invalidator;

  /// @notice Returns bitmask for double-spend invalidators based on lowest byte of order.info and filled quotes
  /// @return Result Each bit represents whether corresponding was already invalidated
  function invalidatorForOrderRFQ(address maker, uint256 slot) external view returns (uint256) {
    return _invalidator[maker][slot];
  }

  /// @notice Cancels order's quote
  function cancelOrderRFQ(uint256 orderInfo) external {
    _invalidateOrder(msg.sender, orderInfo);
  }

  /// @notice Fills order's quote, fully or partially (whichever is possible)
  /// @param order Order quote to fill
  /// @param signature Signature to confirm quote ownership
  /// @param makingAmount Making amount
  /// @param takingAmount Taking amount
  function fillOrderRFQ(
    OrderRFQ memory order,
    bytes calldata signature,
    uint256 makingAmount,
    uint256 takingAmount
  )
    external
    returns (
      uint256, /* actualMakingAmount */
      uint256 /* actualTakingAmount */
    )
  {
    return fillOrderRFQTo(order, signature, makingAmount, takingAmount, msg.sender);
  }

  /// @notice Fills Same as `fillOrderRFQ` but calls permit first,
  /// allowing to approve token spending and make a swap in one transaction.
  /// Also allows to specify funds destination instead of `msg.sender`
  /// @param order Order quote to fill
  /// @param signature Signature to confirm quote ownership
  /// @param makingAmount Making amount
  /// @param takingAmount Taking amount
  /// @param target Address that will receive swap funds
  /// @param permit Should consist of abiencoded token address and encoded `IERC20Permit.permit` call.
  /// @dev See tests for examples
  function fillOrderRFQToWithPermit(
    OrderRFQ memory order,
    bytes calldata signature,
    uint256 makingAmount,
    uint256 takingAmount,
    address target,
    bytes calldata permit
  )
    external
    returns (
      uint256, /* actualMakingAmount */
      uint256 /* actualTakingAmount */
    )
  {
    _permit(address(order.takerAsset), permit);
    return fillOrderRFQTo(order, signature, makingAmount, takingAmount, target);
  }

  /// @notice Same as `fillOrderRFQ` but allows to specify funds destination instead of `msg.sender`
  /// @param order Order quote to fill
  /// @param signature Signature to confirm quote ownership
  /// @param makingAmount Making amount
  /// @param takingAmount Taking amount
  /// @param target Address that will receive swap funds
  function fillOrderRFQTo(
    OrderRFQ memory order,
    bytes calldata signature,
    uint256 makingAmount,
    uint256 takingAmount,
    address target
  )
    public
    returns (
      uint256, /* actualMakingAmount */
      uint256 /* actualTakingAmount */
    )
  {
    require(target != address(0), 'LOP: zero target is forbidden');

    address maker = order.maker;

    // Validate order
    require(
      order.allowedSender == address(0) || order.allowedSender == msg.sender,
      'LOP: private order'
    );
    bytes32 orderHash = _hashTypedDataV4(keccak256(abi.encode(LIMIT_ORDER_RFQ_TYPEHASH, order)));
    require(
      SignatureChecker.isValidSignatureNow(maker, orderHash, signature),
      'LOP: bad signature'
    );

    {
      // Stack too deep
      uint256 info = order.info;
      // Check time expiration
      uint256 expiration = uint128(info) >> 64;
      require(expiration == 0 || block.timestamp <= expiration, 'LOP: order expired'); // solhint-disable-line not-rely-on-time
      _invalidateOrder(maker, info);
    }

    {
      // stack too deep
      uint256 orderMakingAmount = order.makingAmount;
      uint256 orderTakingAmount = order.takingAmount;
      // Compute partial fill if needed
      if (takingAmount == 0 && makingAmount == 0) {
        // Two zeros means whole order
        makingAmount = orderMakingAmount;
        takingAmount = orderTakingAmount;
      } else if (takingAmount == 0) {
        require(makingAmount <= orderMakingAmount, 'LOP: making amount exceeded');
        takingAmount = getTakerAmount(orderMakingAmount, orderTakingAmount, makingAmount);
      } else if (makingAmount == 0) {
        require(takingAmount <= orderTakingAmount, 'LOP: taking amount exceeded');
        makingAmount = getMakerAmount(orderMakingAmount, orderTakingAmount, takingAmount);
      } else {
        revert('LOP: both amounts are non-zero');
      }
    }

    require(makingAmount > 0 && takingAmount > 0, "LOP: can't swap 0 amount");
    require(makingAmount >= order.makingAmountThreshold, 'LOP: not enough filled amount');
    // Maker => Taker, Taker => Maker
    order.makerAsset.safeTransferFrom(maker, target, makingAmount);
    order.takerAsset.safeTransferFrom(msg.sender, maker, takingAmount);

    emit OrderFilledRFQ(msg.sender, orderHash, makingAmount, takingAmount);
    return (makingAmount, takingAmount);
  }

  function _invalidateOrder(address maker, uint256 orderInfo) private {
    uint256 invalidatorSlot = uint64(orderInfo) >> 8;
    uint256 invalidatorBit = 1 << uint8(orderInfo);
    mapping(uint256 => uint256) storage invalidatorStorage = _invalidator[maker];
    uint256 invalidator = invalidatorStorage[invalidatorSlot];
    require(invalidator & invalidatorBit == 0, 'LOP: invalidated order');
    invalidatorStorage[invalidatorSlot] = invalidator | invalidatorBit;
  }

  function hashOrderRFQ(OrderRFQ memory order) public view returns (bytes32) {
    return _hashTypedDataV4(keccak256(abi.encode(LIMIT_ORDER_RFQ_TYPEHASH, order)));
  }
}