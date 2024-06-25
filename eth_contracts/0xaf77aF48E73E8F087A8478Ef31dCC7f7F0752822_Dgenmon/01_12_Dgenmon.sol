// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./ERC721AQueryable.sol";
import "./access/Ownable.sol";
import "./security/Pausable.sol";
import "./security/ReentrancyGuard.sol";
import "./utils/Context.sol";
import "./utils/MerkleProof.sol";
import "./utils/Presalable.sol";
import "./utils/math/SafeMath.sol";

contract Dgenmon is ERC721AQueryable, Ownable, Pausable, Presalable, ReentrancyGuard {
  using SafeMath for uint;

  bytes32 public merkleRoot;
  string public baseTokenURI;
  string public hiddenTokenUri;
  bool public isRevealed = false;
  uint256 public constant PRICE = 0.0099 ether;
  uint256 public constant PRESALE_PRICE = 0.0069 ether;
  uint256 public constant MAX_TOKEN_COUNT = 7878;

  mapping(address => bool) public isPresaleMinted;

  address t1 = 0x0d19303C6E1eF14E2cD824281bDcdD06B8d9940f;
  address t2 = 0x1B63118C94F2Ee99B4138f578860E742BD83c9CF;

  bool internal _locked;

  constructor(string memory _hiddenTokenUri) ERC721A("Dgenmon", "Dgenmon")  {
    setHiddenTokenUri(_hiddenTokenUri);
    presale();
  }

  function totalMinted() public view returns (uint256) {
    return _totalMinted();
  }

  function totalBurned() public view returns (uint256) {
    return _totalBurned();
  }

  function numberMinted(address owner) public view returns (uint256) {
    return _numberMinted(owner);
  }

  function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
    merkleRoot = _merkleRoot;
  }

  function setRevealed(bool _isRevealed) public onlyOwner {
    isRevealed = _isRevealed;
  }

  function setHiddenTokenUri(string memory _hiddenTokenUri) public onlyOwner {
    hiddenTokenUri = _hiddenTokenUri;
  }

  function mint(uint256 _amount) public payable whenNotPresaled whenNotPaused {
    require(_numberMinted(msg.sender) + _amount <= 4, "Can only mint 4 tokens at address");
    require(_totalMinted() + _amount <= MAX_TOKEN_COUNT, "Exceeds maximum supply");

    if (_numberMinted(msg.sender) == 0)
        require(msg.value >= PRICE * (_amount-1), "Ether value sent is not correct");
    else
        require(msg.value >= PRICE * _amount, "Ether value sent is not correct");

    _safeMint(msg.sender, _amount);
  }

  function presaleMint(uint256 _amount, bytes32[] calldata _merkleProof) public payable whenPresaled whenNotPaused {        
    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not whitelisted not allowed mint for presale, Invalid proof!");
    require(isPresaleMinted[msg.sender] == false, "Already mint for presale");
    require(_numberMinted(msg.sender) + _amount <= 4, "Can only mint 4 tokens at address");
    require(_totalMinted() + _amount <= MAX_TOKEN_COUNT, "Exceeds maximum supply");
    require( msg.value >= PRESALE_PRICE * (_amount-1), "Ether value sent is not correct");

    _safeMint(msg.sender, _amount);
    isPresaleMinted[msg.sender] = true;
  }

  function deployerMint(uint256 _amount) public onlyOwner {        
    _safeMint(msg.sender, _amount);
  }

  function isProofed(bytes32[] calldata _merkleProof) public view returns (bool) {
    bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
    return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
  }

  function burnUnlucky(uint256[] memory _tokenIds) public onlyOwner whenNotPaused {
    for(uint256 i = 0; i < _tokenIds.length; i++) {
      _burn(_tokenIds[i]);
    }
  }

  function _baseURI() internal view virtual override returns (string memory) {
    return baseTokenURI;
  }

  function setBaseURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
  }

  function withdraw() external onlyOwner nonReentrant {
    uint256 _balance = address(this).balance / 100;

    require(payable(t1).send(_balance * 80));
    require(payable(t2).send(_balance * 20));
  }

  function pause() public onlyOwner {
    _pause();
  }

  function unpause() public onlyOwner {
    _unpause();
  }

  function presale() public onlyOwner {
    _presale();
  }

  function unpresale() public onlyOwner {
    _unpresale();
  }

  function _startTokenId() internal view virtual override returns (uint256) {
    return 1;
  }

  function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
    require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');

    if (isRevealed == false) {
      return hiddenTokenUri;
    }

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _toString(_tokenId))):'';
  }
}