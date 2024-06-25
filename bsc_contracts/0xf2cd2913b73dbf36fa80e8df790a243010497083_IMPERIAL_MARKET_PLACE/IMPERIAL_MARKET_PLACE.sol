/**
 *Submitted for verification at BscScan.com on 2023-03-06
*/

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;


interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC721 is IERC165 {
   
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(address from, address to, uint256 tokenId) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(uint256 tokenId) external view returns (address operator);

    function setApprovalForAll(address operator, bool _approved) external;

    function isApprovedForAll(address owner, address operator) external view returns (bool);

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
}

interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IERC1155 is IERC165 {
    /**
     * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(address indexed account, address indexed operator, bool approved);

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the amount of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(address account, uint256 id) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(address account, address operator) external view returns (bool);

    /**
     * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `amount`.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
     *
     * Emits a {TransferBatch} event.
     *
     * Requirements:
     *
     * - `ids` and `amounts` must have the same length.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
     * acceptance magic value.
     */
    function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address ) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

library BytesLibrary {
    function toString(bytes32 value) internal pure returns (string memory) {
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(64);
        for (uint256 i = 0; i < 32; i++) {
            str[i * 2] = alphabet[uint8(value[i] >> 4)];
            str[1 + i * 2] = alphabet[uint8(value[i] & 0x0f)];
        }
        return string(str);
    }

    function recover(
        bytes32 hash,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal pure returns (address) {
        bytes32 fullMessage = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
        );
        return ecrecover(fullMessage, v, r, s);
    }
}

interface IWETH {
    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract OrderBook is Ownable {
    enum AssetType {
        ERC20,
        ERC721,
        ERC1155
    }

    struct Asset {
        address token;
        uint256 tokenId;
        AssetType assetType;
    }

    struct OrderKey {
        /* who signed the order */
        address payable owner;
        /* what has owner */
        Asset sellAsset;
        /* what wants owner */
        Asset buyAsset;
    }

    struct Order {
        OrderKey key;
        /* how much has owner (in wei, or UINT256_MAX if ERC-721) */
        uint256 selling;
        /* how much wants owner (in wei, or UINT256_MAX if ERC-721) */
        uint256 buying;
        /* fee for selling  secoundary sale*/
        uint256 sellerFee;
        /* random numbers*/
        uint256 salt;
        /* expiry time for order*/
        uint256 expiryTime; // for bid auction auction time + bidexpiry
        /* order Type */
        uint256 orderType; // 1.sell , 2.buy, 3.bid, 4.auction
    }

    /* An ECDSA signature. */
    struct Sig {
        /* v parameter */
        uint8 v;
        /* r parameter */
        bytes32 r;
        /* s parameter */
        bytes32 s;
    }
}

contract OrderState is OrderBook {
    using BytesLibrary for bytes32;

    mapping(bytes32 => bool) public completed; // 1.completed

    function getCompleted(OrderBook.Order calldata order)
        external
        view
        returns (bool)
    {
        return completed[getCompletedKey(order)];
    }

    function setCompleted(OrderBook.Order memory order, bool newCompleted)
        internal
    {
        completed[getCompletedKey(order)] = newCompleted;
    }

    function setCompletedBidOrder(
        OrderBook.Order memory order,
        bool newCompleted,
        address buyer,
        uint256 buyingAmount
    ) internal {
        completed[
            getBidOrderCompletedKey(order, buyer, buyingAmount)
        ] = newCompleted;
    }

    function getCompletedKey(OrderBook.Order memory order)
        public
        pure
        returns (bytes32)
    {
        return prepareOrderHash(order);
    }

    function getBidOrderCompletedKey(
        OrderBook.Order memory order,
        address buyer,
        uint256 buyingAmount
    ) public pure returns (bytes32) {
        return prepareBidOrderHash(order, buyer, buyingAmount);
    }

    function validateOrderSignature(Order memory order, Sig memory sig)
        internal
        view
    {
        require(completed[getCompletedKey(order)] != true, "Signature exist");
        if (sig.v == 0 && sig.r == bytes32(0x0) && sig.s == bytes32(0x0)) {
            revert("incorrect signature");
        } else {
            require(
                prepareOrderHash(order).recover(sig.v, sig.r, sig.s) ==
                    order.key.owner,
                "Incorrect signature"
            );
        }
    }

    function validateOrderSignatureView(Order memory order, Sig memory sig)
        public
        view 
        returns (address)
    {
        require(completed[getCompletedKey(order)] != true, "Signature exist");
        if (sig.v == 0 && sig.r == bytes32(0x0) && sig.s == bytes32(0x0)) {
            revert("Incorrect signature");
        } else {
              return prepareOrderHash(order).recover(sig.v, sig.r, sig.s);
        }
    }

    function validateBidOrderSignature(
        Order memory order,
        Sig memory sig,
        address bidder,
        uint256 buyingAmount
    ) internal view {
        require(
            completed[getBidOrderCompletedKey(order, bidder, buyingAmount)] !=
                true,
            "Signature exist"
        );
        if (sig.v == 0 && sig.r == bytes32(0x0) && sig.s == bytes32(0x0)) {
            revert("Incorrect bid signature");
        } else {
            require(
                prepareBidOrderHash(order, bidder, buyingAmount).recover(
                    sig.v,
                    sig.r,
                    sig.s
                ) == bidder,
                "Incorrect bid signature"
            );
        }
    }

    function validateBidOrderSignatureView(
        Order memory order,
        Sig memory sig,
        address bidder,
        uint256 buyingAmount
    ) public view returns (address) {
        require(completed[getCompletedKey(order)] != true, "Signature exist");
        if (sig.v == 0 && sig.r == bytes32(0x0) && sig.s == bytes32(0x0)) {
            revert("Incorrect bid signature");
        } else {
                return prepareBidOrderHash(order, bidder, buyingAmount).recover(
                    sig.v,
                    sig.r,
                    sig.s
                );
        }
    }

    function prepareOrderHash(OrderBook.Order memory order)
        public
        pure
        returns (bytes32)
    {
        return
            keccak256(
                abi.encodePacked(
                    order.key.owner,
                    abi.encodePacked(
                        order.key.sellAsset.token,
                        order.key.sellAsset.tokenId,
                        order.key.sellAsset.assetType,
                        order.key.buyAsset.token,
                        order.key.buyAsset.tokenId,
                        order.key.buyAsset.assetType
                    ),
                    order.selling,
                    order.buying,
                    order.sellerFee,
                    order.salt,
                    order.expiryTime,
                    order.orderType
                )
            );
    }

    function prepareBidOrderHash(
        OrderBook.Order memory order,
        address bidder,
        uint256 buyingAmount
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    bidder,
                    abi.encodePacked(
                        order.key.buyAsset.token,
                        order.key.buyAsset.tokenId,
                        order.key.buyAsset.assetType,
                        order.key.sellAsset.token,
                        order.key.sellAsset.tokenId,
                        order.key.sellAsset.assetType
                    ),
                    buyingAmount,
                    order.selling,
                    order.sellerFee,
                    order.salt,
                    order.expiryTime,
                    order.orderType
                )
            );
    }

    function prepareBuyerFeeMessage(
        Order memory order,
        uint256 fee,
        address royaltyReceipt
    ) public pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked(
                    abi.encodePacked(
                        order.key.owner,
                        abi.encodePacked(
                            order.key.sellAsset.token,
                            order.key.sellAsset.tokenId,
                            order.key.buyAsset.token,
                            order.key.buyAsset.tokenId
                        ),
                        order.selling,
                        order.buying,
                        order.sellerFee,
                        order.salt,
                        order.expiryTime,
                        order.orderType
                    ),
                    fee,
                    royaltyReceipt
                )
            );
    }
}

interface IImperialStore {
    function safeMint(
        address to,
        uint256 tokenID
    ) external returns (bool);
}

contract TransferSafe {

    function erc721safeTransferFrom(
        IERC721 token,
        address from,
        address to,
        uint256 tokenId
    ) internal {
        token.safeTransferFrom(from, to, tokenId);
    }

    function erc1155safeTransferFrom(
        IERC1155 token,
        address from,
        address to,
        uint256 id,
        uint256 value
    ) internal {
        token.safeTransferFrom(from, to, id, value, "0x");
    }

    function erc721safeMintTransferFrom(
        IImperialStore token,
        address to,
        uint256 tokenID
    ) internal {
        require(
            token.safeMint(to,tokenID),
            "TransferSafe:erc721safeMintTransferFrom:: transaction Failed"
        );
    }
}

contract IMPERIAL_MARKET_PLACE is OrderState, TransferSafe {
    using SafeMath for uint256;
    using BytesLibrary for bytes32;

    address payable public beneficiaryAddress;
    address public buyerFeeSigner;
    uint256 public beneficiaryFee; //
    uint256 public royaltyFeeLimit = 50; // 5%
    IImperialStore private _ImperialStore;
    address public weth;

    // auth token for exchange
    mapping(address => bool) public allowToken;

    event MatchOrder(
        address indexed sellToken,
        uint256 indexed sellTokenId,
        uint256 sellValue,
        address owner,
        address buyToken,
        uint256 buyTokenId,
        uint256 buyValue,
        address buyer,
        uint256 orderType
    );
    event Cancel(
        address indexed sellToken,
        uint256 indexed sellTokenId,
        address owner,
        address buyToken,
        uint256 buyTokenId
    );
    event Beneficiary(address newBeneficiary);
    event BuyerFeeSigner(address newBuyerFeeSigner);
    event BeneficiaryFee(uint256 newbeneficiaryfee);
    event RoyaltyFeeLimit(uint256 newRoyaltyFeeLimit);
    event AllowToken(address token, bool status);
    event SetMintableStore(address newMintableStore);

    constructor(
        address payable beneficiary,
        address buyerfeesigner,
        uint256 beneficiaryfee,
        address wethAddr
    ) {
        beneficiaryAddress = beneficiary;
        buyerFeeSigner = buyerfeesigner;
        beneficiaryFee = beneficiaryfee;
        weth = wethAddr;
    }

    function sell(
        Order calldata order,
        Sig calldata sig,
        Sig calldata buyerFeeSig,
        uint256 royaltyFee,
        address payable royaltyReceipt,
        bool isStore
    ) external payable {
        require((block.timestamp <= order.expiryTime), "Signature expired");
        require(order.orderType == 1, "Invalid order type");
        require(order.key.owner != msg.sender, "Invalid owner");

        validateOrderSignature(order, sig);
        validateBuyerFeeSig(order, royaltyFee, royaltyReceipt, buyerFeeSig);

        transferSellFee(order, royaltyReceipt, royaltyFee, msg.sender);
        setCompleted(order, true);
        transferToken(order, msg.sender, isStore);
        emitMatchOrder(order, msg.sender);
    }

    function buy(
        Order calldata order,
        Sig calldata sig,
        Sig calldata buyerFeeSig,
        uint256 royaltyFee,
        address payable royaltyReceipt,
        bool isStore
    ) external {
        require((block.timestamp <= order.expiryTime), "Signature expired");
        require(order.orderType == 2, "Invalid order");
        require(order.key.owner != msg.sender, "Invalid owner");
        validateOrderSignature(order, sig);
        validateBuyerFeeSig(order, royaltyFee, royaltyReceipt, buyerFeeSig);
        
        transferBuyFee(order, royaltyReceipt, royaltyFee, msg.sender);
        setCompleted(order, true);
        transferToken(order, msg.sender, isStore);
        emitMatchOrder(order, msg.sender);
    }
    
    function transferToken(
        Order calldata order,
        address buyer,
        bool isStore
    ) internal {
        if (order.key.sellAsset.assetType == AssetType.ERC721 || order.key.buyAsset.assetType == AssetType.ERC721) {
            if (order.orderType == 1 || order.orderType == 3) {
                if (!isStore) {
                    erc721safeTransferFrom(
                        IERC721(order.key.sellAsset.token),
                        order.key.owner,
                        buyer,
                        order.key.sellAsset.tokenId
                    );
                } else {
                    require(order.key.sellAsset.token == address(_ImperialStore), "invalid sell asset");
                    erc721safeMintTransferFrom(
                        IImperialStore(order.key.sellAsset.token),
                        buyer,
                        order.key.sellAsset.tokenId
                    );
                }
            } else if (order.orderType == 2) {
                if (!isStore) {
                    erc721safeTransferFrom(
                        IERC721(order.key.buyAsset.token),
                        buyer,
                        order.key.owner,
                        order.key.buyAsset.tokenId
                    );
                } else {
                    require(order.key.buyAsset.token == address(_ImperialStore), "invalid buy asset");
                    erc721safeMintTransferFrom(
                        IImperialStore(order.key.buyAsset.token),
                        order.key.owner,
                        order.key.buyAsset.tokenId
                    );
                }
            }
        } else if (order.key.sellAsset.assetType == AssetType.ERC1155 || order.key.buyAsset.assetType == AssetType.ERC1155) {
            if (order.orderType == 1 || order.orderType == 3) {
                if (!isStore) {
                    erc1155safeTransferFrom(
                        IERC1155(order.key.sellAsset.token),
                        order.key.owner,
                        buyer,
                        order.key.sellAsset.tokenId,
                        order.selling
                    );
                } else {
                    require(order.key.sellAsset.token == address(_ImperialStore), "invalid sell asset");
                    erc721safeMintTransferFrom(
                        IImperialStore(order.key.sellAsset.token),
                        buyer,
                        order.key.sellAsset.tokenId
                    );
                }
            } else if (order.orderType == 2) {
                if (!isStore) {
                    erc1155safeTransferFrom(
                        IERC1155(order.key.buyAsset.token),
                        buyer,
                        order.key.owner,
                        order.key.buyAsset.tokenId,
                        order.buying
                    );
                } else {
                    require(order.key.buyAsset.token == address(_ImperialStore), "invalid buy asset");
                    erc721safeMintTransferFrom(
                        IImperialStore(order.key.buyAsset.token),
                        order.key.owner,
                        order.key.buyAsset.tokenId
                    );
                }
            }
        } else {
            revert("invalid assest ");
        }
    }

    function bid(
        Order calldata order,
        Sig calldata sig,
        Sig calldata buyerSig,
        Sig calldata buyerFeeSig,
        address buyer,
        uint256 buyingAmount,
        uint256 royaltyFee,
        address payable royaltyReceipt,
        bool isStore
    ) external {
        require((block.timestamp <= order.expiryTime), "Signature expired");
        require(buyingAmount >= order.buying, "BuyingAmount invalid");

        require(order.orderType == 3, "Invalid order");
        require(order.key.owner == msg.sender, "Not owner");

        validateOrderSignature(order, sig);
        validateBidOrderSignature(order, buyerSig, buyer, buyingAmount);
        validateBuyerFeeSig(order, royaltyFee, royaltyReceipt, buyerFeeSig);

        setCompleted(order, true);
        setCompletedBidOrder(order, true, buyer, buyingAmount);

        transferBidFee(
            order.key.buyAsset.token,
            order.key.owner,
            buyingAmount,
            royaltyReceipt,
            royaltyFee,
            buyer
        );
        transferToken(order, buyer, isStore);
        emitMatchOrder(order, buyer);
    }

    function transferSellFee(
        Order calldata order,
        address payable royaltyReceipt,
        uint256 royaltyFee,
        address buyer
    ) internal {
        if (order.key.buyAsset.token == address(0x00)) {
            require(msg.value == order.buying, "msg.value is invalid");
            transferEthFee(
                order.buying,
                order.key.owner,
                royaltyFee,
                royaltyReceipt
            );
        } else if (order.key.buyAsset.token == weth) {
            transferWethFee(
                order.buying,
                order.key.owner,
                buyer,
                royaltyFee,
                royaltyReceipt
            );
        } else {
            transferErc20Fee(
                order.key.buyAsset.token,
                order.buying,
                order.key.owner,
                buyer,
                royaltyFee,
                royaltyReceipt
            );
        }
    }

    function transferBuyFee(
        Order calldata order,
        address payable royaltyReceipt,
        uint256 royaltyFee,
        address buyer
    ) internal {
        if (order.key.sellAsset.token == weth) {
            transferWethFee(
                order.selling,
                buyer,
                order.key.owner,
                royaltyFee,
                royaltyReceipt
            );
        } else {
            transferErc20Fee(
                order.key.sellAsset.token,
                order.selling,
                buyer,
                order.key.owner,
                royaltyFee,
                royaltyReceipt
            );
        }
    }

    function transferBidFee(
        address assest,
        address payable seller,
        uint256 buyingAmount,
        address payable royaltyReceipt,
        uint256 royaltyFee,
        address buyer
    ) internal {
        if (assest == weth) {
            transferWethFee(
                buyingAmount,
                seller,
                buyer,
                royaltyFee,
                royaltyReceipt
            );
        } else {
            transferErc20Fee(
                assest,
                buyingAmount,
                seller,
                buyer,
                royaltyFee,
                royaltyReceipt
            );
        }
    }

    function transferEthFee(
        uint256 amount,
        address payable _seller,
        uint256 royaltyFee,
        address payable royaltyReceipt
    ) internal {
        (
            uint256 protocolfee,
            uint256 secoundaryFee,
            uint256 remaining
        ) = transferFeeView(amount, royaltyFee);
        if (protocolfee > 0) {
            (beneficiaryAddress).transfer(protocolfee);
        }
        if ((secoundaryFee > 0) && (royaltyReceipt != address(0x00))) {
            royaltyReceipt.transfer(secoundaryFee);
        }
        if (remaining > 0) {
            _seller.transfer(remaining);
        }
    }

    function transferWethFee(
        uint256 amount,
        address _seller,
        address buyer,
        uint256 royaltyFee,
        address royaltyReceipt
    ) internal {
        (
            uint256 protocolfee,
            uint256 secoundaryFee,
            uint256 remaining
        ) = transferFeeView(amount, royaltyFee);
        if (protocolfee > 0) {
            require(
                IWETH(weth).transferFrom(
                    buyer,
                    beneficiaryAddress,
                    protocolfee
                ),
                "Failed protocol fee transfer"
            );
        }
        if ((secoundaryFee > 0) && (royaltyReceipt != address(0x00))) {
            require(
                IWETH(weth).transferFrom(buyer, royaltyReceipt, secoundaryFee),
                "Failed royalty fee transfer"
            );
        }
        if (remaining > 0) {
            require(
                IWETH(weth).transferFrom(buyer, _seller, remaining),
                "Failed transfer"
            );
        }
    }

    function transferErc20Fee(
        address token,
        uint256 amount,
        address _seller,
        address buyer,
        uint256 royaltyFee,
        address royaltyReceipt
    ) internal {
        require(allowToken[token], "Not authorized token");

        (
            uint256 protocolfee,
            uint256 secoundaryFee,
            uint256 remaining
        ) = transferFeeView(amount, royaltyFee);
        if (protocolfee > 0) {
            require(
                IERC20(token).transferFrom(
                    buyer,
                    beneficiaryAddress,
                    protocolfee
                ),
                "Failed protocol fee transfer"
            );
        }
        if ((secoundaryFee > 0) && (royaltyReceipt != address(0x00))) {
            require(
                IERC20(token).transferFrom(
                    buyer,
                    royaltyReceipt,
                    secoundaryFee
                ),
                "Failed royalty fee transfer"
            );
        }
        if (remaining > 0) {
            require(
                IERC20(token).transferFrom(buyer, _seller, remaining),
                "Failed transfer"
            );
        }
    }

    function transferFeeView(uint256 amount, uint256 royaltyPcent)
        public
        view
        returns (
            uint256,
            uint256,
            uint256
        )
    {
        uint256 protocolFee = (amount.mul(beneficiaryFee)).div(1000);
        uint256 secoundaryFee;
        if (royaltyPcent > royaltyFeeLimit) {
            secoundaryFee = (amount.mul(royaltyFeeLimit)).div(1000);
        } else {
            secoundaryFee = (amount.mul(royaltyPcent)).div(1000);
        }

        uint256 remaining = amount.sub(protocolFee.add(secoundaryFee));

        return (protocolFee, secoundaryFee, remaining);
    }

    function emitMatchOrder(Order memory order, address buyer) internal {
        emit MatchOrder(
            order.key.sellAsset.token,
            order.key.sellAsset.tokenId,
            order.selling,
            order.key.owner,
            order.key.buyAsset.token,
            order.key.buyAsset.tokenId,
            order.buying,
            buyer,
            order.orderType
        );
    }

    function cancel(Order calldata order) external {
        require(order.key.owner == msg.sender, "Not an owner");
        setCompleted(order, true);
        emit Cancel(
            order.key.sellAsset.token,
            order.key.sellAsset.tokenId,
            msg.sender,
            order.key.buyAsset.token,
            order.key.buyAsset.tokenId
        );
    }

    function validateBuyerFeeSig(
        Order memory order,
        uint256 buyerFee,
        address royaltyReceipt,
        Sig memory sig
    ) internal view {
        require(
            prepareBuyerFeeMessage(order, buyerFee, royaltyReceipt).recover(
                sig.v,
                sig.r,
                sig.s
            ) == buyerFeeSigner,
            "Incorrect buyer fee signature"
        );
    }

    function validateBuyerFeeSigView(
        Order memory order,
        uint256 buyerFee,
        address royaltyReceipt,
        Sig memory sig
    ) public pure returns (address) {
            return prepareBuyerFeeMessage(order, buyerFee, royaltyReceipt).recover(
                sig.v,
                sig.r,
                sig.s
            ); 
    }

    function toEthSignedMessageHash(bytes32 hash, Sig memory sig)
        public
        pure
        returns (address signer)
    {
        signer = hash.recover(sig.v, sig.r, sig.s);
    }

    function setBeneficiary(address payable newBeneficiary) external onlyOwner {
        require(newBeneficiary != address(0x00), "Zero address");
        beneficiaryAddress = newBeneficiary;
        emit Beneficiary(newBeneficiary);
    }

    function setBuyerFeeSigner(address newBuyerFeeSigner) external onlyOwner {
        require(newBuyerFeeSigner != address(0x00), "Zero address");
        buyerFeeSigner = newBuyerFeeSigner;
        emit BuyerFeeSigner(newBuyerFeeSigner);
    }

    function setBeneficiaryFee(uint256 newbeneficiaryfee) external onlyOwner {
        beneficiaryFee = newbeneficiaryfee;
        emit BeneficiaryFee(newbeneficiaryfee);
    }

    function setRoyaltyFeeLimit(uint256 newRoyaltyFeeLimit) external onlyOwner {
        royaltyFeeLimit = newRoyaltyFeeLimit;
        emit RoyaltyFeeLimit(newRoyaltyFeeLimit);
    }

    function setTokenStatus(address token, bool status) external onlyOwner {
        require(token != address(0x00), "Zero address");
        allowToken[token] = status;
        emit AllowToken(token, status);
    }

    function setMintableStore(address newMintableStore) external onlyOwner {
        require(newMintableStore != address(0x00), "Zero address");
        _ImperialStore = IImperialStore(newMintableStore);
        emit SetMintableStore(newMintableStore);
    }

    /**
     * @dev Rescues random funds stuck that the contract can't handle.
     * @param _token address of the token to rescue.
     */
    function inCaseTokensGetStuck(address _token) external onlyOwner {
        if (_token != address(0x000)) {
            uint256 amount = IERC20(_token).balanceOf(address(this));
            IERC20(_token).transfer(msg.sender, amount);
        } else {
            payable(msg.sender).transfer(address(this).balance);
        }
    }

    function ImperialStore() external view returns(address){
        return address(_ImperialStore);
    }

}