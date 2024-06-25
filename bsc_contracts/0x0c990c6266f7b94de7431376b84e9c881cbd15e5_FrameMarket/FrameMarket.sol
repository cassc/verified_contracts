/**
 *Submitted for verification at BscScan.com on 2023-02-22
*/

// SPDX-License-Identifier: MIT 
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

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

// File: @openzeppelin/contracts/access/Ownable.sol


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;


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
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// File: @openzeppelin/contracts/utils/introspection/IERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

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

// File: @openzeppelin/contracts/utils/introspection/ERC165.sol


// OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)

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

// File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol


// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)

pragma solidity ^0.8.0;


/**
 * @dev _Available since v3.1._
 */
interface IERC1155Receiver is IERC165 {
    /**
     * @dev Handles the receipt of a single ERC1155 token type. This function is
     * called at the end of a `safeTransferFrom` after the balance has been updated.
     *
     * NOTE: To accept the transfer, this must return
     * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
     * (i.e. 0xf23a6e61, or its own function selector).
     *
     * @param operator The address which initiated the transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param id The ID of the token being transferred
     * @param value The amount of tokens being transferred
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
     */
    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);

    /**
     * @dev Handles the receipt of a multiple ERC1155 token types. This function
     * is called at the end of a `safeBatchTransferFrom` after the balances have
     * been updated.
     *
     * NOTE: To accept the transfer(s), this must return
     * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
     * (i.e. 0xbc197c81, or its own function selector).
     *
     * @param operator The address which initiated the batch transfer (i.e. msg.sender)
     * @param from The address which previously owned the token
     * @param ids An array containing ids of each token being transferred (order and length must match values array)
     * @param values An array containing amounts of each token being transferred (order and length must match ids array)
     * @param data Additional data with no specified format
     * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
     */
    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);
}

// File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol


// OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)

pragma solidity ^0.8.0;



/**
 * @dev _Available since v3.1._
 */
abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
        return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
    }
}

// File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol


// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)

pragma solidity ^0.8.0;


/**
 * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
 *
 * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
 * stuck.
 *
 * @dev _Available since v3.1._
 */
contract ERC1155Holder is ERC1155Receiver {
    function onERC1155Received(
        address,
        address,
        uint256,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC1155BatchReceived.selector;
    }
}

// File: @openzeppelin/contracts/utils/math/SafeMath.sol


// OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)

pragma solidity ^0.8.0;

// CAUTION
// This version of SafeMath should only be used with Solidity 0.8 or later,
// because it relies on the compiler's built in overflow checks.

/**
 * @dev Wrappers over Solidity's arithmetic operations.
 *
 * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
 * now has built in overflow checking.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            uint256 c = a + b;
            if (c < a) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b > a) return (false, 0);
            return (true, a - b);
        }
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
     *
     * _Available since v3.4._
     */
    function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
            // benefit is lost if 'b' is also tested.
            // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
            if (a == 0) return (true, 0);
            uint256 c = a * b;
            if (c / a != b) return (false, 0);
            return (true, c);
        }
    }

    /**
     * @dev Returns the division of two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a / b);
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
     *
     * _Available since v3.4._
     */
    function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
        unchecked {
            if (b == 0) return (false, 0);
            return (true, a % b);
        }
    }

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
        return a + b;
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
        return a - b;
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
        return a * b;
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator.
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return a / b;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting when dividing by zero.
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
        return a % b;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {trySub}.
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b <= a, errorMessage);
            return a - b;
        }
    }

    /**
     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a / b;
        }
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * reverting with custom message when dividing by zero.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryMod}.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        unchecked {
            require(b > 0, errorMessage);
            return a % b;
        }
    }
}

// File: contracts/FrameMarket.sol

// Marketplace contract

pragma solidity 0.8.17;





interface IFrameNFT {
	function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
	function safeTransferFrom(address from, address to, uint256 id, bytes memory data) external;
	function addItem(uint256 tokenId,address sender,string memory _uri,uint256 supply,uint256 amount,uint256 royalty,address marketAddress,uint256 expireTime,bytes memory _sig) external;
	function balanceOf(address account, uint256 id) external view returns (uint256);
	function ownerOf(uint256 tokenId) external view returns (address);
	function onSignApprove(address auctionAddress) external;
}

contract FrameMarket is Ownable, ERC1155Holder {
    using SafeMath for uint256;

	uint256 constant public PERCENTS_DIVIDER = 1000;
	uint256 public feeAdmin = 25; //2.5%
	address public adminAddress = 0xbA7f642d9c08047b847feb11f2a8Bb437d20B29B;//MultiVac
	//address public adminAddress = 0xbF1bAa92f99E33870f06D6D57d9AeFcadaf05763;//BSC
	address public signerAddress = 0x842C0236236BbDaC052CC2FCC943C6cb9A0e167a;

	uint256 public totalEarnedCoin = 0;
	uint256 public totalEarnedToken = 0;
	uint256 public totalSwapped; /* Total swap count */

	struct Transaction {
		address sender; 
		uint256 actionId;
		address collection;
		uint256 tokenId;
		uint256 _amount;
		uint256 _price;
		address tokenAdr;
		uint256 royalty;
		address itemCreator;
		address owner;
		uint256 expireTime;
		bool 	isLazyMint;
	}

	struct MintItem {
		uint256 tokenId;
		address minter;
		string 	_uri;
		uint256 supply;
		uint256 amount;
		uint256 royalty;
		address marketAddress;
		uint256 expireTime;
	}    

	constructor () {		
	}	

	function setFee(uint256 _feeAdmin, address _adminAddress) external onlyOwner {		
        feeAdmin = _feeAdmin;
		adminAddress = _adminAddress;		
    }

	function setSignAddress(address _signAddress) external onlyOwner {
		signerAddress = _signAddress;
	}

    function onBuyOrder(
		Transaction memory _transaction,
		bytes memory _buySig,
		MintItem memory _item,
		bytes memory _mintSig,
		bool isMulti
	) external payable {
		require(isVerified(_transaction, _buySig), "Invalid Signature");

		IFrameNFT nft = IFrameNFT(_transaction.collection);
		if (_transaction.isLazyMint)
			nft.addItem(
				_item.tokenId, 
				_item.minter, 
				_item._uri,
				_item.supply,
				_item.amount,
				_item.royalty,
				_item.marketAddress,
				_item.expireTime,
				_mintSig);
		if (isMulti){
			uint256 nft_token_balance = nft.balanceOf(_transaction.owner, _transaction.tokenId);
			require(nft_token_balance >= _transaction._amount, "The owner's owned amount is not enough");		
		}else {
			require(nft.ownerOf(_transaction.tokenId) != msg.sender, "You are the admin of this NFT.");
		}

		if (_transaction.tokenAdr == address(0x0)) {
            require(msg.value >= _transaction._price.mul(_transaction._amount), "too small amount");
			uint256 feeAmount = msg.value.mul(feeAdmin).div(PERCENTS_DIVIDER);
			uint256 createrAmount = msg.value.mul(_transaction.royalty).div(PERCENTS_DIVIDER);
			uint256 ownerAmount = msg.value.sub(feeAmount).sub(createrAmount);
			if (feeAmount > 0)payable(adminAddress).transfer(feeAmount);
			if (createrAmount > 0)payable(_transaction.itemCreator).transfer(createrAmount);
			payable(_transaction.owner).transfer(ownerAmount);
			totalEarnedCoin = totalEarnedCoin + feeAmount;
        } else {
			uint256 tokenAmount = _transaction._price.mul(_transaction._amount);
			uint256 feeAmount = tokenAmount.mul(feeAdmin).div(PERCENTS_DIVIDER);
			uint256 createrAmount = tokenAmount.mul(_transaction.royalty).div(PERCENTS_DIVIDER);
			uint256 ownerAmount = tokenAmount.sub(feeAmount).sub(createrAmount);
			IERC20 governanceToken = IERC20(_transaction.tokenAdr);
			require(governanceToken.balanceOf(msg.sender) >= tokenAmount, "The buyer's balance is insufficient.");
			// transfer governance token to feeAddress
			if (feeAmount > 0)require(governanceToken.transferFrom(msg.sender, adminAddress, feeAmount));			
			// transfer governance token to creator
			if (createrAmount > 0)require(governanceToken.transferFrom(msg.sender, _transaction.itemCreator, createrAmount));			
			// transfer governance token to owner
			require(governanceToken.transferFrom(msg.sender, _transaction.owner, ownerAmount));
			totalEarnedToken = totalEarnedToken + feeAmount;
        }

		// transfer NFT token to buyer
		if (isMulti) nft.safeTransferFrom(_transaction.owner, msg.sender, _transaction.tokenId, _transaction._amount, "buy from Marketplace");
		else nft.safeTransferFrom(_transaction.owner, msg.sender, _transaction.tokenId, "buy from Marketplace");
    }

    function onAcceptOffer(
		Transaction memory _transaction,
		bytes memory _offerSig,
		MintItem memory _item,
		bytes memory _mintSig,
		bool isMulti
	) external {
        require(isVerified(_transaction, _offerSig), "Invalid Signature");	

        IFrameNFT nft = IFrameNFT(_transaction.collection);
		if (_transaction.isLazyMint)
			nft.addItem(
				_item.tokenId, 
				_item.minter, 
				_item._uri,
				_item.supply,
				_item.amount,
				_item.royalty,
				_item.marketAddress,
				_item.expireTime,
				_mintSig);

		if (isMulti){
			uint256 nft_token_balance = nft.balanceOf(_transaction.owner, _transaction.tokenId);
			require(nft_token_balance >= _transaction._amount, "Your owned amount is not enough");
		}else{
			require(nft.ownerOf(_transaction.tokenId) == msg.sender, "Only Admin can accept" );
		}
		
		require(_transaction.tokenAdr != address(0x0), "Offer should be with token");

		uint256 offerAmount = _transaction._price.mul(_transaction._amount);
        uint256 feeAmount = offerAmount.mul(feeAdmin).div(PERCENTS_DIVIDER);
		uint256 createrAmount = offerAmount.mul(_transaction.royalty).div(PERCENTS_DIVIDER);
		uint256 ownerAmount = offerAmount.sub(feeAmount).sub(createrAmount);

        IERC20 governanceToken = IERC20(_transaction.tokenAdr);
        require(governanceToken.balanceOf(_transaction.sender) >= offerAmount, "The buyer's balance is insufficient.");
        // transfer governance token to feeAddress
        if (feeAmount > 0)require(governanceToken.transferFrom(_transaction.sender, address(this), feeAmount));			
        // transfer governance token to creator
        if (createrAmount > 0)require(governanceToken.transferFrom(_transaction.sender, _transaction.itemCreator, createrAmount));			
        // transfer governance token to owner
        require(governanceToken.transferFrom(_transaction.sender, _transaction.owner, ownerAmount));

		if (isMulti){
			nft.safeTransferFrom(_transaction.owner, _transaction.sender, _transaction.tokenId, _transaction._amount, "buy from Marketplace");
		}else{
			nft.safeTransferFrom(_transaction.owner, _transaction.sender, _transaction.tokenId, "buy from Marketplace");
		}
    }

	function finalizeAuction(Transaction memory _transaction, bool isMulti) external{
		require(msg.sender == signerAddress, "Only Sign Address can finalize");
		IFrameNFT nft = IFrameNFT(_transaction.collection);
		if (isMulti){
			uint256 nft_token_balance = nft.balanceOf(_transaction.owner, _transaction.tokenId);
			require(nft_token_balance >= _transaction._amount, "Your owned amount is not enough");
		}else{
			require(nft.ownerOf(_transaction.tokenId) == _transaction.owner, "Only Admin can accept" );
		}
		require(_transaction.tokenAdr != address(0x0), "Offer should be with token");
		uint256 offerAmount = _transaction._price.mul(_transaction._amount);
        uint256 feeAmount = offerAmount.mul(feeAdmin).div(PERCENTS_DIVIDER);
		uint256 createrAmount = offerAmount.mul(_transaction.royalty).div(PERCENTS_DIVIDER);
		uint256 ownerAmount = offerAmount.sub(feeAmount).sub(createrAmount);

        IERC20 governanceToken = IERC20(_transaction.tokenAdr);
        require(governanceToken.balanceOf(_transaction.sender) >= offerAmount, "The buyer's balance is insufficient.");
        // transfer governance token to feeAddress
        if (feeAmount > 0)require(governanceToken.transferFrom(_transaction.sender, address(this), feeAmount));			
        // transfer governance token to creator
        if (createrAmount > 0)require(governanceToken.transferFrom(_transaction.sender, _transaction.itemCreator, createrAmount));			
        // transfer governance token to owner
        require(governanceToken.transferFrom(_transaction.sender, _transaction.owner, ownerAmount));

		nft.onSignApprove(address(this));
		if (isMulti){
			nft.safeTransferFrom(_transaction.owner, _transaction.sender, _transaction.tokenId, _transaction._amount, "buy from Marketplace");
		}else{
			nft.safeTransferFrom(_transaction.owner, _transaction.sender, _transaction.tokenId, "buy from Marketplace");
		}
	}

	function withdrawCoin() public onlyOwner {
		uint balance = address(this).balance;
		require(balance > 0, "insufficient balance");
		payable(msg.sender).transfer(balance);
	}
	
	function withdrawToken(address tokenAddress) external onlyOwner {
        IERC20 token = IERC20(tokenAddress);
		uint balance = token.balanceOf(address(this));
		require(balance > 0, "insufficient balance");
		require(token.transfer(msg.sender, balance));			
	}

	function isVerified(Transaction memory _transaction, bytes memory _sig) private view returns(bool){
		require(_transaction.expireTime >= block.timestamp, "Your transaction is expired");
		bytes32 message = prefixed(keccak256(abi.encodePacked(
			_transaction.sender,
			_transaction.collection,
			_transaction.tokenId,
			_transaction.actionId,
			_transaction._amount,
			_transaction._price,
			_transaction.tokenAdr,
			_transaction.royalty,
			_transaction.itemCreator,
			_transaction.owner,
			_transaction.expireTime,
			_transaction.isLazyMint
		)));
		return recoverSigner(message, _sig) == signerAddress;
	}

	/// @dev Builds a prefixed hash to mimic the behavior of eth_sign.
    function prefixed(bytes32 hash) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
            );
    }

	function recoverSigner(bytes32 message, bytes memory sig)
        internal
        pure
        returns (address)
    {
        uint8 v;
        bytes32 r;
        bytes32 s;

        (v, r, s) = splitSignature(sig);

        return ecrecover(message, v, r, s);
    }

	function splitSignature(bytes memory sig_)
        internal
        pure
        returns (
            uint8,
            bytes32,
            bytes32
        )
    {
        require(sig_.length == 65);

        bytes32 r;
        bytes32 s;
        uint8 v;

        assembly {
            // first 32 bytes, after the length prefix
            r := mload(add(sig_, 32))
            // second 32 bytes
            s := mload(add(sig_, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig_, 96)))
        }

        return (v, r, s);
    }
}