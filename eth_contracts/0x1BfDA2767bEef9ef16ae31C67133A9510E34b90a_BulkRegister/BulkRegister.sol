/**
 *Submitted for verification at Etherscan.io on 2023-03-24
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract BulkRegister {
    ENSController ensRegistrarController =
        ENSController(0x283Af0B28c62C092C9727F1Ee09c02CA627EB7F5);

    function getOwner() private pure returns (address) {
        return 0xb931592eEd3f82681E00bfd05ceD4C11bE957115;
    }

    modifier onlyOwner() {
        require(msg.sender == getOwner(), "Not owner");
        _;
    }

    // use external because cheaper and we never want to call it privately.
    function withdraw() external {
        (bool success, ) = getOwner().call{value: address(this).balance}("");
        require(success, "Failed to send Ether");
    }

    function validPrice(
        string[] memory names,
        uint256 duration,
        uint256 ethSent
    ) internal view returns (uint256[] memory) {
        uint256[] memory prices = new uint256[](names.length);
        uint256 totalPrice;
        for (uint256 i = 0; i < names.length; i++) {
            prices[i] = ensRegistrarController.rentPrice(names[i], duration);
            totalPrice += prices[i];
        }
        require(ethSent >= totalPrice, "Invalid price");
        return prices;
    }

    function createCommitmentsForRegistration(
        ENSCommitment.Commitment[] memory commitments,
        uint256 duration,
        bool withConfigs
    ) external view returns (bytes32[] memory, uint256[] memory) {
        bytes32[] memory createdCommitments = new bytes32[](commitments.length);
        if (withConfigs == false) {
            for (uint8 i = 0; i < commitments.length; i++) {
                createdCommitments[i] = ensRegistrarController.makeCommitment(
                    commitments[i].name,
                    commitments[i].owner,
                    commitments[i].secret
                );
            }
        } else {
            for (uint8 i = 0; i < commitments.length; i++) {
                createdCommitments[i] = ensRegistrarController
                    .makeCommitmentWithConfig(
                        commitments[i].name,
                        commitments[i].owner,
                        commitments[i].secret,
                        commitments[i].resolver,
                        commitments[i].owner
                    );
            }
        }

        uint256[] memory prices = new uint256[](commitments.length);
        for (uint8 i = 0; i < commitments.length; i++) {
            prices[i] = ensRegistrarController.rentPrice(
                commitments[i].name,
                duration
            );
        }

        return (createdCommitments, prices);
    }

    function requestRegistration(bytes32[] memory commitments) external {
        for (uint8 i = 0; i < commitments.length; i++) {
            ensRegistrarController.commit(commitments[i]);
        }
    }

    function completeRegistration(
        string[] memory names,
        address owner,
        uint256 duration,
        bytes32 secret
    ) external payable {
        uint256[] memory prices = validPrice(names, duration, msg.value);

        for (uint8 i = 0; i < names.length; i++) {
            ensRegistrarController.register{value: prices[i]}(
                names[i],
                owner,
                duration,
                secret
            );
        }
    }

    function completeRegistrationWithConfigs(
        string[] memory names,
        address owner,
        uint256 duration,
        bytes32 secret,
        address resolver
    ) external payable {
        uint256[] memory prices = validPrice(names, duration, msg.value);

        for (uint8 i = 0; i < names.length; i++) {
            ensRegistrarController.registerWithConfig{value: prices[i]}(
                names[i],
                owner,
                duration,
                secret,
                resolver,
                owner
            );
        }
    }
}

contract ENSCommitment {
    struct Commitment {
        string name;
        address owner;
        uint256 duration;
        bytes32 secret;
        address resolver;
        bytes[] data;
        bool reverseRecord;
        uint32 fuses;
        uint64 wrapperExpiry;
    }
    struct RegistrationWithConfig {
        string name;
        address owner;
    }
}

interface ENSController {
    event NameRegistered(
        string name,
        bytes32 indexed label,
        address indexed owner,
        uint256 cost,
        uint256 expires
    );
    event NameRenewed(
        string name,
        bytes32 indexed label,
        uint256 cost,
        uint256 expires
    );
    event NewPriceOracle(address indexed oracle);

    function rentPrice(
        string memory name,
        uint256 duration
    ) external view returns (uint256);

    function valid(string memory name) external pure returns (bool);

    function available(string memory name) external view returns (bool);

    function makeCommitment(
        string memory name,
        address owner,
        bytes32 secret
    ) external pure returns (bytes32);

    function makeCommitmentWithConfig(
        string memory name,
        address owner,
        bytes32 secret,
        address resolver,
        address addr
    ) external pure returns (bytes32);

    function commit(bytes32 commitment) external;

    function register(
        string calldata name,
        address owner,
        uint256 duration,
        bytes32 secret
    ) external payable;

    function registerWithConfig(
        string memory name,
        address owner,
        uint256 duration,
        bytes32 secret,
        address resolver,
        address addr
    ) external payable;

    function renew(string calldata name, uint256 duration) external payable;
}