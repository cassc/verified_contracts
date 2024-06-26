// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";


contract Wifus is ERC721A, ReentrancyGuard, Ownable {
    bytes32 public merkleRoot;
    string public _metadataURI = "";
    mapping(address => uint256) public mintedAmount;


    constructor(string memory _customBaseURI)
	ERC721A( "Wifus Academy", "WifusA" ){
	    customBaseURI = _customBaseURI;
    }


    uint256 public constant MAX_SUPPLY = 555;


    uint256 public MAX_MULTIMINT = 3;
    function setMAX_MULTIMINT(uint256 _count) external onlyOwner {
	MAX_MULTIMINT = _count;
    }
    uint256 public LIMIT_PER_WALLET = 3;
    function setLIMIT_PER_WALLET(uint256 _count) external onlyOwner {
	LIMIT_PER_WALLET = _count;
    }

    uint256 public PRICE = 15000000000000000;
    function setPRICE(uint256 _price) external onlyOwner {
	PRICE = _price;
    }


    function godMint(address _to, uint256 _count) external onlyOwner {
	require( totalSupply() + _count <= MAX_SUPPLY, "Exceeds max supply" );
	uint256 _mintedAmount = mintedAmount[_to];
	_mint( _to, _count );
	mintedAmount[_to] = _mintedAmount + _count;
    }
    function alphaMint(address[] calldata _to, uint256 _count) external onlyOwner payable {
	require( totalSupply() + ( _count * _to.length ) <= MAX_SUPPLY, "Exceeds max supply" );
	require( msg.value >= PRICE * _count * _to.length, "Insufficient payment"  );
	for (uint256 i = 0; i < _to.length; i++) {
	    uint256 _mintedAmount = mintedAmount[_to[i]];
	    _mint( _to[i], _count );
	    mintedAmount[_to[i]] = _mintedAmount + _count;
	}
    }


    function setRoot(bytes32 _root) external onlyOwner {
	merkleRoot = _root;
    }
    function isValid(bytes32[] memory proof) public view returns (bool) {
	bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
	return MerkleProof.verify(proof, merkleRoot, leaf);
    }


    function mintAL(uint256 _count, bytes32[] memory _proof) public payable nonReentrant {
	bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
	require(MerkleProof.verify(_proof, merkleRoot, leaf), "Invalid proof!");

	require( saleALIsActive, "AL Sale not active" );
	require( msg.value >= PRICE * _count, "Insufficient payment"  );
	require( _count > 0, "0 tokens to mint" );
	require( totalSupply() + _count <= MAX_SUPPLY, "Exceeds max supply" );
	require( _count <= MAX_MULTIMINT, "Exceeds max mints per transaction" );
	uint256 _mintedAmount = mintedAmount[msg.sender];
	require( _mintedAmount + _count <= LIMIT_PER_WALLET, "Exceeds max mints per wallet" );
	_mint(msg.sender, _count);
	mintedAmount[msg.sender] = _mintedAmount + _count;
    }


    function mint(uint256 _count) public payable nonReentrant {
	require( saleIsActive, "Sale not active" );
	require( msg.value >= PRICE * _count, "Insufficient payment"  );
	require( _count > 0, "0 tokens to mint" );
	require( totalSupply() + _count <= MAX_SUPPLY, "Exceeds max supply" );
	require( _count <= MAX_MULTIMINT, "Exceeds max mints per transaction" );
	uint256 _mintedAmount = mintedAmount[msg.sender];
	require( _mintedAmount + _count <= LIMIT_PER_WALLET, "Exceeds max mints per wallet" );
	_mint(msg.sender, _count);
	mintedAmount[msg.sender] = _mintedAmount + _count;
    }


    bool public saleIsActive = false;
    function setSaleIsActive(bool _sale) external onlyOwner {
	saleIsActive = _sale;
    }
    bool public saleALIsActive = false;
    function setSaleALIsActive(bool _sale) external onlyOwner {
	saleALIsActive = _sale;
    }


    string private customBaseURI;
    function setBaseURI(string memory _URI) external onlyOwner {
	customBaseURI = _URI;
    }
    function _baseURI() internal view virtual override returns (string memory) {
	return customBaseURI;
    }


    function setMetadataURI(string memory _URI) external onlyOwner {
	_metadataURI = _URI;
    }


    function _withdraw(address _address, uint256 _amount) private {
	(bool success, ) = _address.call{value: _amount}("");
	require(success, "Transfer failed.");
    }
    function withdraw() public nonReentrant onlyOwner {
	uint256 balance = address(this).balance;
	Address.sendValue(payable(owner()), balance);
    }


    modifier isHuman() {
	address _addr = msg.sender;
	uint256 _codeLength;
	assembly {_codeLength := extcodesize(_addr)}
	require(_codeLength == 0, "sorry humans only");
	_;
    }


}