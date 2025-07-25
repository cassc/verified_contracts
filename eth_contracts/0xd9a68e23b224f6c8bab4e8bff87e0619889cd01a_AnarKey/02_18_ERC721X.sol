// SPDX-License-Identifier: MIT
// ERC721A Contracts v3.3.0
// Creator: Chiru Labs

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
 *
 * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
 *
 * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
 *
 * Does not support burning tokens to address(0).
 */
contract ERC721X is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    struct TokenOwnership {
        address addr;
        uint64 startTimestamp;
    }

    struct AddressData {
        uint64 balance;
        uint64 numberMinted;
    }

    uint256 private currentIndex = 0;
    uint256 private burnedIndex = 0;

    uint256 internal collectionSize;
    uint256 internal maxBatchSize;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to ownership details
    // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
    mapping(uint256 => TokenOwnership) private _ownerships;

    // Mapping owner address to address data
    mapping(address => AddressData) private _addressData;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
    * @dev
    * `maxBatchSize` refers to how much a minter can mint at a time.
    * `collectionSize_` refers to how many tokens are in the collection.
    */
    constructor(
        string memory name_,
        string memory symbol_,
        uint256 maxBatchSize_,
        uint256 collectionSize_
    ) {
        require(collectionSize_ > 0, "ERC721X: collection must have a nonzero supply");
        require(maxBatchSize_ > 0, "ERC721X: max batch size must be nonzero");
        _name = name_;
        _symbol = symbol_;
        maxBatchSize = maxBatchSize_;
        collectionSize = collectionSize_;
    }

    /**
    * @dev See Remove store data in IERC721Enumerable {IERC721Enumerable-totalSupply}.
    */
    function totalSupply() public view returns (uint256) {
        return currentIndex - burnedIndex;
    }

    /**
    * @dev See Remove store data in IERC721Enumerable {IERC721Enumerable-totalSupply}.
    */
    function setCollectionSize(uint256 _collectionSize) internal {
         collectionSize = _collectionSize;
    }

    /**
    * @dev See {IERC165-supportsInterface}.
    */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }

    /**
    * @dev See {IERC721-balanceOf}.
    */
    function balanceOf(address owner) public view override returns (uint256) {
        require(owner != address(0), "ERC721X: balance query for the zero address");
        return uint256(_addressData[owner].balance);
    }

    function _numberMinted(address owner) internal view returns (uint256) {
        require(owner != address(0), "ERC721X: number minted query for the zero address");
        return uint256(_addressData[owner].numberMinted);
    }

    function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
        require(_exists(tokenId), "ERC721X: owner query for nonexistent token");
        uint256 lowestTokenToCheck;
        if (tokenId >= maxBatchSize) {
            lowestTokenToCheck = tokenId - maxBatchSize + 1;
        }

        for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
            TokenOwnership memory ownership = _ownerships[curr];
            if (ownership.addr != address(0)) {
                return ownership;
            }
        }
        revert("ERC721X: unable to determine the owner of token");
    }

    /**
    * @dev See {IERC721-ownerOf}.
    */
    function ownerOf(uint256 tokenId) public view override returns (address) {
        return ownershipOf(tokenId).addr;
    }

    /**
    * @dev See {IERC721Metadata-name}.
    */
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    /**
    * @dev See {IERC721Metadata-symbol}.
    */
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    /**
    * @dev See {IERC721Metadata-tokenURI}.
    */
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")): "";
    }

    /**
    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
    * by default, can be overriden in child contracts.
    */
    function _baseURI() internal view virtual returns (string memory) {
        return "";
    }

    /**
    * @dev See {IERC721-approve}.
    */
    function approve(address to, uint256 tokenId) public override {
        address owner = ERC721X.ownerOf(tokenId);
        require(to != owner, "ERC721X: approval to current owner");
        require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),"ERC721X: approve caller is not owner nor approved for all");
        _approve(to, tokenId, owner);
    }

    /**
    * @dev See {IERC721-getApproved}.
    */
    function getApproved(uint256 tokenId) public view override returns (address) {
        require(_exists(tokenId), "ERC721X: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
    * @dev See {IERC721-setApprovalForAll}.
    */
    function setApprovalForAll(address operator, bool approved) public override {
        require(operator != _msgSender(), "ERC721X: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
    * @dev See {IERC721-isApprovedForAll}.
    */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool){
        return _operatorApprovals[owner][operator];
    }

    /**
    * @dev See {IERC721-transferFrom}.
    */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        _transfer(from, to, tokenId);
    }

    /**
    * @dev See {IERC721-safeTransferFrom}.
    */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public override {
        safeTransferFrom(from, to, tokenId, "");
    }

    /**
    * @dev See {IERC721-safeTransferFrom}.
    */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) public override {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721X: transfer to non ERC721Receiver implementer");
    }

    /**
    * @dev Returns whether `tokenId` exists.
    *
    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
    *
    * Tokens start existing when they are minted (`_mint`),
    */
    function _exists(uint256 tokenId) internal view returns (bool) {
        return tokenId < currentIndex;
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721X: operator query for nonexistent token");
        TokenOwnership memory prevOwnership = ownershipOf(tokenId);
        return(spender == prevOwnership.addr || getApproved(tokenId) == spender || isApprovedForAll(prevOwnership.addr, spender));
        //return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function _safeMint(address to, uint256 quantity) internal {
        _safeMint(to, quantity, "");
    }

    /**
    * @dev Mints `quantity` tokens and transfers them to `to`.
    *
    * Requirements:
    *
    * - there must be `quantity` tokens remaining unminted in the total collection.
    * - `to` cannot be the zero address.
    * - `quantity` cannot be larger than the max batch size.
    *
    * Emits a {Transfer} event.
    */
    function _safeMint(
        address to,
        uint256 quantity,
        bytes memory _data
    ) internal {
        uint256 startTokenId = currentIndex;
        require(to != address(0), "ERC721X: mint to the zero address");
        require(!_exists(startTokenId), "ERC721X: token already minted");
        require(quantity <= maxBatchSize, "ERC721X: quantity to mint over than max batch size");

        _beforeTokenTransfers(address(0), to, startTokenId, quantity);

        unchecked {
            _addressData[to].balance += uint64(quantity);
            _addressData[to].numberMinted += uint64(quantity);

            _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));

            uint256 updatedIndex = startTokenId;

            for (uint256 i = 0; i < quantity; i++) {
                updatedIndex++;
                emit Transfer(address(0), to, updatedIndex);
                require(_checkOnERC721Received(address(0), to, updatedIndex, _data), "ERC721X: transfer to non ERC721Receiver implementer");         
            }
            currentIndex = updatedIndex;
            _afterTokenTransfers(address(0), to, startTokenId, quantity);
        }
    }

    /**
    * @dev burn function Transfers `tokenId` from `from` to `unused address`.
    *
    * Requirements:
    *
    * - `to` cannot be the zero address and fix to unused address.
    * - `tokenId` token must be owned by `from`.
    *
    * Emits a {Transfer} event.
    */

    function _burn(
        address from,
        uint256 tokenId
        ) internal virtual {
        address to = 0x000000000000000000000000000000000000dEaD;
        TokenOwnership memory prevOwnership = ownershipOf(tokenId);

        //bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
        //getApproved(tokenId) == _msgSender() ||
        //isApprovedForAll(prevOwnership.addr, _msgSender()));

        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721X: burn caller is not owner nor approved");
        require(prevOwnership.addr == from, "ERC721X: burn from incorrect owner");

        _beforeTokenTransfers(from, to, tokenId, 1);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId, prevOwnership.addr);

        _addressData[from].balance -= 1;
        _addressData[to].balance += 1;
        _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));

        // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
        // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
        uint256 nextTokenId = tokenId + 1;
        if (_ownerships[nextTokenId].addr == address(0)) {
            if (_exists(nextTokenId)) {
                _ownerships[nextTokenId] = TokenOwnership(
                prevOwnership.addr,
                prevOwnership.startTimestamp
                );
            }
        }
        emit Transfer(from, to, tokenId);
        burnedIndex++;
        _afterTokenTransfers(from, to, tokenId, 1);
    }

    /**
    * @dev Transfers `tokenId` from `from` to `to`.
    *
    * Requirements:
    *
    * - `to` cannot be the zero address.
    * - `tokenId` token must be owned by `from`.
    *
    * Emits a {Transfer} event.
    */
    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {
        TokenOwnership memory prevOwnership = ownershipOf(tokenId);

        //bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
        //getApproved(tokenId) == _msgSender() ||
        //isApprovedForAll(prevOwnership.addr, _msgSender()));

        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721X: transfer caller is not owner nor approved");
        require(prevOwnership.addr == from, "ERC721X: transfer from incorrect owner");
        require(to != address(0), "ERC721X: transfer to the zero address");

        _beforeTokenTransfers(from, to, tokenId, 1);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId, prevOwnership.addr);

        _addressData[from].balance -= 1;
        _addressData[to].balance += 1;
        _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));

        // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
        // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
        uint256 nextTokenId = tokenId + 1;
        if (_ownerships[nextTokenId].addr == address(0)) {
            if (_exists(nextTokenId)) {
                _ownerships[nextTokenId] = TokenOwnership(
                prevOwnership.addr,
                prevOwnership.startTimestamp
                );
            }
        }

        emit Transfer(from, to, tokenId);
        _afterTokenTransfers(from, to, tokenId, 1);
    }

    /**
    * @dev Approve `to` to operate on `tokenId`
    *
    * Emits a {Approval} event.
    */
    function _approve(
        address to,
        uint256 tokenId,
        address owner
    ) private {
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    uint256 public nextOwnerToExplicitlySet = 0;

    /**
    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
    */
    function _setOwnersExplicit(uint256 quantity) internal {
        uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
        require(quantity > 0, "quantity must be nonzero");
        uint256 endIndex = oldNextOwnerToSet + quantity - 1;
        if (endIndex > collectionSize - 1) {
            endIndex = collectionSize - 1;
        }
        // We know if the last one in the group exists, all in the group exist, due to serial ordering.
        require(_exists(endIndex), "not enough minted yet for this cleanup");
        for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
            if (_ownerships[i].addr == address(0)) {
                TokenOwnership memory ownership = ownershipOf(i);
                _ownerships[i] = TokenOwnership(
                ownership.addr,
                ownership.startTimestamp
                );
            }
        }
        nextOwnerToExplicitlySet = endIndex + 1;
    }

    /**
    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
    * The call is not executed if the target address is not a contract.
    *
    * @param from address representing the previous owner of the given token ID
    * @param to target address that will receive the tokens
    * @param tokenId uint256 ID of the token to be transferred
    * @param _data bytes optional data to send along with the call
    * @return bool whether the call correctly returned the expected magic value
    */
    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
            returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721X: transfer to non ERC721Receiver implementer");
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

    /**
    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
    *
    * startTokenId - the first token id to be transferred
    * quantity - the amount to be transferred
    *
    * Calling conditions:
    *
    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
    * transferred to `to`.
    * - When `from` is zero, `tokenId` will be minted for `to`.
    */
    function _beforeTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual {}

    /**
    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
    * minting.
    *
    * startTokenId - the first token id to be transferred
    * quantity - the amount to be transferred
    *
    * Calling conditions:
    *
    * - when `from` and `to` are both non-zero.
    * - `from` and `to` are never both zero.
    */
    function _afterTokenTransfers(
        address from,
        address to,
        uint256 startTokenId,
        uint256 quantity
    ) internal virtual {}
}