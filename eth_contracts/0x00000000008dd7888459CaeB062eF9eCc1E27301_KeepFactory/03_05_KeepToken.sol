// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @notice ERC1155 interface to receive tokens.
/// @author Modified from Solbase (https://github.com/Sol-DAO/solbase/blob/main/src/tokens/ERC1155/ERC1155.sol)
abstract contract ERC1155TokenReceiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes calldata
    ) public payable virtual returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] calldata,
        uint256[] calldata,
        bytes calldata
    ) public payable virtual returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}

/// @notice Modern, minimalist, and gas-optimized ERC1155 implementation with Compound-style voting and flexible permissioning scheme.
/// @author Modified from ERC1155V (https://github.com/kalidao/ERC1155V/blob/main/src/ERC1155V.sol)
/// @author Modified from Compound (https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol)
abstract contract KeepToken {
    /// -----------------------------------------------------------------------
    /// Events
    /// -----------------------------------------------------------------------

    event DelegateChanged(
        address indexed delegator,
        address indexed fromDelegate,
        address indexed toDelegate,
        uint256 id
    );

    event DelegateVotesChanged(
        address indexed delegate,
        uint256 indexed id,
        uint256 previousBalance,
        uint256 newBalance
    );

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 amount
    );

    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] amounts
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    event TransferabilitySet(
        address indexed operator,
        uint256 indexed id,
        bool on
    );

    event PermissionSet(address indexed operator, uint256 indexed id, bool on);

    event UserPermissionSet(
        address indexed operator,
        address indexed to,
        uint256 indexed id,
        bool on
    );

    event URI(string value, uint256 indexed id);

    /// -----------------------------------------------------------------------
    /// Custom Errors
    /// -----------------------------------------------------------------------

    error InvalidSig();

    error LengthMismatch();

    error Unauthorized();

    error NonTransferable();

    error NotPermitted();

    error UnsafeRecipient();

    error InvalidRecipient();

    error ExpiredSig();

    error Undetermined();

    error Overflow();

    /// -----------------------------------------------------------------------
    /// ERC1155 Storage
    /// -----------------------------------------------------------------------

    mapping(address => mapping(uint256 => uint256)) public balanceOf;

    mapping(address => mapping(address => bool)) public isApprovedForAll;

    /// -----------------------------------------------------------------------
    /// EIP-712 Storage/Logic
    /// -----------------------------------------------------------------------

    bytes32 internal constant MALLEABILITY_THRESHOLD =
        0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0;

    mapping(address => uint256) public nonces;

    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    // `keccak256(
                    //     "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                    // )`
                    0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
                    // `keccak256(bytes("Keep"))`
                    0x21d66785fec14e4da3d76f3866cf99a28f4da49ec8782c3cab7cf79c1b6fa66b,
                    // `keccak256("1")`
                    0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6,
                    block.chainid,
                    address(this)
                )
            );
    }

    function _recoverSig(
        bytes32 hash,
        address signer,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal view virtual {
        bool isValid;

        /// @solidity memory-safe-assembly
        assembly {
            // Clean the upper 96 bits of `signer` in case they are dirty.
            for {
                signer := shr(96, shl(96, signer))
            } signer {

            } {
                // Load the free memory pointer.
                // Simply using the free memory usually costs less if many slots are needed.
                let m := mload(0x40)

                // Clean the excess bits of `v` in case they are dirty.
                v := and(v, 0xff)
                // If `s` in lower half order, such that the signature is not malleable.
                if iszero(gt(s, MALLEABILITY_THRESHOLD)) {
                    mstore(m, hash)
                    mstore(add(m, 0x20), v)
                    mstore(add(m, 0x40), r)
                    mstore(add(m, 0x60), s)
                    pop(
                        staticcall(
                            gas(), // Amount of gas left for the transaction.
                            0x01, // Address of `ecrecover`.
                            m, // Start of input.
                            0x80, // Size of input.
                            m, // Start of output.
                            0x20 // Size of output.
                        )
                    )
                    // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
                    if mul(eq(mload(m), signer), returndatasize()) {
                        isValid := 1
                        break
                    }
                }

                // `bytes4(keccak256("isValidSignature(bytes32,bytes)"))`.
                let f := shl(224, 0x1626ba7e)
                // Write the abi-encoded calldata into memory, beginning with the function selector.
                mstore(m, f) // `bytes4(keccak256("isValidSignature(bytes32,bytes)"))`.
                mstore(add(m, 0x04), hash)
                mstore(add(m, 0x24), 0x40) // The offset of the `signature` in the calldata.
                mstore(add(m, 0x44), 65) // Store the length of the signature.
                mstore(add(m, 0x64), r) // Store `r` of the signature.
                mstore(add(m, 0x84), s) // Store `s` of the signature.
                mstore8(add(m, 0xa4), v) // Store `v` of the signature.

                isValid := and(
                    and(
                        // Whether the returndata is the magic value `0x1626ba7e` (left-aligned).
                        eq(mload(0x00), f),
                        // Whether the returndata is exactly 0x20 bytes (1 word) long.
                        eq(returndatasize(), 0x20)
                    ),
                    // Whether the staticcall does not revert.
                    // This must be placed at the end of the `and` clause,
                    // as the arguments are evaluated from right to left.
                    staticcall(
                        gas(), // Remaining gas.
                        signer, // The `signer` address.
                        m, // Offset of calldata in memory.
                        0xa5, // Length of calldata in memory.
                        0x00, // Offset of returndata.
                        0x20 // Length of returndata to write.
                    )
                )
                break
            }
        }

        if (!isValid) revert InvalidSig();
    }

    /// -----------------------------------------------------------------------
    /// ID Storage
    /// -----------------------------------------------------------------------

    uint256 internal constant SIGN_KEY = uint32(0x6c4b5546); // `execute()`

    mapping(uint256 => uint256) public totalSupply;

    mapping(uint256 => bool) public transferable;

    mapping(uint256 => bool) public permissioned;

    mapping(address => mapping(uint256 => bool)) public userPermissioned;

    /// -----------------------------------------------------------------------
    /// Checkpoint Storage
    /// -----------------------------------------------------------------------

    mapping(address => mapping(uint256 => address)) internal _delegates;

    mapping(address => mapping(uint256 => uint256)) public numCheckpoints;

    mapping(address => mapping(uint256 => mapping(uint256 => Checkpoint)))
        public checkpoints;

    struct Checkpoint {
        uint40 fromTimestamp;
        uint216 votes;
    }

    /// -----------------------------------------------------------------------
    /// Metadata Logic
    /// -----------------------------------------------------------------------

    function name() public pure virtual returns (string memory) {
        uint256 placeholder;

        assembly {
            placeholder := sub(
                calldatasize(),
                add(shr(240, calldataload(sub(calldatasize(), 2))), 2)
            )

            placeholder := calldataload(add(placeholder, 2))
        }

        return string(abi.encodePacked(placeholder));
    }

    /// -----------------------------------------------------------------------
    /// ERC165 Logic
    /// -----------------------------------------------------------------------

    function supportsInterface(
        bytes4 interfaceId
    ) public view virtual returns (bool) {
        return
            // ERC165 interface ID for ERC165.
            interfaceId == this.supportsInterface.selector ||
            // ERC165 interface ID for ERC1155.
            interfaceId == 0xd9b67a26;
    }

    /// -----------------------------------------------------------------------
    /// ERC1155 Logic
    /// -----------------------------------------------------------------------

    function balanceOfBatch(
        address[] calldata owners,
        uint256[] calldata ids
    ) public view virtual returns (uint256[] memory balances) {
        if (owners.length != ids.length) revert LengthMismatch();

        balances = new uint256[](owners.length);

        for (uint256 i; i < owners.length; ) {
            balances[i] = balanceOf[owners[i]][ids[i]];

            // Unchecked because the only math done is incrementing
            // the array index counter which cannot possibly overflow.
            unchecked {
                ++i;
            }
        }
    }

    function setApprovalForAll(
        address operator,
        bool approved
    ) public payable virtual {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) public payable virtual {
        if (msg.sender != from)
            if (!isApprovedForAll[from][msg.sender]) revert Unauthorized();

        if (!transferable[id]) revert NonTransferable();

        if (permissioned[id])
            if (!userPermissioned[to][id] || !userPermissioned[from][id])
                revert NotPermitted();

        // If not transferring SIGN_KEY, update delegation balance.
        // Otherwise, prevent transfer to SIGN_KEY holder.
        if (id != SIGN_KEY)
            _moveDelegates(delegates(from, id), delegates(to, id), id, amount);
        else if (balanceOf[to][id] != 0) revert Overflow();

        balanceOf[from][id] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to][id] += amount;
        }

        emit TransferSingle(msg.sender, from, to, id, amount);

        if (to.code.length != 0) {
            if (
                ERC1155TokenReceiver(to).onERC1155Received(
                    msg.sender,
                    from,
                    id,
                    amount,
                    data
                ) != ERC1155TokenReceiver.onERC1155Received.selector
            ) revert UnsafeRecipient();
        } else if (to == address(0)) revert InvalidRecipient();
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata data
    ) public payable virtual {
        if (ids.length != amounts.length) revert LengthMismatch();

        if (msg.sender != from)
            if (!isApprovedForAll[from][msg.sender]) revert Unauthorized();

        // Storing these outside the loop saves ~15 gas per iteration.
        uint256 id;
        uint256 amount;

        for (uint256 i; i < ids.length; ) {
            id = ids[i];
            amount = amounts[i];

            if (!transferable[id]) revert NonTransferable();

            if (permissioned[id])
                if (!userPermissioned[to][id] || !userPermissioned[from][id])
                    revert NotPermitted();

            // If not transferring SIGN_KEY, update delegation balance.
            // Otherwise, prevent transfer to SIGN_KEY holder.
            if (id != SIGN_KEY)
                _moveDelegates(
                    delegates(from, id),
                    delegates(to, id),
                    id,
                    amount
                );
            else if (balanceOf[to][id] != 0) revert Overflow();

            balanceOf[from][id] -= amount;

            // Cannot overflow because the sum of all user
            // balances can't exceed the max uint256 value.
            unchecked {
                balanceOf[to][id] += amount;
            }

            // An array can't have a total length
            // larger than the max uint256 value.
            unchecked {
                ++i;
            }
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);

        if (to.code.length != 0) {
            if (
                ERC1155TokenReceiver(to).onERC1155BatchReceived(
                    msg.sender,
                    from,
                    ids,
                    amounts,
                    data
                ) != ERC1155TokenReceiver.onERC1155BatchReceived.selector
            ) revert UnsafeRecipient();
        } else if (to == address(0)) revert InvalidRecipient();
    }

    /// -----------------------------------------------------------------------
    /// EIP-2612-style Permit Logic
    /// -----------------------------------------------------------------------

    function permit(
        address owner,
        address operator,
        bool approved,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public payable virtual {
        if (owner == address(0)) revert InvalidSig();

        if (block.timestamp > deadline) revert ExpiredSig();

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            bytes32 hash = keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    DOMAIN_SEPARATOR(),
                    keccak256(
                        abi.encode(
                            keccak256(
                                "Permit(address owner,address operator,bool approved,uint256 nonce,uint256 deadline)"
                            ),
                            owner,
                            operator,
                            approved,
                            nonces[owner]++,
                            deadline
                        )
                    )
                )
            );

            _recoverSig(hash, owner, v, r, s);
        }

        isApprovedForAll[owner][operator] = approved;

        emit ApprovalForAll(owner, operator, approved);
    }

    /// -----------------------------------------------------------------------
    /// Checkpoint Logic
    /// -----------------------------------------------------------------------

    function getVotes(
        address account,
        uint256 id
    ) public view virtual returns (uint256) {
        return getCurrentVotes(account, id);
    }

    function getCurrentVotes(
        address account,
        uint256 id
    ) public view virtual returns (uint256) {
        // Unchecked because subtraction only occurs if positive `nCheckpoints`.
        unchecked {
            uint256 nCheckpoints = numCheckpoints[account][id];

            uint256 result;

            if (nCheckpoints != 0)
                result = checkpoints[account][id][nCheckpoints - 1].votes;

            return result;
        }
    }

    function getPastVotes(
        address account,
        uint256 id,
        uint256 timestamp
    ) public view virtual returns (uint256) {
        return getPriorVotes(account, id, timestamp);
    }

    function getPriorVotes(
        address account,
        uint256 id,
        uint256 timestamp
    ) public view virtual returns (uint256) {
        if (block.timestamp <= timestamp) revert Undetermined();

        uint256 nCheckpoints = numCheckpoints[account][id];

        if (nCheckpoints == 0) return 0;

        // Unchecked because subtraction only occurs if positive `nCheckpoints`.
        unchecked {
            uint256 prevCheckpoint = nCheckpoints - 1;

            if (
                checkpoints[account][id][prevCheckpoint].fromTimestamp <=
                timestamp
            ) return checkpoints[account][id][prevCheckpoint].votes;

            if (checkpoints[account][id][0].fromTimestamp > timestamp) return 0;

            uint256 lower;

            uint256 upper = prevCheckpoint;

            while (upper > lower) {
                uint256 center = upper - (upper - lower) / 2;

                Checkpoint memory cp = checkpoints[account][id][center];

                if (cp.fromTimestamp == timestamp) {
                    return cp.votes;
                } else if (cp.fromTimestamp < timestamp) {
                    lower = center;
                } else {
                    upper = center - 1;
                }
            }

            return checkpoints[account][id][lower].votes;
        }
    }

    /// -----------------------------------------------------------------------
    /// Delegation Logic
    /// -----------------------------------------------------------------------

    function delegates(
        address account,
        uint256 id
    ) public view virtual returns (address) {
        address current = _delegates[account][id];

        if (current == address(0)) current = account;

        return current;
    }

    function delegate(address delegatee, uint256 id) public payable virtual {
        _delegate(msg.sender, delegatee, id);
    }

    function delegateBySig(
        address delegator,
        address delegatee,
        uint256 id,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public payable virtual {
        if (delegator == address(0)) revert InvalidSig();

        if (block.timestamp > deadline) revert ExpiredSig();

        // Unchecked because the only math done is incrementing
        // the delegator's nonce which cannot realistically overflow.
        unchecked {
            bytes32 hash = keccak256(
                abi.encodePacked(
                    "\x19\x01",
                    DOMAIN_SEPARATOR(),
                    keccak256(
                        abi.encode(
                            keccak256(
                                "Delegation(address delegator,address delegatee,uint256 id,uint256 nonce,uint256 deadline)"
                            ),
                            delegator,
                            delegatee,
                            id,
                            nonces[delegator]++,
                            deadline
                        )
                    )
                )
            );

            _recoverSig(hash, delegator, v, r, s);
        }

        _delegate(delegator, delegatee, id);
    }

    function _delegate(
        address delegator,
        address delegatee,
        uint256 id
    ) internal virtual {
        address currentDelegate = delegates(delegator, id);

        _delegates[delegator][id] = delegatee;

        emit DelegateChanged(delegator, currentDelegate, delegatee, id);

        _moveDelegates(
            currentDelegate,
            delegatee,
            id,
            balanceOf[delegator][id]
        );
    }

    function _moveDelegates(
        address srcRep,
        address dstRep,
        uint256 id,
        uint256 amount
    ) internal virtual {
        if (srcRep != dstRep) {
            if (amount != 0) {
                if (srcRep != address(0)) {
                    uint256 srcRepNum = numCheckpoints[srcRep][id];

                    uint256 srcRepOld;

                    // Unchecked because subtraction only occurs if positive `srcRepNum`.
                    unchecked {
                        srcRepOld = srcRepNum != 0
                            ? checkpoints[srcRep][id][srcRepNum - 1].votes
                            : 0;
                    }

                    _writeCheckpoint(
                        srcRep,
                        id,
                        srcRepNum,
                        srcRepOld,
                        srcRepOld - amount
                    );
                }

                if (dstRep != address(0)) {
                    uint256 dstRepNum = numCheckpoints[dstRep][id];

                    uint256 dstRepOld;

                    // Unchecked because subtraction only occurs if positive `dstRepNum`.
                    unchecked {
                        if (dstRepNum != 0)
                            dstRepOld = checkpoints[dstRep][id][dstRepNum - 1]
                                .votes;
                    }

                    _writeCheckpoint(
                        dstRep,
                        id,
                        dstRepNum,
                        dstRepOld,
                        dstRepOld + amount
                    );
                }
            }
        }
    }

    function _writeCheckpoint(
        address delegatee,
        uint256 id,
        uint256 nCheckpoints,
        uint256 oldVotes,
        uint256 newVotes
    ) internal virtual {
        emit DelegateVotesChanged(delegatee, id, oldVotes, newVotes);

        // Unchecked because subtraction only occurs if positive `nCheckpoints`.
        unchecked {
            if (nCheckpoints != 0) {
                if (
                    checkpoints[delegatee][id][nCheckpoints - 1]
                        .fromTimestamp == block.timestamp
                ) {
                    checkpoints[delegatee][id][nCheckpoints - 1]
                        .votes = _safeCastTo216(newVotes);
                    return;
                }
            }

            checkpoints[delegatee][id][nCheckpoints] = Checkpoint(
                _safeCastTo40(block.timestamp),
                _safeCastTo216(newVotes)
            );

            // Unchecked because the only math done is incrementing
            // checkpoints which cannot realistically overflow.
            ++numCheckpoints[delegatee][id];
        }
    }

    /// -----------------------------------------------------------------------
    /// Safecast Logic
    /// -----------------------------------------------------------------------

    function _safeCastTo40(uint256 x) internal pure virtual returns (uint40) {
        if (x >= (1 << 40)) revert Overflow();

        return uint40(x);
    }

    function _safeCastTo216(uint256 x) internal pure virtual returns (uint216) {
        if (x >= (1 << 216)) revert Overflow();

        return uint216(x);
    }

    /// -----------------------------------------------------------------------
    /// Internal Mint/Burn Logic
    /// -----------------------------------------------------------------------

    function _mint(
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) internal virtual {
        _safeCastTo216(totalSupply[id] += amount);

        // If not minting SIGN_KEY, update delegation balance.
        // Otherwise, prevent minting to SIGN_KEY holder.
        if (id != SIGN_KEY)
            _moveDelegates(address(0), delegates(to, id), id, amount);
        else if (balanceOf[to][id] != 0) revert Overflow();

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to][id] += amount;
        }

        emit TransferSingle(msg.sender, address(0), to, id, amount);

        if (to.code.length != 0) {
            if (
                ERC1155TokenReceiver(to).onERC1155Received(
                    msg.sender,
                    address(0),
                    id,
                    amount,
                    data
                ) != ERC1155TokenReceiver.onERC1155Received.selector
            ) revert UnsafeRecipient();
        } else if (to == address(0)) revert InvalidRecipient();
    }

    function _burn(address from, uint256 id, uint256 amount) internal virtual {
        balanceOf[from][id] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            totalSupply[id] -= amount;
        }

        emit TransferSingle(msg.sender, from, address(0), id, amount);

        // If not burning SIGN_KEY, update delegation balance.
        if (id != SIGN_KEY)
            _moveDelegates(delegates(from, id), address(0), id, amount);
    }

    /// -----------------------------------------------------------------------
    /// Internal Permission Logic
    /// -----------------------------------------------------------------------

    function _setTransferability(uint256 id, bool on) internal virtual {
        transferable[id] = on;

        emit TransferabilitySet(msg.sender, id, on);
    }

    function _setPermission(uint256 id, bool on) internal virtual {
        permissioned[id] = on;

        emit PermissionSet(msg.sender, id, on);
    }

    function _setUserPermission(
        address to,
        uint256 id,
        bool on
    ) internal virtual {
        userPermissioned[to][id] = on;

        emit UserPermissionSet(msg.sender, to, id, on);
    }
}