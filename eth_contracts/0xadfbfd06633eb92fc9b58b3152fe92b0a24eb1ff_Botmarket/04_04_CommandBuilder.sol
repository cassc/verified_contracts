// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

library CommandBuilder {
    uint256 constant IDX_VARIABLE_LENGTH = 0x80;
    uint256 constant IDX_VALUE_MASK = 0x7f;
    uint256 constant IDX_END_OF_ARGS = 0xff;
    uint256 constant IDX_USE_STATE = 0xfe;

    function buildInputs(bytes[] memory state, bytes4 selector, bytes32 indices)
        internal
        view
        returns (bytes memory ret)
    {
        uint256 free; // Pointer to first free byte in tail part of message
        uint256 idx;

        // Determine the length of the encoded data
        for (uint256 i; i < 32;) {
            idx = uint8(indices[i]);
            if (idx == IDX_END_OF_ARGS) break;
            unchecked {
                free += 32;
            }
            unchecked {
                ++i;
            }
        }

        // Encode it
        uint256 bytesWritten;
        assembly {
            ret := mload(0x40)
            bytesWritten := add(bytesWritten, 4)
            mstore(0x40, add(ret, and(add(add(bytesWritten, 0x20), 0x1f), not(0x1f))))
            mstore(add(ret, 32), selector)
        }
        uint256 count = 0;
        bytes memory stateData; // Optionally encode the current state if the call requires it
        for (uint256 i; i < 32;) {
            idx = uint8(indices[i]);
            if (idx == IDX_END_OF_ARGS) break;

            if (idx & IDX_VARIABLE_LENGTH != 0) {
                if (idx == IDX_USE_STATE) {
                    assembly {
                        bytesWritten := add(bytesWritten, 32)
                        mstore(0x40, add(ret, and(add(add(bytesWritten, 0x20), 0x1f), not(0x1f))))
                        mstore(add(add(ret, 36), count), free)
                    }
                    if (stateData.length == 0) {
                        stateData = abi.encode(state);
                    }
                    assembly {
                        bytesWritten := add(bytesWritten, mload(stateData))
                        mstore(0x40, add(ret, and(add(add(bytesWritten, 0x20), 0x1f), not(0x1f))))
                    }
                    memcpy(stateData, 32, ret, free + 4, stateData.length - 32);
                    free += stateData.length - 32;
                } else {
                    bytes memory stateVar = state[idx & IDX_VALUE_MASK];
                    uint256 arglen = stateVar.length;

                    // Variable length data; put a pointer in the slot and write the data at the end
                    assembly {
                        bytesWritten := add(bytesWritten, 32)
                        mstore(0x40, add(ret, and(add(add(bytesWritten, 0x20), 0x1f), not(0x1f))))
                        mstore(add(add(ret, 36), count), free)
                    }
                    assembly {
                        bytesWritten := add(bytesWritten, arglen)
                        mstore(0x40, add(ret, and(add(add(bytesWritten, 0x20), 0x1f), not(0x1f))))
                    }
                    memcpy(stateVar, 0, ret, free + 4, arglen);
                    free += arglen;
                }
            } else {
                // Fixed length data; write it directly
                bytes memory stateVar = state[idx & IDX_VALUE_MASK];
                assembly {
                    bytesWritten := add(bytesWritten, mload(stateVar))
                    mstore(0x40, add(ret, and(add(add(bytesWritten, 0x20), 0x1f), not(0x1f))))
                    mstore(add(add(ret, 36), count), mload(add(stateVar, 32)))
                }
            }
            unchecked {
                count += 32;
            }
            unchecked {
                ++i;
            }
        }
        assembly {
            mstore(ret, bytesWritten)
        }
    }

    function writeOutputs(bytes[] memory state, bytes1 index, bytes memory output)
        internal
        pure
        returns (bytes[] memory)
    {
        uint256 idx = uint8(index);
        if (idx == IDX_END_OF_ARGS) return state;

        if (idx & IDX_VARIABLE_LENGTH != 0) {
            if (idx == IDX_USE_STATE) {
                state = abi.decode(output, (bytes[]));
            } else {
                // Check the first field is 0x20 (because we have only a single return value)
                uint256 argptr;
                assembly {
                    argptr := mload(add(output, 32))
                }
                require(argptr == 32, "Only one return value permitted (variable)");

                assembly {
                    // Overwrite the first word of the return data with the length - 32
                    mstore(add(output, 32), sub(mload(output), 32))
                    // Insert a pointer to the return data, starting at the second word, into state
                    mstore(add(add(state, 32), mul(and(idx, IDX_VALUE_MASK), 32)), add(output, 32))
                }
            }
        } else {
            // Single word
            require(output.length == 32, "Only one return value permitted (static)");

            state[idx & IDX_VALUE_MASK] = output;
        }

        return state;
    }

    function writeTuple(bytes[] memory state, bytes1 index, bytes memory output) internal view {
        uint256 idx = uint256(uint8(index));
        if (idx == IDX_END_OF_ARGS) return;

        bytes memory entry = state[idx & IDX_VALUE_MASK] = new bytes(output.length + 32);

        memcpy(output, 0, entry, 32, output.length);
        assembly {
            let l := mload(output)
            mstore(add(entry, 32), l)
        }
    }

    function memcpy(bytes memory src, uint256 srcidx, bytes memory dest, uint256 destidx, uint256 len) internal view {
        assembly {
            pop(staticcall(gas(), 4, add(add(src, 32), srcidx), len, add(add(dest, 32), destidx), len))
        }
    }
}