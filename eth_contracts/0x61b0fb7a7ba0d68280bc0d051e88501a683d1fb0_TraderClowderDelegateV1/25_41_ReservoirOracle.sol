// SPDX-License-Identifier: MIT
// Changes made by Clowder: 
// - Removed updateReservoirOracleAddress
// - Added PriceKind gotten from the PriceDataRecorder example
// - Removed RESERVOIR_ORACLE_ADDRESS
pragma solidity ^0.8.13;

// Inspired by https://github.com/ZeframLou/trustus
abstract contract ReservoirOracle {
    // --- Structs ---
    
    enum PriceKind {
        SPOT,
        TWAP,
        LOWER,
        UPPER
    }

    struct Message {
        bytes32 id;
        bytes payload;
        // The UNIX timestamp when the message was signed by the oracle
        uint256 timestamp;
        uint256 chainId;
        // ECDSA signature or EIP-2098 compact signature
        bytes signature;
    }

    // --- Errors ---

    error InvalidMessage();

    // --- Fields ---


    // --- Constructor ---

    constructor() {
    }

    // --- Internal methods ---

    function _verifyMessage(
        bytes32 id,
        uint256 validFor,
        Message memory message,
        address reservoirOracleAddress
    ) internal view virtual returns (bool success) {
        // Ensure the message matches the requested id
        if (id != message.id) {
            return false;
        }

        // Ensure the message timestamp is valid
        if (
            message.timestamp > block.timestamp ||
            message.timestamp + validFor < block.timestamp
        ) {
            return false;
        }

        bytes32 r;
        bytes32 s;
        uint8 v;

        // Extract the individual signature fields from the signature
        bytes memory signature = message.signature;
        if (signature.length == 64) {
            // EIP-2098 compact signature
            bytes32 vs;
            assembly {
                r := mload(add(signature, 0x20))
                vs := mload(add(signature, 0x40))
                s := and(
                    vs,
                    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
                )
                v := add(shr(255, vs), 27)
            }
        } else if (signature.length == 65) {
            // ECDSA signature
            assembly {
                r := mload(add(signature, 0x20))
                s := mload(add(signature, 0x40))
                v := byte(0, mload(add(signature, 0x60)))
            }
        } else {
            return false;
        }

        address signerAddress = ecrecover(
            keccak256(
                abi.encodePacked(
                    "\x19Ethereum Signed Message:\n32",
                    // EIP-712 structured-data hash
                    keccak256(
                        abi.encode(
                            keccak256(
                                "Message(bytes32 id,bytes payload,uint256 timestamp,uint256 chainId)"
                            ),
                            message.id,
                            keccak256(message.payload),
                            message.timestamp,
                            message.chainId
                        )
                    )
                )
            ),
            v,
            r,
            s
        );

        // Ensure the signer matches the designated oracle address
        return signerAddress == reservoirOracleAddress;
    }
}