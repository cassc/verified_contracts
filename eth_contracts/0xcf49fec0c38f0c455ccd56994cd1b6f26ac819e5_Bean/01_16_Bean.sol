// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Bean is ERC20, Pausable, Ownable, ReentrancyGuard {
    using SafeMath for uint256;
    using ECDSA for bytes32;

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * (10**18);

    address public signatureManager;

    // contract => tokenId => claimed
    mapping(address => mapping(uint256 => bool)) public tokenClaimed;

    // signature => claimed
    mapping(bytes => bool) public signatureClaimed;

    // contract whitelist
    address[] public contracts;

    constructor(
        string memory _name,
        string memory _symbol,
        address _treasury,
        address _signatureManager,
        address[] memory _contracts
    ) ERC20(_name, _symbol) {
        _mint(address(this), MAX_SUPPLY.div(2));
        _mint(_treasury, MAX_SUPPLY.div(2));
        signatureManager = _signatureManager;
        contracts =_contracts;
    }

    function claim(
        address[] memory _contracts,      // NFT contracts: azuki + beanz + elementals
        uint256[] memory _amounts,        // token amount for every contract: 2 + 3 + 1
        uint256[] memory _tokenIds,       // all token id, tokenIds.length = sum(amounts)
        uint256 _claimAmount,
        uint256 _endTime,
        bytes memory _signature          // sender + claimAmount + endTime
    ) external whenNotPaused nonReentrant {
        // check length
        require(_contracts.length == _amounts.length, "contracts length not match amounts length");

        uint256 totalAmount;
        for (uint256 i = 0; i < _amounts.length; i++) {
            totalAmount = totalAmount + _amounts[i];
        }
        require(totalAmount == _tokenIds.length, "total amount not match tokenId length");

        // check signature
        bytes32 message = keccak256(abi.encodePacked(msg.sender, _claimAmount, _endTime));
        require(signatureManager == message.toEthSignedMessageHash().recover(_signature), "invalid signature");
        require(block.timestamp <= _endTime, "signature expired");

        // check NFT
        uint256 endIndex;
        uint256 startIndex;
        for (uint256 i = 0; i < _amounts.length; i++) {

            endIndex = startIndex + _amounts[i];

            for (uint256 j = startIndex; j < endIndex; j++) {
                address contractAddr = _contracts[i];
                uint256 tokenId = _tokenIds[j];
                require(IERC721(contractAddr).ownerOf(tokenId) == msg.sender, "not owner");
                tokenClaimed[contractAddr][tokenId] = true;
            }
            startIndex = endIndex;
        }
        signatureClaimed[_signature] = true;
        // transfer token
        _transfer(address(this), msg.sender, _claimAmount);
    }

    function setContracts(address[] memory _contracts) external onlyOwner {
        contracts = _contracts;
    }

    function setSignatureManager(address _signatureManager) external onlyOwner {
        signatureManager = _signatureManager;
    }

    function finish() external onlyOwner whenPaused {
        _burn(address(this), balanceOf(address(this)));
    }

    function pause() external onlyOwner whenNotPaused {
        _pause();
    }

    function unpause() external onlyOwner whenPaused {
        _unpause();
    }

    function withdraw(address _receiver, address _token, bool _isETH) external onlyOwner {
        if (_isETH) {
            payable(_receiver).transfer(address(this).balance);
        } else {
            IERC20(_token).transfer(_receiver, IERC20(_token).balanceOf(address(this)));
        }
    }

}