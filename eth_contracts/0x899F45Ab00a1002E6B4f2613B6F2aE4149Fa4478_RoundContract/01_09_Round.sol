//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "./interfaces/IMaster.sol";

/// @title NFT minter
/// @notice The contract allows you to mint new NFT as well as change the parameters of the collection
contract                      RoundContract is AccessControl {
  using Address for address payable;

  address public constant            OWNER_ADDRESS = 0x0867436a889bf9C1abCAf3c505046FC4F7880b50;
  address public constant            WITHDRAW_ADDRESS = 0xf867C48da1Aa3268FEBCff36a6879066dd8EB304;
  address public constant            PROVIDER_WALLET_ADDRESS = 0x706EbB592Ea9D75E7981B7944aA1de28d30D6C14;
  address public                     DEV_ADDRESS;

  uint256 private constant           ORACLE_FEE = 0.015 ether;

  /// @notice main round information
  struct                             RoundInfo {
    uint256                          mintPrice;
    uint256                          endTimestamp;
    uint16                           collPadding;
    uint16                           maxSupply;
    uint16                           roundSupply;
    uint16                           maxPurchase;
    string                           roundName;
  }
  RoundInfo public                   info;

  IMaster masterContract;

  mapping(address => uint) public    userPurchasedNum;

  event                              Withdrawn(address recipient);

  modifier mintPossible(uint nTokens) {
    require(userPurchasedNum[msg.sender] + nTokens <= info.maxPurchase, "Round: too many tokens to mint");
    require(address(PROVIDER_WALLET_ADDRESS).balance >= ORACLE_FEE, "Round: Provider the wallet has insufficient funds");

    _;
  }

  constructor(
    uint256                          _mintPrice,
    uint256                          _endTimestamp,
    uint16                           _reserved,
    uint16                           _collPadding,
    uint16                           _maxSupply,
    uint16                           _maxPurchase,
    string memory                    _roundName
    ) {
      info.mintPrice = _mintPrice;
      info.collPadding = _collPadding;
      info.maxSupply = _maxSupply;
      info.endTimestamp = _endTimestamp;
      info.maxPurchase = _maxPurchase;
      info.roundName = _roundName;
      info.roundSupply = (info.maxSupply - info.collPadding) - _reserved;
      DEV_ADDRESS = msg.sender;

      _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
      _grantRole(DEFAULT_ADMIN_ROLE, OWNER_ADDRESS);
  }

  function setPrice(uint256 _price) external onlyRole(DEFAULT_ADMIN_ROLE) {
    info.mintPrice = _price;
  }

  function setSupply(uint16 _supply) external onlyRole(DEFAULT_ADMIN_ROLE) {
    info.roundSupply = _supply;
  }

  function setFinish(uint256 _finish) external onlyRole(DEFAULT_ADMIN_ROLE) {
    info.endTimestamp = _finish;
  }

  function setMaxPurch(uint16 _purch) external onlyRole(DEFAULT_ADMIN_ROLE) {
    info.maxPurchase = _purch;
  }

  /// @notice                         function for revoke admin role for developers
  function                            revokeDevPermissions() external onlyRole(DEFAULT_ADMIN_ROLE) {
    _revokeRole(DEFAULT_ADMIN_ROLE, DEV_ADDRESS);
  }

  /// @notice                         mint price of current round
  function                            mintPrice() external view returns(uint) {
    return info.mintPrice;
  }

  /// @notice                         get round total supply of not minted tokens
  function                            roundTotalSupply() external view returns(uint) {
    return info.roundSupply;
  }

  /// @notice                         set master contract for round
  function                            setMaster(address _master) external onlyRole(DEFAULT_ADMIN_ROLE) {
    masterContract = IMaster(_master);
  }

  /// @notice                         user can get master contract address
  /// @return                         address of master contract
  function                            getMaster() public view returns(address) {
    return address(masterContract);
  }

  /// @notice                         create psudo-random number to get index
  /// @param                          i - nonce
  /// @param                          from - salt
  /// @return                         uint - new psudo-random value
  function                            _random(uint i, address from) private view returns(uint) {
    uint randomnumber = uint(keccak256(abi.encodePacked(block.timestamp, from, i))) % (info.maxSupply - info.collPadding);
    randomnumber = randomnumber + info.collPadding;
    return randomnumber + 1;
  }

  /// @notice                         Use for check the content of the element in the array
  /// @dev                            using for generate array of random unique number
  /// @param                          array of uints
  /// @param                          value target value
  function                            _contain(uint[] memory array, uint value) pure private returns(bool) {
    bool contained = false;
    for (uint256 i = 0; i < array.length; i++) {
      if (array[i] == value) {
        contained = true;
        break;
      }
    }
    return contained;
  }

  /// @notice                         Withdrawn funds to treasury
  function                            withdrawn() external onlyRole(DEFAULT_ADMIN_ROLE) {
    payable(WITHDRAW_ADDRESS).sendValue(address(this).balance);
    emit Withdrawn(WITHDRAW_ADDRESS);
  }

  /// @notice                         function for call paid mind for users in original white list
  /// @dev                            check if user in original(non payable) white list
  /// @dev                            check if user's sended funds enough for mint n times
  /// @param                          nTokens is number of tokens for mint
  function                            paidMint(uint nTokens) public payable mintPossible(nTokens) {
    require(block.timestamp <= info.endTimestamp, "Round already finished!");
    require(msg.value >= info.mintPrice * nTokens, "NFT round: Not enough funds");
    _mintTokens(nTokens);
  }

  /// @notice Create random number
  /// @dev the function accesses an external master contract and asks if the generated id is busy
  /// @dev max attemps - 250
  /// @param nTokens => attempt
  function _mintTokens(uint nTokens) private {
    uint[]  memory idxs = new uint[](nTokens);
    uint16  n = 0;
    uint    i = 0;

    while(_contain(idxs, 0)) {
      uint idx = _random(i, msg.sender);
      if (!masterContract.idOccuped(idx) && !_contain(idxs, idx)) {
        idxs[i] = idx;
        i++;
      }
      else {
        n++;
      }
      if (n == 250) {
        payable(msg.sender).sendValue(msg.value);
        revert("NFT: The required number of tokens was not found, try again");
      }
    }
    payable(PROVIDER_WALLET_ADDRESS).sendValue(ORACLE_FEE);
    userPurchasedNum[msg.sender] += nTokens;
    info.roundSupply -= uint16(nTokens);
    masterContract.mint(idxs, msg.sender, info.roundName);
  }
}