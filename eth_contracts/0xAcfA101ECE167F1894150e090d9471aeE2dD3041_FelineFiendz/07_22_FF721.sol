// SPDX-License-Identifier: BSD-3-Clause

pragma solidity ^0.8.0;

/****************************************
 * @author: squeebo_nft                 *
 ****************************************
 *   Blimpie-FF721 provides low-gas    *
 *       mints + transfers              *
 ****************************************/

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";


abstract contract FF721 is Context, ERC165, IERC721, IERC721Metadata {
  using Address for address;

  struct Owner{
    uint16 balance;
    uint16 purchased;
  }

  struct Token{
    address owner;
  }

  Token[] public tokens;
  mapping(address => Owner) public owners;

  string private _name;
  string private _symbol;

  mapping(uint => address) internal _tokenApprovals;
  mapping(address => mapping(address => bool)) private _operatorApprovals;

  constructor(string memory name_, string memory symbol_){
    _name = name_;
    _symbol = symbol_;
  }

  //public view
  function balanceOf(address owner) public view override returns (uint balance){
    return owners[owner].balance;
  }

  function name() external view override returns( string memory name_ ){
    return _name;
  }

  function ownerOf(uint tokenId) public view override returns( address owner ){
    require(_exists(tokenId), "FF721: query for nonexistent token");
    return tokens[tokenId].owner;
  }

  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns( bool isSupported ){
    return
      interfaceId == type(IERC721).interfaceId ||
      interfaceId == type(IERC721Metadata).interfaceId ||
      super.supportsInterface(interfaceId);
  }

  function symbol() external view override returns( string memory symbol_ ){
    return _symbol;
  }


  //approvals
  function approve(address to, uint tokenId) external override {
    address owner = ownerOf(tokenId);
    require(to != owner, "FF721: approval to current owner");

    require(
      _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
      "FF721: caller is not owner nor approved for all"
    );

    _approve(to, tokenId);
  }

  function getApproved(uint tokenId) public view override returns( address approver ){
    require(_exists(tokenId), "FF721: query for nonexistent token");
    return _tokenApprovals[tokenId];
  }

  function isApprovedForAll(address owner, address operator) public view override returns( bool isApproved ){
    return _operatorApprovals[owner][operator];
  }

  function setApprovalForAll(address operator, bool approved) external override {
    _operatorApprovals[_msgSender()][operator] = approved;
    emit ApprovalForAll(_msgSender(), operator, approved);
  }


  //transfers
  function safeTransferFrom(address from, address to, uint tokenId) external override{
    safeTransferFrom(from, to, tokenId, "");
  }

  function safeTransferFrom(address from, address to, uint tokenId, bytes memory _data) public override {
    require(_isApprovedOrOwner(_msgSender(), tokenId), "FF721: caller is not owner nor approved");
    _safeTransfer(from, to, tokenId, _data);
  }

  function transferFrom(address from, address to, uint tokenId) external override {
    require(_isApprovedOrOwner(_msgSender(), tokenId), "FF721: caller is not owner nor approved");
    _transfer(from, to, tokenId);
  }


  //internal
  function _approve(address to, uint tokenId) internal{
    _tokenApprovals[tokenId] = to;
    emit Approval(ownerOf(tokenId), to, tokenId);
  }

  function _beforeTokenTransfer(address from, address to) internal virtual {
    if( from != address(0) )
      --owners[from].balance;

    if( to != address(0) )
      ++owners[to].balance;
  }

  function _checkOnERC721Received(address from, address to, uint tokenId, bytes memory _data)private returns ( bool ){
    if (to.isContract()) {
      try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
        return retval == IERC721Receiver.onERC721Received.selector;
      } catch (bytes memory reason) {
        if (reason.length == 0) {
          revert("FF721: transfer to non ERC721Receiver implementer");
        } else {
          assembly {
            revert(add(32, reason), mload(reason))
          }
        }
      }
    } else {
      return true;
    }
  }

  function _exists(uint tokenId) internal view returns ( bool ){
    return tokenId < tokens.length && tokens[tokenId].owner != address(0);
  }

  function _isApprovedOrOwner(address spender, uint tokenId) internal view returns( bool ){
    require(_exists(tokenId), "FF721: query for nonexistent token");
    address owner = ownerOf(tokenId);
    return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
  }

  function _safeTransfer(address from, address to, uint tokenId, bytes memory _data) internal{
    _transfer(from, to, tokenId);
    require(_checkOnERC721Received(from, to, tokenId, _data), "FF721: transfer to non ERC721Receiver implementer");
  }

  function _transfer(address from, address to, uint tokenId) internal {
    require(ownerOf(tokenId) == from, "FF721: transfer of token that is not own");
    _beforeTokenTransfer(from, to);
    _approve(address(0), tokenId);
    tokens[tokenId].owner = to;

    emit Transfer(from, to, tokenId);
  }
}