// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IUserApplication {
    // @param srcChainId - the source endpoint identifier
    // @param srcAddress - the source sending contract address from the source chain
    // @param nonce - the ordered message nonce
    // @param payload - the signed payload is the UA bytes has encoded to be sent
    function receiveMessage(uint16 srcChainId, address srcAddress, uint64 nonce, bytes calldata payload) external;
}