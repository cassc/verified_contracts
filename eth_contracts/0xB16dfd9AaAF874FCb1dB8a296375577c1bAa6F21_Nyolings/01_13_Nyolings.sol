// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

/// @author narghev dactyleth

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "erc721a/contracts/ERC721A.sol";

contract Nyolings is ERC721A, Ownable, ReentrancyGuard {
    using Strings for uint256;

    enum ContractMintState {
        PAUSED,
        PUBLIC,
        ALLOWLIST,
        REFUND
    }

    ContractMintState public state = ContractMintState.PAUSED;

    string public uriPrefix = "";
    string public hiddenMetadataUri = "ipfs://QmRtoGVkaRgk4NNy2DP672EV9hKNDiV2GEEFmjJSpwBHmq";

    uint256 public allowlistCost = 0 ether;
    uint256 public publicCost = 0.03 ether;
    uint256 public maxPerWalletPublic = 3;
    uint256 public maxSupply = 7777;
    uint256 public maxMintAmountPerTx = 3;

    uint256 public publicSupply = 5555;

    bytes32 public whitelistMerkleRoot = 0xd3506552cf8409f75c26b01e3ae58e503f003851dfce3f002eecc76ab8df027d;

    mapping(address => uint256) public publicPaid;
    mapping(address => uint256) public publicMinted;
    mapping(address => bool) public refunded;

    mapping(address => uint256) public allowlistMinted;

    constructor() ERC721A("Nyolings", "NYOLINGS") {}

    // OVERRIDES
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return uriPrefix;
    }

    // MODIFIERS
    modifier mintCompliance(uint256 _mintAmount) {
        require(
            _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
            "Invalid mint amount"
        );
        require(
            totalSupply() + _mintAmount <= maxSupply,
            "Max supply exceeded"
        );
        _;
    }

    // MERKLE TREE
    function _verify(bytes32 leaf, bytes32[] memory proof)
        internal
        view
        returns (bool)
    {
        return MerkleProof.verify(proof, whitelistMerkleRoot, leaf);
    }

    function _leaf(address account, uint256 allowance)
        internal
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(account, allowance));
    }

    // MINTING FUNCTIONS
    function publicMint(uint256 amount) public payable mintCompliance(amount) {
        require(state == ContractMintState.PUBLIC, "Public mint is disabled");
        require(totalSupply() + amount <= publicSupply, "Can't mint that many");
        require(publicMinted[msg.sender] + amount <= maxPerWalletPublic);
        require(msg.value == publicCost * amount, "Insufficient funds");

        // Refund logic
        publicPaid[msg.sender] += msg.value;
        publicMinted[msg.sender] += amount;

        _safeMint(msg.sender, amount);
    }

    function mintAllowList(
        uint256 amount,
        uint256 allowance,
        bytes32[] calldata proof
    ) public payable mintCompliance(amount) {
        require(
            state == ContractMintState.ALLOWLIST,
            "Allowlist mint is disabled"
        );
        require(msg.value >= allowlistCost * amount, "Insufficient funds");
        require(
            allowlistMinted[msg.sender] + amount <= allowance,
            "Can't mint that many"
        );
        require(_verify(_leaf(msg.sender, allowance), proof), "Invalid proof");

        allowlistMinted[msg.sender] += amount;
        _safeMint(msg.sender, amount);
    }

    function refund() external nonReentrant {
        require(state == ContractMintState.REFUND, "Refund is disabled");
        require(!refunded[msg.sender], "Already refunded");

        uint256 toRefund = getRefundAmount(msg.sender);
        refunded[msg.sender] = true;

        payable(msg.sender).transfer(toRefund);
    }

    function mintForAddress(uint256 amount, address _receiver)
        public
        onlyOwner
    {
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
        _safeMint(_receiver, amount);
    }

    // GETTERS
    function getRefundAmount(address _minter) public view returns (uint256) {
        if (state != ContractMintState.REFUND) {
            return 0;
        }
        if (refunded[msg.sender]) {
            return 0;
        }

        uint256 paid = publicPaid[_minter];
        uint256 amountMinted = publicMinted[_minter];

        uint256 shouldHavePaid = amountMinted * publicCost;
        uint256 toRefund = paid - shouldHavePaid;
        
        return toRefund;
    }

    function numberMinted(address _minter) public view returns (uint256) {
        return _numberMinted(_minter);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();

        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        _tokenId.toString(),
                        ".json"
                    )
                )
                : hiddenMetadataUri;
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory ownerTokens = new uint256[](ownerTokenCount);
        uint256 ownerTokenIdx = 0;
        for (
            uint256 tokenIdx = _startTokenId();
            tokenIdx <= totalSupply();
            tokenIdx++
        ) {
            if (ownerOf(tokenIdx) == _owner) {
                ownerTokens[ownerTokenIdx] = tokenIdx;
                ownerTokenIdx++;
            }
        }
        return ownerTokens;
    }

    // SETTERS
    function setState(ContractMintState _state) public onlyOwner {
        state = _state;
    }

    function setCosts(uint256 _allowlistCost, uint256 _publicCost)
        public
        onlyOwner
    {
        allowlistCost = _allowlistCost;
        publicCost = _publicCost;
    }

    function setPublicSupply(uint256 _publicSupply) external onlyOwner {
        require(
            _publicSupply <= maxSupply,
            "Public supply can't be higher than max supply"
        );
        publicSupply = _publicSupply;
    }

    function setMaxSupply(uint256 _maxSupply) public onlyOwner {
        require(_maxSupply < maxSupply, "Cannot increase the supply");
        maxSupply = _maxSupply;
    }

    function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
        public
        onlyOwner
    {
        maxMintAmountPerTx = _maxMintAmountPerTx;
    }

    function setMaxPerWalletPublic(uint256 _maxPerWalletPublic)
        public
        onlyOwner
    {
        maxPerWalletPublic = _maxPerWalletPublic;
    }

    function setHiddenMetadataUri(string memory _hiddenMetadataUri)
        public
        onlyOwner
    {
        hiddenMetadataUri = _hiddenMetadataUri;
    }

    function setUriPrefix(string memory _uriPrefix) public onlyOwner {
        uriPrefix = _uriPrefix;
    }

    function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot)
        external
        onlyOwner
    {
        whitelistMerkleRoot = _whitelistMerkleRoot;
    }

    // WITHDRAW
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        bool success = true;

        (success, ) = payable(0x47bA1d0081053e97878Af4F7943719C87d64bcaA).call{
            value: (88 * contractBalance) / 100
        }("");
        require(success, "Transfer failed");

        (success, ) = payable(0x44230C74E406d5690333ba81b198441bCF02CEc8).call{
            value: (6 * contractBalance) / 100
        }("");
        require(success, "Transfer failed");

        (success, ) = payable(0xFA9A358b821f4b4A1B5ac2E0c594bB3f860AFbd8).call{
            value: (6 * contractBalance) / 100
        }("");
        require(success, "Transfer failed");
    }
}