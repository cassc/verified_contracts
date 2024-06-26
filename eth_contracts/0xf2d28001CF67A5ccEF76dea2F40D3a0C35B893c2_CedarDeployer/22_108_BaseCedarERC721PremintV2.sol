// SPDX-License-Identifier: Apache-2.0

// Generated by impl.ts. Will be overwritten.
// Filename: './BaseCedarERC721PremintV2.sol'

pragma solidity ^0.8.4;

import "../../api/impl/ICedarERC721Premint.sol";

/// Inherit from this base to implement introspection
abstract contract BaseCedarERC721PremintV2 is ICedarERC721PremintV2 {
    function supportedFeatures() override public pure returns (string[] memory features) {
        features = new string[](6);
        features[0] = "ICedarFeatures.sol:ICedarFeaturesV0";
        features[1] = "ICedarVersioned.sol:ICedarVersionedV1";
        features[2] = "issuance/ICedarPremint.sol:ICedarPremintV0";
        features[3] = "agreement/ICedarAgreement.sol:ICedarAgreementV0";
        features[4] = "IMulticallable.sol:IMulticallableV0";
        features[5] = "baseURI/ICedarUpgradeBaseURI.sol:ICedarUpgradeBaseURIV0";
    }

    /// This needs to be public to be callable from initialize via delegatecall
    function minorVersion() virtual override public pure returns (uint256 minor, uint256 patch);

    function implementationVersion() override public pure returns (uint256 major, uint256 minor, uint256 patch) {
        (minor, patch) = minorVersion();
        major = 2;
    }

    function implementationInterfaceName() virtual override public pure returns (string memory interfaceName) {
        interfaceName = "ICedarERC721PremintV2";
    }

    function supportsInterface(bytes4 interfaceID) virtual override public view returns (bool) {
        return (interfaceID == type(IERC165Upgradeable).interfaceId) || ((interfaceID == type(ICedarFeaturesV0).interfaceId) || ((interfaceID == type(ICedarVersionedV1).interfaceId) || ((interfaceID == type(ICedarPremintV0).interfaceId) || ((interfaceID == type(ICedarAgreementV0).interfaceId) || ((interfaceID == type(IMulticallableV0).interfaceId) || (interfaceID == type(ICedarUpgradeBaseURIV0).interfaceId))))));
    }

    function isICedarFeaturesV0() override public pure returns (bool) {
        return true;
    }
}