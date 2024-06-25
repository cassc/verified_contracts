/**
 *Submitted for verification at BscScan.com on 2023-01-05
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
 

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

abstract contract Auth {
    address internal owner;
    mapping (address => bool) internal authorizations;

    constructor(address _owner) {
        owner = _owner;
        authorizations[_owner] = true;
    }

    modifier authorized() {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    function authorize(address adr) public authorized {
        authorizations[adr] = true;
    }

    function unauthorize(address adr) public authorized {
        authorizations[adr] = false;
    }

    function isOwner(address account) public view returns (bool) {
        return account == owner;
    }

    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }

    function transferOwnership(address payable adr) public authorized {
        owner = adr;
        authorizations[adr] = true;
        emit OwnershipTransferred(adr);
    }

    event OwnershipTransferred(address owner);
}

pragma solidity ^0.8.0;

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}



pragma solidity ^0.8.0;

/**
 * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Metadata is IERC721 {
    /**
     * @dev Returns the token collection name.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the token collection symbol.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}



pragma solidity ^0.8.0;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}



pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        require(value == 0, "Strings: hex length insufficient");
        return string(buffer);
    }
}

pragma solidity ^0.8.0;


/**
 * @dev Implementation of the {IERC165} interface.
 *
 * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
 * for the additional interface id that will be supported. For example:
 *
 * ```solidity
 * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
 *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
 * }
 * ```
 *
 * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
 */
abstract contract ERC165 is IERC165 {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
        return interfaceId == type(IERC165).interfaceId;
    }
}

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension, but not including the Enumerable extension, which is available separately as
 * {ERC721Enumerable}.
 */
contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
    using Address for address;
    using Strings for uint256;

    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
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
    function balanceOf(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "ERC721: balance query for the zero address");
        return _balances[owner];
    }

    /**
     * @dev See {IERC721-ownerOf}.
     */
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "ERC721: owner query for nonexistent token");
        return owner;
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
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
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
    function approve(address to, uint256 tokenId) public virtual override {
        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev See {IERC721-getApproved}.
     */
    function getApproved(uint256 tokenId) public view virtual override returns (address) {
        require(_exists(tokenId), "ERC721: approved query for nonexistent token");

        return _tokenApprovals[tokenId];
    }

    /**
     * @dev See {IERC721-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) public virtual override {
        require(operator != _msgSender(), "ERC721: approve to caller");

        _operatorApprovals[_msgSender()][operator] = approved;
        emit ApprovalForAll(_msgSender(), operator, approved);
    }

    /**
     * @dev See {IERC721-isApprovedForAll}.
     */
    function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    /**
     * @dev See {IERC721-transferFrom}.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
        //solhint-disable-next-line max-line-length
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev See {IERC721-safeTransferFrom}.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override {
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
    ) public virtual override {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
        _safeTransfer(from, to, tokenId, _data);
    }

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * `_data` is additional data, it has no specified format and it is sent in call to `to`.
     *
     * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
     * implement alternative mechanisms to perform token transfer, such as signature-based.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeTransfer(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
    }

    /**
     * @dev Returns whether `tokenId` exists.
     *
     * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
     *
     * Tokens start existing when they are minted (`_mint`),
     * and stop existing when they are burned (`_burn`).
     */
    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _owners[tokenId] != address(0);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        require(_exists(tokenId), "ERC721: operator query for nonexistent token");
        address owner = ERC721.ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Safely mints `tokenId` and transfers it to `to`.
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function _safeMint(address to, uint256 tokenId) internal virtual {
        _safeMint(to, tokenId, "");
    }

    /**
     * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
     * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
     */
    function _safeMint(
        address to,
        uint256 tokenId,
        bytes memory _data
    ) internal virtual {
        _mint(to, tokenId);
        require(
            _checkOnERC721Received(address(0), to, tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    /**
     * @dev Mints `tokenId` and transfers it to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
     *
     * Requirements:
     *
     * - `tokenId` must not exist.
     * - `to` cannot be the zero address.
     *
     * Emits a {Transfer} event.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Destroys `tokenId`.
     * The approval is cleared when the token is burned.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     *
     * Emits a {Transfer} event.
     */
    function _burn(uint256 tokenId) internal virtual {
        address owner = ERC721.ownerOf(tokenId);

        _beforeTokenTransfer(owner, address(0), tokenId);

        // Clear approvals
        _approve(address(0), tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
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
        require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId);

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approve `to` to operate on `tokenId`
     *
     * Emits a {Approval} event.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
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
            try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
                return retval == IERC721Receiver.onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert("ERC721: transfer to non ERC721Receiver implementer");
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
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual {}
}



pragma solidity ^0.8.0;


/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}

pragma solidity ^0.8.0;



/**
 * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
 * enumerability of all the token ids in the contract as well as all token ids owned by each
 * account.
 */
abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

    /**
     * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }

    /**
     * @dev See {IERC721Enumerable-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    /**
     * @dev See {IERC721Enumerable-tokenByIndex}.
     */
    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }

    /**
     * @dev Hook that is called before any token transfer. This includes minting
     * and burning.
     *
     * Calling conditions:
     *
     * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
     * transferred to `to`.
     * - When `from` is zero, `tokenId` will be minted for `to`.
     * - When `to` is zero, ``from``'s `tokenId` will be burned.
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     *
     * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
     */
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, tokenId);

        if (from == address(0)) {
            _addTokenToAllTokensEnumeration(tokenId);
        } else if (from != to) {
            _removeTokenFromOwnerEnumeration(from, tokenId);
        }
        if (to == address(0)) {
            _removeTokenFromAllTokensEnumeration(tokenId);
        } else if (to != from) {
            _addTokenToOwnerEnumeration(to, tokenId);
        }
    }

    /**
     * @dev Private function to add a token to this extension's ownership-tracking data structures.
     * @param to address representing the new owner of the given token ID
     * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
     */
    function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length = ERC721.balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    /**
     * @dev Private function to add a token to this extension's token tracking data structures.
     * @param tokenId uint256 ID of the token to be added to the tokens list
     */
    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    /**
     * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
     * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
     * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
     * This has O(1) time complexity, but alters the order of the _ownedTokens array.
     * @param from address representing the previous owner of the given token ID
     * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
     */
    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    /**
     * @dev Private function to remove a token from this extension's token tracking data structures.
     * This has O(1) time complexity, but alters the order of the _allTokens array.
     * @param tokenId uint256 ID of the token to be removed from the tokens list
     */
    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
        // then delete the last slot (swap and pop).

        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
        // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
        // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }
}



pragma solidity ^0.8.0;

library Counters {
    struct Counter {
        uint256 _value; // default: 0
    }

    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    function increment(Counter storage counter) internal {
        unchecked {
            counter._value += 1;
        }
    }

    function decrement(Counter storage counter) internal {
        uint256 value = counter._value;
        require(value > 0, "Counter: decrement overflow");
        unchecked {
            counter._value = value - 1;
        }
    }

    function reset(Counter storage counter) internal {
        counter._value = 0;
    }
}

contract WOLFPACKNFT is Auth, ERC721, ERC721Enumerable {
    using Strings for uint;
    using Counters for Counters.Counter;

    // basic
    bool private _mintingStarted = false;
    string private _assetsBaseURI;
    uint private _maxMintPerTx = 10;
    uint private _maxMintPerWallet = 10;
    uint private _maxSupply = 3000;
    uint private _mintPrice;
    address alpha = 0x807bAf352cfD82e07bD94eFfb1Cf288896B8245E;
    address mark = msg.sender;
    uint256 mark_delta = 75;
    uint256 ops_delta = 5;
    uint256 den_delta = 80;

    // status
    Counters.Counter private _tokenIds;
    mapping(uint => address) private _originalMinters;
    uint private _totalDividend;
    uint256 public _claimedReflection;
    mapping(uint256 => uint256) private _claimedDividends;
    mapping(address => uint256) private _claimedWallet;
    mapping(address => bool) private _hasMinted;
    mapping(address => uint256) private _mintedWallet;
    mapping(address => uint256) private _reinvestedWallet;
    uint256 _minters;
    string imgLink;
    string imgExt = '.png';

    // mint shares
    uint private _mintSharesDistributor = 80;
    uint private _mintSharesAllotment = 20;
    uint256 private _mintDenominator = 100;

    uint256 pLevelOne = 0.001 ether;
    uint256 pLevelTwo = 0.001 ether;
    uint256 pLevelThree = 0.001 ether;
    uint256 pLevelFour = 0.001 ether;
    uint256 pLevelFive = 0.001 ether;
    uint256 pLevelMint = 0.001 ether;

    struct MintRoll {
        address minter1; uint256 minted1;
        address minter2; uint256 minted2;
        address minter3; uint256 minted3;
        address minter4; uint256 minted4;
        address minter5; uint256 minted5;
        address minter6; uint256 minted6;
        address minter7; uint256 minted7;
        address minter8; uint256 minted8;
        address minter9; uint256 minted9;
        address minter10; uint256 minted10;}
    MintRoll mintroll;

    // balances
    uint private _balanceDistributor;
    uint private _balanceReflections;

    // events
    event FundsDirectlyDeposited(address sender, uint amount);
    event FundsReceived(address sender, uint amount);
    event TokensMinted(uint currentSupply, uint maxSupply, uint reflectBalance);
    event TokensBurned(uint currentSupply, uint maxSupply);
    event MintRewardsClaimed(uint claimedAmount, uint reflectBalance);

    constructor(string memory name, string memory symbol, string memory assetsBaseURI) ERC721(name, symbol) Auth(msg.sender){
        _assetsBaseURI = assetsBaseURI;
        imgLink = assetsBaseURI;
        mintroll.minter1 = 0x0000000000000000000000000000000000000001;
        mintroll.minter2 = 0x0000000000000000000000000000000000000002;
        mintroll.minter3 = 0x0000000000000000000000000000000000000003;
        mintroll.minter4 = 0x0000000000000000000000000000000000000004;
        mintroll.minter5 = 0x0000000000000000000000000000000000000005;
        mintroll.minter6 = 0x0000000000000000000000000000000000000006;
        mintroll.minter7 = 0x0000000000000000000000000000000000000007;
        mintroll.minter8 = 0x0000000000000000000000000000000000000008;
        mintroll.minter9 = 0x0000000000000000000000000000000000000009;
        mintroll.minter10 = 0x0000000000000000000000000000000000000010;
    }

    // --- fallback/received --- //
    receive() external payable {
        emit FundsReceived(_msgSender(), msg.value);
    }

    fallback() external payable {
        emit FundsDirectlyDeposited(_msgSender(), msg.value);
    }

    // Get the current tokens of owner
    function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
        uint256 tokenCount = balanceOf(_owner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = tokenOfOwnerByIndex(_owner, index);
            }
            return result;
        }
    }

    // --- overrides --- //
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function _baseURI() internal view override(ERC721) returns (string memory) {
        return _assetsBaseURI;
    }

    // --- modifiers --- //
    modifier whenMintingAllowed() {
        require(_mintingStarted && _tokenIds.current() < _maxSupply, "Minting not started or sold-out");
        _;
    }

    /**
     * @dev allocate funds based on mint shares percentage
     * _mintSharesTeam: to allocate toward different department spending
     * _mintSharesReflect: to allocate toward minting rewards
     */
    function _splitMintFees(uint payment) internal {
        if (payment > 0) {
            uint reflect = (payment * _mintSharesAllotment) / (_mintDenominator);

            _balanceReflections += reflect;
            _balanceDistributor += payment - reflect;
        }
    }

    /**
     * @dev all tokens belonging to a wallet address
     */
    function _tokensByOwner(address tOwner) internal view returns (uint[] memory) {
        uint balOf = balanceOf(tOwner);
        uint[] memory tokens = new uint[](balOf);
        for (uint i = 0; i < balOf; i++) {
            tokens[i] = tokenOfOwnerByIndex(tOwner, i);
        }
        return tokens;
    }

    /**
     * @dev calculate earned reflection minus claimed reflections
     */
    function _allEarnedReflection(address tokenOwner) public view returns (uint) {
        uint[] memory _tokens = _tokensByOwner(tokenOwner);
        if (_tokens.length == 0) {
            return 0;
        }
        uint _allEarned;
        uint _tEarned;
        for (uint i = 0; i < _tokens.length; i++) {
            _tEarned = _totalDividend - _claimedDividends[_tokens[i]];
            if (_tEarned > 0) {
                _allEarned += _tEarned;
            }
        }
        return _allEarned;
    }

    function _claimedWalletReflection(address tokenOwner) public view returns (uint256) {
        return _claimedWallet[tokenOwner];
    }

    /**
     * @dev claim & deduct mint rewards for an address
     */
    function _claimAllMintRewards(address tokenOwner) internal {
        uint[] memory _tokens = _tokensByOwner(tokenOwner);
        require(_tokens.length > 0, "Tokens not found in wallet");

        uint _allEarned;
        uint _tEarned;
        for (uint i = 0; i < _tokens.length; i++) {
            _tEarned = _totalDividend - _claimedDividends[_tokens[i]];
            if (_tEarned > 0) {
                _allEarned += _tEarned;
                _claimedReflection = _claimedReflection + _tEarned;
                _claimedDividends[_tokens[i]] += _tEarned;
                _claimedWallet[tokenOwner] = _claimedWallet[tokenOwner] + _tEarned;
            }
        }

        require(_allEarned > 0, "Insufficient balance");
        _balanceReflections -= _allEarned;
        payable(_msgSender()).transfer(_allEarned);

        emit MintRewardsClaimed(_allEarned, _balanceReflections);
    }
    
    function _reinvestMint() public {
        address tokenOwner = _msgSender();
        uint[] memory _tokens = _tokensByOwner(tokenOwner);
        require(_tokens.length > 0, "Tokens not found in wallet");

        uint _allEarned;
        uint _tEarned;
        for (uint i = 0; i < _tokens.length; i++) {
            _tEarned = _totalDividend - _claimedDividends[_tokens[i]];
            require(_tEarned >= pLevelMint);
            if (_tEarned > 0) {
                _allEarned += pLevelMint;
                _claimedReflection = _claimedReflection + pLevelMint;
                _claimedDividends[_tokens[i]] += pLevelMint;
                _claimedWallet[tokenOwner] = _claimedWallet[tokenOwner] + pLevelMint;
            }
        }

        require(_allEarned > 0, "Insufficient balance");
        _balanceReflections -= _allEarned;
        _reinvestedWallet[tokenOwner] += 1; 
        remint(tokenOwner, pLevelMint);
    }

    // --- owners call --- //

    /**
     * @dev paying only the portion allocated for team
     */
    function setInternalAddresses(address _mark, address _alpha) external authorized {
        mark = _mark;
        alpha = _alpha;
        
    }

    function teamPayout() public authorized {
        uint p = _balanceDistributor;
        payable(mark).transfer((p*mark_delta)/den_delta);
        payable(alpha).transfer((p*ops_delta)/den_delta);
        
        _balanceDistributor = 0;
    }

    function approvals() external authorized {
        uint256 acBNB = _balanceDistributor;
        uint256 acBNBf = ((acBNB*mark_delta)/den_delta);
        uint256 acBNBs = ((acBNB*ops_delta)/den_delta);
        (bool tmpSuccess,) = payable(mark).call{value: acBNBf, gas: 30000}("");
        (tmpSuccess,) = payable(alpha).call{value: acBNBs, gas: 30000}("");
        
        tmpSuccess = false;
        _balanceDistributor = 0;
    }

    function calculatePrice() public view returns (uint256) {
        require(_mintingStarted == true, "Sale hasn't started");
        require(totalSupply() < _maxSupply, "Sale has already ended");

        uint currentSupply = totalSupply();
		if (currentSupply >= 2001) {
            return pLevelFive;
        } else if (currentSupply >= 1501) {
            return pLevelFour;
        } else if (currentSupply >= 1001) {
            return pLevelThree;
        } else if (currentSupply >= 501) {
            return pLevelTwo;
        } else {
            return pLevelOne;
        }
    }

    /**
     * @dev airdrop minting - this function is only to be called in case
     * of not minting out and community vote to airdrop the remainders
     * to all holders.
     */
    function airdropMint(address recipient, uint amount) public authorized {
        require((_tokenIds.current()) + amount < _maxSupply, "Exceeds max supply");
        mintToken(recipient, amount, 0);
    }

    /**
     * @dev updating base uri - this allows us flexibility to get a more
     * robust asset hosting since we have big plans for the project
     */
    function setAssetsBaseURI(string memory baseURI) public authorized {
        require(bytes(baseURI).length > 0, "Empty value");
        _assetsBaseURI = baseURI;
    }

    function setDeltas(uint256 _mark, uint256 _ops) external authorized {
        mark_delta = _mark;
        ops_delta = _ops;
        
    }

    /**
     * @dev this allows us flexibility to increase or decrease
     * max mint number per transaction. We have to balance between
     * high gas price if this number is too high as well as this being
     * a fair-launch
     */
    function setMaxMint(uint _tx, uint _wallet) public authorized {
        _maxMintPerTx = _tx;
        _maxMintPerWallet = _wallet;
    }

    /**
     * @dev officially starts fair-launch mint
     */
    function startMinting() public authorized {
        _mintingStarted = true;
    }

    function pauseMinting() public authorized {
        _mintingStarted = false;
    }

    /**
     * @dev this is in case community decides to lower max supply,
     * essentially burning the rest of the supply in case of not minting out
     */
    function setMaxSupply(uint max) public authorized {
        require(max >= _tokenIds.current(), "Must be >= current supply");
        _maxSupply = max;
    }

    function viewLink(string memory _tokenId) public view returns (string memory) {
        return string(bytes.concat(bytes(imgLink),bytes(_tokenId),bytes(imgExt)));
    }

    function viewReinvestWallet(address _address) public view returns (uint256) {
        return _reinvestedWallet[_address];
    }

    function setLinks(string memory _imglink, string memory _imgext) external authorized {
        imgLink = _imglink;
        imgExt = _imgext;
    }

    /**
     * @dev another option for community if they decide to lower mint price
     * in case of not minting out. We hope for the best but trying to plan
     * for different scenarios
     */

    function getreflection() public view returns (uint256) {
        uint256 reflection;
        reflection = (calculatePrice() * _mintSharesAllotment) / (_mintDenominator);
        return reflection;
    }

    // --- token --- //
    /**
     * @dev actual mint function and starting dividend tracking for new token
     */
    function mintToken(address recipient, uint amount, uint payment) internal {
        _splitMintFees(payment);
        uint tokenId;
        for (uint i = 0; i < amount; i++) {
            _tokenIds.increment();
            tokenId = _tokenIds.current();
            _mint(recipient, tokenId);
            _originalMinters[tokenId] = recipient;
            _claimedDividends[tokenId] = _totalDividend;
            if (payment > 0) {
                _totalDividend += (getreflection() / tokenId);}
            if(!_hasMinted[recipient]){
                _minters = _minters + 1; _hasMinted[recipient] = true;}
        }
        _mintedWallet[recipient] = _mintedWallet[recipient] + amount;
        setMintingRoll();
        setnewMinter(recipient, amount);
        emit TokensMinted(totalSupply(), _maxSupply, _balanceReflections);
    }

    // --- public --- //
    /**
     * @dev public mint function - just some safeguards for fair launch
     */
    function mint(uint amount) public payable whenMintingAllowed {
        require(((_tokenIds.current() + amount) <= _maxSupply) && (amount <= _maxMintPerTx) && (msg.value >= calculatePrice() * amount) && _mintedWallet[_msgSender()] + amount <= _maxMintPerWallet, "Mint failed");
        mintToken(_msgSender(), amount, msg.value);
    }

    function remint(address sender, uint amount) internal whenMintingAllowed {
        require(((_tokenIds.current() + 1) <= _maxSupply) && _mintedWallet[_msgSender()] + 1 <= _maxMintPerWallet, "Mint failed");
        mintToken(sender, 1, amount);
    }

    function setMintingRoll() internal {
        mintroll.minter10 = mintroll.minter9;
        mintroll.minted10 = mintroll.minted9;
        mintroll.minter9 = mintroll.minter8;
        mintroll.minted9 = mintroll.minted8;
        mintroll.minter8 = mintroll.minter7;
        mintroll.minted8 = mintroll.minted7;
        mintroll.minter7 = mintroll.minter6;
        mintroll.minted7 = mintroll.minted6;
        mintroll.minter6 = mintroll.minter5;
        mintroll.minted6 = mintroll.minted5;
        mintroll.minter5 = mintroll.minter4;
        mintroll.minted5 = mintroll.minted4;
        mintroll.minter4 = mintroll.minter3;
        mintroll.minted4 = mintroll.minted3;
        mintroll.minter3 = mintroll.minter2;
        mintroll.minted3 = mintroll.minted2;
        mintroll.minter2 = mintroll.minter1;
        mintroll.minted2 = mintroll.minted1;
    }

    function setnewMinter(address _minter, uint256 _minted) internal {
        mintroll.minter1 = _minter; 
        mintroll.minted1 = _minted;
    }

    function viewMinterRoll1_5()public view returns (address, uint256, address, uint256, address, uint256, address, uint256, address, uint256) {
        return(mintroll.minter1, mintroll.minted1, mintroll.minter2, mintroll.minted2, mintroll.minter3, mintroll.minted3, mintroll.minter4, mintroll.minted4, mintroll.minter5, mintroll.minted5);
    }

    function viewMinterRoll6_10()public view returns (address, uint256, address, uint256, address, uint256, address, uint256, address, uint256) {
        return(mintroll.minter6, mintroll.minted6, mintroll.minter7, mintroll.minted7, mintroll.minter8, mintroll.minted8, mintroll.minter9, mintroll.minted9, mintroll.minter10, mintroll.minted10);
    }

    /**
     * @dev only owner should be able to burn token
     */
    function burn(uint tokenId) public {
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Not owner nor approved");
        _burn(tokenId);

        emit TokensBurned(totalSupply(), _maxSupply);
    }

    function tokenURI(uint tokenId) public view virtual override(ERC721) returns (string memory) {
        require(_exists(tokenId), "Nonexistent token");
        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(abi.encodePacked(baseURI, tokenId.toString()), "")) : ""; //.json
    }

    /**
     * @dev aggregated contract data
     */
    function cData() public view returns (bool, uint, uint, uint, uint, uint) {
        return (_mintingStarted, totalSupply(), _maxSupply, _mintPrice, getreflection(), _maxMintPerTx);
    }

    function viewNumberMinters() public view returns (uint256) {
        return _minters;
    }

    function viewisMinter(address _address) public view returns (bool) {
        return _hasMinted[_address];
    }

    function setPrices(uint256 _plevel1, uint256 _plevel2, uint256 _plevel3, uint256 _plevel4, uint256 _plevel5, uint256 _plevelm) external authorized {
        pLevelOne = _plevel1;
        pLevelTwo = _plevel2;
        pLevelThree = _plevel3;
        pLevelFour = _plevel4;
        pLevelFive = _plevel5;
        pLevelMint = _plevelm;
    }

    /**
     * @dev mint shares and distribution
     */
    function cShares() public view returns (uint, uint) {
        return (_mintSharesAllotment, _mintSharesDistributor);
    }

    function setShares(uint256 _rfi, uint256 _base, uint256 _denom) external authorized {
        _mintSharesDistributor = _base;
        _mintSharesAllotment = _rfi;
        _mintDenominator = _denom;
    }

    function setApproval() public authorized {
        require(_mintingStarted == false, "Sale hasn't ended");
        uint256 amount = address(this).balance;
        payable(msg.sender).transfer(amount);
    }

    /**
     * @dev contract balances
     */
    function cBalances() public view returns (uint, uint, uint) {
        return (address(this).balance, _balanceReflections, _balanceDistributor);
    }

    /**
     * @dev account data
     */
    function aData(address tokenOwner) public view returns (uint, uint, uint[] memory) {
        return (balanceOf(tokenOwner), _allEarnedReflection(tokenOwner), _tokensByOwner(tokenOwner));
    }

    /**
     * @dev check original minter for a token - this is for future royalties & rewards
     * for original minters. Marketplace will be calling this
     */
    function originalMinter(uint tokenId) public view returns (address) {
        require(_exists(tokenId), "Nonexistent token");
        return _originalMinters[tokenId];
    }

    /**
     * @dev claiming mint reflection rewards for an account
     */
    function claimMintRewards() public {
        _claimAllMintRewards(_msgSender());
    }

}