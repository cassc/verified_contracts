// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

library LobsterGeneGenerator {
    struct Gene {
        uint256 lastRandom;
    }

    function random(Gene storage g) internal returns (uint256) {
        g.lastRandom = uint256(
            keccak256(
                abi.encode(
                    keccak256(
                        abi.encodePacked(
                            msg.sender,
                            tx.origin,
                            gasleft(),
                            g.lastRandom,
                            block.timestamp,
                            block.number,
                            blockhash(block.number),
                            blockhash(block.number - 100)
                        )
                    )
                )
            )
        );
        return g.lastRandom;
    }
}