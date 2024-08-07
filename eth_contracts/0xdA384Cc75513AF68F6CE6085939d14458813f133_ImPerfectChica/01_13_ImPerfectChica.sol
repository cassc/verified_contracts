// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract ImPerfectChica is ERC721A, Ownable {
    string  public baseURI;
    uint256 public immutable mintPrice = 0.005 ether;
    uint32 public immutable maxSupply = 3334;
    uint32 public immutable perTxMax = 6;
    mapping(address => bool) public freeMinted;
    bytes32 public root;

    modifier callerIsUser() {
        require(tx.origin == msg.sender, "The caller is another contract");
        _;
    }

    constructor()
    ERC721A ("ImPerfectChica", "IPC") {
    }

    function _baseURI() internal view override(ERC721A) returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory uri) public onlyOwner {
        baseURI = uri;
    }

    function _startTokenId() internal view virtual override(ERC721A) returns (uint256) {
        return 0;
    }

    function mint(uint32 amount) public payable callerIsUser{
        require(totalSupply() + amount <= maxSupply,"sold out");
        require(amount <= perTxMax,"max 6 amount");
        if(freeMinted[msg.sender])
        {
            require(msg.value >= amount * mintPrice,"insufficient");
        }
        else 
        {
            freeMinted[msg.sender] = true;
            require(msg.value >= (amount-1) * mintPrice,"insufficient");
        }
        _safeMint(msg.sender, amount);
    }

    function getMintedFree(address addr) public view returns (bool){
        return freeMinted[addr];
    }

    function withdraw() public onlyOwner {
        uint256 sendAmount = address(this).balance;

        address h = payable(msg.sender);

        bool success;

        (success, ) = h.call{value: sendAmount}("");
        require(success, "Transaction Unsuccessful");
    }
}