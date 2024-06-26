// SPDX-License-Identifier: UNLICENSED
pragma solidity =0.8.16;

import {Initializable} from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import {ERC1155Upgradeable} from '@openzeppelin/contracts-upgradeable/token/ERC1155/ERC1155Upgradeable.sol';
import {ERC1155SupplyUpgradeable} from '@openzeppelin/contracts-upgradeable/token/ERC1155/extensions/ERC1155SupplyUpgradeable.sol';
import {PausableUpgradeable} from '@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol';
import {OwnableUpgradeable} from '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';
import {CountersUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/CountersUpgradeable.sol";
import {IERC2981Upgradeable, IERC165Upgradeable} from '@openzeppelin/contracts-upgradeable/interfaces/IERC2981Upgradeable.sol';
import {SafeERC20, IERC20} from '@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';
import {Base64} from '@openzeppelin/contracts/utils/Base64.sol';
import {Strings} from '@openzeppelin/contracts/utils/Strings.sol';
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";

/// @title QuestNFT
/// @author RabbitHole.gg
/// @notice This contract is the Erc1155 Quest Collection contract. It is the NFT that can be minted after a quest is completed.
contract QuestNFT is Initializable, ERC1155Upgradeable, ERC1155SupplyUpgradeable, PausableUpgradeable, OwnableUpgradeable, IERC2981Upgradeable, ReentrancyGuardUpgradeable {
    using CountersUpgradeable for CountersUpgradeable.Counter;
    using SafeERC20 for IERC20;

    CountersUpgradeable.Counter private _tokenIdCounter;
    address public protocolFeeRecipient;
    address public minterAddress;
    string public collectionName;
    struct QuestData {
        uint256 startTime;
        uint256 endTime;
        uint256 totalParticipants;
        uint256 questFee;
        uint256 tokenId;
        string description;
        string imageIPFSHash;
    }
    mapping(string => QuestData) public quests; // questId => QuestData
    mapping(uint256 => string) public tokenIdToQuestId; // tokenId => questId

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(
        address protocolFeeRecipient_,
        address minterAddress_, // should always be the QuestFactory contract
        string memory collectionName_
    ) external initializer {
        protocolFeeRecipient = protocolFeeRecipient_;
        minterAddress = minterAddress_;
        collectionName = collectionName_;
        __ERC1155_init("");
        __ERC1155Supply_init();
        __Ownable_init();
        __Pausable_init();
        __ReentrancyGuard_init();
    }

    /// @dev checks if the quest start time and end time are valid and the quest exists
    /// @param questId_ the questId to check
    modifier questChecks(string memory questId_) {
        QuestData storage quest = quests[questId_];
        require(quest.tokenId != 0, 'Quest does not exist');
        require(block.timestamp > quest.startTime, 'Quest not started');
        require(block.timestamp < quest.endTime, 'Quest ended');
        _;
    }

    modifier onlyMinter() {
        require(msg.sender == minterAddress, 'Only minter address');
        _;
    }

    function addQuest(
        uint256 questFee_,
        uint256 startTime_,
        uint256 endTime_,
        uint256 totalParticipants_,
        string memory questId_,
        string memory description_,
        string memory imageIPFSHash_
    ) public onlyMinter returns (uint256) {
        require (endTime_ > block.timestamp, 'endTime_ in the past');
        require (endTime_ > startTime_, 'startTime_ before endTime_');

        _tokenIdCounter.increment();
        QuestData storage quest = quests[questId_];
        quest.startTime = startTime_;
        quest.endTime = endTime_;
        quest.totalParticipants = totalParticipants_;
        quest.questFee = questFee_;
        quest.imageIPFSHash = imageIPFSHash_;
        quest.description = description_;
        quest.tokenId = _tokenIdCounter.current();
        tokenIdToQuestId[_tokenIdCounter.current()] = questId_;

        return _tokenIdCounter.current();
    }

    function mint(address to_, string memory questId_)
        public
        onlyMinter questChecks(questId_) whenNotPaused nonReentrant
    {
        QuestData storage quest = quests[questId_];

        _mint(to_, quest.tokenId, 1, "");

        (bool success, ) = protocolFeeRecipient.call{value: quest.questFee}("");
        require(success, 'protocol fee transfer failed');
    }

    function tokenIdFromQuestId(string memory questId_) public view returns (uint256) {
        QuestData storage quest = quests[questId_];
        return quest.tokenId;
    }

    /// @dev The maximum amount of coins the quest needs for the protocol fee
    function totalTransferAmount(string memory questId_) external view returns (uint256) {
        QuestData storage quest = quests[questId_];
        return quest.questFee * quest.totalParticipants;
    }

    /// @notice Pauses the Quest
    /// @dev Only the owner of the Quest can call this function.
    function pause() external onlyOwner {
        _pause();
    }

    /// @notice Unpauses the Quest
    /// @dev Only the owner of the Quest can call this function.
    function unPause() external onlyOwner {
        _unpause();
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155Upgradeable, ERC1155SupplyUpgradeable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    /// @dev Function that to withdraw the remaining coins in the contract to the owner
    /// @notice This function can only be called after all quests have ended
    function withdrawRemainingCoins() external nonReentrant {
        uint balance = address(this).balance;

        for (uint256 i = 1; i <= _tokenIdCounter.current(); i++) {
            require(quests[tokenIdToQuestId[i]].endTime < block.timestamp, 'Not all Quests have ended');
        }

        if (balance > 0) {
            (bool success, ) = owner().call{value: balance}("");
            require(success, 'withdraw remaining tokens failed');
        }

    }

    /// @dev saftey hatch function to transfer tokens sent to the contract to the contract owner.
    /// @param erc20Address_ The address of the ERC20 token to refund
    function refund(address erc20Address_) external nonReentrant {
        uint erc20Balance = IERC20(erc20Address_).balanceOf(address(this));
        if (erc20Balance > 0) IERC20(erc20Address_).safeTransfer(owner(), erc20Balance);
    }

    /// @dev returns the token uri
    /// @param tokenId_ the token id
    function uri(uint256 tokenId_)
        public
        view
        override(ERC1155Upgradeable)
        returns (string memory)
    {
        bytes memory dataURI = generateDataURI(tokenId_);
        return string(abi.encodePacked('data:application/json;base64,', Base64.encode(dataURI)));
    }

    /// @dev returns the data uri in json format
    function generateDataURI(uint256 tokenId_) internal view virtual returns (bytes memory) {
        QuestData storage quest = quests[tokenIdToQuestId[tokenId_]];
        bytes memory dataURI = abi.encodePacked(
            '{',
            '"name": "',
            collectionName,
            '",',
            '"description": "',
            quest.description,
            '",',
            '"image": "',
            tokenImage(quest.imageIPFSHash),
            '"',
            '}'
        );
        return dataURI;
    }

    function tokenImage(string memory imageIPFSHash_) internal view virtual returns (string memory) {
        return string(abi.encodePacked('ipfs://', imageIPFSHash_));
    }

    /// @dev See {IERC165-royaltyInfo}
    /// @param tokenId_ the token id
    /// @param salePrice_ the sale price
    function royaltyInfo(
        uint256 tokenId_,
        uint256 salePrice_
    ) external view override returns (address receiver, uint256 royaltyAmount) {
        require(exists(tokenId_), 'Nonexistent token');

        uint256 royaltyPayment = (salePrice_ * 200) / 10_000; // 2% royalty
        return (owner(), royaltyPayment);
    }

    /// @dev returns true if the supplied interface id is supported
    /// @param interfaceId_ the interface id
    function supportsInterface(
        bytes4 interfaceId_
    ) public view virtual override(ERC1155Upgradeable, IERC165Upgradeable) returns (bool) {
        return interfaceId_ == type(IERC2981Upgradeable).interfaceId || super.supportsInterface(interfaceId_);
    }

    // Functions to receive ETH
    receive() external payable {}
    fallback() external payable {}
}