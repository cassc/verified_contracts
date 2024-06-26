// SPDX-License-Identifier: MIT
pragma solidity 0.8.11;

import { IERC20 } from "@openzeppelin/contracts-0.8/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts-0.8/token/ERC20/utils/SafeERC20.sol";
import { IAuraLocker } from "../interfaces/IAuraLocker.sol";
import { CrossChainMessages as CCM } from "./CrossChainMessages.sol";
import { PausableProxyOFT } from "./PausableProxyOFT.sol";

/**
 * @title   AuraProxyOFT
 * @author  AuraFinance
 * @dev     Send and receive AURA to and from all the Sidechains and receives
 * 		    lock requests from the sidechains
 */
contract AuraProxyOFT is PausableProxyOFT {
    using SafeERC20 for IERC20;

    /* -------------------------------------------------------------------
       Storage 
    ------------------------------------------------------------------- */

    /// @dev Aura Locker contract address
    address public immutable locker;

    /* -------------------------------------------------------------------
       Constructor 
    ------------------------------------------------------------------- */
    /**
     * @dev Constructs the AuraProxyOFT contract
     * @param _lzEndpoint   LayerZero endpoint contract
     * @param _token        The proxied token (auraBAL)
     * @param _locker       The Aura Locker contract address
     * @param _guardian     The pause guardian address
     * @param _sudo         The super user address
     * @param _inflowLimit  Initial inflow limit per epoch
     */
    constructor(
        address _lzEndpoint,
        address _token,
        address _locker,
        address _guardian,
        address _sudo,
        uint256 _inflowLimit
    ) PausableProxyOFT(_token, _sudo, _inflowLimit) {
        locker = _locker;

        _initializeLzApp(_lzEndpoint);
        _initializePauseGuardian(_guardian);

        IERC20(_token).safeApprove(_locker, type(uint256).max);
    }

    /* -------------------------------------------------------------------
       Core Functions
    ------------------------------------------------------------------- */

    /**
     * @dev Lock tokens in the Locker contract
     * @param _sender Address that is locking
     * @param _amount Amount to lock
     */
    function _lockFor(
        uint16 _srcChainId,
        address _sender,
        uint256 _amount
    ) internal {
        if (IAuraLocker(locker).isShutdown() || paused()) {
            _safeCreditTo(_srcChainId, _sender, _amount);
        } else {
            IAuraLocker(locker).lock(_sender, _amount);
        }
    }

    /* -------------------------------------------------------------------
      Layer Zero functions L1 -> L2
    ------------------------------------------------------------------- */

    /**
     * @dev Override the default OFT lzReceive function logic
     */
    function _nonblockingLzReceive(
        uint16 _srcChainId,
        bytes memory _srcAddress,
        uint64 _nonce,
        bytes memory _payload
    ) internal virtual override {
        if (CCM.isCustomMessage(_payload)) {
            // The payload is a specific cross chain message we decode
            // the type to determine what the message is an continue
            CCM.MessageType messageType = CCM.getMessageType(_payload);
            if (messageType == CCM.MessageType.LOCK) {
                // Receiving a lock request from the L2. We decode
                // The payload to get the sender and the amount to lock
                (address sender, uint256 amount) = CCM.decodeLock(_payload);
                _lockFor(_srcChainId, sender, amount);
            }
        } else {
            // The message is not a specific cross chain message so we just
            // fallback to the normal LZ OFT flow
            super._nonblockingLzReceive(_srcChainId, _srcAddress, _nonce, _payload);
        }
    }
}