// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// @author: olive
// @co-author: Gurtej

/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//         @@@@@@@@@                    @@@@@                      @@@@@@             ///
//         @@     @@@                 @@     @@                  @@      @@           ///
//         @@      @@                @@       @@               @@         @@          ///
//         @@     @@@               @@         @@             @@                      ///
//         @@@@@@@@@                @@         @@             @@    @@@@@@@@@         ///
//         @@     @@@               @@         @@              @@       @@            ///
//         @@      @@                @@       @@                @@      @@            ///
//         @@     @@@                 @@     @@                   @@@@  @@            ///
//         @@@@@@@@                     @@@@@                           @@            ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
//                                                                                    ///
/////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

contract BOG is ERC721Enumerable, Ownable {
    using SafeMath for uint256;
    using Counters for Counters.Counter;
    using Strings for uint256;

    uint256 public constant MAX_ELEMENTS = 10000;
    uint256 public PRICE = 0.07 ether;
    uint256 public constant START_AT = 1;

    bool private PAUSE = true;

    Counters.Counter private _tokenIdTracker;

    string public baseTokenURI;

    bool public META_REVEAL = false;
    uint256 public HIDE_FROM = 1;
    uint256 public HIDE_TO = 10000;
    string public sampleTokenURI;

    address public constant creator1Address = 0x2F5C4Ca63835D877Aa3a570B3F68D8c05353774E;
    address public constant creator2Address = 0xDbe24D356c5fBAa4F18C37f6610C565E50D6C195;
    address public constant creator3Address = 0x3a372F725A97b968a839E3d49a0D7320f52BE0e2;

    event PauseEvent(bool pause);
    event welcomeToBOG(uint256 indexed id);
    event NewPriceEvent(uint256 price);

    constructor(string memory baseURI) ERC721("Babies of Gods", "BOG"){
        setBaseURI(baseURI);
    }

    modifier saleIsOpen {
        require(totalToken() <= MAX_ELEMENTS, "Soldout!");
        require(!PAUSE, "Sales not open");
        _;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory baseURI) public onlyOwner {
        baseTokenURI = baseURI;
    }

    function setSampleURI(string memory sampleURI) public onlyOwner {
        sampleTokenURI = sampleURI;
    }

    function totalToken() public view returns (uint256) {
        return _tokenIdTracker.current();
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        if(!META_REVEAL && tokenId >= HIDE_FROM && tokenId <= HIDE_TO) 
            return sampleTokenURI;
        
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function mint(uint256 _tokenAmount, uint256 _timestamp, bytes memory _signature) public payable saleIsOpen {

        uint256 total = totalToken();
        require(_tokenAmount <= 3, "Max limit");
        require(total + _tokenAmount <= MAX_ELEMENTS, "Max limit");
        require(msg.value >= price(_tokenAmount), "Value below price");

        address wallet = _msgSender();

        address signerOwner = signatureWallet(wallet,_tokenAmount,_timestamp,_signature);
        require(signerOwner == owner(), "Not authorized to mint");

        require(block.timestamp >= _timestamp - 30, "Out of time");

        for(uint8 i = 1; i <= _tokenAmount; i++){
            _mintAnElement(wallet, total + i);
        }

    }

    function signatureWallet(address wallet, uint256 _tokenAmount, uint256 _timestamp, bytes memory _signature) public pure returns (address){

        return ECDSA.recover(keccak256(abi.encode(wallet, _tokenAmount, _timestamp)), _signature);

    }

    function _mintAnElement(address _to, uint256 _tokenId) private {

        _tokenIdTracker.increment();
        _safeMint(_to, _tokenId);

        emit welcomeToBOG(_tokenId);
    }

    function price(uint256 _count) public view returns (uint256) {
        return PRICE.mul(_count);
    }

    function walletOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);

        uint256[] memory tokensId = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensId[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensId;
    }

    function setPause(bool _pause) public onlyOwner{
        PAUSE = _pause;
        emit PauseEvent(PAUSE);
    }

    function setPrice(uint256 _price) public onlyOwner{
        PRICE = _price;
        emit NewPriceEvent(PRICE);
    }


    function setMetaReveal(bool _reveal, uint256 _from, uint256 _to) public onlyOwner{
        META_REVEAL = _reveal;
        HIDE_FROM = _from;
        HIDE_TO = _to;
    }

    function withdrawAll() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(creator1Address, balance.mul(15).div(100));
        _widthdraw(creator2Address, balance.mul(15).div(100));
        _widthdraw(creator3Address, address(this).balance);
    }

    function _widthdraw(address _address, uint256 _amount) private {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    function giftMint(address[] memory _addrs, uint[] memory _tokenAmounts) public onlyOwner {
        uint totalQuantity = 0;
        uint256 total = totalToken();
        for(uint i = 0; i < _addrs.length; i ++) {
            totalQuantity += _tokenAmounts[i];
        }
        require( total + totalQuantity <= MAX_ELEMENTS, "Max limit" );
        for(uint i = 0; i < _addrs.length; i ++){
            for(uint j = 0; j < _tokenAmounts[i]; j ++){
                total ++;
                _mintAnElement(_addrs[i], total);
            }
        }
    }

    function mintUnsoldTokens(uint256[] memory _tokensId) public onlyOwner {

        require(PAUSE, "Pause is disable");

        for (uint256 i = 0; i < _tokensId.length; i++) {
            if(rawOwnerOf(_tokensId[i]) == address(0)){
                _mintAnElement(owner(), _tokensId[i]);
            }
        }
    }
}