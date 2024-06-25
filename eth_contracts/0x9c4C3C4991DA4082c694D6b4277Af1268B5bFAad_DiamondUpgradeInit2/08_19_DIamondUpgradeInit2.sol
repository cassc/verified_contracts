pragma solidity ^0.8.0;

// SPDX-License-Identifier: MIT OR Apache-2.0



import "./Config.sol";
import "./facets/Mailbox.sol";
import "./libraries/Diamond.sol";
import "../common/L2ContractHelper.sol";

interface IOldContractDeployer {
    function forceDeployOnAddress(
        bytes32 _bytecodeHash,
        address _newAddress,
        bytes calldata _input
    ) external payable returns (address);
}

/// @author Matter Labs
contract DiamondUpgradeInit2 is MailboxFacet {
    function forceDeploy2(
        bytes calldata _upgradeDeployerCalldata,
        bytes calldata _upgradeSystemContractsCalldata,
        bytes[] calldata _factoryDeps
    ) external payable returns (bytes32) {
        // 1. Update bytecode for the deployer smart contract
        _requestL2Transaction(
            FORCE_DEPLOYER,
            DEPLOYER_SYSTEM_CONTRACT_ADDRESS,
            0,
            _upgradeDeployerCalldata,
            PRIORITY_TX_MAX_ERGS_LIMIT,
            _factoryDeps
        );

        // 2. Redeploy other contracts by one transaction
        _requestL2Transaction(
            FORCE_DEPLOYER,
            DEPLOYER_SYSTEM_CONTRACT_ADDRESS,
            0,
            _upgradeSystemContractsCalldata,
            PRIORITY_TX_MAX_ERGS_LIMIT,
            _factoryDeps
        );

        return Diamond.DIAMOND_INIT_SUCCESS_RETURN_VALUE;
    }
}