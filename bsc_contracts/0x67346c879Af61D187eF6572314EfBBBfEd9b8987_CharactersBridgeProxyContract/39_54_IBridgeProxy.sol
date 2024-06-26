pragma solidity ^0.6.5;

interface IBridgeProxy {
    function collectData(uint256 tokenId) external view returns (uint256[] memory uintVars, string memory stringVar);

    function mintOrUpdate(address receiver, uint256 tokenId, uint256[] calldata uintVars,  string calldata stringVar) external returns (uint256);

    function isEnabled() external view returns (bool);

    function sigVersion() external view returns (uint256);
    function canBridge(address wallet, uint256 tokenId, uint256 targetChain) external view returns (bool);
}