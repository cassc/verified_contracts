// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { IGovernance } from "@interfaces/IGovernance.sol";
import { IENSRegistry } from "@interfaces/IENSRegistry.sol";
import { IENSResolver } from "@interfaces/IENSResolver.sol";

import { TornadoAddresses } from "@proprietary/TornadoAddresses.sol";

contract UpdateENSDataProposal is TornadoAddresses {
    function executeProposal() public {
        address ensResolverAddress = 0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41;
        address ensRegistryAddress = 0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e;
        address governanceImplementationAddress = 0xBa178126C28F50Ee60322a82f5EbCd6b3711e101;

        IENSRegistry ensRegistry = IENSRegistry(ensRegistryAddress);
        IENSResolver ensResolver = IENSResolver(ensResolverAddress);

        // From data/ensNodesDeclarations.txt, calculated via scripts/calculateENSNodes.ts
        bytes32 rootTornadoENSNode = 0xe6ae31d630cc7a8279c0f1c7cbe6e7064814c47d1785fa2703d9ae511ee2be0c;
        bytes32 tornadoContractENSNode = 0xe7e1d618367ebadd8e172150a43cfc839fd19022c2be81a6e8d45e06aa1011cd;
        bytes32 stakingRewardsENSNode = 0x3da4b79cd8c20d2fafb1c7cb37a62be8668f543393f6636d421fba0be735e68f;
        bytes32 governanceImplENSNode = 0x092359a5505072470ce8b86eebed5b4b6f001fe6bd08dbcf723c97073a360cfc;
        bytes32 novaENSNode = 0xc3964c598b56aeaee4c253283fb1ebb12510b95db00960589cdc62807a2537a0;
        bytes32 docsENSNode = 0xd7b8aac14a9b2507ab99b5fde3060197fddb9735afa9bf38b1f7e34923cb935e;
        bytes32 relayersUIENSNode = 0x4e37047f2c961db41dfb7d38cf79ca745faf134a8392cfb834d3a93330b9108d;

        bytes32 tornadoContractENSLabelhash = 0x7f6dd79f0020bee2024a097aaa5d32ab7ca31126fa375538de047e7475fa8572;
        bytes32 stakingRewardsENSLabelhash = 0x15826fcf9999635849b273bcd226f436dc42a8fabf43049b60971ab51d8d6b8f;
        bytes32 governanceImplENSLabelhash = 0x6583a22765d3d6a6ca97b21440f79fecaf21bb8bcaa4fb694483e63d821ba50d;

        // At first change owner of subdomain contract.tornadocash.eth and then staking-rewards.contract.tornadocash.eth
        // and governance-impl.contract.tornadocash.eth to Governance
        ensRegistry.setSubnodeOwner(rootTornadoENSNode, tornadoContractENSLabelhash, governanceAddress);
        ensRegistry.setSubnodeOwner(tornadoContractENSNode, stakingRewardsENSLabelhash, governanceAddress);
        ensRegistry.setSubnodeOwner(tornadoContractENSNode, governanceImplENSLabelhash, governanceAddress);

        // Update staking address, that has been changed in proposal 22: https://tornado.ws/governance/22
        ensResolver.setAddr(stakingRewardsENSNode, stakingAddress);
        // Update Governance implementation (logic) address on ENS, that has been changed in proposal 22: https://tornado.ws/governance/22
        ensResolver.setAddr(governanceImplENSNode, governanceImplementationAddress);

        // From data/ensDomainsIPFSContenthashes.txt, calculated via scripts/calculateIPFSContenthashes.ts
        bytes memory classicUiIPFSContenthash = hex"e301017012203c89ba6bfdeb8d7209463006e620ee6dcb34675cf3202f20919e3a5f9919070d";
        bytes memory novaUiIPFSContenthash = hex"e3010170122069648b09fb7ed9a89ca153a000bc8c1bf82a779195a640609e1510dc36c28bb7";
        bytes memory relayersUiIPFSContenthash = hex"e301017012203d61bed0641d7c53d5f036b6448f9d455ae6e0ceda44563009536a12e51d52cf";
        bytes memory docsIPFSContenthash = hex"e301017012201e6facc47ac27a4072b3ba19e716c0db37cbd29b40b23f3af8a85412ef45be08";

        ensResolver.setContenthash(rootTornadoENSNode, classicUiIPFSContenthash);
        ensResolver.setContenthash(novaENSNode, novaUiIPFSContenthash);
        ensResolver.setContenthash(docsENSNode, docsIPFSContenthash);
        ensResolver.setContenthash(relayersUIENSNode, relayersUiIPFSContenthash);
    }
}