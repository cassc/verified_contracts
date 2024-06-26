// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


interface IERC721Tengoku {
    event Refund(
        address indexed _sender,
        uint256 indexed _tokenId,
        uint256 _amount
    );

    function refund(uint256[] calldata tokenIds) external;

    function getRefundPrice(uint256 tokenId) external view returns (uint256);

    function getRefundGuaranteeBeginTime() external view returns (uint256);

    function isRefundGuaranteeActive() external view returns (bool);
}